﻿Shader "TriangleForm"
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


float dot2( float2 v ) { return dot(v,v); }
float cro(in float2 a, in float2 b ) { return a.x*b.y-a.y*b.x; }
float sdTriangle( in float2 p0, in float2 p1, in float2 p2, in float2 p )
{
	float2 e0 = p1-p0;
	float2 v0 = p-p0;
	float2 e1 = p2-p1;
	float2 v1 = p-p1;
	float2 e2 = p0-p2;
	float2 v2 = p-p2;

	float2 pq0 = v0 - e0*clamp( dot(v0,e0)/dot2(e0), 0.0, 1.0 );
	float2 pq1 = v1 - e1*clamp( dot(v1,e1)/dot2(e1), 0.0, 1.0 );
	float2 pq2 = v2 - e2*clamp( dot(v2,e2)/dot2(e2), 0.0, 1.0 );
    
    float2 d = min( min( float2( dot2( pq0 ), cro(v0,e0) ),
                       	 float2( dot2( pq1 ), cro(v1,e1) )),
                       	 float2( dot2( pq2 ), cro(v2,e2) ));

	return -sqrt(d.x)*sign(d.y);
}
// alternative formulation
// float sdTunnel2( in float2 p, in float2 wh )
// {
//     vec2 q = abs(p);
//     q.x -= wh.x;

//     if( p.y>=0.0 )
//     {
//     q.x = max(q.x,0.0);
//     q.y += wh.y;
//     return -min( wh.x-length(p), length(q) );
//     }
//     else
//     {
//     q.y -= wh.y;
//     float f = max(q.x,q.y);
//     return (f<0.0) ? f : length(max(q,0.0));
//     }
// }


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


                float2 p = coordinate;
    // float4 colFull = float4(0.0,0.0,0.0, 1.0) - sign(d)*float4(col2, 1.0);

    
   
	float2 v0 = float2(1.2,0.8)*cos( 0.5 * TIME + float2(0.0,2.0) );
	float2 v1 = float2(1.2,0.8)*cos( 0.5 * TIME + float2(1.5,3.0) );
	float2 v2 = float2(1.2,0.8)*cos( 0.5 * TIME + float2(4.0,1.0) );

    // compute traingle SDF
	float d = sdTriangle( v0, v1, v2, p );
    

    // draw triangle SDF
    float4 col = float4(0.0,0.0,0.0, 1.0) - sign(d)*float4(col2, 1.0);

	col *= 1.0 - exp(-48.0*abs(d));
	col *= 0.8 + 0.2*cos(150.0*d);
	col = lerp( col, float4(1.0,1.0,1.0,1.0), 1.0-smoothstep(0.005,0.005,abs(d)));


    // if(col.z == 0.0)
    // {
    // 	col = float4(col2, 1.0);
    // }
					return float4(col);


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

























