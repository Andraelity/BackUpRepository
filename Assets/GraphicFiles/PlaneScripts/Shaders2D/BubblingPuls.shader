Shader "Shaders2D/BubblingPuls"
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

#define s(v) v.x+v.y+v.z
#define pi 3.14159265
#define R(p, a) p=cos(a)*p+sin(a)*float2(p.y, -p.x)
#define hsv(h,s,v) lerp(float3(1.0, 1.0, 1.0), clamp((abs(frac(h+float3(1., 1., 3.)/3.)*6.-3.)-1.), 0., 1.), s)*v

static const float BLOWUP=86.0; 
static const float MAXSTEPSHIFT=10.0; 
static const int MAXITERS=55;


float pn(float3 p) { //noise @Las^Mercury
	float3 i = floor(p);
	float4 a = dot(i, float3(1., 57., 21.)) + float4(0., 57., 21., 78.);
	float3 f = cos((p-i)*pi)*(-.5) + .5;
	a = lerp(sin(cos(a)*a), sin(cos(1.+a)*(1.+a)), f.x);
	a.xy = lerp(a.xz, a.yw, f.y);
	return lerp(a.x, a.y, f.z);
}

float fpn(float3 p) {
	return pn(p*.06125)*.5 + pn(p*.125)*.25 + pn(p*.25)*.125;
}

float displace(float3 p) {
	return ((cos(4.*p.x)*sin(4.*p.y)*sin(4.*p.z))*cos(30.1))*sin(TIME);
}

int f(float3 pos,float stepshift)
{
	float d = displace(pos);
	float3 v2=abs(frac(pos + d) - float3(0.5,0.5,0.5))/2.0;
	float noise = fpn(v2*130.+ TIME*05.) * 0.05;

	v2 = v2 + noise +d/2.;
	float r=0.0769*sin(TIME*30.0*-0.0708);
	float blowup=BLOWUP/pow(2.0,stepshift+8.0);

	if(s(v2)-0.1445+r<blowup) return 1;
	v2=float3(0.25,0.25,0.25)-v2;
	if(s(v2)-0.1445-r<blowup) return 2;

	int hue;
	float width;
	if(abs(s(v2)-3.0*r-0.375)<0.03846+blowup)
	{
		width=0.1445;
		hue=4;
	}
	else
	{
		width=0.0676;
		hue=3;
	}

	if(s(abs(v2.zxy-v2.xyz))-width<blowup) return hue;

	return 0;
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
                

				float4 lastStep = 0.0;



	float time    = TIME;
	float2 uv = 2.0;
	// float x = 0.5*( 2.0 * fragCoord.x - uv.x) / max( uv.x, uv.y); 
	// float y = 0.5*( 2.0 * fragCoord.y - uv.y) / max( uv.x, uv.y);
	float x = coordinateShade.x;
	float y = coordinateShade.y;

	float sin_a = sin( time * 20.0 * 0.00564 );
	float cos_a = cos( time * 20.0 * 0.00564 );

	float3 dir = float3(x,-y,0.33594-x*x-y*y);
	dir = float3(dir.y,dir.z*cos_a-dir.x*sin_a,dir.x*cos_a+dir.z*sin_a);
	dir = float3(dir.y,dir.z*cos_a-dir.x*sin_a,dir.x*cos_a+dir.z*sin_a);
	dir = float3(dir.y,dir.z*cos_a-dir.x*sin_a,dir.x*cos_a+dir.z*sin_a);

	float3 pos = float3(0.5,2.1875,0.875) + float3(1.0,1.0,1.0)*0.0134*20.0*time;

	float stepshift=MAXSTEPSHIFT;

	if(frac(pow(x,y)*time*30.0*1000.0)>0.5) pos+=dir/pow(2.0,stepshift);
	else pos-=dir/pow(2.0,stepshift);

	int value =0;
	int c;

	for(int j=0;j<100;j++)
	{
		c=f(pos,stepshift);
		if(c>0)
		{
			stepshift+=1.0;
			pos-=dir/pow(2.0,stepshift);
		}
		else
		{
			if(stepshift>0.0) stepshift-=1.0;
			pos+=dir/pow(2.0,stepshift);
			value++;
		}

		if(stepshift>=MAXSTEPSHIFT) break;
		if(value>=MAXITERS) break;
	}

	float3 col;
	if(c==0) col = float3(0.0,0.0,0.0);
	else if(c==1) col = float3(0.0,0.0,1.0);
	else if(c==2) col = float3(0.0,1.0,0.0);
	else if(c==3) col = float3(1.0,1.0,0.25);
	else if(c==4) col = float3(0.5,0.5,0.5);

	float k=1.0-(float(value)-stepshift)/42.0;
	float4 fragColor=float4(col*float3(k*k,k*k*k,k*k*k),1.0);

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

























