// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hologram"
{
	Properties
	{
		_Thickness("Thickness", Range( 0 , 0.1)) = 0.08823534
		_Frecuency("Frecuency", Float) = 1.5
		_Float1("Float 1", Float) = 1.5
		_Speed("Speed", Float) = 2
		_Float0("Float 0", Float) = 2
		_FresnelScale("Fresnel Scale", Float) = 1.87
		_Fresnelpower("Fresnel power", Float) = 1.82
		_Direction("Direction", Float) = -0.6
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.5
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _Thickness;
		uniform float _Float1;
		uniform float _Float0;
		uniform float _FresnelScale;
		uniform float _Fresnelpower;
		uniform float _Frecuency;
		uniform float _Speed;
		uniform float _Direction;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 break7 = ase_vertex3Pos;
			float mulTime76 = _Time.y * _Float0;
			float smoothstepResult84 = smoothstep( 0.0 , 1.0 , sin( ( ( ( ( ase_vertex3Pos.x * _Float1 ) + mulTime76 ) * 1.0 ) * 6.28318548202515 ) ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV23 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode23 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV23, _Fresnelpower ) );
			float mulTime20 = _Time.y * _Speed;
			float smoothstepResult22 = smoothstep( 0.0 , 1.0 , sin( ( ( ( ( ase_vertex3Pos.y * _Frecuency ) + mulTime20 ) * _Direction ) * 6.28318548202515 ) ));
			float temp_output_87_0 = ( ( ( step( frac( atan2( break7.x , break7.z ) ) , _Thickness ) * smoothstepResult84 ) * fresnelNode23 ) + ( step( frac( asin( break7.y ) ) , _Thickness ) * smoothstepResult22 ) );
			float4 color48 = IsGammaSpace() ? float4(0,0.9248903,1,0) : float4(0,0.8375679,1,0);
			o.Emission = ( temp_output_87_0 * color48 ).rgb;
			o.Alpha = saturate( temp_output_87_0 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.5
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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
1920;15;1920;996;3273.683;82.15672;1.680269;True;False
Node;AmplifyShaderEditor.CommentaryNode;27;-3039.528,1075.057;Inherit;False;1171.9;334.16;Band;11;17;18;20;16;15;22;43;44;45;46;88;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;72;-3077.111,441.221;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;75;-2917.229,719.5782;Inherit;False;Property;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;1.5;2.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-2905.733,829.5792;Inherit;False;Property;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;2;0.89;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2717.133,689.0772;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;76;-2761.733,832.5792;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2989.528,1149.058;Inherit;False;Property;_Frecuency;Frecuency;1;0;Create;True;0;0;0;False;0;False;1.5;1.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2978.032,1259.059;Inherit;False;Property;_Speed;Speed;3;0;Create;True;0;0;0;False;0;False;2;0.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;26;-2619.63,-137.8234;Inherit;False;1573.15;696.16;GRID;8;7;4;9;8;10;11;12;3;;0,0.9374716,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-2527.921,834.2592;Inherit;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-2789.432,1118.557;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;20;-2834.032,1262.059;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-2523.234,704.8782;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-2383.622,723.7592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;81;-2315.69,841.3472;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-2595.533,1134.358;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2600.22,1263.739;Inherit;False;Property;_Direction;Direction;7;0;Create;True;0;0;0;False;0;False;-0.6;-0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;7;-2413.63,62.17668;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TauNode;46;-2387.989,1270.827;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-2455.921,1153.239;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-2215.99,732.3463;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;3;-2125.63,153.1766;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ASinOpNode;4;-2124.63,45.17673;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-2288.289,1161.826;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;83;-2073.027,725.1581;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1974.93,406.7769;Inherit;False;Property;_Thickness;Thickness;0;0;Create;True;0;0;0;False;0;False;0.08823534;0.0771;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;9;-1975.63,181.1766;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;88;-2120.125,1160.369;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;84;-1886.732,718.8782;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;8;-1981.63,-54.82318;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1652.469,1391.904;Inherit;False;Property;_FresnelScale;Fresnel Scale;5;0;Create;True;0;0;0;False;0;False;1.87;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1655.469,1467.904;Inherit;False;Property;_Fresnelpower;Fresnel power;6;0;Create;True;0;0;0;False;0;False;1.82;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;11;-1628.63,151.1767;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;10;-1628.63,-67.82319;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1377.014,547.7031;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;23;-1356.468,1215.904;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;22;-1959.028,1148.358;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1359.532,785.5937;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-1036.254,538.5044;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-775.2544,593.5044;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-773.4529,1046.15;Inherit;False;Constant;_Color0;Color 0;6;0;Create;True;0;0;0;False;0;False;0,0.9248903,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;73;-330.6032,251.2813;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-564.154,715.9499;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,-1.667952;Float;False;True;-1;5;ASEMaterialInspector;0;0;Unlit;Hologram;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;77;0;72;1
WireConnection;77;1;75;0
WireConnection;76;0;74;0
WireConnection;17;0;72;2
WireConnection;17;1;15;0
WireConnection;20;0;16;0
WireConnection;78;0;77;0
WireConnection;78;1;76;0
WireConnection;80;0;78;0
WireConnection;80;1;79;0
WireConnection;18;0;17;0
WireConnection;18;1;20;0
WireConnection;7;0;72;0
WireConnection;43;0;18;0
WireConnection;43;1;44;0
WireConnection;82;0;80;0
WireConnection;82;1;81;0
WireConnection;3;0;7;0
WireConnection;3;1;7;2
WireConnection;4;0;7;1
WireConnection;45;0;43;0
WireConnection;45;1;46;0
WireConnection;83;0;82;0
WireConnection;9;0;3;0
WireConnection;88;0;45;0
WireConnection;84;0;83;0
WireConnection;8;0;4;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;10;0;8;0
WireConnection;10;1;12;0
WireConnection;85;0;11;0
WireConnection;85;1;84;0
WireConnection;23;2;24;0
WireConnection;23;3;25;0
WireConnection;22;0;88;0
WireConnection;28;0;10;0
WireConnection;28;1;22;0
WireConnection;86;0;85;0
WireConnection;86;1;23;0
WireConnection;87;0;86;0
WireConnection;87;1;28;0
WireConnection;73;0;87;0
WireConnection;47;0;87;0
WireConnection;47;1;48;0
WireConnection;0;2;47;0
WireConnection;0;9;73;0
ASEEND*/
//CHKSM=B04AA1BB4DF479484F35B280C1E44AC77F8B40A7