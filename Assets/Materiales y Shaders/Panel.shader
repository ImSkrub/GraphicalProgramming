// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Panel"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_sci_fi4_Displacement("sci_fi4_Displacement", 2D) = "white" {}
		_sci_fi_4_Ambient("sci_fi_4_Ambient", 2D) = "white" {}
		_sci_fi_4_BaseColor("sci_fi_4_BaseColor", 2D) = "white" {}
		_sci_fi_4_Emissive("sci_fi_4_Emissive", 2D) = "white" {}
		_sci_fi_4_Metallic("sci_fi_4_Metallic", 2D) = "white" {}
		_sci_fi_4_Normal("sci_fi_4_Normal", 2D) = "white" {}
		_sci_fi_4_Roughness("sci_fi_4_Roughness", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf StandardCustom keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Translucency;
		};

		uniform sampler2D _sci_fi_4_Normal;
		uniform float4 _sci_fi_4_Normal_ST;
		uniform sampler2D _sci_fi_4_BaseColor;
		uniform float4 _sci_fi_4_BaseColor_ST;
		uniform sampler2D _sci_fi_4_Emissive;
		uniform float4 _sci_fi_4_Emissive_ST;
		uniform sampler2D _sci_fi_4_Metallic;
		uniform float4 _sci_fi_4_Metallic_ST;
		uniform sampler2D _sci_fi_4_Roughness;
		uniform float4 _sci_fi_4_Roughness_ST;
		uniform sampler2D _sci_fi_4_Ambient;
		uniform float4 _sci_fi_4_Ambient_ST;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform sampler2D _sci_fi4_Displacement;
		uniform float4 _sci_fi4_Displacement_ST;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_sci_fi_4_Normal = v.texcoord * _sci_fi_4_Normal_ST.xy + _sci_fi_4_Normal_ST.zw;
			float4 Normal13 = tex2Dlod( _sci_fi_4_Normal, float4( uv_sci_fi_4_Normal, 0, 0.0) );
			v.normal = ( Normal13 * 1.5 ).rgb;
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float2 uv_sci_fi_4_Normal = i.uv_texcoord * _sci_fi_4_Normal_ST.xy + _sci_fi_4_Normal_ST.zw;
			float4 Normal13 = tex2D( _sci_fi_4_Normal, uv_sci_fi_4_Normal );
			o.Normal = Normal13.rgb;
			float2 uv_sci_fi_4_BaseColor = i.uv_texcoord * _sci_fi_4_BaseColor_ST.xy + _sci_fi_4_BaseColor_ST.zw;
			float4 Albedo8 = tex2D( _sci_fi_4_BaseColor, uv_sci_fi_4_BaseColor );
			o.Albedo = Albedo8.rgb;
			float2 uv_sci_fi_4_Emissive = i.uv_texcoord * _sci_fi_4_Emissive_ST.xy + _sci_fi_4_Emissive_ST.zw;
			float4 Emisive10 = tex2D( _sci_fi_4_Emissive, uv_sci_fi_4_Emissive );
			o.Emission = Emisive10.rgb;
			float2 uv_sci_fi_4_Metallic = i.uv_texcoord * _sci_fi_4_Metallic_ST.xy + _sci_fi_4_Metallic_ST.zw;
			float4 Metallic14 = tex2D( _sci_fi_4_Metallic, uv_sci_fi_4_Metallic );
			o.Metallic = Metallic14.r;
			float2 uv_sci_fi_4_Roughness = i.uv_texcoord * _sci_fi_4_Roughness_ST.xy + _sci_fi_4_Roughness_ST.zw;
			float4 Roughness12 = tex2D( _sci_fi_4_Roughness, uv_sci_fi_4_Roughness );
			o.Smoothness = Roughness12.r;
			float2 uv_sci_fi_4_Ambient = i.uv_texcoord * _sci_fi_4_Ambient_ST.xy + _sci_fi_4_Ambient_ST.zw;
			float4 Ambientoclusion11 = tex2D( _sci_fi_4_Ambient, uv_sci_fi_4_Ambient );
			o.Occlusion = Ambientoclusion11.r;
			float2 uv_sci_fi4_Displacement = i.uv_texcoord * _sci_fi4_Displacement_ST.xy + _sci_fi4_Displacement_ST.zw;
			float4 Displacement9 = tex2D( _sci_fi4_Displacement, uv_sci_fi4_Displacement );
			o.Translucency = Displacement9.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1920;15;1920;996;1057.777;228.338;1;True;False
