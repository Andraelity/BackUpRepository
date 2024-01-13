Shader "StairsScale"
{
	Properties
	{
		_TextureChannel0 ("Texture", 2D) = "gray" {}
		_TextureChannel1 ("Texture", 2D) = "gray" {}
		_TextureChannel2 ("Texture", 2D) = "gray" {}
		_TextureChannel3 ("Texture", 2D) = "gray" {}


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
            UNITY_DEFINE_INSTANCED_PROP(fixed4, _FillColor)
            UNITY_DEFINE_INSTANCED_PROP(float, _AASmoothing)
            UNITY_DEFINE_INSTANCED_PROP(float, _rangeZero_Ten)
            UNITY_DEFINE_INSTANCED_PROP(float, _rangeSOne_One)
            UNITY_DEFINE_INSTANCED_PROP(float, _rangeZoro_OneH)
            UNITY_DEFINE_INSTANCED_PROP(float, _mousePosition_x)
            UNITY_DEFINE_INSTANCED_PROP(float, _mousePosition_y)
            UNITY_INSTANCING_BUFFER_END(CommonProps)		

			pixel vert (vertexPoints v)
			{
				pixel o;
				
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.vertex.xy;
				return o;
			}
            
            sampler2D _TextureChannel0;
            sampler2D _TextureChannel1;
            sampler2D _TextureChannel2;
            sampler2D _TextureChannel3;
  			
            #define PI 3.1415926535897931
            #define TIME _Time.y
  
            float2 mouseCoordinateFunc(float x, float y)
            {
            	return normalize(float2(x,y));
            }

            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////


float dot2( in float2 v ) { return dot(v,v); }

float sdStairs( in float2 p, in float2 wh, in float n )
{
    // base
    float2 ba = wh*n;
    float d = min(dot2(p - float2( clamp(p.x,0.0,ba.x),0.0)), 
                  dot2(p - float2(ba.x, clamp(p.y,0.0,ba.y))) );
    float s = sign(max(-p.y,p.x-ba.x) );


    // float dia2 = dot2(wh);
    float dia2 = length(wh);
    float2x2 mat2 = {wh.x,-wh.y,wh.y,wh.x};
    p = mul(mat2, p/dia2);
    // p = mul(mat2, p);
    float id = clamp(round(p.x/dia2),0.0,n-1.0);
    p.x = p.x - id * dia2;
    float2x2 mat2_0 = {wh.x,wh.y,-wh.y,wh.x};
    p = mul(mat2_0, p/dia2);
// signed distance to a n-star polygon with external angle en

    float hh = wh.y/2.0;
    p.y -= hh;
    
    if( p.y>hh*sign(p.x) ) s=1.0;
    // p = (id<0.5 || p.x>0.0) ? p : -p;
    p = p;

    d = min( d, dot2(p - float2(0.0,clamp(p.y,-hh,hh))) );
    d = min( d, dot2(p - float2(clamp(p.x,0.0,wh.x),hh)) );
    
    return sqrt(d)*s;
}

            fixed4 frag (pixel i) : SV_Target
			{
				
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////

			    UNITY_SETUP_INSTANCE_ID(i);
			    
		    	float aaSmoothing = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _AASmoothing);
			    fixed4 fillColor = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _FillColor);
			   	float _rangeZero_Ten = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeZero_Ten);
				float _rangeSOne_One = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeSOne_One);
			    float _rangeZoro_OneH = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeZoro_OneH);
                float _mousePosition_x = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _mousePosition_x);
                float _mousePosition_y = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _mousePosition_y);

                float2 mouseCoordinate = mouseCoordinateFunc(_mousePosition_x, _mousePosition_y);
                float2 mouseCoordinateScale = (mouseCoordinate + 1.0)/ float2(2.0,2.0);

                
                float2 coordinate = i.uv;
                
                float2 coordinateBase = i.uv/(float2(2.0, 2.0));
                
                float2 coordinateScale = (coordinate + 1.0 )/ float2(2.0,2.0);
                
                float2 coordinateFull = ceil(coordinateBase);

                //Test Output 
                float3 colBase  = 0.0;
                float3 col2 = float3(coordinate.x + coordinate.y, coordinate.y - coordinate.x, pow(coordinate.x,2.0f));
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////
	
                colBase = 0.0;
                //////////////////////////////////////////////////////////////////////////////////////////////
                
				// normalized pixel coordinates


                float2 p = coordinate ;
                p -= float2(-0.9, -0.5);
             //uv = 0.5*(uv-vec2(0.0,0.5));
                    
                // animate
                float wi = 0.5 * (0.5+0.3*sin(TIME*1.1+0.0));
                float he = wi *  (0.5+0.3*sin(TIME*1.3+2.0));
                
                float nu = 5.0;//1.0+floor( 4.95*(0.5 + 0.5*cos(3.0*iTime)) );
             
                // distance
                float d = sdStairs(p, float2(wi,he),nu);
                
                // coloring
                float3 col = (d>0.0) ? float3(0.9,0.6,0.3) : float3(0.65,0.85,1.0);
                col *= 1.0 - exp(-7.0*abs(d));
                col *= 0.8 + 0.2*cos(160.0*abs(d));
                col = lerp( col, float3(1.0, 1.0, 1.0), 1.0-smoothstep(0.0,0.015,abs(d)) );

   // // animate
   //  float w = 1.0/8.0;
   //  float n = floor( 3.95*(0.5 + 0.5*cos(TIME*3.0)) );
   //  // float n = 2.0;
 
   //  // distance
   //  float d = sdSquareStairs(p,w,n);
   
   //  // coloring
   //  float3 col = (d>0.0) ? float3(0.9,0.6,0.3) : float3(0.65,0.85,1.0);
   //  col *= 1.0 - exp(-7.0*abs(d));
   //  col *= 0.8 + 0.2 * cos(160.0*abs(d));
   //  col = lerp( col, float3(1.0, 1.0, 1.0), 1.0-smoothstep(0.0,0.015,abs(d)) );


					return float4(col, 1.0);


				// return float4(vPixel/GetWindowResolution(), 0.0, 1.0);


				//(colBase.x + colBase.y + colBase.z)/3.0
                // return float4(coordinateScale, 0.0, 1.0);
				// return float4(right.x, up2.y, 0.0, 1.0);
				// return float4(coordinate3.x, coordinate3.y, 0.0, 1.0);
				// return float4(ro.xy, 0.0, 1.0);

				// float radio = 0.5;
				// float lenghtRadio = length(offset);

    //             if (lenghtRadio < radio)
    //             {
    //             	return float4(1, 0.0, 0.0, 1.0);
    //             }
    //             else
    //             {
    //             	return 0.0;
    //             }


				
			}

			ENDHLSL
		}
	}
}

























