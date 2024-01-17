Shader "Try/BallSpace"
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
			float3 trianglesGrid(float2 p)
			{
			
			    p *= 4.0;    p.x += 0.5*p.y;    float2 f = frac(p);    float2 i = floor(p);    float id = frac(frac(dot(i, float2(0.436,0.173))) * 45.0);    if( f.x>f.y ) id += 1.3;
			    
			    float3  col = 0.5 + 0.5 * cos(0.7 * id  + float3(0.0,1.5,2.0 ) + 4.0);    float pha = smoothstep(-1.0,1.0,sin(0.2*i.x + TIME + id*1.0));    float2  pat = min(0.5-abs(f-0.5),abs(f.x-f.y)) - 0.3*pha;
			    
			    pat = smoothstep( 0.04, 0.07, pat );    return col * pat.x * pat.y;
			
			}


			//IQ signed box
			float sdBox(float3 p, float3 b){
			  float3 d = abs(p)-b;
			  return min(max(d.x,max(d.y,d.z)),0.0) +
			         length(max(d,0.0));
			}
			
			float2 rot(float2 p,float r){
			  float2 ret;
			  ret.x = p.x * cos(r) - p.y * sin(r);
			  ret.y = p.x * sin(r) + p.y * cos(r);
			  return ret;
			}
			
			float2 rotsim(float2 p,float s){
			  float2 ret = p;
			  ret = rot(p,-PI/(s*2.0));
			  ret = rot(p,floor(atan2(ret.x,ret.y)/PI*s)*(PI/s));
			  return ret;
			}
			
			//Object
			float obj(in float3 p)
			{
			  float3 op = p;
			  p.xz = rotsim(p.xz, 16.0);
			  p.yz = rotsim(p.yz, 16.0); 
			  p.z=p.z-4.0;
			  float2 uv;
			  float3 p2=normalize(op);
			  uv.x=1.0-acos(abs(p2.y)-0.1)/PI;
			  uv.y=0.1;
			  uv=floor(uv*16.0);
			  uv/=16.0;
			  float3 p3=p;
			  //p3.z-=(textureLod(iChannel0,uv,0.0).x-0.2)*4.0;	
			  float c1 = sdBox(p3, float3(0.2,0.2,1.0));
			  p.z = p.z-12.0;
			  uv.y = 0.9;
			  p.xy = rot(p.xy,1.0*2.0*PI);
			  uv.y = 0.1;	
			  p.yz = rot(p.yz,1.0*2.0*PI);	
			  float c3 = sdBox(p, float3(0.8,0.8,0.1));	
			  float c4 = length(op)-5.0;
			  return min(lerp(c1,c4,(c4<0.0)?abs(c4):0.0),c3);	
			}
			
			//Object Color
			float3 obj_c(float3 p)
			{
			  return float3(1.0,1.0,1.0); 
			}
			
			//Scene End
			
			
			//Raymarching Framework Start
			
			float3 phong(
			  in float3 pt,
			  in float3 prp,
			  in float3 normal,
			  in float3 light,
			  in float3 color,
			  in float spec,
			  in float3 ambLight)
			{
			   float3 lightv=normalize(light-pt);
			   float diffuse=dot(normal,lightv);
			   float3 refl=-reflect(lightv,normal);
			   float3 viewv=normalize(prp-pt);
			   float specular=pow(max(dot(refl,viewv),0.0),spec);
			   return (max(diffuse,0.0)+ambLight)*color+specular;
			}
			
			float raymarching(
			  in float3 prp,
			  in float3 scp,
			  in int maxite,
			  in float precis,
			  in float startf,
			  in float maxd,
			  out int objfound)
			{ 
			  const float3 e = float3(0.1,0,0.0);
			  float s=startf;
			  float3 c,p,n;
			  float f = startf;
			  objfound = 1;
			  for(int i=0;i<256;i++){
			    if (abs(s)<precis||f>maxd||i>maxite) break;
			    f+=s;
			    p=prp+scp*f;
			    s=obj(p);
			  }
			  if (f>maxd) objfound=-1;
			  return f;
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
			
			float3 normal(in float3 p)
			{
			  //tetrahedron normal
			  const float n_er=0.01;
			  float v1 = obj(float3(p.x+n_er,p.y-n_er,p.z-n_er));
			  float v2 = obj(float3(p.x-n_er,p.y-n_er,p.z+n_er));
			  float v3 = obj(float3(p.x-n_er,p.y+n_er,p.z-n_er));
			  float v4 = obj(float3(p.x+n_er,p.y+n_er,p.z+n_er));
			  return normalize(float3(v4+v1-v3-v2,v3+v4-v1-v2,v2+v4-v3-v1));
			}
			
			float3 render(
			  in float3 prp,
			  in float3 scp,
			  in int maxite,
			  in float precis,
			  in float startf,
			  in float maxd,
			  in float3 background,
			  in float3 light,
			  in float spec,
			  in float3 ambLight,
			  out float3 n,
			  out float3 p,
			  out float f,
			  out int objfound)
			{ 
			  objfound = -1;
			  f = raymarching(prp,scp,maxite,precis,startf,maxd,objfound);
			  if (objfound>0){
			    p = prp + scp * f;
			    float3 c = obj_c(p);
			    n = normal(p);
			    float3 cf = phong(p,prp,n,light,c,spec,ambLight);
			    return float3(cf);
			  }
			  f=maxd;
			  return float3(background); //background color
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
                
                float2 valueCoordinate = coordinateScale;

				float4 lastStep = 0.0;




  //Camera animation
  float3 vuv = normalize(float3(sin(sin(TIME)*0.6)*0.4,1.0,cos(sin(TIME)*0.7)*0.2));
  float3 vrp = float3(0.0,0.0,0.0);	
  float3 prp = float3(sin(TIME)*12.0,5.0,cos(TIME)*12.0); //Trackball style camera pos
  float vpd=1.5;
  float3 light=prp;
  
  float3 scp=camera(prp,vrp,vuv,vpd,valueCoordinate);
  float3 n,p;
  float f;
  int o;
  const float maxe = 0.01;
  const float startf = 0.1;
  const float3 backc = float3(0.0,0.0,0.0);
  const float spec = 8.0;
  const float3 ambi = float3(0.1,0.1,0.1);
  
  float3 c1=render(prp,scp,64,maxe,startf,32.0,backc,light,spec,ambi,n,p,f,o);
  // c1=c1*max(1.0-f*.02,0.0);
  // float3 c2 = backc;
  // if (o>0){
    // scp=reflect(scp,n);
    // c2=render(p+scp*0.05,scp,8,maxe,startf,4.0,backc,light,spec,ambi,n,p,f,o);
  // }
  // c2=c2*max(1.0-f*.5,0.0);
  // lastStep=(c1.xyz*0.75+c2.xyz*0.25,1.0);
  lastStep=(c1.xyz,1.0);
  // lastStep = float4(trianglesGrid(coordinateScale), 1.0);
  // lastStep = float4(scp, 1.0);







                                       
///////////////////////////////////////↓↓↓↓↓↓↓↓↓// This is the last step on the sticker process.
				float4 colBackground = lastStep;

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

























