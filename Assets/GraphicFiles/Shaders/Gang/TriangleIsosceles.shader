﻿Shader "TriangleIsosceles"
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

float3 trianglesGrid(float2 p )
{

    p *= 4.0;

    p.x += 0.5*p.y;
    
    float2 f = frac(p);
    float2 i = floor(p);
    
    float id = frac(frac(dot(i, float2(0.436,0.173))) * 45.0);
    if( f.x>f.y ) id += 1.3;
    
    float3  col = 0.5 + 0.5 * cos(0.7 * id  + float3(0.0,1.5,2.0 ) + 4.0);
    float pha = smoothstep(-1.0,1.0,sin(0.2*i.x + TIME + id*1.0));
    
    
    float2  pat = min(0.5-abs(f-0.5),abs(f.x-f.y)) - 0.3*pha;
    
    
    pat = smoothstep( 0.04, 0.07, pat );

    return col * pat.x * pat.y;

}



float3 sdgTriangleIsosceles( in float2 p, in float2 q )
{
    float w = sign(p.x);
    p.x = abs(p.x);
    float2 a = p - q * clamp( dot(p,q)/dot(q,q), 0.0, 1.0 );
    float2 b = p - q * float2( clamp( p.x/q.x, 0.0, 1.0 ), 1.0 );
    float k = sign( q.y );
    float l1 = dot(a,a);
    float l2 = dot(b,b);
    float d = sqrt((l1<l2)?l1:l2);
    float2  g =      (l1<l2)? a: b;
    float s = max( k*(p.x*q.y-p.y*q.x),k*(p.y-q.y)  );
    return float3(d, float2(w*g.x,g.y)/d)*sign(s);
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

                float2 p = coordinate;
                float3 backGround = trianglesGrid(p);
	
				// float4 col = float4(0.0,0.0,0.0, 1.0) - sign(d)*float4(col2, 1.0);
				// col *= 1.0 - exp(-48.0*abs(d));
				// col *= 0.8 + 0.2*cos(120.0*d);
				// col = lerp( col, float4(1.0, 1.0, 1.0, 1.0), 1.0-smoothstep(0.005,0.005,abs(d)) );

                // p -= 0.3;

                float2 si = float2(0.5,-0.5) + float2(0.3,-0.3)*cos( TIME + float2(0.0,1.57) + 0.0 );
        
                float3 dg = sdgTriangleIsosceles(p,si);
                float d = dg.x;
    
                float4 col = float4(0.0,0.0,0.0, 0.0) - sign(d)*float4(backGround, 1.0);
                col *= 1.0 - exp(-48.0*abs(d));
                // col *= 0.8 + 0.2*cos(120.0*d);
                col = lerp( col, float4(1.0, 1.0, 1.0, 1.0), 1.0-smoothstep(0.005,0.005,abs(d)) );
    
                    
    // if(col.z == 0.0)
    // {
    // 	col = float4(col2, 1.0);
    // }

                    return float4(col);
					// return float4(col.xyz, (col.x + col.y + col.z )/3.0);


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

























