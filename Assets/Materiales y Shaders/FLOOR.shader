// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FLOOR"
{
	Properties
	{
		_d880Mat_baseColor("d880Mat_baseColor", 2D) = "white" {}
		_d880Mat_emissive("d880Mat_emissive", 2D) = "white" {}
		_d880Mat_metallicRoughness("d880Mat_metallicRoughness", 2D) = "white" {}
		_d880Mat_normal("d880Mat_normal", 2D) = "white" {}
		_Emissivescale("Emissive scale", Range( 0 , 2)) = 1
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
		uniform float _Emissivescale;
		uniform sampler2D _d880Mat_metallicRoughness;
		uniform float4 _d880Mat_metallicRoughness_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_d880Mat_normal = i.uv_texcoord * _d880Mat_normal_ST.xy + _d880Mat_normal_ST.zw;
			o.Normal = tex2D( _d880Mat_normal, uv_d880Mat_normal ).rgb;
			float2 uv_d880Mat_baseColor = i.uv_texcoord * _d880Mat_baseColor_ST.xy + _d880Mat_baseColor_ST.zw;
			o.Albedo = tex2D( _d880Mat_baseColor, uv_d880Mat_baseColor ).rgb;
			float2 uv_d880Mat_emissive = i.uv_texcoord * _d880Mat_emissive_ST.xy + _d880Mat_emissive_ST.zw;
			float4 tex2DNode2 = tex2D( _d880Mat_emissive, uv_d880Mat_emissive );
			float mulTime10 = _Time.y * _Emissivescale;
			o.Emission = saturate( ( tex2DNode2 * ( tex2DNode2.a * sin( mulTime10 ) ) ) ).rgb;
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
0;472;1383;527;2776.58;840.2419;2.802924;True;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-987.0063,501.3358;Inherit;False;Property;_Emissivescale;Emissive scale;4;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-819.0063,504.3358;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-945.5351,225.9051;Inherit;True;Property;_d880Mat_emissive;d880Mat_emissive;1;0;Create;True;0;0;0;False;0;False;-1;70ed6f740c212dc4db79d40d3d843cc3;70ed6f740c212dc4db79d40d3d843cc3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;9;-669.0063,481.3358;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-516.0063,332.3358;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-451.0063,223.3358;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;14;-208.0063,193.3358;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-773.3843,-559.8843;Inherit;True;Property;_d880Mat_baseColor;d880Mat_baseColor;0;0;Create;True;0;0;0;False;0;False;-1;490b35b0c3b72c7489de956fb4a919d7;490b35b0c3b72c7489de956fb4a919d7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-903.4404,-354.2438;Inherit;True;Property;_d880Mat_normal;d880Mat_normal;3;0;Create;True;0;0;0;False;0;False;-1;a86ba0b683e711a478efb9a02f8b90de;a86ba0b683e711a478efb9a02f8b90de;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;199.6225,610.6458;Inherit;True;Property;_d880Mat_metallicRoughness;d880Mat_metallicRoughness;2;0;Create;True;0;0;0;False;0;False;-1;a110d7e1a56f9e34cba5ad5230cf2661;a110d7e1a56f9e34cba5ad5230cf2661;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;FLOOR;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;11;0
WireConnection;9;0;10;0
WireConnection;12;0;2;4
WireConnection;12;1;9;0
WireConnection;13;0;2;0
WireConnection;13;1;12;0
WireConnection;14;0;13;0
WireConnection;0;0;1;0
WireConnection;0;1;4;0
WireConnection;0;2;14;0
WireConnection;0;3;3;0
WireConnection;0;4;3;0
ASEEND*/
//CHKSM=F51C6FBC132F56995A9014FE76333D9BFA8A147B