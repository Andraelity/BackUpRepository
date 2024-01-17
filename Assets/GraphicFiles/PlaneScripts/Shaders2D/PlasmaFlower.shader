Shader "Shaders2D/PlasmaFlower"
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
  

			pixel vert (vertexPoints v)
			{
				pixel o;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
            

			float4 _VectorVariable;
			float _FloatVariable;
			float _FloatNumber;

			int _IntVariable;
			int _IntNumber;
			
			#define Number _FloatNumber
			#define NumberOne _FloatVariable

			#include "SDfs.hlsl"
			#include "Stickers.hlsl"

            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////



			float addFlower(float x, float y, float ax, float ay, float fx, float fy)
			{
				float xx=(x + sin(TIME * fx)*ax)*8.0;
			   	float yy=(y + cos(TIME * fy)*ay)*8.0;
				float angle = atan2(yy,xx);
				float zz = 1.5*(cos(18.0*angle)*0.5+0.5) / (0.7 * 3.141592) + 1.2*(sin(15.0*angle)*0.5+0.5)/ (0.7 * 3.141592);
				
				return zz;
			}
			
			float3 camera(
			  in float3 prp,
			  in float3 vrp,
			  in float3 vuv,
			  in float vpd,
			  in float2 fragCoord)
			{
			  float2 vPos= fragCoord;
			  float3 vpn = normalize(vrp-prp);
			  float3 u=normalize(cross(vuv,vpn));
			  float3 v=cross(vpn,u);
			  float3 scrCoord=prp+vpn*vpd+ vPos.x * u *1.0+vPos.y*v;
			  return normalize(scrCoord-prp);
			}


            fixed4 frag (pixel i) : SV_Target
			{
				
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////

			    UNITY_SETUP_INSTANCE_ID(i);
			    
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


                float2 coordinate = i.uv;
                
                float2 coordinateScale = (i.uv - 0.5) * 2.0 ;;
                
                float2 coordinateShade = coordinate/(float2(2.0, 2.0));
                
                float2 coordinateFull = ceil(coordinateShade);

                //Test Output 
                float3 colBase  = 0.0;	

                float3 col2 = float3(coordinateScale.x + coordinateScale.y, coordinateScale.y - coordinateScale.x, pow(coordinate.x,2.0f));
				
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////
	
                colBase = 0.0;

                //////////////////////////////////////////////////////////////////////////////////////////////
                

				float4 lastStep = 0.0;








	float2 xy = coordinateShade;


  float3 vuv = normalize(float3(sin(sin(TIME)*0.6)*0.4,1.0,cos(sin(TIME)*0.7)*0.2));
  float3 vrp = float3(0.0,0.0,0.0);	
  float3 prp = float3(sin(TIME)*12.0,5.0,cos(TIME)*12.0); //Trackball style camera pos
  float vpd=1.5;
  float3 light=prp;
  
  float3 scp=camera(prp,vrp,vuv,vpd,coordinateScale);


  	float x=xy.x;
   	float y=xy.y;
	
	float p1 = addFlower(x, y, col2.x, col2.y, col2.z, 0.85);
	float p2 = addFlower(x, y, 0.7, 0.9, 0.42, 0.71);
	// float p3 = addFlower(x, y, scp.x, scp,y, scp.z, 0.97);
	float p3 = addFlower(x, y, 0.5, 1.0, 0.23, 0.97);
	// float p3 = addFlower(x, y, scp.x, scp,y, scp.z, 0.97);
	float p4 = addFlower(x, y, 0.8, 0.5, 0.81, 1.91);

	float p=clamp((p1+p2+p3+p4)*0.25, 0.0, 1.0);

	float4 col;
	if (p < 0.5)
		col = float4(lerp(col2.x, col2.z, p*2.0), lerp(col2.y, scp.x ,p*2.0), col2.z, 1.0);
	else if (p >= 0.5 && p <= 0.75)
		col = float4(lerp(scp.z, col2.z, (p-0.5)*4.0), lerp(col2.y, scp.x, (p-0.5)*4.0), lerp(col2.x, scp.y,(p-0.5)*4.0), 1.0);
	else
		col = float4(lerp(col2.x, scp.x, (p-0.75)*4.0), scp.z, lerp(col2.z, scp.z, (p-0.75)*4.0), 1.0);	

	

                                       
///////////////////////////////////////↓↓↓↓↓↓↓↓↓// This is the last step on the sticker process.
				float4 colBackground = col;

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

























