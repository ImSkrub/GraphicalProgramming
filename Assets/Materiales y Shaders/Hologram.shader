// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hologram"
{
	Properties
	{
		_Thickness("Thickness", Range( 0 , 0.1)) = 0.04885225
		_Frecuency("Frecuency", Float) = 1.5
		_Float1("Float 1", Float) = 1.5
		_Speed("Speed", Range( 0 , 1)) = 2
		_PosTimeScale("Pos Time Scale", Range( 0 , 2)) = 2
		_NegTimeScale("Neg Time Scale", Range( -2 , -1)) = -1.831754
		_NegTimeScale1("Neg Time Scale", Range( -2 , -1)) = -1.831754
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

		uniform float _NegTimeScale1;
		uniform float _Thickness;
		uniform float _NegTimeScale;
		uniform float _Float1;
		uniform float _PosTimeScale;
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
			float temp_output_113_0 = ( ase_vertex3Pos.x * 2.5 );
			float mulTime258 = _Time.y * _NegTimeScale1;
			float smoothstepResult133 = smoothstep( 0.0 , 1.0 , sin( ( ( ( ( temp_output_113_0 + mulTime258 ) * 0.15 ) * 6.28318548202515 ) * 0.5 ) ));
			float Thirdholo132 = smoothstepResult133;
			float3 break7 = ase_vertex3Pos;
			float temp_output_3_0 = atan2( break7.x , break7.z );
			float HorizontalHolo2245 = step( frac( ( temp_output_3_0 + 0.2 ) ) , _Thickness );
			float mulTime100 = _Time.y * _NegTimeScale;
			float smoothstepResult98 = smoothstep( 0.0 , 1.0 , sin( ( ( ( temp_output_113_0 + mulTime100 ) * 0.25 ) * 6.28318548202515 ) ));
			float HorizontalnegSin105 = smoothstepResult98;
			float HorizontalHoloEffect1103 = step( frac( temp_output_3_0 ) , _Thickness );
			float mulTime76 = _Time.y * _PosTimeScale;
			float smoothstepResult84 = smoothstep( 0.0 , 1.0 , sin( ( ( ( ( ase_vertex3Pos.x * _Float1 ) + mulTime76 ) * 0.33 ) * 6.28318548202515 ) ));
			float HorizontalPositiveSin104 = smoothstepResult84;
			float smoothstepResult250 = smoothstep( 0.85 , 1.0 , frac( ( temp_output_3_0 / 0.58 ) ));
			float hor3251 = smoothstepResult250;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV23 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode23 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV23, _Fresnelpower ) );
			float FresnelEffect106 = fresnelNode23;
			float mulTime20 = _Time.y * _Speed;
			float smoothstepResult22 = smoothstep( 0.85 , 1.0 , sin( ( ( ( ( ase_vertex3Pos.y * _Frecuency ) + mulTime20 ) * 6.28318548202515 ) * _Direction ) ));
			float VerticalSinEffect101 = smoothstepResult22;
			float VerticalHoloEffect102 = step( frac( ( asin( break7.y ) / 0.42 ) ) , 0.08235294 );
			float temp_output_149_0 = ( ( ( ( Thirdholo132 * HorizontalHolo2245 ) + ( HorizontalnegSin105 * HorizontalHoloEffect1103 ) + ( HorizontalPositiveSin104 * hor3251 ) ) * FresnelEffect106 ) + ( VerticalSinEffect101 * VerticalHoloEffect102 * 2.0 ) );
			float4 color48 = IsGammaSpace() ? float4(0,0.9248903,1,0) : float4(0,0.8375679,1,0);
			o.Emission = ( temp_output_149_0 * color48 ).rgb;
			o.Alpha = saturate( temp_output_149_0 );
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
0;407;1383;592;4770.961;-146.1398;2.573945;True;False
Node;AmplifyShaderEditor.CommentaryNode;90;-4410.575,818.4488;Inherit;False;1662.529;905.0861;Horizontal;34;178;92;94;83;104;84;82;105;97;98;132;95;99;113;100;93;133;96;131;130;127;74;76;80;81;79;78;77;75;181;180;182;183;258;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-4424.838,1125.975;Inherit;False;Constant;_Float5;Float 5;9;0;Create;True;0;0;0;False;0;False;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;-4545.746,1390.51;Inherit;False;Property;_NegTimeScale1;Neg Time Scale;6;0;Create;True;0;0;0;False;0;False;-1.831754;-2;-2;-1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;72;-5539.771,538.2858;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;75;-4360.575,898.9497;Inherit;False;Property;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;1.5;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;258;-4248.651,1378.71;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-4526.367,1236.125;Inherit;False;Property;_NegTimeScale;Neg Time Scale;5;0;Create;True;0;0;0;False;0;False;-1.831754;-1;-2;-1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-4500.079,1012.95;Inherit;False;Property;_PosTimeScale;Pos Time Scale;4;0;Create;True;0;0;0;False;0;False;2;1.600433;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-4181.138,1107.975;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-3990.213,1457.909;Inherit;False;Constant;_Float3;Float 3;6;0;Create;True;0;0;0;False;0;False;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;100;-4229.273,1224.325;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-4160.478,868.4487;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;178;-4008.034,1344.181;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;26;-4356.977,-969.5726;Inherit;False;1573.15;696.16;GRID;15;7;4;9;8;10;11;12;3;102;103;241;242;245;265;266;;0,0.9374716,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;27;-4432.245,2106.805;Inherit;False;1500.9;319.16;Band;12;101;22;88;45;43;44;46;18;20;17;15;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;76;-4205.079,1011.95;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-3971.267,1013.63;Inherit;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;0;False;0;False;0.33;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-3966.58,884.2498;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-3988.39,1111.402;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;7;-4150.977,-769.5729;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;182;-3986.204,1220.284;Inherit;False;Constant;_Float6;Float 6;6;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-4511.556,2292.407;Inherit;False;Property;_Speed;Speed;3;0;Create;True;0;0;0;False;0;False;2;0.7770588;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-3846.913,1369.409;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;94;-3835.354,1463.601;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-4382.245,2180.806;Inherit;False;Property;_Frecuency;Frecuency;1;0;Create;True;0;0;0;False;0;False;1.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;20;-4226.748,2293.807;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;247;-4040.693,-93.42304;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0.58;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;3;-3963.804,-668.9995;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-3826.968,903.1307;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-3707.281,1422.996;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;242;-4031.052,-369.9319;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-3700.268,1517.184;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;183;-3795.345,1222.976;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-4182.147,2150.305;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;-3848.905,1093.784;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;81;-3759.036,1020.718;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;46;-3958.706,2306.575;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-3988.249,2166.106;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;241;-3807.45,-387.8313;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-3601.268,1382.184;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;257;-3773.247,-143.7788;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;-3678.272,1131.371;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-3687.336,905.7177;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;127;-3458.268,1350.184;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-3848.637,2184.988;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;9;-3603.218,-554.2527;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;244;-3603.92,-305.0591;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-3665.142,-659.3926;Inherit;False;Property;_Thickness;Thickness;0;0;Create;True;0;0;0;False;0;False;0.04885225;0.05058824;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;97;-3518.318,1135.808;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;265;-3973.276,-909.2091;Inherit;False;Constant;_Float7;Float 7;10;0;Create;True;0;0;0;False;0;False;0.42;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-3805.936,2325.487;Inherit;False;Property;_Direction;Direction;9;0;Create;True;0;0;0;False;0;False;-0.6;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;83;-3463.372,898.5297;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ASinOpNode;4;-3942.37,-832.5817;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;248;-3606.353,-96.42304;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;98;-3303.023,1162.528;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;133;-3298.168,1365.057;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;11;-3281.218,-580.2527;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;84;-3265.077,898.2498;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;250;-3297.949,-72.07205;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.85;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-3681.006,2193.574;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;243;-3281.92,-331.0591;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;266;-3789.276,-892.2091;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-2960.968,-593.363;Inherit;False;HorizontalHoloEffect1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;8;-3654.972,-926.5724;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;267;-3600.276,-1057.209;Inherit;False;Constant;_Float8;Float 8;10;0;Create;True;0;0;0;False;0;False;0.08235294;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;245;-2983.881,-349.427;Inherit;False;HorizontalHolo2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-2976.148,905.0858;Inherit;False;HorizontalPositiveSin;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1650.429,2108.803;Inherit;False;Property;_Fresnelpower;Fresnel power;8;0;Create;True;0;0;0;False;0;False;1.82;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1647.429,2032.802;Inherit;False;Property;_FresnelScale;Fresnel Scale;7;0;Create;True;0;0;0;False;0;False;1.87;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;88;-3512.841,2192.117;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;251;-2969.949,-55.07205;Inherit;False;hor3;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-3012.141,1155.6;Inherit;False;HorizontalnegSin;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-2981.264,1375.762;Inherit;False;Thirdholo;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;22;-3370.852,2177.632;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.85;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;10;-3341.059,-924.5724;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-2096.556,286.6337;Inherit;False;245;HorizontalHolo2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-2104.875,200.9328;Inherit;False;132;Thirdholo;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-1995.817,507.6778;Inherit;False;103;HorizontalHoloEffect1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-2018.486,414.5225;Inherit;False;105;HorizontalnegSin;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-2095.571,665.7054;Inherit;False;104;HorizontalPositiveSin;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-2083.252,764.4063;Inherit;False;251;hor3;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;23;-1351.428,1856.802;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-1722.093,619.0172;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-1719.809,158.2446;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1714.571,394.6778;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-1018.159,1855.309;Inherit;False;FresnelEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;-3110.883,-905.2034;Inherit;False;VerticalHoloEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-3139.741,2191.61;Inherit;False;VerticalSinEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;252;-1337.846,332.3609;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-2074.87,932.5053;Inherit;False;101;VerticalSinEffect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-1270.083,565.9424;Inherit;False;106;FresnelEffect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-2090.87,1019.505;Inherit;False;102;VerticalHoloEffect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;260;-2052.989,1150.076;Inherit;False;Constant;_Float4;Float 4;10;0;Create;True;0;0;0;False;0;False;2;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;255;-1000.166,336.1437;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-1722.841,936.6439;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-773.4529,1046.15;Inherit;False;Constant;_Color0;Color 0;6;0;Create;True;0;0;0;False;0;False;0,0.9248903,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;149;-685.6187,325.8321;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;73;-203.6751,354.5454;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-183.6434,154.9986;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;313.5034,87.90443;Float;False;True;-1;5;ASEMaterialInspector;0;0;Unlit;Hologram;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;258;0;259;0
WireConnection;113;0;72;1
WireConnection;113;1;114;0
WireConnection;100;0;99;0
WireConnection;77;0;72;1
WireConnection;77;1;75;0
WireConnection;178;0;113;0
WireConnection;178;1;258;0
WireConnection;76;0;74;0
WireConnection;78;0;77;0
WireConnection;78;1;76;0
WireConnection;92;0;113;0
WireConnection;92;1;100;0
WireConnection;7;0;72;0
WireConnection;95;0;178;0
WireConnection;95;1;93;0
WireConnection;20;0;16;0
WireConnection;3;0;7;0
WireConnection;3;1;7;2
WireConnection;80;0;78;0
WireConnection;80;1;79;0
WireConnection;96;0;95;0
WireConnection;96;1;94;0
WireConnection;17;0;72;2
WireConnection;17;1;15;0
WireConnection;181;0;92;0
WireConnection;181;1;182;0
WireConnection;18;0;17;0
WireConnection;18;1;20;0
WireConnection;241;0;3;0
WireConnection;241;1;242;0
WireConnection;130;0;96;0
WireConnection;130;1;131;0
WireConnection;257;0;3;0
WireConnection;257;1;247;0
WireConnection;180;0;181;0
WireConnection;180;1;183;0
WireConnection;82;0;80;0
WireConnection;82;1;81;0
WireConnection;127;0;130;0
WireConnection;43;0;18;0
WireConnection;43;1;46;0
WireConnection;9;0;3;0
WireConnection;244;0;241;0
WireConnection;97;0;180;0
WireConnection;83;0;82;0
WireConnection;4;0;7;1
WireConnection;248;0;257;0
WireConnection;98;0;97;0
WireConnection;133;0;127;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;84;0;83;0
WireConnection;250;0;248;0
WireConnection;45;0;43;0
WireConnection;45;1;44;0
WireConnection;243;0;244;0
WireConnection;243;1;12;0
WireConnection;266;0;4;0
WireConnection;266;1;265;0
WireConnection;103;0;11;0
WireConnection;8;0;266;0
WireConnection;245;0;243;0
WireConnection;104;0;84;0
WireConnection;88;0;45;0
WireConnection;251;0;250;0
WireConnection;105;0;98;0
WireConnection;132;0;133;0
WireConnection;22;0;88;0
WireConnection;10;0;8;0
WireConnection;10;1;267;0
WireConnection;23;2;24;0
WireConnection;23;3;25;0
WireConnection;116;0;109;0
WireConnection;116;1;107;0
WireConnection;119;0;120;0
WireConnection;119;1;121;0
WireConnection;117;0;108;0
WireConnection;117;1;118;0
WireConnection;106;0;23;0
WireConnection;102;0;10;0
WireConnection;101;0;22;0
WireConnection;252;0;119;0
WireConnection;252;1;117;0
WireConnection;252;2;116;0
WireConnection;255;0;252;0
WireConnection;255;1;136;0
WireConnection;115;0;110;0
WireConnection;115;1;111;0
WireConnection;115;2;260;0
WireConnection;149;0;255;0
WireConnection;149;1;115;0
WireConnection;73;0;149;0
WireConnection;195;0;149;0
WireConnection;195;1;48;0
WireConnection;0;2;195;0
WireConnection;0;9;73;0
ASEEND*/
//CHKSM=FAE4943CC04BB84324E1F0A76E4ACC0EE7C9CFA4