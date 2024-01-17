Shader "Try/ParticleTracing"
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

static float3 cam_origin;
static float3x3 cam_rotation;
static float2 frag_coord;

float3 rotateX(float a, float3 v)
{
	return float3(v.x, cos(a) * v.y + sin(a) * v.z, cos(a) * v.z - sin(a) * v.y);
}

float3 rotateY(float a, float3 v)
{
	return float3(cos(a) * v.x + sin(a) * v.z, v.y, cos(a) * v.z - sin(a) * v.x);
}

float torusDistance(float3 p, float inner_radius, float outer_radius)
{
	float3 ring_p = float3(normalize(p.xy) * outer_radius, 0.0);
	return distance(p, ring_p) - inner_radius;
}

float2 orbIntensity(float3 p)
{
	// return a value to create some nice shapes out of particles
	float3 ofs = float3(0.0, 0.0, 0.0);
	float d0 = torusDistance(p - ofs, 0.5, 5.0);
	float d1 = torusDistance(rotateY(3.1415926 * 0.5, p) - ofs, 1.3, 8.0);
	float d2 = torusDistance(rotateX(0.2, rotateY(3.1415926, p)) - ofs, 1.5, 20.0);
	float amb = smoothstep(0.8, 1.0, cos(p.x * 10.0) * sin(p.y * 5.0) * cos(p.z * 7.0)) * 0.02;
	float wave = step(abs(p.y + 10.0 +  cos(p.z * 0.1) * sin(p.x * 0.1 + TIME) * 4.0), 1.0) * 0.3;
	return float2(max(max(1.0 - step(4.0, length(p)), step(d0, 0.0)), step(d1, 0.0)) + amb + step(d2, 0.0) * 0.1 + wave,
				step(0.3, wave));
}

float3 project(float3 p)
{
	// transpose the rotation matrix. unfortunately tranpose() is not available.
	float3x3 cam_rotation_t = {float3(cam_rotation[0].x, cam_rotation[1].x, cam_rotation[2].x),
							   float3(cam_rotation[0].y, cam_rotation[1].y, cam_rotation[2].y),
							   float3(cam_rotation[0].z, cam_rotation[1].z, cam_rotation[2].z)};
	
	// transform into viewspace
	p = mul(cam_rotation_t ,(p - cam_origin));
	
	// project
	return float3(p.xy / p.z, p.z);
}

float3 orb(float rad, float3 coord)
{
	// return the orb sprite
	return 4.0 * (1.0 - smoothstep(0.0, rad, length((coord.xy - frag_coord)))) *
			float3(1.0, 0.6, 0.3) * clamp(coord.z, 0.0, 1.0);
}


float3 traverseUniformGrid(float3 ro, float3 rd)
{
	float3 increment = float3(1.0, 1.0, 1.0) / rd;
	float3 intersection = ((floor(ro) + round(rd * 0.5 + float3(0.5, 0.5, 0.5))) - ro) * increment;

	increment = abs(increment);
	ro += rd * 1e-3;
	
	float3 orb_accum = 0.0;
	
	// traverse the uniform grid
	for(int i = 0; i < 50; i += 1)
	{
		float3 rp = floor(ro + rd * min(intersection.x, min(intersection.y, intersection.z)));
		
		float2 orb_intensity = orbIntensity(rp);

		// get the screenspace position of the cell's centerpoint										   
		float3 coord = project(rp + float3(0.5, 0.5, 0.5));
		
		float rmask = smoothstep(0.0, 0.1, distance(frag_coord, coord.xy));
		
		// calculate the initial radius
		float rad = 0.5 / coord.z * (1.0 - smoothstep(0.0, 50.0, length(rp)));
		
		// adjust the radius
		rad *= 0.5 + 0.5 * sin(rp.x + TIME * 5.0) * cos(rp.y + TIME * 10.0) * cos(rp.z);
		
		orb_accum += orb(rad, coord) * orb_intensity.x * lerp(1.0, rmask, orb_intensity.y);
		
		// step to the next ray-cell intersection
		intersection += increment * step(intersection.xyz, intersection.yxy) *
									step(intersection.xyz, intersection.zzx);
	}
	
	return orb_accum;
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
                
                float2 coordinateScale = (i.uv - 0.5) * 2.0 ;
                
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

				// float4 fragColor = float4(noise2D(coordinateScale * TIME)/abs(tan(TIME /4.0)),noise2D(coordinateScale * TIME)/abs(tan(TIME)), noise2D(coordinateScale * TIME)/abs(sin(TIME)), 1.0); 

				float2 p = coordinateScale;
				

				float2 frag_coord = p;
				// zoom in
				frag_coord *= 1.5;
			
				cam_origin = rotateX(TIME * 0.3,
									 rotateY(TIME * 0.5, float3(0.0, 0.0, -10.0 + 5.0 * cos(TIME * 0.1))));
				
				// calculate the rotation matrix
				float3 cam_w = normalize(float3(cos(TIME) * 10.0, 0.0, 0.0) - cam_origin);
				float3 cam_u = normalize(cross(cam_w, float3(0.0, 1.0, 0.0)));
				float3 cam_v = normalize(cross(cam_u, cam_w));
				
				float3x3 matrixValue= {cam_u.x, cam_u.y, cam_u.z, cam_v.x, cam_v.y, cam_v.z, cam_w.x, cam_w.y, cam_w.z};
				cam_rotation = matrixValue;
				float3 ro = cam_origin;
				// float3 rd = mul(cam_rotation , float3(frag_coord, 1.0));
				float3 rd = 0.0;
				
				float4 fragColor = 1.0;
				// render the particles
				fragColor.rgb = traverseUniformGrid(ro, rd);
				fragColor.rgb = sqrt(fragColor.rgb * 0.8);
                                       
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

























