Shader "Shaders2D/CloudsSkybox"
{
	Properties
	{

	

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
		

            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////

static const float cloudscale = 1.1;
static const float speed = 0.03;
static const float clouddark = 0.5;
static const float cloudlight = 0.3;
static const float cloudcover = 0.2;
static const float cloudalpha = 8.0;
static const float skytint = 0.5;
static const float3 skycolour1 = float3(0.2, 0.4, 0.6);
static const float3 skycolour2 = float3(0.4, 0.7, 1.0);

static const float2x2 mxValue = { 1.6,  1.2, -1.2,  1.6 };

float2 hash( float2 p ) {
	p = float2(dot(p, float2(127.1,311.7)), dot(p, float2(269.5,183.3)));
	return -1.0 + 2.0*frac(sin(p)*43758.5453123);
}

float noise( in float2 p ) {
    const float K1 = 0.366025404; // (sqrt(3)-1)/2;
    const float K2 = 0.211324865; // (3-sqrt(3))/6;
	float2 i = floor(p + (p.x+p.y)*K1);	
    float2 a = p - i + (i.x+i.y)*K2;
    float2 o = (a.x>a.y) ? float2(1.0,0.0) : float2(0.0,1.0); //vec2 of = 0.5 + 0.5*vec2(sign(a.x-a.y), sign(a.y-a.x));
    float2 b = a - o + K2;
	float2 c = a - 1.0 + 2.0*K2;
    float3 h = max(0.5 - float3(dot(a,a), dot(b,b), dot(c,c) ), 0.0 );
	float3 n = h*h*h*h * float3( dot(a,hash(i+0.0)), dot(b,hash(i+o)), dot(c,hash(i+1.0)));
    return dot(n, float3(70.0, 70.0, 70.0));	
}

float fbm(float2 n) {
	float total = 0.0, amplitude = 0.1;
	for (int i = 0; i < 7; i++) {
		total += noise(n) * amplitude;
		n = mul(mxValue,n);
		amplitude *= 0.4;
	}
	return total;
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
 
 	float2 p = coordinate;
	float2 uv = coordinate;    
    float time = TIME * speed;
    float q = fbm(uv * cloudscale * 0.5);
    
    //ridged noise shape
	float r = 0.0;
	uv *= cloudscale;
    uv -= q - time;
    float weight = 0.8;
    for (int i=0; i<8; i++){
		r += abs(weight*noise( uv ));
        uv = mul(mxValue,uv) + time;
		weight *= 0.7;
    }
    
    //noise shape
	float f = 0.0;
    uv = p*float2(1.0,1.0);
	uv *= cloudscale;
    uv -= q - time;
    weight = 0.7;
    for (int i=0; i<8; i++){
		f += weight*noise( uv );
        uv = mul(mxValue,uv) + time;
		weight *= 0.6;
    }
    
    f *= r + f;
    
    //noise colour
    float c = 0.0;
    time = TIME * speed * 2.0;
    uv = p*float2(1.0,1.0);
	uv *= cloudscale*2.0;
    uv -= q - time;
    weight = 0.4;
    for (int i=0; i<7; i++){
		c += weight*noise( uv );
        uv = mul(mxValue,uv) + time;
		weight *= 0.6;
    }
    
    //noise ridge colour
    float c1 = 0.0;
    time = TIME * speed * 3.0;
    uv = p * float2(1.0,1.0);
	uv *= cloudscale*3.0;
    uv -= q - time;
    weight = 0.4;
    for (int i=0; i<7; i++){
		c1 += abs(weight*noise( uv ));
        uv = mul(mxValue,uv) + time;
		weight *= 0.6;
    }
	
    c += c1;
    
    float3 skycolour = lerp(skycolour2, skycolour1, p.y);
    float3 cloudcolour = float3(1.1, 1.1, 0.9) * clamp((clouddark + cloudlight*c), 0.0, 1.0);
   
    f = cloudcover + cloudalpha*f*r;
    
    float3 result = lerp(skycolour, clamp(skytint * skycolour + cloudcolour, 0.0, 1.0), clamp(f + c, 0.0, 1.0));
    
	float4 fragColor = float4( result, 1.0 );

     

		        return fragColor;
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

























