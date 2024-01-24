Shader "ShaderBloom/ApplicationBloomGroup"
{

	Properties {
		[HideInInspector]_Color ("Tint", Color) = (0, 0, 0, 0)
		[HDR]_ColorGlowHDR ("ColorValue", Color) = (1, 1, 1, 1)
		_AlphaColor ("AlphaColor", Range(-3, 3)) = 0.5
		[HideInInspector]_MainTex ("Albedo", 2D) = "white" {}

		[HideInInspector][NoScaleOffset] _NormalMap ("Normals", 2D) = "bump" {}
		[HideInInspector]_BumpScale ("Bump Scale", Float) = 1

		[HideInInspector][NoScaleOffset] _MetallicMap ("Metallic", 2D) = "white" {}
		[HideInInspector][Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
		[HideInInspector]_Smoothness ("Smoothness", Range(0, 1)) = 0.1

		[HideInInspector][NoScaleOffset] _ParallaxMap ("Parallax", 2D) = "black" {}
		[HideInInspector]_ParallaxStrength ("Parallax Strength", Range(0, 0.1)) = 0

		[HideInInspector][NoScaleOffset] _OcclusionMap ("Occlusion", 2D) = "white" {}
		[HideInInspector]_OcclusionStrength ("Occlusion Strength", Range(0, 1)) = 1

		[HideInInspector][NoScaleOffset] _EmissionMap ("Emission", 2D) = "black" {}
		[HideInInspector][HDR]_Emission ("Emission", Color) = (0, 0, 0)

		[HideInInspector][NoScaleOffset] _DetailMask ("Detail Mask", 2D) = "white" {}
		[HideInInspector]_DetailTex ("Detail Albedo", 2D) = "gray" {}
		[HideInInspector][NoScaleOffset] _DetailNormalMap ("Detail Normals", 2D) = "bump" {}
		[HideInInspector]_DetailBumpScale ("Detail Bump Scale", Float) = 1

		[HideInInspector]_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.0

		[HideInInspector] _SrcBlend ("_SrcBlend", Float) = 0
		[HideInInspector] _DstBlend ("_DstBlend", Float) = 0
		[HideInInspector] _ZWrite ("_ZWrite", Float) = 1



	    _ColorOperation ("ColorForSomething", Color) = (1.0, 1.0, 1.0, 1.0)

        _TextureSprite ("_TextureSprite", 2D)     = "green" {}
        _TextureChannel0 ("_TextureChannel0", 2D) = "green" {}
        _TextureChannel1 ("_TextureChannel1", 2D) = "green" {}
        _TextureChannel2 ("_TextureChannel2", 2D) = "green" {}
        _TextureChannel3 ("_TextureChannel3", 2D) = "green" {}


        _OverlaySelection("_OverlaySelection", Range(0.0, 1.0)) = 1.0

        _StickerType("_StickerType", Float) = 1.0
        _MotionState("_MotionState", Float) = 1.0
        _BorderColor("_BorderColor", Color) = (1.0, 1.0, 1.0, 1.0)
        _BorderSizeOne("_BorderSizeOne", Float) = 1.0
        _BorderSizeTwo("_BorderSizeTwo", Float) = 1.0
        _BorderBlurriness("_BorderBlurriness", Float) = 1.0
        _RangeSOne_One0("_RangeSOne_One0", Float) = 1.0
        _RangeSOne_One1("_RangeSOne_One1", Float) = 1.0
        _RangeSOne_One2("_RangeSOne_One2", Float) = 1.0
        _RangeSOne_One3("_RangeSOne_One3", Float) = 1.0
        _RangeSTen_Ten0("_RangeSTen_Ten0", Float) = 1.0
        _RangeSTen_Ten1("_RangeSTen_Ten1", Float) = 1.0
        _RangeSTen_Ten2("_RangeSTen_Ten2", Float) = 1.0
        _RangeSTen_Ten3("_RangeSTen_Ten3", Float) = 1.0

        _InVariableTickY(" _InVariableTickY", Float) = 1.0
        _InVariableRatioX("_InVariableRatioX", Float) = 1.0
        _InVariableRatioY("_InVariableRatioY", Float) = 1.0
        _OutlineColor("_OutlineColor", Color) = (1.0, 1.0, 1.0, 1.0)
        _OutlineSprite("_OutlineSprite", Float) = 1.0

        _GlowFull("_GlowFull", Range(0.0, 1.0)) = 0.0


	}

	CGINCLUDE

	#define BINORMAL_PER_FRAGMENT
	#define FOG_DISTANCE

	#define PARALLAX_BIAS 0
//	#define PARALLAX_OFFSET_LIMITING
	#define PARALLAX_RAYMARCHING_STEPS 10
	#define PARALLAX_RAYMARCHING_INTERPOLATE
//	#define PARALLAX_RAYMARCHING_SEARCH_STEPS 3
	#define PARALLAX_FUNCTION ParallaxRaymarching
	#define PARALLAX_SUPPORT_SCALED_DYNAMIC_BATCHING

	ENDCG

	SubShader {

        LOD 500


		Pass {
			Tags {
				"LightMode" = "ForwardBase"
				"RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" 

			}
			// Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
            Cull off
            Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM

			#pragma target 3.0

			#pragma shader_feature _ _RENDERING_CUTOUT _RENDERING_FADE _RENDERING_TRANSPARENT
			#pragma shader_feature _METALLIC_MAP
			#pragma shader_feature _ _SMOOTHNESS_ALBEDO _SMOOTHNESS_METALLIC
			#pragma shader_feature _NORMAL_MAP
			#pragma shader_feature _PARALLAX_MAP
			#pragma shader_feature _OCCLUSION_MAP
			#pragma shader_feature _EMISSION_MAP
			#pragma shader_feature _DETAIL_MASK
			#pragma shader_feature _DETAIL_ALBEDO_MAP
			#pragma shader_feature _DETAIL_NORMAL_MAP

			#pragma multi_compile _ LOD_FADE_CROSSFADE

			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			#pragma multi_compile_instancing
			#pragma instancing_options lodfade force_same_maxcount_for_gl

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#define FORWARD_BASE_PASS

			#include "My Lighting.cginc"

			ENDCG
		}

		Pass {
			Tags {
				"LightMode" = "ForwardAdd"
				"RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" 
			}

			// Blend [_SrcBlend] One
			ZWrite Off
            Cull off
            Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM

			#pragma target 3.0

			#pragma shader_feature _ _RENDERING_CUTOUT _RENDERING_FADE _RENDERING_TRANSPARENT
			#pragma shader_feature _METALLIC_MAP
			#pragma shader_feature _ _SMOOTHNESS_ALBEDO _SMOOTHNESS_METALLIC
			#pragma shader_feature _NORMAL_MAP
			#pragma shader_feature _PARALLAX_MAP
			#pragma shader_feature _DETAIL_MASK
			#pragma shader_feature _DETAIL_ALBEDO_MAP
			#pragma shader_feature _DETAIL_NORMAL_MAP

			#pragma multi_compile _ LOD_FADE_CROSSFADE

			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog
			
			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "My Lighting.cginc"

			ENDCG
		}

		Pass {
			Tags {
				"LightMode" = "Deferred"
				"RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" 
			}

       		ZWrite Off
            Cull off
            Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM

			#pragma target 3.0
			#pragma exclude_renderers nomrt

			#pragma shader_feature _ _RENDERING_CUTOUT
			#pragma shader_feature _METALLIC_MAP
			#pragma shader_feature _ _SMOOTHNESS_ALBEDO _SMOOTHNESS_METALLIC
			#pragma shader_feature _NORMAL_MAP
			#pragma shader_feature _PARALLAX_MAP
			#pragma shader_feature _OCCLUSION_MAP
			#pragma shader_feature _EMISSION_MAP
			#pragma shader_feature _DETAIL_MASK
			#pragma shader_feature _DETAIL_ALBEDO_MAP
			#pragma shader_feature _DETAIL_NORMAL_MAP

			#pragma multi_compile _ LOD_FADE_CROSSFADE

			#pragma multi_compile_prepassfinal
			#pragma multi_compile_instancing
			#pragma instancing_options lodfade

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#define DEFERRED_PASS

			#include "My Lighting.cginc"

			ENDCG
		}

		// Pass {
		// 	Tags {
		// 		"LightMode" = "ShadowCaster"
		// 	}

		// 	CGPROGRAM

		// 	#pragma target 3.0

		// 	#pragma shader_feature _ _RENDERING_CUTOUT _RENDERING_FADE _RENDERING_TRANSPARENT
		// 	#pragma shader_feature _SEMITRANSPARENT_SHADOWS
		// 	#pragma shader_feature _SMOOTHNESS_ALBEDO

		// 	#pragma multi_compile _ LOD_FADE_CROSSFADE

		// 	#pragma multi_compile_shadowcaster
		// 	#pragma multi_compile_instancing
		// 	#pragma instancing_options lodfade force_same_maxcount_for_gl

		// 	#pragma vertex MyShadowVertexProgram
		// 	#pragma fragment MyShadowFragmentProgram

		// 	#include "My Shadows.cginc"

		// 	ENDCG
		// }

		// Pass
  //       {
  //       Tags { "RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" }


  //           ZWrite Off
  //           Cull off
  //           Blend SrcAlpha OneMinusSrcAlpha
            

  //           CGPROGRAM
  //           #pragma vertex vert
  //           #pragma fragment frag
  //           // make fog work
  //           #pragma multi_compile_fog

  //           #include "UnityCG.cginc"

		// 	#include "UnityPBSLighting.cginc"
		// 	#include "UnityMetaPass.cginc"

  //           float3 _Emission;


  //           struct appdata
  //           {
  //               float4 vertex : POSITION;
  //               float2 uv : TEXCOORD0;
  //           };

  //           struct v2f
  //           {
  //               float2 uv : TEXCOORD0;
  //               UNITY_FOG_COORDS(1)
  //               float4 vertex : SV_POSITION;
  //           };

  //           sampler2D _MainTex;
  //           float4 _MainTex_ST;

  //           v2f vert (appdata v)
  //           {
  //               v2f o;
  //               o.vertex = UnityObjectToClipPos(v.vertex);
  //               o.uv = TRANSFORM_TEX(v.uv, _MainTex);
  //               return o;
  //           }


		// 	float3 GetEmission (v2f i) {
		// 		#if defined(_EMISSION_MAP)
		// 			return tex2D(_EmissionMap, i.uv.xy) * _Emission;
		// 		#else
		// 			return _Emission;
		// 		#endif
		// 	}

  //           fixed4 frag (v2f PIXEL) : SV_Target
  //           {
  //               // sample the texture

  //               float2 coordinate = PIXEL.uv;
                
  //               float2 coordinateScale = (PIXEL.uv - 0.5) * 2.0 ;
                
  //               float2 coordinateShade = coordinateScale/(float2(2.0, 2.0));
                
  //               float2 coordinateFull = ceil(coordinateShade);

  //               float3 colBase  = 0.0;  

  //               float3 colTexture = float3(coordinateScale.x + coordinateScale.y, coordinateScale.y - coordinateScale.x, pow(coordinate.x,2.0f));


  //               float4 col = float4(colTexture, 1.0);

  //               // float ticks = 1s;
  //               // 1 ticks = 1 sprite
  //               // how many ticks on a second?
  //               // // size of the sprite seheek/*

  //               // ////////// starts at 0 to sprite.Length() - 1;
  //               // int _inVariableTickX = 0;
  //               // int _inVariableTickY = 0;
  //               // ////////// starts at 0 to sprite.Length() - 1;

  //               // int tickX = _inVariableTickX;
  //               // int tickY = _inVariableTickY;

  //               // int ratioX = _inVariableRatioX;
  //               // int ratioY = _inVariableRatioY;*/

                    
  //               // float4 valueText = tex2D(_MainTex, float2((coordinate.x/ratioX) + (1/ratioX) * tickX, (coordinate.y/ratioY) + (1/ratioY) * tickY ));
  //               // valueText = tex2D(_MainTex, float2((coordinate.x), (coordinate.y) ));

  //               // bool elementoBoolean  = functionCurrentTime(_Time.y, variableTimeOutOne, variableTimeOutTwo);
  //               // functionCurrentTime(_Time.y, variableTimeOutOne, variableTimeOutTwo);
  //               float paintPoint = float2(abs(cos(_Time.y)), abs(sin(_Time.y)));
  //               float radio = 0.1;
  //               float lenghtRadio = length(coordinate - paintPoint);
 

  //               if (lenghtRadio < radio)
  //               {
  //                   // return float4(GetEmission(PIXEL), 1.0);
  //                   return float4(1.0, 1.0, 1.0, 1.0) + float4(GetEmission(PIXEL), 1.0);//+ col;
  //                   // return 0.0;
  //               }
  //               else
  //               {
  //                   return float4(0.0, 0.0, 0.0, 0.0);
  //               }
  //               // return lenghtRadio;
  //               // return tex2D(_MainTex, coordinate);




  //               // return col;
  //           }
  //           ENDCG
  //       }


        Pass
        {
			Tags { "RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" }
            
            ZWrite Off
            Cull off
            Blend SrcAlpha OneMinusSrcAlpha
            
            HLSLPROGRAM
            #pragma vertex VERTEXSHADER
            #pragma fragment FRAGMENTSHADER
            
            #pragma multi_compile_instancing
            

            #include "UnityCG.cginc"


            #define PI 3.1415926535897931
            #define TIME _Time.y          


            sampler2D _TextureSprite;
            sampler2D _TextureChannel0;
            sampler2D _TextureChannel1;
            sampler2D _TextureChannel2;
            sampler2D _TextureChannel3;
            
            float _OverlaySelection;

            float _StickerType;
            float _MotionState;

            float4 _BorderColor;
            float _BorderSizeOne;
            float _BorderSizeTwo;
            float _BorderBlurriness;

            float _RangeSOne_One0; 
            float _RangeSOne_One1; 
            float _RangeSOne_One2; 
            float _RangeSOne_One3; 

            float _RangeSTen_Ten0;
            float _RangeSTen_Ten1;
            float _RangeSTen_Ten2;
            float _RangeSTen_Ten3;

            float _InVariableTick;
            float _InVariableRatioX;
            float _InVariableRatioY;
            float4 _OutlineColor;
            float _OutlineSprite;

            float4 _ColorGlowHDR;
            float _AlphaColor;
            float _GlowFull;




            #include "SDfs.hlsl"
            #include "Stickers.hlsl"
            #include "Sprites.hlsl"



			#include "UnityPBSLighting.cginc"
			#include "UnityMetaPass.cginc"

            struct vertexPoints
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            
            };

            struct pixelPoints
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };




            pixelPoints VERTEXSHADER (vertexPoints VERTEXSPACE)
            {
                pixelPoints PIXELSPACE;


                PIXELSPACE.vertex = UnityObjectToClipPos(VERTEXSPACE.vertex);
 
                PIXELSPACE.uv = VERTEXSPACE.uv;
                PIXELSPACE.uv2 = VERTEXSPACE.uv2;
                return PIXELSPACE;
            }


            #define Number _FloatNumber
            #define NumberOne _FloatVariable


            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////



			
			float saturate(float color)
			{
				return clamp(color, 0.0, 1.0);
			}
			
			float2 saturate(float2 color)
			{
				return clamp(color, 0.0, 1.0);
			}
			
			float3 saturate(float3 color)
			{
				return clamp(color, 0.0, 1.0);
			}
			
			float4 saturate(float4 color)
			{
				return clamp(color, 0.0, 1.0);
			}


            //////////////////////////////////////////////////////////////////////////////////////////////
            /// DEFAULT
            //////////////////////////////////////////////////////////////////////////////////////////////


            fixed4 FRAGMENTSHADER (pixelPoints PIXELSPACE) : SV_Target
            {
                float2 coordinateSprite = PIXELSPACE.uv2;

                float2 coordinate = PIXELSPACE.uv;
                
                float2 coordinateScale = (PIXELSPACE.uv - 0.5) * 2.0 ;
                
                float2 coordinateShade = coordinateScale/(float2(2.0, 2.0));
                
                float2 coordinateFull = ceil(coordinateShade);

                float3 colBase  = 0.0;  

                float3 colTexture = float3(coordinateScale.x + coordinateScale.y, coordinateScale.y - coordinateScale.x, pow(coordinate.x,2.0f));


			//////////////////////////////////////////////////////////////////////////////////////////////
			///	DEFAULT
			//////////////////////////////////////////////////////////////////////////////////////////////
	                colBase = 0.0;

            //////////////////////////////////////////////////////////////////////////////////////////////
                      


	float2 glUV = coordinate;
	float4 cvSplashData = float4(2.0, 2.0, TIME, 0.0);	
	float2 InUV = glUV * 2.0 - 1.0;	
	
	//////////////////////////////////////////////////////////////
	// End of ShaderToy Input Compat
	//////////////////////////////////////////////////////////////
	
	// Constants
	const float TimeElapsed		= cvSplashData.z;
	const float Brightness		= sin(TimeElapsed) * 0.1;
	const float2 Resolution		= float2(cvSplashData.x, cvSplashData.y);
	const float AspectRatio		= 1.0;
	const float3 InnerColor		= float3( 0.50, 0.50, 0.50 );
	const float3 OuterColor		= float3( 0.00, 0.45, 0.00 );
	const float3 WaveColor		= float3( 1.00, 1.00, 1.00 );
		
	// Input
	float2 uv				= (InUV + 1.0) / 2.0;

	// Output
	float4 outColor			= float4(0.0, 0.0, 0.0, 0.0);

	// Positioning 
	float2 outerPos			= -0.5 + uv;
	outerPos.x				*= AspectRatio;

	float2 innerPos			= InUV * ( 2.0 - Brightness );
	innerPos.x				*= AspectRatio;

	// "logic" 
	float innerWidth		= length(outerPos);	
	float circleRadius		= 0.24 + Brightness * 0.1;
	float invCircleRadius 	= 1.0 / circleRadius;	
	float circleFade		= pow(length(2.0 * outerPos), 0.5);
	float invCircleFade		= 1.0 - circleFade;
	float circleIntensity	= pow(invCircleFade * max(1.1 - circleFade, 0.0), 2.0) * 40.0;
  	float circleWidth		= dot(innerPos,innerPos);
	float circleGlow		= ((1.0 - sqrt(abs(1.0 - circleWidth))) / circleWidth) + Brightness * 0.5;
	float outerGlow			= min( max( 1.0 - innerWidth * ( 1.0 - Brightness ), 0.0 ), 1.0 );
	float waveIntensity		= 0.0;
	
	// Inner circle logic
	if( innerWidth < circleRadius )
	{
		circleIntensity		*= pow(innerWidth * invCircleRadius, 24.0);
		
		float waveWidth		= 0.05;
		float2 waveUV		= InUV;

		waveUV.y			+= 0.14 * cos(TimeElapsed + (waveUV.x * 2.0));
		waveIntensity		+= abs(1.0 / (130.0 * waveUV.y));
			
		waveUV.x			+= 0.14 * sin(TimeElapsed + (waveUV.y * 2.0));
		waveIntensity		+= abs(1.0 / (130.0 * waveUV.x));

		waveIntensity		*= 1.0 - pow((innerWidth / circleRadius), 3.0);
	}	

	// Compose outColor
	outColor.rgb	= outerGlow * OuterColor;	
	outColor.rgb	+= circleIntensity * InnerColor;	
	outColor.rgb	+= circleGlow * InnerColor * (0.6 + Brightness * 1.2);
	outColor.rgb	+= WaveColor * waveIntensity;
	outColor.rgb	+= circleIntensity * InnerColor;
	outColor.a		= 1.0;

	// Fade in
	outColor.rgb	= saturate(outColor.rgb);
	outColor.rgb	*= min(TimeElapsed / 2.0, 1.0);

	//////////////////////////////////////////////////////////////
	// Start of ShaderToy Output Compat
	//////////////////////////////////////////////////////////////


	float4 fragColor = outColor;
	

///////////////////////////////////////↓↓↓↓↓↓↓↓↓// THIS IS THE LAST STEP ON THE PROCESS
///////////////////////////////////////↓↓↓↓↓↓↓↓↓// THIS IS THE LAST STEP ON THE PROCESS
                float4 colBackground = fragColor;
                // float4 colBackground = 0.0;

                bool StickerSprite = (_OverlaySelection == 0)?true:false;
                if(StickerSprite)
                {

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LINES OF CODE FOR THE SDFs STICKERS /////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    if(_GlowFull == 1.0)
                    {
	
	                    float2 coordUV = coordinate;    
	                    float dSign = PaintSticker(_StickerType, coordUV, _MotionState, _RangeSOne_One0, _RangeSOne_One1, _RangeSOne_One2, _RangeSOne_One3,
	                                                                                    _RangeSTen_Ten0, _RangeSTen_Ten1, _RangeSTen_Ten2, _RangeSTen_Ten3); 
	                    float4 colorOutputTotal = ColorSign(dSign, colBackground, _BorderColor, _BorderSizeOne, _BorderSizeTwo, _BorderBlurriness); 
	    
	    				if(colorOutputTotal.w * -1.0 < 0)
	    				{
	
	    					// GetEmission(PIXELSPACE)/3.0
	                    	return colorOutputTotal + float4( _ColorGlowHDR.xyz / 3.0, _AlphaColor/3.0);
	    				}
						else 
						{
							return 0.0;
						}	

                    }
                    else
                    {

					    float2 coordUV = coordinate;    
	                    float dSign = PaintSticker(_StickerType, coordUV, _MotionState, _RangeSOne_One0, _RangeSOne_One1, _RangeSOne_One2, _RangeSOne_One3,
	                                                                                    _RangeSTen_Ten0, _RangeSTen_Ten1, _RangeSTen_Ten2, _RangeSTen_Ten3); 
	                    float4 colorOutputTotal = ColorSign(dSign, float4(0.0, 0.0, 0.0, 0.0), _BorderColor, _BorderSizeOne, _BorderSizeTwo, _BorderBlurriness); 
	    
	    				if(colorOutputTotal.w * -1.0 < 0)
	    				{

	    					// GetEmission(PIXELSPACE)/3.0
	                    	return colorOutputTotal + float4( _ColorGlowHDR.xyz / 3.0, _AlphaColor/3.0);

	    				}
						else 
						{

	                   		float4 colorOutputTotal = ColorSign(dSign, colBackground, float4(0.0, 0.0, 0.0, 0.0), 0.0, 0.0, _BorderBlurriness); 

							return colorOutputTotal;

						}	

                    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LINES OF CODE FOR THE SDFs STICKERS /////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                }
                else
                {

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LINES OF CODE FOR THE SPRITES ///////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    if(_GlowFull == 1.0)
                    {

	                    float4 colorOutputTotal = PaintSprite(coordinateSprite, colBackground, _TextureSprite, _OutlineColor,
	                                                            _InVariableTick, _InVariableRatioX, _InVariableRatioY, _OutlineSprite);
						
						if(colorOutputTotal.w * -1.0 < 0)
	    				{
	
	    					// GetEmission(PIXELSPACE)/3.0
	                    	// return colorOutputTotal ;
	                    	return colorOutputTotal + float4( _ColorGlowHDR.xyz, _AlphaColor);
	    				}
	
	    				return 0.0;
    
                    }
                    else
                    {

	                    float4 colorOutputTotal = PaintSpriteGlow(coordinateSprite, colBackground, _TextureSprite, _OutlineColor,
	                                                            _InVariableTick, _InVariableRatioX, _InVariableRatioY, _OutlineSprite);
						
						if(colorOutputTotal.w * -1.0 < 0)
	    				{
	
	    					// GetEmission(PIXELSPACE)/3.0
	                    	// return colorOutputTotal ;
	                    	return colorOutputTotal ;
	    				}
	
	    				return 0.0;

                    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LINES OF CODE FOR THE SPRITES ///////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                }
                // return colBackground 


    //             float radio = 0.5;
    //             // float2 pointValue = float2(0.0, 0.0);
    //             float paintPoint = float2(abs(cos(_Time.y)), abs(sin(_Time.y)));

				// float lenghtRadio = length(uv - paintPoint);
    //             if (lenghtRadio < radio)
    //             {
    //                 return float4(1.0, 1.0, 1.0, 1.0) ;
    //                 // return 0.0;
    //             }
    //             else
    //             {
    //                 return 0.0;
    //             }


				
			}

			ENDHLSL
		}




		Pass {
			Tags {
				"LightMode" = "Meta"
				"RenderType"="Transparent" 
				"Queue" = "Transparent" 
				"DisableBatching" ="true" }


            ZWrite Off
            Cull off
            Blend SrcAlpha OneMinusSrcAlpha
			

			Cull Off

			CGPROGRAM

			#pragma vertex MyLightmappingVertexProgram
			#pragma fragment MyLightmappingFragmentProgram

			#pragma shader_feature _METALLIC_MAP
			#pragma shader_feature _ _SMOOTHNESS_ALBEDO _SMOOTHNESS_METALLIC
			#pragma shader_feature _EMISSION_MAP
			#pragma shader_feature _DETAIL_MASK
			#pragma shader_feature _DETAIL_ALBEDO_MAP

			#include "My Lightmapping.cginc"

			ENDCG
		}

		
	Pass {
			Tags {
				"LightMode" = "ForwardBase"
				"RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" 

			}
			// Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
            Cull off
            Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM

			#pragma target 3.0

			#pragma shader_feature _ _RENDERING_CUTOUT _RENDERING_FADE _RENDERING_TRANSPARENT
			#pragma shader_feature _METALLIC_MAP
			#pragma shader_feature _ _SMOOTHNESS_ALBEDO _SMOOTHNESS_METALLIC
			#pragma shader_feature _NORMAL_MAP
			#pragma shader_feature _PARALLAX_MAP
			#pragma shader_feature _OCCLUSION_MAP
			#pragma shader_feature _EMISSION_MAP
			#pragma shader_feature _DETAIL_MASK
			#pragma shader_feature _DETAIL_ALBEDO_MAP
			#pragma shader_feature _DETAIL_NORMAL_MAP

			#pragma multi_compile _ LOD_FADE_CROSSFADE

			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			#pragma multi_compile_instancing
			#pragma instancing_options lodfade force_same_maxcount_for_gl

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#define FORWARD_BASE_PASS
			float4 _ColorGlowHDR;
			#include "SHADERLIGHTADDITION.cginc"

			ENDCG
		}
	}

	// CustomEditor "MyLightingShaderGUI"
}