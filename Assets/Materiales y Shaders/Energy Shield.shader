// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Energy Shield"
{
	Properties
	{
		_EdgePower("Edge Power", Float) = 4
		_EdgeScale("Edge Scale", Float) = 2
		_DepthRange("DepthRange", Float) = 0
		_FinalEdge("Final Edge", Range( 0 , 1)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (0,0,0,0)
		_RadialGlowCentralRadius("RadialGlowCentralRadius", Range( 0 , 1)) = 0.5
		_PulseIntensity("Pulse Intensity", Float) = 0
		_PulseRange("Pulse Range", Float) = 0
		_Edgecolor("Edge color", Color) = (0,0,0,0)
		_Hexcolor("Hex color", Color) = (1,1,1,0)
		_HexIntensity("Hex Intensity", Range( 0 , 2)) = 2
		_Speed("Speed", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 screenPosition4;
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform float4 _Hexcolor;
		uniform float4 _Edgecolor;
		uniform float _FinalEdge;
		uniform float _DepthRange;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _EdgeScale;
		uniform float _EdgePower;
		uniform sampler2D _TextureSample0;
		uniform float2 _Tiling;
		uniform float _PulseRange;
		uniform float _PulseIntensity;
		uniform float _HexIntensity;
		uniform float _Speed;
		uniform float _RadialGlowCentralRadius;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos4 = ase_vertex3Pos;
			float4 ase_screenPos4 = ComputeScreenPos( UnityObjectToClipPos( vertexPos4 ) );
			o.screenPosition4 = ase_screenPos4;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos4 = i.screenPosition4;
			float4 ase_screenPosNorm4 = ase_screenPos4 / ase_screenPos4.w;
			ase_screenPosNorm4.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm4.z : ase_screenPosNorm4.z * 0.5 + 0.5;
			float screenDepth4 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm4.xy ));
			float distanceDepth4 = abs( ( screenDepth4 - LinearEyeDepth( ase_screenPosNorm4.z ) ) / ( 1.0 ) );
			float lerpResult75 = lerp( 0.0 , _DepthRange , distanceDepth4);
			float Depth81 = saturate( ( 1.0 - lerpResult75 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV3 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode3 = ( 0.0 + _EdgeScale * pow( 1.0 - fresnelNdotV3, _EdgePower ) );
			float Edge82 = fresnelNode3;
			float lerpResult89 = lerp( 0.0 , _FinalEdge , max( ( 1.5 * Depth81 ) , Edge82 ));
			float EdgeDepth90 = lerpResult89;
			float2 Tiling93 = _Tiling;
			float2 uv_TexCoord94 = i.uv_texcoord * Tiling93;
			float4 tex2DNode54 = tex2D( _TextureSample0, uv_TexCoord94 );
			float2 uv_TexCoord97 = i.uv_texcoord * Tiling93;
			float temp_output_101_0 = length( ( uv_TexCoord97 + ( Tiling93 * -0.5 ) ) );
			float mulTime110 = _Time.y * -1.0;
			float Pulse117 = ( ( sin( ( ( temp_output_101_0 + mulTime110 ) * 5.0 ) ) - _PulseRange ) * _PulseIntensity );
			float temp_output_133_0 = ( tex2DNode54.g * saturate( Pulse117 ) );
			o.Emission = max( _Hexcolor , max( ( _Edgecolor * EdgeDepth90 ) , ( _Edgecolor * temp_output_133_0 ) ) ).rgb;
			float2 appendResult6_g2 = (float2(_Speed , 0.0));
			float2 break19_g1 = ( i.uv_texcoord * float2( 10,10 ) );
			float temp_output_20_0_g1 = ( break19_g1.x * 1.5 );
			float2 appendResult14_g1 = (float2(temp_output_20_0_g1 , ( break19_g1.y + ( ( floor( temp_output_20_0_g1 ) % 2.0 ) * 0.5 ) )));
			float2 break12_g1 = abs( ( ( appendResult14_g1 % float2( 1,1 ) ) - float2( 0.5,0.5 ) ) );
			float smoothstepResult1_g1 = smoothstep( 0.0 , 0.68 , ( abs( ( max( ( ( break12_g1.x * 1.5 ) + break12_g1.y ) , ( break12_g1.y * 2.0 ) ) - 0.73 ) ) * 2.0 ));
			float2 panner7_g2 = ( 1.0 * _Time.y * appendResult6_g2 + (( i.uv_texcoord * smoothstepResult1_g1 )).xy);
			float simplePerlin2D8_g2 = snoise( panner7_g2*4.0 );
			simplePerlin2D8_g2 = simplePerlin2D8_g2*0.5 + 0.5;
			float lerpResult188 = lerp( 0.0 , 0.0 , saturate( simplePerlin2D8_g2 ));
			float Random172 = lerpResult188;
			float Length102 = temp_output_101_0;
			float smoothstepResult106 = smoothstep( _RadialGlowCentralRadius , 1.0 , ( 1.0 - Length102 ));
			float CenterGlow108 = saturate( smoothstepResult106 );
			o.Alpha = saturate( ( max( EdgeDepth90 , max( ( _HexIntensity * ( Random172 * tex2DNode54.r ) ) , temp_output_133_0 ) ) + CenterGlow108 ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float2 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xyzw = customInputData.screenPosition4;
				o.customPack2.xy = customInputData.uv_texcoord;
				o.customPack2.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.screenPosition4 = IN.customPack1.xyzw;
				surfIN.uv_texcoord = IN.customPack2.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;559;1344;440;3244.191;-2324.658;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;95;-4449.693,1743.134;Inherit;False;478.1401;212.7476;;2;93;92;Global Tiling;1,0.8028251,0,1;0;0
Node;AmplifyShaderEditor.Vector2Node;92;-4399.693,1794.401;Inherit;False;Property;_Tiling;Tiling;5;0;Create;True;0;0;0;False;0;False;0,0;2,1.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;121;-4708.097,-418.6968;Inherit;False;2085.685;568.8749;Pulse;18;96;97;99;98;100;101;110;111;113;114;115;116;119;120;117;118;112;102;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-4210.953,1793.134;Inherit;False;Tiling;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-4636.614,-197.6971;Inherit;False;Constant;_Center;Center;8;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-4658.097,-356.308;Inherit;False;93;Tiling;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;97;-4424.614,-368.6968;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;68;-4587.335,1161.107;Inherit;False;1410.443;358.5103;Depth;8;4;75;76;77;78;79;81;157;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-4390.614,-218.6971;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;157;-4609.082,1215.462;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;100;-4098.614,-321.6968;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-4104.812,-68.98205;Inherit;False;Constant;_TimeScale;TimeScale;9;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-4276.776,1416.765;Inherit;False;Property;_DepthRange;DepthRange;2;0;Create;True;0;0;0;False;0;False;0;0.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;110;-3930.802,-63.98205;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;101;-3902.604,-324.6968;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-4268.776,1325.765;Inherit;False;Constant;_Float2;Float 2;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;4;-4405.889,1213.835;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;173;-3413.959,2430.282;Inherit;False;1469.4;331;Random;8;166;170;172;169;186;187;185;188;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;187;-3352.531,2575.586;Inherit;True;Hex Lattice;-1;;1;56d977fb137832a498dced8436cf6708;0;3;3;FLOAT2;10,10;False;2;FLOAT;0.73;False;4;FLOAT;0.68;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;185;-3320.209,2467.399;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;75;-4034.776,1215.765;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-3567.802,-2.98207;Inherit;False;Constant;_Const;Const;9;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;112;-3688.802,-109.9821;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;67;-4602.819,795.303;Inherit;False;1115.405;331.6246;Edge;4;5;3;6;82;Edge;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;78;-3877.776,1219.765;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-3509.802,-98.98205;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-3008.531,2500.586;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;166;-2852.067,2510.437;Inherit;False;True;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-2730.959,2616.282;Inherit;False;Property;_Speed;Speed;12;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-4552.819,972.7669;Inherit;False;Property;_EdgeScale;Edge Scale;1;0;Create;True;0;0;0;False;0;False;2;2.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;114;-3329.802,-94.98205;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-4555.819,1037.767;Inherit;False;Property;_EdgePower;Edge Power;0;0;Create;True;0;0;0;False;0;False;4;3.96;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;79;-3717.776,1219.765;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-3292.802,-12.98207;Inherit;False;Property;_PulseRange;Pulse Range;8;0;Create;True;0;0;0;False;0;False;0;0.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-3555.776,1219.765;Inherit;False;Depth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;3;-4190.815,866.7671;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-3086.802,7.017933;Inherit;False;Property;_PulseIntensity;Pulse Intensity;7;0;Create;True;0;0;0;False;0;False;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;91;-3456.394,771.0693;Inherit;False;1074.4;361.32;Edge + depth;8;84;83;85;86;88;87;89;90;E+D;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;115;-3193.802,-95.98205;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;169;-2572.959,2532.282;Inherit;False;Random;-1;;2;942f61131817a044da03f825a48d59d5;0;2;2;FLOAT2;0,0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-3037.802,-96.98205;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;-3660.604,-329.6968;Inherit;False;Length;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-3391.394,821.0692;Inherit;False;Constant;_Float3;Float 3;4;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;188;-2326.191,2464.658;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-3714.128,852.5277;Inherit;False;Edge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;109;-4709.329,160.6124;Inherit;False;1081.4;308.16;RadialGlow;6;103;104;106;107;108;105;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-3403.394,892.0692;Inherit;False;81;Depth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;66;-3405.889,1760.075;Inherit;False;952.0228;468.5153;Grid;6;54;133;139;138;174;175;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;94;-3979.955,1775.134;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;-2179.959,2513.282;Inherit;False;Random;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-3168.394,871.0692;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-2861.802,-107.9821;Inherit;True;Pulse;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-3406.394,1007.069;Inherit;False;82;Edge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;-4659.329,213.6124;Inherit;False;102;Length;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-4537.329,333.6124;Inherit;False;Property;_RadialGlowCentralRadius;RadialGlowCentralRadius;6;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-3032.394,807.0692;Inherit;False;Property;_FinalEdge;Final Edge;3;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;88;-2999.394,999.0692;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-3143.846,2237.044;Inherit;False;117;Pulse;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;104;-4433.329,217.6124;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-3349.594,1918.764;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;e61a550a7ddc3304fbfe0a01919efe9c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;175;-3119.508,1834.802;Inherit;False;172;Random;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;89;-2801.394,900.0692;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-2877.606,1887.603;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;106;-4242.329,213.6124;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;132;-2939.179,2241.068;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-2893.778,1807.511;Inherit;False;Property;_HexIntensity;Hex Intensity;11;0;Create;True;0;0;0;False;0;False;2;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;107;-4043.329,215.6124;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-2609.177,1820.308;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-2621.394,898.0692;Inherit;False;EdgeDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-2669.318,2129.348;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;141;-1875.902,2092.823;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;-1791.598,1859.599;Inherit;False;90;EdgeDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-3867.329,210.6124;Inherit;True;CenterGlow;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;-1839.477,1298.011;Inherit;False;90;EdgeDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;148;-1990.477,1425.011;Inherit;False;Property;_Edgecolor;Edge color;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0.3820239,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-1622.477,1597.011;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;176;-1583.805,1907.358;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-1616.525,2193.288;Inherit;False;108;CenterGlow;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-1622.477,1327.011;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;158;-1366.172,1503.769;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;153;-1351.879,1290.51;Inherit;False;Property;_Hexcolor;Hex color;10;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,0.7276479,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;142;-1314.425,2076.264;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-1380.785,2449.002;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;0;False;0;False;0.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;182;-1427.785,2312.002;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;183;-1643.785,2323.002;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;149;-906.2195,2076.552;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;184;-1076.073,1443.012;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-685.8235,1364.547;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Energy Shield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;93;0;92;0
WireConnection;97;0;96;0
WireConnection;98;0;96;0
WireConnection;98;1;99;0
WireConnection;100;0;97;0
WireConnection;100;1;98;0
WireConnection;110;0;111;0
WireConnection;101;0;100;0
WireConnection;4;1;157;0
WireConnection;75;0;77;0
WireConnection;75;1;76;0
WireConnection;75;2;4;0
WireConnection;112;0;101;0
WireConnection;112;1;110;0
WireConnection;78;0;75;0
WireConnection;113;0;112;0
WireConnection;113;1;120;0
WireConnection;186;0;185;0
WireConnection;186;1;187;0
WireConnection;166;0;186;0
WireConnection;114;0;113;0
WireConnection;79;0;78;0
WireConnection;81;0;79;0
WireConnection;3;2;6;0
WireConnection;3;3;5;0
WireConnection;115;0;114;0
WireConnection;115;1;119;0
WireConnection;169;2;166;0
WireConnection;169;3;170;0
WireConnection;116;0;115;0
WireConnection;116;1;118;0
WireConnection;102;0;101;0
WireConnection;188;2;169;0
WireConnection;82;0;3;0
WireConnection;94;0;93;0
WireConnection;172;0;188;0
WireConnection;85;0;86;0
WireConnection;85;1;83;0
WireConnection;117;0;116;0
WireConnection;88;0;85;0
WireConnection;88;1;84;0
WireConnection;104;0;103;0
WireConnection;54;1;94;0
WireConnection;89;1;87;0
WireConnection;89;2;88;0
WireConnection;174;0;175;0
WireConnection;174;1;54;1
WireConnection;106;0;104;0
WireConnection;106;1;105;0
WireConnection;132;0;131;0
WireConnection;107;0;106;0
WireConnection;138;0;139;0
WireConnection;138;1;174;0
WireConnection;90;0;89;0
WireConnection;133;0;54;2
WireConnection;133;1;132;0
WireConnection;141;0;138;0
WireConnection;141;1;133;0
WireConnection;108;0;107;0
WireConnection;144;0;148;0
WireConnection;144;1;133;0
WireConnection;176;0;160;0
WireConnection;176;1;141;0
WireConnection;151;0;148;0
WireConnection;151;1;150;0
WireConnection;158;0;151;0
WireConnection;158;1;144;0
WireConnection;142;0;176;0
WireConnection;142;1;137;0
WireConnection;182;0;183;0
WireConnection;149;0;142;0
WireConnection;184;0;153;0
WireConnection;184;1;158;0
WireConnection;0;2;184;0
WireConnection;0;9;149;0
ASEEND*/
//CHKSM=AC9A1167EAE043E2CA21B18201F72F15491DA343