// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FLOOR"
{
	Properties
	{
		_d880Mat_baseColor("d880Mat_baseColor", 2D) = "white" {}
		_d880Mat_emissive("d880Mat_emissive", 2D) = "white" {}
		_d880Mat_metallicRoughness("d880Mat_metallicRoughness", 2D) = "white" {}
		_d880Mat_normal("d880Mat_normal", 2D) = "bump" {}
		_FlowIntensity("Flow Intensity", Float) = 1
		_Leftorright("Left or right ", Range( -1 , 2)) = -0.5828406
		_WaveSpeed("Wave Speed", Range( 0 , 1)) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _d880Mat_normal;
		uniform float4 _d880Mat_normal_ST;
		uniform sampler2D _d880Mat_baseColor;
		uniform float4 _d880Mat_baseColor_ST;
		uniform sampler2D _d880Mat_emissive;
		uniform float4 _d880Mat_emissive_ST;
		uniform float _FlowIntensity;
		uniform float _Leftorright;
		uniform float _WaveSpeed;
		uniform sampler2D _d880Mat_metallicRoughness;
		uniform float4 _d880Mat_metallicRoughness_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_d880Mat_normal = i.uv_texcoord * _d880Mat_normal_ST.xy + _d880Mat_normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _d880Mat_normal, uv_d880Mat_normal ) );
			float2 uv_d880Mat_baseColor = i.uv_texcoord * _d880Mat_baseColor_ST.xy + _d880Mat_baseColor_ST.zw;
			o.Albedo = tex2D( _d880Mat_baseColor, uv_d880Mat_baseColor ).rgb;
			float2 uv_d880Mat_emissive = i.uv_texcoord * _d880Mat_emissive_ST.xy + _d880Mat_emissive_ST.zw;
			float4 tex2DNode2 = tex2D( _d880Mat_emissive, uv_d880Mat_emissive );
			float mulTime151 = _Time.y * _Leftorright;
			float smoothstepResult170 = smoothstep( 0.5 , 1.0 , cos( ( ( ( ( i.uv_texcoord.x * _FlowIntensity ) + mulTime151 ) * 6.28318548202515 ) * _WaveSpeed ) ));
			o.Emission = saturate( ( tex2DNode2 * ( tex2DNode2.a * smoothstepResult170 ) ) ).rgb;
			float2 uv_d880Mat_metallicRoughness = i.uv_texcoord * _d880Mat_metallicRoughness_ST.xy + _d880Mat_metallicRoughness_ST.zw;
			float4 tex2DNode3 = tex2D( _d880Mat_metallicRoughness, uv_d880Mat_metallicRoughness );
			o.Metallic = tex2DNode3.r;
			o.Smoothness = tex2DNode3.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;466;1383;533;1728.062;-397.5426;1.145976;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;147;-1846.197,466.9196;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;160;-1768.194,615.2775;Inherit;False;Property;_FlowIntensity;Flow Intensity;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-1799.133,779.152;Inherit;False;Property;_Leftorright;Left or right ;5;0;Create;True;0;0;0;False;0;False;-0.5828406;-0.5828406;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-1508.056,545.3733;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;151;-1514.64,787.9012;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;165;-1306.361,780.2975;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;-1255.939,603.817;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-1105.813,603.8163;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-1066.85,756.2318;Inherit;False;Property;_WaveSpeed;Wave Speed;6;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-959.1281,608.4017;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;164;-853.6969,598.087;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;170;-622.205,612.9854;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1187.535,146.9051;Inherit;True;Property;_d880Mat_emissive;d880Mat_emissive;1;0;Create;True;0;0;0;False;0;False;-1;70ed6f740c212dc4db79d40d3d843cc3;70ed6f740c212dc4db79d40d3d843cc3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-705.1162,330.9124;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-486.0063,211.3358;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;199.6225,610.6458;Inherit;True;Property;_d880Mat_metallicRoughness;d880Mat_metallicRoughness;2;0;Create;True;0;0;0;False;0;False;-1;a110d7e1a56f9e34cba5ad5230cf2661;a110d7e1a56f9e34cba5ad5230cf2661;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-773.3843,-559.8843;Inherit;True;Property;_d880Mat_baseColor;d880Mat_baseColor;0;0;Create;True;0;0;0;False;0;False;-1;490b35b0c3b72c7489de956fb4a919d7;490b35b0c3b72c7489de956fb4a919d7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-903.4404,-354.2438;Inherit;True;Property;_d880Mat_normal;d880Mat_normal;3;0;Create;True;0;0;0;False;0;False;-1;a86ba0b683e711a478efb9a02f8b90de;a86ba0b683e711a478efb9a02f8b90de;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;14;-236.0063,199.3358;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;FLOOR;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;158;0;147;1
WireConnection;158;1;160;0
WireConnection;151;0;162;0
WireConnection;163;0;158;0
WireConnection;163;1;151;0
WireConnection;166;0;163;0
WireConnection;166;1;165;0
WireConnection;168;0;166;0
WireConnection;168;1;169;0
WireConnection;164;0;168;0
WireConnection;170;0;164;0
WireConnection;12;0;2;4
WireConnection;12;1;170;0
WireConnection;13;0;2;0
WireConnection;13;1;12;0
WireConnection;14;0;13;0
WireConnection;0;0;1;0
WireConnection;0;1;4;0
WireConnection;0;2;14;0
WireConnection;0;3;3;0
WireConnection;0;4;3;0
ASEEND*/
//CHKSM=43E14197A098C82036E9CC32389B7AA7805AF95B