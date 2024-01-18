Shader "Shaders2D/SimplicityGalaxy"
{
	Properties
	{

		_TextureChannel0 ("Texture", 2D) = "gray" {}
		_TextureChannel1 ("Texture", 2D) = "gray" {}
		_TextureChannel2 ("Texture", 2D) = "gray" {}
		_TextureChannel3 ("Texture", 2D) = "gray" {}
		_ColorOperation ("ColorForSomething", Color) = (1.0, 1.0, 1.0, 1.0)

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

	}
	SubShader
	{
		
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" }

		LOD 100

		Pass
		{
			Name "SecondtRunPass"

		    ZWrite Off
		    Cull off
		    Blend SrcAlpha OneMinusSrcAlpha
		    
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
            #pragma multi_compile_instancing
			
			#include "UnityCG.cginc"


			struct vertexPoints
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
                  UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct pixel
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            UNITY_INSTANCING_BUFFER_START(CommonProps)

            UNITY_DEFINE_INSTANCED_PROP(float, _StickerType)
		  	UNITY_DEFINE_INSTANCED_PROP(float, _MotionState)

            UNITY_DEFINE_INSTANCED_PROP(float4, _BorderColor)
            UNITY_DEFINE_INSTANCED_PROP(float, _BorderSizeOne)
            UNITY_DEFINE_INSTANCED_PROP(float, _BorderSizeTwo)
            UNITY_DEFINE_INSTANCED_PROP(float, _BorderBlurriness)

            UNITY_DEFINE_INSTANCED_PROP(float, _RangeSOne_One0)
            UNITY_DEFINE_INSTANCED_PROP(float, _RangeSOne_One1)
            UNITY_DEFINE_INSTANCED_PROP(float, _RangeSOne_One2)
            UNITY_DEFINE_INSTANCED_PROP(float, _RangeSOne_One3)

            UNITY_DEFINE_INSTANCED_PROP(float, _RangeSTen_Ten0)
            UNITY_DEFINE_INSTANCED_PROP(float, _RangeSTen_Ten1)
            UNITY_DEFINE_INSTANCED_PROP(float, _RangeSTen_Ten2)
            UNITY_DEFINE_INSTANCED_PROP(float, _RangeSTen_Ten3)

            UNITY_INSTANCING_BUFFER_END(CommonProps)		

            sampler2D _TextureChannel0;
            sampler2D _TextureChannel1;
            sampler2D _TextureChannel2;
            sampler2D _TextureChannel3;
  			
            #define PI 3.1415926535897931
            #define TIME _Time.y          

			float4 _VectorVariable;
			float _FloatVariable;
			float _FloatNumber;

			int _IntVariable;
			int _IntNumber;
			

			pixel vert (vertexPoints v)
			{
				pixel o;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			#define Number _FloatNumber
			#define NumberOne _FloatVariable

			#include "SDfs.hlsl"
			#include "Stickers.hlsl"

            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////

			float field(in float3 p,float s) {
				float strength = 7. + .03 * log(1.e-6 + frac(sin(TIME) * 4373.11));
				float accum = s/4.;
				float prev = 0.;
				float tw = 0.;
				for (int i = 0; i < 26; ++i) {
					float mag = dot(p, p);
					p = abs(p) / mag + float3(-.5, -.4, -1.5);
					float w = exp(-float(i) / 7.);
					accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
					tw += w;
					prev = mag;
				}
				return max(0., 5. * accum / tw - .7);
			}
			
			// Less iterations for second layer
			float field2(in float3 p, float s) {
				float strength = 7. + .03 * log(1.e-6 + frac(sin(TIME) * 4373.11));
				float accum = s/4.;
				float prev = 0.;
				float tw = 0.;
				for (int i = 0; i < 18; ++i) {
					float mag = dot(p, p);
					p = abs(p) / mag + float3(-.5, -.4, -1.5);
					float w = exp(-float(i) / 7.);
					accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
					tw += w;
					prev = mag;
				}
				return max(0., 5. * accum / tw - .7);
			}
			
			float3 nrand3( float2 co )
			{
				float3 a = frac( cos( co.x*8.3e-3 + co.y ) * float3(1.3e5, 4.7e5, 2.9e5) );
				float3 b = frac( sin( co.x*0.3e-3 + co.y ) * float3(8.1e5, 1.0e5, 0.1e5) );
				float3 c = lerp(a, b, 0.5);
				return c;
			}


            fixed4 frag (pixel PIXEL) : SV_Target
			{
				
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////

			    UNITY_SETUP_INSTANCE_ID(PIXEL);
			    
		  		float _StickerType = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _StickerType);
		  		float _MotionState = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _MotionState);

			    float4 _BorderColor = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _BorderColor);
				float _BorderSizeOne = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _BorderSizeOne);
				float _BorderSizeTwo = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _BorderSizeTwo);
				float _BorderBlurriness = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _BorderBlurriness);

			    float _RangeSOne_One0 = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _RangeSOne_One0);
				float _RangeSOne_One1 = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _RangeSOne_One1);
			 	float _RangeSOne_One2 = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _RangeSOne_One2);
			 	float _RangeSOne_One3 = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _RangeSOne_One3);

   		       	float _RangeSTen_Ten0 = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _RangeSTen_Ten0);
				float _RangeSTen_Ten1 = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _RangeSTen_Ten1);
			    float _RangeSTen_Ten2 = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _RangeSTen_Ten2);
			    float _RangeSTen_Ten3 = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _RangeSTen_Ten3);


                float2 coordinate =  PIXEL.uv;
                
                float2 coordinateScale = (PIXEL.uv - 0.5) * 2.0 ;
                
                float2 coordinateShade = coordinate/(float2(2.0, 2.0));
                
                float2 coordinateFull = ceil(coordinateShade);

                float3 colBase  = 0.0;	

                float3 colTexture = float3(coordinateScale.x + coordinateScale.y, coordinateScale.y - coordinateScale.x, pow(coordinate.x,2.0f));
				
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////
	
                colBase = 0.0;

                //////////////////////////////////////////////////////////////////////////////////////////////
   	float2 uv = coordinateScale;
	float2 uvs = coordinateShade;
	float3 p = float3(uvs / 4., 0) + float3(1., -1.3, 0.);
	p += .2 * float3(sin(TIME / 16.), sin(TIME / 12.),  sin(TIME / 128.));
	
	float freqs[4];
	//Sound
	freqs[0] = 1.0;
	freqs[1] = 1.0;
	freqs[2] = 1.0;
	freqs[3] = 1.0;

	float valueT = field(p,freqs[2]);
	float v = (1. - exp((abs(uv.x) - 1.) * 6.)) * (1. - exp((abs(uv.y) - 1.) * 6.));
	
    //Second Layer
	float3 p2 = float3(uvs / (4.0 + sin(TIME*0.11) * 0.2 + 0.2 + sin(TIME*0.15) * 0.3 + 0.4), 1.5) + float3(2., -1.3, -1.);
	p2 += 0.25 * float3(sin(TIME / 16.), sin(TIME / 12.),  sin(TIME / 128.));
	float t2 = field2(p2,freqs[3]);
	float4 c2 = lerp(.4, 1., v) * float4(1.3 * t2 * t2 * t2 ,1.8  * t2 * t2 , t2* freqs[0], t2);
	
	
	//Let's add some stars
	//Thanks to http://glsl.heroku.com/e#6904.0
	float2 seed = p.xy * 2.0;	
	seed = floor(seed * 2.0);
	float3 rnd = nrand3( seed );
	float4 starcolor = float4(pow(rnd.y,40.0),pow(rnd.y,40.0),pow(rnd.y,40.0),pow(rnd.y,40.0));
	
	//Second Layer
	float2 seed2 = p2.xy * 2.0;
	seed2 = floor(seed2 * 2.0);
	float3 rnd2 = nrand3( seed2);
	// starcolor += float4(pow(rnd2.y,40.0), pow(rnd2.y,40.0), pow(rnd2.y,40.0), pow(rnd2.y,40.0));
	
	float4 fragColor = lerp(freqs[3]-.3, 1., v) * float4(1.5*freqs[2] * valueT * valueT* valueT , 1.2*freqs[1] * valueT * valueT, freqs[3]*valueT, 1.0)+c2+starcolor;

	// float4 fragColor = 0.0;
                                       
