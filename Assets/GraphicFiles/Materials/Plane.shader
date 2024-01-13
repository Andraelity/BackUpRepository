Shader "Unlit/PlaneCode"
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
            
            // #pragma multi_compile_instancing
            
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
            sampler2D _TextureChannel0;
            sampler2D _TextureChannel1;
            sampler2D _TextureChannel2;
            sampler2D _TextureChannel3;
            
            #define PI 3.1415926535897931
            #define TIME _Time.y
  
            pixel vert (vertexPoints v)
            {

                pixel o;

                float4  valor = v.vertex;

                

                // v.vertex /= 4.0;

                o.vertex = UnityObjectToClipPos(v.vertex);
                
                o.uv = v.uv;
                return o;
            }
            

            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////


            fixed4 frag (pixel i) : SV_Target
            {
                
                //////////////////////////////////////////////////////////////////////////////////////////////
                /// DEFAULT
                //////////////////////////////////////////////////////////////////////////////////////////////

                
                float2 coordinate = i.uv;
                
                float2 coordinateBase = i.uv/(float2(2.0, 2.0));
                
                float2 coordinateScale = (coordinate + 1.0 )/ float2(2.0,2.0);
                
                float2 coordinateFull = ceil(coordinateBase);

                //Test Output 
                float3 colBase  = 0.0;
                float3 col2 = float3(coordinate.x + coordinate.y, coordinate.y - coordinate.x, pow(coordinate.x,2.0f));
                //////////////////////////////////////////////////////////////////////////////////////////////
                /// DEFAULT
                //////////////////////////////////////////////////////////////////////////////////////////////
    
                colBase = 0.0;
                //////////////////////////////////////////////////////////////////////////////////////////////
                
                // normalized pixel coordinates


                float2 p = coordinate* 2.0 - 0.5 ;
    
                // float4 col = float4(0.0,0.0,0.0, 1.0) - sign(d)*float4(col2, 1.0);
                // col *= 1.0 - exp(-48.0*abs(d));
                // col *= 0.8 + 0.2*cos(120.0*d);
                // col = lerp( col, float4(1.0, 1.0, 1.0, 1.0), 1.0-smoothstep(0.005,0.005,abs(d)) );


                
                float ta = 3.14*(0.5 + 0.5 * cos(TIME* 0.52+2.0));
                float tb = 3.14*(0.5 + 0.5 * cos(TIME* 0.31+2.0));
                float rb = 0.15*(0.5 + 0.5 * cos(TIME* 0.41+1.0));
        
                // // sdf(p) and gradient(sdf(p))
                // float3  dg = sdgArc(p, float2(sin(ta),cos(ta)), float2(sin(tb),cos(tb)), 0.5, rb);
                // float d = dg.x;
                // float2  g = dg.yz;
                // // central differenes based gradient, for comparison
                // // g = vec2(dFdx(d),dFdy(d))/(2.0/iResolution.y);
            
                // // coloring
                // float4 col = float4(0.0,0.0,0.0, 1.0) - sign(d)*float4(col2, 1.0);
                // col *= 1.0 - exp(-48.0*abs(d));
                // col *= 0.8 + 0.2*cos(120.0*d);
                // col = lerp( col, float4(1.0, 1.0, 1.0, 1.0), 1.0-smoothstep(0.005,0.005,abs(d)) );
    

    // if(col.z == 0.0)
    // {
    //  col = float4(col2, 1.0);
    // }
                // p.x += 4.0;
                // p.y += 0;
                // p /= 10.0;



                float radio = 0.5;
                float lenghtRadio = length(p  - float2(0.5, 0.5));
 
                if (lenghtRadio < radio)
                {
                 return float4(1, 0.0, 0.0, 1.0);
                }
                else
                {
                 return 0.0;
                }



                    return float4(p, 0.0 ,1.0);


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
    //              return float4(1, 0.0, 0.0, 1.0);
    //             }
    //             else
    //             {
    //              return 0.0;
    //             }


                
            }

            ENDHLSL
        }
    }
}

























