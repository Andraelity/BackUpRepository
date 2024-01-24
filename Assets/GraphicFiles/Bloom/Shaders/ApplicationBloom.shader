Shader "ShaderBloom/ApplicationBloom"
{

	Properties {
		_Color ("Tint", Color) = (1, 1, 1, 1)
		_ColorValue ("ColorValue", Color) = (1, 1, 1, 1)
		_AlphaColor ("AlphaColor", Range(0, 1)) = 0.5
		_MainTex ("Albedo", 2D) = "white" {}

		[NoScaleOffset] _NormalMap ("Normals", 2D) = "bump" {}
		_BumpScale ("Bump Scale", Float) = 1

		[NoScaleOffset] _MetallicMap ("Metallic", 2D) = "white" {}
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
		_Smoothness ("Smoothness", Range(0, 1)) = 0.1

		[NoScaleOffset] _ParallaxMap ("Parallax", 2D) = "black" {}
		_ParallaxStrength ("Parallax Strength", Range(0, 0.1)) = 0

		[NoScaleOffset] _OcclusionMap ("Occlusion", 2D) = "white" {}
		_OcclusionStrength ("Occlusion Strength", Range(0, 1)) = 1

		[NoScaleOffset] _EmissionMap ("Emission", 2D) = "black" {}
		[HDR]_Emission ("Emission", Color) = (0, 0, 0)

		[NoScaleOffset] _DetailMask ("Detail Mask", 2D) = "white" {}
		_DetailTex ("Detail Albedo", 2D) = "gray" {}
		[NoScaleOffset] _DetailNormalMap ("Detail Normals", 2D) = "bump" {}
		_DetailBumpScale ("Detail Bump Scale", Float) = 1

		_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5

		[HideInInspector] _SrcBlend ("_SrcBlend", Float) = 1
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

		Pass
        {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" }


            ZWrite Off
            Cull off
            Blend SrcAlpha OneMinusSrcAlpha
            

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

			#include "UnityPBSLighting.cginc"
			#include "UnityMetaPass.cginc"

            float3 _Emission;


            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }


			float3 GetEmission (v2f i) {
				#if defined(_EMISSION_MAP)
					return tex2D(_EmissionMap, i.uv.xy) * _Emission;
				#else
					return _Emission;
				#endif
			}

            fixed4 frag (v2f PIXEL) : SV_Target
            {
                // sample the texture

                float2 coordinate = PIXEL.uv;
                
                float2 coordinateScale = (PIXEL.uv - 0.5) * 2.0 ;
                
                float2 coordinateShade = coordinateScale/(float2(2.0, 2.0));
                
                float2 coordinateFull = ceil(coordinateShade);

                float3 colBase  = 0.0;  

                float3 colTexture = float3(coordinateScale.x + coordinateScale.y, coordinateScale.y - coordinateScale.x, pow(coordinate.x,2.0f));


                float4 col = float4(colTexture, 1.0);

                // float ticks = 1s;
                // 1 ticks = 1 sprite
                // how many ticks on a second?
                // // size of the sprite seheek/*

                // ////////// starts at 0 to sprite.Length() - 1;
                // int _inVariableTickX = 0;
                // int _inVariableTickY = 0;
                // ////////// starts at 0 to sprite.Length() - 1;

                // int tickX = _inVariableTickX;
                // int tickY = _inVariableTickY;

                // int ratioX = _inVariableRatioX;
                // int ratioY = _inVariableRatioY;*/

                    
                // float4 valueText = tex2D(_MainTex, float2((coordinate.x/ratioX) + (1/ratioX) * tickX, (coordinate.y/ratioY) + (1/ratioY) * tickY ));
                // valueText = tex2D(_MainTex, float2((coordinate.x), (coordinate.y) ));

                // bool elementoBoolean  = functionCurrentTime(_Time.y, variableTimeOutOne, variableTimeOutTwo);
                // functionCurrentTime(_Time.y, variableTimeOutOne, variableTimeOutTwo);
                float paintPoint = float2(abs(cos(_Time.y)), abs(sin(_Time.y)));
                float radio = 0.1;
                float lenghtRadio = length(coordinate - paintPoint);
 

                if (lenghtRadio < radio)
                {
                    return float4(GetEmission(PIXEL), 1.0);
                    // return float4(1.0, 1.0, 1.0, 1.0) + col;
                    // return 0.0;
                }
                else
                {
                    return float4(0.0, 0.0, 0.0, 0.0);
                }
                // return lenghtRadio;
                // return tex2D(_MainTex, coordinate);




                // return col;
            }
            ENDCG
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
			float4 _ColorValue;
			#include "SHADERLIGHTADDITION.cginc"

			ENDCG
		}
	}

	CustomEditor "MyLightingShaderGUI"
}