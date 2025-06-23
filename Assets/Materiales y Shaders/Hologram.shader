// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hologram"
{
	Properties
	{
		_BandWidth("Band Width", Range( 0 , 1)) = 1
		_BandOffset("Band Offset", Float) = 1
		_Timemult("Time mult", Float) = 0.5
		_Glowpower("Glow power", Float) = 5
		_GlowSize("Glow Size", Float) = 30
		_Hologramnoise("Hologram noise", 2D) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _Hologramnoise;
		uniform float _Glowpower;
		uniform float _GlowSize;
		uniform float _Timemult;
		uniform float _BandOffset;
		uniform float _BandWidth;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color71 = IsGammaSpace() ? float4(0,0.935358,1,0) : float4(0,0.8592024,1,0);
			float2 panner53 = ( 1.0 * _Time.y * float2( 0,0 ) + float2( 0,0 ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV50 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode50 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV50, _Glowpower ) );
			float mulTime20 = _Time.y * _Timemult;
			float4 lerpResult69 = lerp( saturate( ( ( tex2D( _Hologramnoise, panner53 ) * fresnelNode50 ) * _GlowSize ) ) , float4( 0,0,0,0 ) , sin( ( ( ( ( ase_worldPos.y + mulTime20 + ase_worldPos.z ) - _BandOffset ) / _BandWidth ) * 6.28318548202515 ) ));
			o.Albedo = ( color71 * lerpResult69 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
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
8;31;1904;980;1903.45;456.5072;1.689552;True;False
Node;AmplifyShaderEditor.RangedFloatNode;22;-3723.21,1238.098;Inherit;False;Property;_Timemult;Time mult;2;0;Create;True;0;0;0;False;0;False;0.5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;49;-3725.763,938.7558;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;20;-3526.21,1242.098;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;53;-2879.933,180.7156;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-3274.21,1355.097;Inherit;False;Property;_BandOffset;Band Offset;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-3377.21,949.099;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2748.58,681.5779;Inherit;False;Property;_Glowpower;Glow power;4;0;Create;True;0;0;0;False;0;False;5;2.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-3107.21,949.099;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;-2570.243,154.5762;Inherit;True;Property;_Hologramnoise;Hologram noise;6;0;Create;True;0;0;0;False;0;False;-1;8c8f18354560c6b45895f12292577b40;8c8f18354560c6b45895f12292577b40;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;50;-2545.446,594.5461;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2880.154,1275.613;Inherit;False;Property;_BandWidth;Band Width;0;0;Create;True;0;0;0;False;0;False;1;0.4610955;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;26;-2602.078,950.4576;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;39;-2366.705,1135.205;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1830.989,428.3988;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1680.989,672.3988;Inherit;False;Property;_GlowSize;Glow Size;5;0;Create;True;0;0;0;False;0;False;30;4.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1517.989,447.3988;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2064.706,955.2053;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;33;-1856.706,930.2053;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;63;-1324.989,447.3988;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;69;-955.3311,834.2629;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;71;-641.3557,232.8297;Inherit;False;Constant;_Color0;Color 0;7;0;Create;True;0;0;0;False;0;False;0,0.935358,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-387.9228,340.9598;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-3247.489,222.3988;Inherit;False;Property;_pannermult;panner mult;3;0;Create;True;0;0;0;False;0;False;0.5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Hologram;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;22;0
WireConnection;19;0;49;2
WireConnection;19;1;20;0
WireConnection;19;2;49;3
WireConnection;23;0;19;0
WireConnection;23;1;24;0
WireConnection;68;1;53;0
WireConnection;50;3;51;0
WireConnection;26;0;23;0
WireConnection;26;1;29;0
WireConnection;60;0;68;0
WireConnection;60;1;50;0
WireConnection;61;0;60;0
WireConnection;61;1;62;0
WireConnection;38;0;26;0
WireConnection;38;1;39;0
WireConnection;33;0;38;0
WireConnection;63;0;61;0
WireConnection;69;0;63;0
WireConnection;69;2;33;0
WireConnection;70;0;71;0
WireConnection;70;1;69;0
WireConnection;0;0;70;0
ASEEND*/
//CHKSM=A5A1F32293A7870E0ECD56F5E165262EBAA106BB