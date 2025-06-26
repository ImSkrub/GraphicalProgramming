// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( GlitchEffectPostProcessPPSRenderer ), PostProcessEvent.AfterStack, "GlitchEffectPostProcess", true )]
public sealed class GlitchEffectPostProcessPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Screen" )]
	public TextureParameter _MainTex = new TextureParameter {  };
	[Tooltip( "Noise Time Scale" )]
	public FloatParameter _NoiseTimeScale = new FloatParameter { value = 1f };
	[Tooltip( "Screen Blend" )]
	public FloatParameter _ScreenBlend = new FloatParameter { value = 0f };
	[Tooltip( "Time Mult" )]
	public FloatParameter _TimeMult = new FloatParameter { value = 4f };
	[Tooltip( "Noise Scale" )]
	public FloatParameter _NoiseScale = new FloatParameter { value = 10f };
	[Tooltip( "Flickering mult" )]
	public FloatParameter _Flickeringmult = new FloatParameter { value = 3f };
	[Tooltip( "Flicker Time scale" )]
	public FloatParameter _FlickerTimescale = new FloatParameter { value = 1f };
	[Tooltip( "Mod Flicker effect" )]
	public FloatParameter _ModFlickereffect = new FloatParameter { value = 0.3529412f };
}

public sealed class GlitchEffectPostProcessPPSRenderer : PostProcessEffectRenderer<GlitchEffectPostProcessPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "GlitchEffectPostProcess" ) );
		if(settings._MainTex.value != null) sheet.properties.SetTexture( "_MainTex", settings._MainTex );
		sheet.properties.SetFloat( "_NoiseTimeScale", settings._NoiseTimeScale );
		sheet.properties.SetFloat( "_ScreenBlend", settings._ScreenBlend );
		sheet.properties.SetFloat( "_TimeMult", settings._TimeMult );
		sheet.properties.SetFloat( "_NoiseScale", settings._NoiseScale );
		sheet.properties.SetFloat( "_Flickeringmult", settings._Flickeringmult );
		sheet.properties.SetFloat( "_FlickerTimescale", settings._FlickerTimescale );
		sheet.properties.SetFloat( "_ModFlickereffect", settings._ModFlickereffect );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
