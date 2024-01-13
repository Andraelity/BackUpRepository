Shader "Parabola"
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

    p *= 4.0;    p.x += 0.5*p.y;    float2 f = frac(p);    float2 i = floor(p);    float id = frac(frac(dot(i, float2(0.436,0.173))) * 45.0);    if( f.x>f.y ) id += 1.3;
    
    float3  col = 0.5 + 0.5 * cos(0.7 * id  + float3(0.0,1.5,2.0 ) + 4.0);    float pha = smoothstep(-1.0,1.0,sin(0.2*i.x + TIME + id*1.0));    float2  pat = min(0.5-abs(f-0.5),abs(f.x-f.y)) - 0.3*pha;
    
    pat = smoothstep( 0.04, 0.07, pat );    return col * pat.x * pat.y;

}

float3 sdParabola( in float2 pos, in float k )
{
    float s = sign(pos.x);
    pos.x = abs(pos.x);
    
    float ik = 1.0/k;
    float p = ik*(pos.y - 0.5*ik)/3.0;
    float q = 0.25*ik*ik*pos.x;
    
    float h = q*q - p*p*p;
    float r = sqrt(abs(h));

    float x = (h>0.0) ? 
        // 1 root
    pow(q+r,1.0/3.0) - pow(abs(q-r),1.0/3.0)*sign(r-q) :
        // 3 roots
    2.0*cos(atan2(r,q)/3.0)*sqrt(p);
    
    float z = (pos.x-x<0.0)?-1.0:1.0;
    float2 w = pos-float2(x,k*x*x); float l = length(w); w.x*=s;
    
    return z * float3(l, w/l );
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

                p -= 0.3;
                // animate
                float t = TIME/2.0;
                float px =  0.0 + 0.4 * cos(t * 1.1 + 5.5); // x position
                float py = -0.4 + 0.2 * cos(t * 1.2 + 3.0); // y position
                float pk =  8.0 + 7.5 * cos(t * 1.3 + 3.5); // width
                
                // sdf
                float3  dg = sdParabola( p - float2(px,py), pk );
                float d = dg.x;
                float2 g = dg.yz;
        
    // central differenes based gradient, for comparison
    //g = vec2(dFdx(d),dFdy(d))/(2.0/iResolution.y);
    
                // central differenes based gradient, for comparison
                //g = vec2(dFdx(d),dFdy(d))/(2.0/iResolution.y);
                
                // float4 col = float4(0.0,0.0,0.0, 1.0) - sign(d)*float4(col2, 1.0);
                float4 col = (d>0.0) ? float4(0.0,0.0,0.0,0.0) : float4(backGround, 1.0); //vec3(0.4,0.7,0.85);

                col *= 1.0 - exp(-48.0*abs(d));
                // col *= 0.8 + 0.2*cos(120.0*d);
                col = lerp( col, float4(1.0, 1.0, 1.0, 1.0), 1.0-smoothstep(0.009,0.009,abs(d)) );
                
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

























