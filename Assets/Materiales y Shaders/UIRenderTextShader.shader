// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UIRenderTextShader"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		[NoScaleOffset][Normal]_DistortionNormal("Distortion Normal", 2D) = "bump" {}
		_TimeScale("Time Scale", Range( 0 , 2)) = 1
		_Radarcolorhdp("Radar color hdp", Color) = (0,1,0.1349115,1)
		_Insidesprteeffectcolor("Inside sprte effect color", Color) = (0,1,0.1450763,1)
		_Texture0("Texture 0", 2D) = "bump" {}
		_Distortionamount("Distortion amount", Float) = 0
		_MinRadius("MinRadius", Float) = 0
		_DistortionSpeed("Distortion Speed", Vector) = (0,0,0,0)
		_Texture4("Texture 4", 2D) = "white" {}
		_Texture1("Texture 1", 2D) = "white" {}
		_Texture2("Texture 2", 2D) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityShaderVariables.cginc"
			#include "UnityStandardUtils.cginc"
			#define ASE_NEEDS_FRAG_COLOR

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform sampler2D _Texture4;
			uniform sampler2D _Texture0;
			uniform float4 _Texture0_ST;
			uniform float4 _Insidesprteeffectcolor;
			uniform sampler2D _Texture2;
			uniform sampler2D _DistortionNormal;
			uniform float2 _DistortionSpeed;
			uniform float4 _Texture2_ST;
			uniform float _Distortionamount;
			uniform sampler2D _Texture1;
			uniform float4 _Radarcolorhdp;
			uniform float _TimeScale;
			uniform float _MinRadius;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_Texture0 = IN.texcoord.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float4 tex2DNode14_g8 = tex2D( _Texture0, uv_Texture0 );
				float2 appendResult20_g8 = (float2(tex2DNode14_g8.r , tex2DNode14_g8.g));
				float TimeVar197_g8 = _Time.y;
				float2 temp_cast_0 = (TimeVar197_g8).xx;
				float2 temp_output_18_0_g8 = ( appendResult20_g8 - temp_cast_0 );
				float4 tex2DNode72_g8 = tex2D( _Texture4, temp_output_18_0_g8 );
				float TimeVar197_g7 = _Time.y;
				float2 uv_Texture2 = IN.texcoord.xy * _Texture2_ST.xy + _Texture2_ST.zw;
				float2 MainUvs222_g7 = uv_Texture2;
				float4 tex2DNode65_g7 = tex2D( _DistortionNormal, ( ( _DistortionSpeed * TimeVar197_g7 ) + MainUvs222_g7 ) );
				float4 appendResult82_g7 = (float4(0.0 , tex2DNode65_g7.g , 0.0 , tex2DNode65_g7.r));
				float2 temp_output_84_0_g7 = (UnpackScaleNormal( appendResult82_g7, _Distortionamount )).xy;
				float2 panner179_g7 = ( 1.0 * _Time.y * float2( 0,0 ) + MainUvs222_g7);
				float2 temp_output_71_0_g7 = ( ( temp_output_84_0_g7 * tex2D( _Texture1, ( ( _DistortionSpeed * TimeVar197_g7 ) + MainUvs222_g7 ) ).g ) + panner179_g7 );
				float4 tex2DNode96_g7 = tex2D( _Texture2, temp_output_71_0_g7 );
				float4 temp_output_192_0_g8 = ( tex2DNode96_g7 * float4( 1,1,1,1 ) );
				float mulTime203 = _Time.y * _TimeScale;
				float2 appendResult254 = (float2(cos( mulTime203 ) , sin( mulTime203 )));
				float2 texCoord216 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 normalizeResult219 = normalize( ( texCoord216 - float2( 0.5,0.5 ) ) );
				float dotResult245 = dot( appendResult254 , normalizeResult219 );
				float smoothstepResult255 = smoothstep( 0.95 , 1.0 , dotResult245);
				float2 texCoord270 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float CenterMask275 = step( length( ( texCoord270 - float2( 0.5,0.5 ) ) ) , _MinRadius );
				
				half4 color = ( IN.color * ( ( ( ( tex2DNode72_g8 * _Insidesprteeffectcolor ) + temp_output_192_0_g8 ) + ( _Radarcolorhdp * smoothstepResult255 ) ) * CenterMask275 ) );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;484;1383;515;2513.29;-1080.39;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;264;-2961.263,2124.69;Inherit;False;1631.62;526.3401;Radar;9;217;216;218;219;245;255;256;257;237;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;198;-3350.295,1827.619;Inherit;False;Property;_TimeScale;Time Scale;7;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;203;-3062.933,1832.762;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;216;-2911.263,2342.55;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;217;-2868.263,2489.55;Inherit;False;Constant;_Vector1;Vector 1;10;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SinOpNode;237;-2822.123,2191.615;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;218;-2625.263,2357.55;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CosOpNode;236;-2819.123,1983.615;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;270;-2856.708,3110.632;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;254;-2469.591,2108.366;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;219;-2418.263,2358.55;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;271;-2621.375,3110.706;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;272;-2459.375,3110.706;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;274;-2426.375,3032.706;Inherit;False;Property;_MinRadius;MinRadius;12;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;192;-4157.958,1123.455;Inherit;True;Property;_Texture2;Texture 2;16;0;Create;True;0;0;0;False;0;False;50f5d21e33de59b4bb7e38615a1464f9;50f5d21e33de59b4bb7e38615a1464f9;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;195;-4117.391,1502.349;Inherit;True;Property;_Texture1;Texture 1;15;0;Create;True;0;0;0;False;0;False;e9453ef74db983f409c4ddc338308850;e9453ef74db983f409c4ddc338308850;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DotProductOpNode;245;-2124.793,2343.29;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;194;-4117.523,1345.831;Inherit;False;Property;_DistortionSpeed;Distortion Speed;13;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;269;-3787.17,1518.485;Inherit;False;Property;_Distortionamount;Distortion amount;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;273;-2256.375,3111.706;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;263;-2862.124,1597.644;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;256;-1803.993,2174.69;Inherit;False;Property;_Radarcolorhdp;Radar color hdp;8;0;Create;True;0;0;0;False;0;False;0,1,0.1349115,1;0,1,0.1349114,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;255;-1881.793,2348.29;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.95;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;199;-3796.809,1030.921;Inherit;False;Property;_Insidesprteeffectcolor;Inside sprte effect color;9;0;Create;True;0;0;0;False;0;False;0,1,0.1450763,1;0,1,0.1450762,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;261;-3238.132,1585.266;Inherit;True;Property;_Texture0;Texture 0;10;0;Create;True;0;0;0;False;0;False;1fd1729ec1f6c4d4b83c195a0184de84;1fd1729ec1f6c4d4b83c195a0184de84;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;202;-3659.984,1265.024;Inherit;True;UI-Sprite Effect Layer;0;;7;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,1,225,0,242,0,237,0,249,0,186,1,177,1,182,1,229,0,92,0,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;5;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.TexturePropertyNode;205;-3236.144,1397.19;Inherit;True;Property;_Texture4;Texture 4;14;0;Create;True;0;0;0;False;0;False;6b877baad4ae59141a83a973bec1f180;6b877baad4ae59141a83a973bec1f180;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;206;-2887.367,1342.441;Inherit;True;UI-Sprite Effect Layer;0;;8;789bf62641c5cfe4ab7126850acc22b8;18,74,1,204,1,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,0,98,0,234,0,126,0,129,1,130,0,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;-1564.793,2326.29;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;275;-2013.821,3106.686;Inherit;False;CenterMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;259;-2442.788,1389.185;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;278;-2340.29,1231.39;Inherit;False;275;CenterMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;208;-2102.268,892.7659;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;-2160.29,1314.39;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-1887.526,1153.78;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;89;-1622.185,1167.041;Float;False;True;-1;2;ASEMaterialInspector;0;4;UIRenderTextShader;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;203;0;198;0
WireConnection;237;0;203;0
WireConnection;218;0;216;0
WireConnection;218;1;217;0
WireConnection;236;0;203;0
WireConnection;254;0;236;0
WireConnection;254;1;237;0
WireConnection;219;0;218;0
WireConnection;271;0;270;0
WireConnection;272;0;271;0
WireConnection;245;0;254;0
WireConnection;245;1;219;0
WireConnection;273;0;272;0
WireConnection;273;1;274;0
WireConnection;255;0;245;0
WireConnection;202;37;192;0
WireConnection;202;80;269;0
WireConnection;202;183;194;0
WireConnection;202;188;195;0
WireConnection;206;192;202;0
WireConnection;206;39;199;0
WireConnection;206;37;205;0
WireConnection;206;33;261;0
WireConnection;206;40;263;2
WireConnection;257;0;256;0
WireConnection;257;1;255;0
WireConnection;275;0;273;0
WireConnection;259;0;206;0
WireConnection;259;1;257;0
WireConnection;276;0;259;0
WireConnection;276;1;278;0
WireConnection;209;0;208;0
WireConnection;209;1;276;0
WireConnection;89;0;209;0
ASEEND*/
//CHKSM=65CD6167F57099720CF8BC3B6DEDE9F3F6C8118B