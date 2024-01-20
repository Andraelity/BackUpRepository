Shader "Font/LetterA_SDF"
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
            sampler2D _TextureChannel0;
            sampler2D _TextureChannel1;
            sampler2D _TextureChannel2;
            sampler2D _TextureChannel3;
  			
            #define PI 3.1415926535897931
            #define TIME _Time.y          

			#define BLACK float4(0.0, 0.0, 0.0, 1.0)			
			#define WHITE float4(1.0, 1.0, 1.0, 1.0)			

			pixel vert (vertexPoints v)
			{
				pixel o;

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}


            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////



float3 ShaderWaves( in float2 coordinate, in float2 uvScale)
{

	float3 COLOR1 = float3(0.0, 0.0, 0.3);
	float3 COLOR2 = float3(0.5, 0.0, 0.0);
	float BLOCK_WIDTH = 0.01;

	float2 uv = coordinate.yx;
	
	// To create the BG pattern
	float3 final_color = float3(1.0, 1.0, 1.0);
	float3 bg_color = float3(0.0, 0.0, 0.0);
	float3 wave_color = float3(0.0, 0.0, 0.0);
	
	float c1 = fmod(uv.x, 2.0 * BLOCK_WIDTH);
	c1 = step(BLOCK_WIDTH, c1);
	
	float c2 = fmod(uv.y, 2.0 * BLOCK_WIDTH);
	c2 = step(BLOCK_WIDTH, c2);
	
	bg_color = lerp(uv.x * COLOR1, uv.y * COLOR2, c1 * c2);
	
	
	// To create the waves
	float wave_width = 0.01;
	uv  = uvScale.yx;
	uv.y += 0.1;
	for(float i = 0.0; i < 10.0; i++) {
		
		uv.y += (0.07 * sin(uv.x + i/7.0 + TIME));
		wave_width = abs(1.0 / (150.0 * uv.y));
		wave_color += float3(wave_width * 1.9, wave_width, wave_width * 1.5);
	}
	
	final_color = bg_color + wave_color;
	return final_color;

}

float Segment( in float2 p, in float2 a, in float2 b )
{
	float2 pa = p - a;
	float2 ba = b - a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	return length( pa - ba*h );
}


float SDFLetter_A(float2 coordinateScale, float2 coordPosition)
{
	float SDF = 0.0;
	float2 inCoordPosition = coordPosition;


	float2 p0 = float2(-0.4,-0.6)  + inCoordPosition;
	float2 p1 = float2(-0.4, 0.7) + inCoordPosition;

	float2 p2 = float2(-0.4, 0.7) + inCoordPosition;
	float2 p3 = float2( 0.4, 0.7) + inCoordPosition;

	float2 p4 = float2( 0.4,-0.6) + inCoordPosition;
	float2 p5 = float2( 0.4, 0.7) + inCoordPosition;

	float2 p6 = float2(-0.4,-0.1) + inCoordPosition;
	float2 p7 = float2( 0.4,-0.1)  + inCoordPosition;


	float d1 = Segment( coordinateScale, p0,p1 ); 
	float d2 = Segment( coordinateScale, p2,p3 ); 
	float d3 = Segment( coordinateScale, p4,p5 ); 
	float d4 = Segment( coordinateScale, p6,p7 ); 
	
	SDF = min(min(min(d1,d2), d3),d4);
			
	return SDF;
}

            fixed4 frag (pixel PIXEL) : SV_Target
			{
				
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////


                float2 coordinate = PIXEL.uv;
                
                float2 coordinateScale = (PIXEL.uv - 0.5) * 2.0 ;
                
                float2 coordinateShade = coordinateScale/(float2(2.0, 2.0));
                
                float2 coordinateFull = ceil(coordinateShade);

                float3 colBase  = 0.0;	

                float3 colTexture = float3(coordinateScale.x + coordinateScale.y, coordinateScale.y - coordinateScale.x, pow(coordinate.x,2.0f));
				
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////
	
                colBase = 0.0;

                //////////////////////////////////////////////////////////////////////////////////////////////
                

                // float4 fragColor = float4(colTexture, 1.0);

				// float border = 2.0/2.0;
			
				// float2 uv = coordinatenateShade;
			
				// border*=zoom;
				// uv*=zoom;
				

			    float3 colorShader = ShaderWaves(coordinate, coordinateScale);
			    
                // coordinateScale *= float2(4.0, 1.0);
                // coordinateFull *= float2(4.0, 1.0);
// 
				// float2 p0 = float2(-.4,-.6);
				// float2 p1 = float2(-0.4, 0.7);
// 
				// float2 p2 = float2(-0.4,0.7);
				// float2 p3 = float2( 0.4,0.7);
// 
				// float2 p4 = float2(0.4,-0.6);
				// float2 p5 = float2(0.4, 0.7);
// 
				// float2 p6 = float2(-0.4,-0.1);
				// float2 p7 = float2(0.4,-0.1);
// 
// 
			    // float d = Segment(  coordinateScale, p0,p1 ); 
			    // float d2 = Segment( coordinateScale, p2,p3 ); 
			    // float d3 = Segment( coordinateScale, p4,p5 ); 
			    // float d4 = Segment( coordinateScale, p6,p7 ); 
				// 
                float2 coordPosition0 = float2(-1.0, 0.0 );
                float2 coordPosition1 = float2(-0.0, 0.0 );

                float d   = SDFLetter_A(coordinateScale, coordPosition0);
				float d2  = SDFLetter_A(coordinateScale, coordPosition1);
			    d = min(d, d2);

   				float4 col = (d < 0.15) ? float4(colorShader, 1.0) : float4(coordinateFull, 0.0, 1.0); //vec3(0.4,0.7,0.85);
			    // float3 col = float3(1.0, 1.0, 1.0) - float3(0.1,0.4,0.7)*(sign(d),1.0,0.0);
				col *= 1.0 - exp(-96.0*abs(d));
				// col *= 0.8 + 0.2*cos(140.0*d);
				col = lerp( col, float4(BLACK), 1.0-smoothstep(0.09,0.09,abs(d)) );
    
				float4 fragColor = float4(col);

				// fragColor = float4(coordinateShade, 0.0 , 1.0);
		        return fragColor;



	          	// return float4(Number, 0.0, 0.0, NumberOne);

	          	// return float4(1.0, 0.0, 0.0, 1.0);


		        // return float4(tex2D(_TextureChannel0,coordinateScale));

		         // float paintPoint = float2(0.0, 0.0);
				// float radio = 0.1;
				// float lenghtRadio = length(coordinateScale - paintPoint);

    // 			if (lenghtRadio < radio)
    // 			{
    // 				// return float4(1.0, 1.0, 1.0, 1.0) + fragColor;
    // 				return fragColor;
    // 			}
    // 			else
    // 			{
    // 				return fragColor;
    // 			}
				
			}

			ENDHLSL
		}
	}
}

























