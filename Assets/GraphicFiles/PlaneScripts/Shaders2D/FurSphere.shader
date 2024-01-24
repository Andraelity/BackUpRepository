Shader "Shaders2D/FurSphere"
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

static const float uvScale = 1.0;
static const float colorUvScale = 0.1;
static const float furDepth = 0.2;
static const int furLayers = 64;
static const float rayStep = furDepth*2.0 / float(furLayers);
static const float furThreshold = 0.4;
static const float shininess = 50.0;

bool intersectSphere(float3 ro, float3 rd, float r, out float t)
{
	float b = dot(-ro, rd);
	float det = b*b - dot(ro, ro) + r*r;
	if (det < 0.0) return false;
	det = sqrt(det);
	t = b - det;
	return t > 0.0;
}

float3 rotateX(float3 p, float a)
{
    float sa = sin(a);
    float ca = cos(a);
    return float3(p.x, ca*p.y - sa*p.z, sa*p.y + ca*p.z);
}

float3 rotateY(float3 p, float a)
{
    float sa = sin(a);
    float ca = cos(a);
    return float3(ca*p.x + sa*p.z, p.y, -sa*p.x + ca*p.z);
}

float2 cartesianToSpherical(float3 p)
{		
	float r = length(p);

	float t = (r - (1.0 - furDepth)) / furDepth;	
	p = rotateX(p.zyx, -cos(TIME*1.5)*t*t*0.4).zyx;	// curl

	p /= r;	
	float2 uv = float2(atan2(p.y, p.x), acos(p.z));

	//uv.x += cos(iTime*1.5)*t*t*0.4;	// curl
	//uv.y += sin(iTime*1.7)*t*t*0.2;
	uv.y -= t*t*0.1;	// curl down
	return uv;
}

// returns fur density at given position
float furDensity(float3 pos, out float2 uv)
{
	uv = cartesianToSpherical(pos.xzy);	
	float4 tex = tex2D(_TextureChannel0, uv*uvScale);

	// thin out hair
	float density = smoothstep(furThreshold, 1.0, tex.x);
	
	float r = length(pos);
	float t = (r - (1.0 - furDepth)) / furDepth;
	
	// fade out along length
	float len = tex.y;
	density *= smoothstep(len, len-0.2, t);

	return density;	
}

// calculate normal from density
float3 furNormal(float3 pos, float density)
{
    float eps = 0.01;
    float3 n;
	float2 uv;
    n.x = furDensity( float3(pos.x+eps, pos.y, pos.z), uv ) - density;
    n.y = furDensity( float3(pos.x, pos.y+eps, pos.z), uv ) - density;
    n.z = furDensity( float3(pos.x, pos.y, pos.z+eps), uv ) - density;
    return normalize(n);
}

float3 furShade(float3 pos, float2 uv, float3 ro, float density)
{
	// lighting
	const float3 L = float3(0, 1, 0);
	float3 V = normalize(ro - pos);
	float3 H = normalize(V + L);

	float3 N = -furNormal(pos, density);
	//float diff = max(0.0, dot(N, L));
	float diff = max(0.0, dot(N, L)*0.5+0.5);
	float spec = pow(max(0.0, dot(N, H)), shininess);
	
	// base color
	float3 color = tex2D(_TextureChannel1, uv*colorUvScale).xyz;

	// darken with depth
	float r = length(pos);
	float t = (r - (1.0 - furDepth)) / furDepth;
	t = clamp(t, 0.0, 1.0);
	float i = t*0.5+0.5;
		
	return color*diff*i + float3(spec*i, spec*i, spec*i);
}		

float4 scene(float3 ro, float3 rd)
{
	
	float3 p = float3(0.0, 0.0, 0.0);
	const float r = 1.0;
	float t;				  
	bool hit = intersectSphere(ro - p, rd, r, t);
	
	float4 c = float4(0.0, 0.0, 0.0, 0.0);
	if (hit) {
		float3 pos = ro + rd*t;

		// ray-march into volume
		for(int i=0; i<furLayers; i++) {
			float4 sampleCol;
			float2 uv;
			sampleCol.a = furDensity(pos, uv);
			if (sampleCol.a > 0.0) {
				sampleCol.rgb = furShade(pos, uv, ro, sampleCol.a);

				// pre-multiply alpha
				sampleCol.rgb *= sampleCol.a;
				c = c + sampleCol*(1.0 - c.a);
				if (c.a > 0.95) break;
			}
			
			pos += rd*rayStep;
		}
	}
	
	return c;
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
                

	float2 uv = coordinateScale * 2.0;

	float3 ro = float3(0.0, 0.0, 2.5);
	float3 rd = normalize(float3(uv, -2.0));
	
	float roty = 0.0;
	float rotx = 0.0;
	roty = (TIME + 2.0*abs(sin(TIME)));

    ro = rotateX(ro, rotx);	
    ro = rotateY(ro, roty);	
    rd = rotateX(rd, rotx);
    rd = rotateY(rd, roty);
	
	float4 fragColor = scene(ro, rd);

	// float4 fragColor = 0.0;

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

























