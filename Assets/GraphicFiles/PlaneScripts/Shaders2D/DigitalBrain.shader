Shader "Shaders2D/DigitalBrain"
{
    Properties
    {

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
    
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" }
        LOD 100

        Pass
        {
            
            ZWrite Off
            Cull off
            Blend SrcAlpha OneMinusSrcAlpha
            
            HLSLPROGRAM
            #pragma vertex VERTEXSHADER
            #pragma fragment FRAGMENTSHADER
            
            #pragma multi_compile_instancing
            
            #include "UnityCG.cginc"


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

            #define PI 3.1415926535897931
            #define TIME _Time.y          


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

            #include "SDfs.hlsl"
            #include "Stickers.hlsl"
            #include "Sprites.hlsl"



            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////

// rotate position around axis
float2 rotate(float2 p, float a)
{
	return float2(p.x * cos(a) - p.y * sin(a), p.x * sin(a) + p.y * cos(a));
}

// 1D random numbers
float rand(float n)
{
    return frac(sin(n) * 43758.5453123);
}

// 2D random numbers
float2 rand2(in float2 p)
{
	return frac(float2(sin(p.x * 591.32 + p.y * 154.077), cos(p.x * 391.32 + p.y * 49.077)));
}

// 1D noise
float noise1(float p)
{
	float fl = floor(p);
	float fc = frac(p);
	return lerp(rand(fl), rand(fl + 1.0), fc);
}

// voronoi distance noise, based on iq's articles
float voronoi(in float2 x)
{
	float2 p = floor(x);
	float2 f = frac(x);
	
	float2 res = float2(8.0, 8.0);

	for(int j = -1; j <= 1; j ++)
	{
		for(int i = -1; i <= 1; i ++)
		{
			float2 b = float2(i, j);
			float2 r = float2(b) - f + rand2(p + b);
			
			// chebyshev distance, one of many ways to do this
			float d = max(abs(r.x), abs(r.y));
			
			if(d < res.x)
			{
				res.y = res.x;
				res.x = d;
			}
			else if(d < res.y)
			{
				res.y = d;
			}
		}
	}
	return res.y - res.x;
}

////////////////////////////////////////////////////////////////////////////
//////////COLOR EFFECT//////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


static const float timeEffect=1.0;

//-----------------------------------------------------------------------------
// Maths utils
//-----------------------------------------------------------------------------
static float3x3 m =	{ 0.00,  0.80,  0.60,
	 			 	 -0.80,  0.36, -0.48,
	 			 	 -0.60, -0.48,  0.64 };
float hashShader( float n )
{
    return frac(sin(n)*43758.5453);
}

float noise( in float3 x )
{
    float3 p = floor(x);
    float3 f = frac(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = lerp(lerp(lerp( hashShader(n+  0.0), hashShader(n+  1.0),f.x),
                        lerp( hashShader(n+ 57.0), hashShader(n+ 58.0),f.x),f.y),
                    lerp(lerp( hashShader(n+113.0), hashShader(n+114.0),f.x),
                        lerp( hashShader(n+170.0), hashShader(n+171.0),f.x),f.y),f.z);
    return res;
}

float fbm( float3 p )
{
    float f;
    f  = 0.5000 * noise( p ); 
    p = mul(m , p * 2.02);
    f += 0.2500 * noise( p ); 
    p = mul(m , p * 2.03);
    f += 0.1250 * noise( p );
    return f;
}

float fbm2( float3 p )
{
    return fbm(p) * 2.0 - 1.0;
}

// Mattias' drawing functions ( http://sociart.net/ )
// Terminals
float4 simplex_color(float2 p) 
{
	const float offset=5.0;
	float x = p.x*1.5;
	float y = p.y*1.5;
	float4 col= float4(
		   fbm2(float3(x,y, offset)),
		   fbm2(float3(x,y, offset*2.0)),
		   fbm2(float3(x,y, offset*3.0)),
		   fbm2(float3(x,y, offset*4.0)));
	
	return col-0.2;
}
// Warpers*/
float2 swirl(float2 p)
{
	float swirlFactor = 3.0+timeEffect*(sin(TIME+0.22)-1.5);
	float radius = length(p);
	float angle = atan2(p.y, p.x);
	float inner = angle-cos(radius*swirlFactor);
	return float2(radius * cos(inner), radius*sin(inner));
}

float2 horseShoe(float2 p)
{
	float radius = length(p);
	float angle = 2.0 * atan2(p.y, p.x);
	return float2(radius * cos(angle), radius*sin(angle));
}

float2 wrap(float2 p)
{
	float zoomFactor = 1.5 - timeEffect * (sin(TIME + 0.36));
	float repeatFactor = 3.0;
	float radius = length(p)*zoomFactor;
	float angle = atan2(p.y, p.x)*repeatFactor;
	return float2(radius * cos(angle), radius*sin(angle));
}

// FUNCTION
/* (wrap (horseshoe (swirl simplex-color)))*/

float4 imageFunction(float2 pos)
{
	return 		
		simplex_color(wrap(horseShoe(swirl(pos))))-0.2;
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
                

   
  	float flicker = noise1(TIME * 2.0) * 0.8 + 0.4;

    float2 uv = coordinate;
	uv = (uv - 0.5) * 2.0;
	float2 suv = uv;
	uv.x *= 1.0;
	
	
	float v = 0.0;
	
	// that looks highly interesting:
	//v = 1.0 - length(uv) * 1.3;
	
	
	// a bit of camera movement
	uv *= 0.6 + sin(TIME * 0.1) * 0.4;
	uv = rotate(uv, sin(TIME * 0.3) * 1.0);
	uv += TIME * 0.4;
	
	
	// add some noise octaves
	float a = 0.6, f = 1.0;
	
	for(int i = 0; i < 3; i ++) // 4 octaves also look nice, its getting a bit slow though
	{	
		float v1 = voronoi(uv * f + 5.0);
		float v2 = 0.0;
		
		// make the moving electrons-effect for higher octaves
		if(i > 0)
		{
			// of course everything based on voronoi
			v2 = voronoi(uv * f * 0.5 + 50.0 + TIME);
			
			float va = 0.0, vb = 0.0;
			va = 1.0 - smoothstep(0.0, 0.1, v1);
			vb = 1.0 - smoothstep(0.0, 0.08, v2);
			v += a * pow(va * (0.5 + vb), 2.0);
		}
		
		// make sharp edges
		v1 = 1.0 - smoothstep(0.0, 0.3, v1);
		
		// noise is used as intensity map
		v2 = a * (noise1(v1 * 5.5 + 0.1));
		
		// octave 0's intensity changes a bit
		if(i == 0)
			v += v2 * flicker;
		else
			v += v2;
		
		f *= 3.0;
		a *= 0.7;
	}

	v *= exp(-0.6 * length(suv)) * 1.2;
	
	float3 cexp = tex2D(_TextureChannel0, uv * 0.001).xyz * 3.0 + tex2D(_TextureChannel0, uv * 0.01).xyz;//vec3(1.0, 2.0, 4.0);
	cexp *= 1.4;

	// slight vignetting

	// float2 coordinateRotate = 
	// float4 fragColor = color;		
	coordinateScale = rotate(coordinateScale, TIME);
	float2 coordinateValue = rotate(coordinate,TIME);
	float3 colTextureValue = colTexture;
	colTexture = float3(coordinateScale.x * abs(sin(TIME)) + coordinateValue.y * abs(clamp(sinh(TIME), -1, 1)), coordinateScale.y * abs(cos(TIME)) - coordinateScale.x, pow(coordinateValue.x * abs(clamp(cosh(TIME), -1, 1)),2.0f));


	
	float3 col = colTextureValue/3.0 +  float3(pow(v, cexp.x), pow(v, cexp.y), pow(v, cexp.z)) * 2.0;
	// 
	float4 fragColor = float4(col, 1.0);



///////////////////////////////////////↓↓↓↓↓↓↓↓↓// THIS IS THE LAST STEP ON THE PROCESS
///////////////////////////////////////↓↓↓↓↓↓↓↓↓// THIS IS THE LAST STEP ON THE PROCESS
                float4 colBackground = fragColor;

                bool StickerSprite = (_OverlaySelection == 0)?true:false;
                if(StickerSprite)
                {

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

                }
                else
                {

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LINES OF CODE FOR THE SPRITES ///////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    float4 colorOutputTotal = PaintSprite(coordinateSprite, colBackground, _TextureSprite, _OutlineColor,
                                                            _InVariableTick, _InVariableRatioX, _InVariableRatioY, _OutlineSprite);

                    return colorOutputTotal;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LINES OF CODE FOR THE SPRITES ///////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                }



                // float radio = 0.5;
                // float2 point = float2(0.0, 0.0);
				// float lenghtRadio = length(uv - point);
                // if (lenghtRadio < radio)
                // {
                //     return float4(1.0, 1.0, 1.0, 1.0) ;
                // }
                // else
                // {
                //     return 0.0;
                // }

			}

			ENDHLSL
		}
	}
}

