Node;AmplifyShaderEditor.SamplerNode;6;-1440.69,852.6112;Inherit;True;Property;_sci_fi_4_Normal;sci_fi_4_Normal;17;0;Create;True;0;0;0;False;0;False;-1;61996249d13959c4f934eba20f08c80d;61996249d13959c4f934eba20f08c80d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1425.113,1053.831;Inherit;True;Property;_sci_fi_4_Metallic;sci_fi_4_Metallic;16;0;Create;True;0;0;0;False;0;False;-1;cbdeff1ef137dff41a0168b12c078c8a;cbdeff1ef137dff41a0168b12c078c8a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1471.252,-219.1411;Inherit;True;Property;_sci_fi_4_BaseColor;sci_fi_4_BaseColor;14;0;Create;True;0;0;0;False;0;False;-1;166e9d22c709e6b4d802a3e0a28c84e5;166e9d22c709e6b4d802a3e0a28c84e5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-1444.72,231.4844;Inherit;True;Property;_sci_fi_4_Emissive;sci_fi_4_Emissive;15;0;Create;True;0;0;0;False;0;False;-1;3dc6f01f3d3ebf04db821654637d4437;3dc6f01f3d3ebf04db821654637d4437;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1453.362,431.0313;Inherit;True;Property;_sci_fi_4_Ambient;sci_fi_4_Ambient;13;0;Create;True;0;0;0;False;0;False;-1;20e7ed27da426144fa82e2500e108c77;20e7ed27da426144fa82e2500e108c77;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-1428.597,633.6892;Inherit;True;Property;_sci_fi_4_Roughness;sci_fi_4_Roughness;18;0;Create;True;0;0;0;False;0;False;-1;92d96824ce3a3aa45b08aaf9ed234d6f;92d96824ce3a3aa45b08aaf9ed234d6f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1447.877,15.62505;Inherit;True;Property;_sci_fi4_Displacement;sci_fi4_Displacement;12;0;Create;True;0;0;0;False;0;False;-1;c9f38e0d829f4234894d911c4658127d;c9f38e0d829f4234894d911c4658127d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1071.276,860.6921;Inherit;False;Normal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-1070.276,647.6921;Inherit;False;Roughness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-360.7773,487.662;Inherit;False;13;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-1118.276,-177.3079;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1044.276,1054.692;Inherit;False;Metallic;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-351.7773,588.662;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1103.276,255.6921;Inherit;False;Emisive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-1088.276,435.6921;Inherit;False;Ambientoclusion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-1110.276,49.69214;Inherit;False;Displacement;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-462.6619,-63.45288;Inherit;False;8;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-479.6619,233.5471;Inherit;False;11;Ambientoclusion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-546.7045,377.7999;Inherit;False;9;Displacement;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-135.7773,514.662;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-502.6619,11.54712;Inherit;False;13;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-355.7045,321.7999;Inherit;False;12;Roughness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-320.6619,153.5471;Inherit;False;14;Metallic;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-519.6619,111.5471;Inherit;False;10;Emisive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;105,-12;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Panel;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;5;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;6;0
WireConnection;12;0;7;0
WireConnection;8;0;3;0
WireConnection;14;0;5;0
WireConnection;10;0;4;0
WireConnection;11;0;2;0
WireConnection;9;0;1;0
WireConnection;25;0;24;0
WireConnection;25;1;26;0
WireConnection;0;0;15;0
WireConnection;0;1;16;0
WireConnection;0;2;17;0
WireConnection;0;3;19;0
WireConnection;0;4;20;0
WireConnection;0;5;18;0
WireConnection;0;7;21;0
WireConnection;0;12;25;0
ASEEND*/
//CHKSM=83A163E65D3D3D93F37004B6B452505A5347D118