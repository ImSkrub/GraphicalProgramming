// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GlitchEffectPostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_NoiseTimeScale("Noise Time Scale", Range( 0 , 2)) = 1
		_ScreenBlend("Screen Blend", Range( 0 , 1)) = 0
		_TimeMult("Time Mult", Float) = 4
		_NoiseScale("Noise Scale", Float) = 10
		_Flickeringmult("Flickering mult", Float) = 3
		_FlickerTimescale("Flicker Time scale", Float) = 1
		_ModFlickereffect("Mod Flicker effect", Range( 0 , 1)) = 0.3529412
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _NoiseTimeScale;
			uniform float _TimeMult;
			uniform float _NoiseScale;
			uniform float _FlickerTimescale;
			uniform float _Flickeringmult;
			uniform float _ModFlickereffect;
			uniform float _ScreenBlend;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode137 = tex2D( _MainTex, uv_MainTex );
				float4 color147 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float mulTime76 = _Time.y * _NoiseTimeScale;
				float2 temp_cast_0 = (( ase_screenPosNorm.y + ( mulTime76 * _TimeMult ) )).xx;
				float simplePerlin2D93 = snoise( temp_cast_0*_NoiseScale );
				simplePerlin2D93 = simplePerlin2D93*0.5 + 0.5;
				float mulTime102 = _Time.y * _FlickerTimescale;
				float2 temp_cast_1 = (( mulTime102 * _Flickeringmult )).xx;
				float simplePerlin2D100 = snoise( temp_cast_1*1.66 );
				simplePerlin2D100 = simplePerlin2D100*0.5 + 0.5;
				float temp_output_105_0 = ( simplePerlin2D100 * simplePerlin2D100 );
				float4 lerpResult143 = lerp( color147 , tex2DNode137 , ( (-1.0 + (simplePerlin2D93 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * ( ( temp_output_105_0 * temp_output_105_0 ) * _ModFlickereffect ) ));
				float4 lerpResult140 = lerp( tex2DNode137 , lerpResult143 , _ScreenBlend);
				

				finalColor = lerpResult140;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;559;1344;440;3027.38;353.147;1.378298;True;False
Node;AmplifyShaderEditor.CommentaryNode;108;-3976.228,313.2101;Inherit;False;1748.15;395.16;Flickering;9;100;101;102;104;105;106;103;110;111;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;99;-3687.115,-377.709;Inherit;False;1467.836;541.4775;Comment;9;67;91;95;96;93;97;98;76;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-3913.228,475.9101;Inherit;False;Property;_FlickerTimescale;Flicker Time scale;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-3637.115,-47.10312;Inherit;False;Property;_NoiseTimeScale;Noise Time Scale;0;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;102;-3731.228,470.2101;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-3669.228,593.2101;Inherit;False;Property;_Flickeringmult;Flickering mult;4;0;Create;True;0;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;76;-3349.753,-41.9599;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-3344.609,48.60892;Inherit;False;Property;_TimeMult;Time Mult;2;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-3469.228,474.2101;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-3139.609,-50.39106;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;67;-3252.109,-301.3087;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;100;-3214.227,372.2101;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1.66;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-2955.228,366.2101;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-2978.609,-209.3913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-2941.609,-96.39105;Inherit;False;Property;_NoiseScale;Noise Scale;3;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;93;-2749.609,-228.3913;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-2718.228,363.2101;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-2561.179,614.4936;Inherit;False;Property;_ModFlickereffect;Mod Flicker effect;6;0;Create;True;0;0;0;False;0;False;0.3529412;0.3529412;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-2457.685,372.8864;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;98;-2510.609,-223.3913;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;136;-2114.149,-326.9211;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;137;-1987.64,-325.2358;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-1984.672,133.4641;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;147;-1873.119,-501.2528;Inherit;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;135;-1476.424,-59.96317;Inherit;False;Property;_ScreenBlend;Screen Blend;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;143;-1550.579,-298.1659;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;140;-1222.955,-367.2068;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;-955.7296,-368.7605;Float;False;True;-1;2;ASEMaterialInspector;0;2;GlitchEffectPostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;102;0;103;0
WireConnection;76;0;72;0
WireConnection;101;0;102;0
WireConnection;101;1;104;0
WireConnection;96;0;76;0
WireConnection;96;1;91;0
WireConnection;100;0;101;0
WireConnection;105;0;100;0
WireConnection;105;1;100;0
WireConnection;95;0;67;2
WireConnection;95;1;96;0
WireConnection;93;0;95;0
WireConnection;93;1;97;0
WireConnection;106;0;105;0
WireConnection;106;1;105;0
WireConnection;110;0;106;0
WireConnection;110;1;111;0
WireConnection;98;0;93;0
WireConnection;137;0;136;0
WireConnection;109;0;98;0
WireConnection;109;1;110;0
WireConnection;143;0;147;0
WireConnection;143;1;137;0
WireConnection;143;2;109;0
WireConnection;140;0;137;0
WireConnection;140;1;143;0
WireConnection;140;2;135;0
WireConnection;2;0;140;0
ASEEND*/
//CHKSM=5269063576F5019DB7C6317578F1AE89BB6F0217