///////////////////////////////////////↓↓↓↓↓↓↓↓↓// This is the last step on the sticker process.
				float4 colBackground = fragColor;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LINES OF CODE FOR THE SDFs STICKERS /////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                float2 coordUV = coordinate;	
				float dSign = PaintSticker(_StickerType, coordUV, _MotionState, _RangeSOne_One0, _RangeSOne_One1, _RangeSOne_One2, _RangeSOne_One3,
											 									_RangeSTen_Ten0, _RangeSTen_Ten1, _RangeSTen_Ten2, _RangeSTen_Ten3); 
		        float4 colorOutputTotal = ColorSign(dSign, colBackground, _BorderColor, _BorderSizeOne, _BorderSizeTwo, _BorderBlurriness); 

		        return colorOutputTotal;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LINES OF CODE FOR THE SDFs STICKERS /////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



	          	// return float4(Number, 0.0, 0.0, NumberOne);

	          	// return float4(1.0, 0.0, 0.0, 1.0);


		        // return float4(tex2D(_TextureChannel0,coordinateScale));

		        // return float4(coordUV, 0.0, 1.0);
				// float radio = 0.5;
				// float lenghtRadio = length(p - point);

    			// if (lenghtRadio < radio)
    			// {
    			// 	return float4(1, 0.0, 0.0, 1.0);
    			// }
    			// else
    			// {
    			// 	return 0.0;
    			// }
				
			}

			ENDHLSL
		}
	}
}

























