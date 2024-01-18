Shader "Font/LetterSDF"
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

static const float dot_size=.005;

static const float3 point_col = float3(1,1,0);

static const float zoom=1.;

static const float pi=3.1415926535;

static const int num_segments=5;

static const int num_iterations=3;
static const int num_start_params=3;

//factor should be positive
//it decreases the step size when lowered.
//Lowering the factor and increasing iterations increases the area in which
//the iteration converges, but this is quite costly
static const float factor=1.;

static const float eps=.005;

float newton_iteration3(float3 coeffs, float x){
	float a2=coeffs[2]+x;
	float a1=coeffs[1]+x*a2;

	float f=coeffs[0]+x*a1;
	float f1=((x+a2)*x)+a1;

	return x-f/f1;
}

float halley_iteration3(float3 coeffs, float x){
	float a2=coeffs[2]+x;
	float a1=coeffs[1]+x*a2;

	float f=coeffs[0]+x*a1;

	float b2=a2+x;

	float f1=a1+x*b2;
	float f2=2.*(b2+x);

	return x-(2.*f*f1)/(2.*f1*f1-f*f2);
}

//From Trisomie21
//But instead of his cancellation fix i'm using a newton iteration
int solve_cubic(float a, float b, float c, out float3 r){
	float p = b - a*a / 3.0;
	float q = a * (2.0*a*a - 9.0*b) / 27.0 + c;
	float p3 = p*p*p;
	float d = q*q + 4.0*p3 / 27.0;
	float offset = -a / 3.0;
	if(d >= 0.0) { // Single solution
		float z = sqrt(d);
		float u = (-q + z) / 2.0;
		float v = (-q - z) / 2.0;
		u = sign(u)*pow(abs(u),1.0/3.0);
		v = sign(v)*pow(abs(v),1.0/3.0);
		r[0] = offset + u + v;	

		//Single newton iteration to account for cancellation
		float f = ((r[0] + a) * r[0] + b) * r[0] + c;
		float f1 = (3. * r[0] + 2. * a) * r[0] + b;

		r[0] -= f / f1;

		return 1;
	}
	float u = sqrt(-p / 3.0);
	float v = acos(-sqrt( -27.0 / p3) * q / 2.0) / 3.0;
	float m = cos(v), n = sin(v)*1.732050808;

	//Single newton iteration to account for cancellation
	//(once for every root)
	r[0] = offset + u * (m + m);
    r[1] = offset - u * (n + m);
    r[2] = offset + u * (n - m);

	float3 f = ((r + a) * r + b) * r + c;
	float3 f1 = (3. * r + 2. * a) * r + b;

	r -= f / f1;

	return 3;
}



//cubic bezier distance by segmentation based on the one by iq
//see https://www.shadertoy.com/view/XdVBWd

float length2( float2 v ) { return dot(v,v); }

float segment_dis_sq( float2 p, float2 a, float2 b ){
	float2 pa = p-a, ba = b-a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	return length2( pa - ba*h );
}

float cubic_bezier_segments_dis_sq(float2 uv, float2 p0, float2 p1, float2 p2, float2 p3){   
    float d0 = 1e38;
    float2 a = p0;
    for( int i=1; i<num_segments; i++ )
    {
        float t = float(i)/float(num_segments-1);
        float s = 1.0-t;
        float2 b = p0*s*s*s + p1*3.0*s*s*t + p2*3.0*s*t*t + p3*t*t*t;
        d0 = min(d0,segment_dis_sq(uv, a, b ));
        a = b;
    }
    
    return d0;
}

float cubic_bezier_segments_dis(float2 uv, float2 p0, float2 p1, float2 p2, float2 p3){
	return sqrt(cubic_bezier_segments_dis_sq(uv,p0,p1,p2,p3));
}

float cubic_bezier_normal_iteration(float t, float2 a0, float2 a1, float2 a2, float2 a3){
	//horner's method
	float2 a_2=a2+t*a3;
	float2 a_1=a1+t*a_2;
	float2 b_2=a_2+t*a3;

	float2 uv_to_p=a0+t*a_1;
	float2 tang=a_1+t*b_2;

	float l_tang=dot(tang,tang);
	return t-factor*dot(tang,uv_to_p)/l_tang;
}

float cubic_bezier_normal_iteration2(float t, float2 a0, float2 a1, float2 a2, float2 a3){
	//horner's method
	float2 a_2=a2+t*a3;
	float2 a_1=a1+t*a_2;
	float2 b_2=a_2+t*a3;

	float2 uv_to_p=a0+t*a_1;
	float2 tang=a_1+t*b_2;
	float2 snd_drv=2.*(b_2+t*a3);

	float l_tang=dot(tang,tang);

	float fac=dot(tang,snd_drv)/(2.*l_tang);
	float d=-dot(tang,uv_to_p);

	float t2=d/(l_tang+fac*d);

	return t+factor*t2;
}

float cubic_bezier_normal_iteration3(float t, float2 a0, float2 a1, float2 a2, float2 a3){
	float2 tang = (3.*a3*t+2.*a2)*t+a1;
	float3 poly = float3(dot(a0,tang),dot(a1,tang),dot(a2,tang))/dot(a3,tang);

	/* newton iteration on this polynomial is equivalent to cubic_bezier_normal_iteration */
	return newton_iteration3(poly,t);

	/* halley iteration on this polynomial is equivalent to cubic_bezier_normal_iteration2 */
	//return halley_iteration3(poly,t);
}

float cubic_bezier_dis_approx_sq(float2 uv, float2 p0, float2 p1, float2 p2, float2 p3){
	float2 a3 = (-p0 + 3. * p1 - 3. * p2 + p3);
	float2 a2 = (3. * p0 - 6. * p1 + 3. * p2);
	float2 a1 = (-3. * p0 + 3. * p1);
	float2 a0 = p0 - uv;

	float d0 = 1e38;

	float t0=0.;
	float t;

	for(int i=0;i<num_start_params;i++){
		t=t0;
		for(int j=0;j<num_iterations;j++){
			
			t=cubic_bezier_normal_iteration(t,a0,a1,a2,a3);
		}
		t=clamp(t,0.,1.);
		float2 uv_to_p=((a3*t+a2)*t+a1)*t+a0;
		d0=min(d0,dot(uv_to_p,uv_to_p));

		t0+=1./float(num_start_params-1);
	}

	return d0;
}

float cubic_bezier_dis_approx(float2 uv, float2 p0, float2 p1, float2 p2, float2 p3){
	return sqrt(cubic_bezier_dis_approx_sq(uv,p0,p1,p2,p3));
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

				float border = 2.0/2.0;
			
				float2 uv = coordinateShade;
			
				border*=zoom;
				uv*=zoom;
			
				float2 p0 = float2(-.1,-.1);
				float2 p1 = float2(-0.15, 0.2);
				float2 p2 = float2(0.15,0.2);
				float2 p3 = float2(0.1,-0.1);
				float dis;

				float AA = 2;

				for (float i = -AA; i < AA; ++i) {
        			for (float j = -AA; j < AA; ++j) {
    					dis += cubic_bezier_dis_approx(uv,p0,p1,p2,p3);
        			}
    			}
			
				//iq's sd color scheme
				//float3 color = float3(1.0, 1.0, 1.0) - dis * float3(0.1,0.4,0.7);
   				float4 color = (dis<0.2) ? float4(colTexture, 1.0) : float4(coordinateFull, 0.0, 1.0); //vec3(0.4,0.7,0.85);
				// float3 color = float3(1.0, 1.0, 1.0) - dis*float3(0.0,0.0,0.0);

				color *= 1.0 - exp(-8.0*dis);
				// color *= 0.8 + 0.2*cos(120.0*dis);
				color = lerp( color, float4(1.0, 1.0, 1.0, 1.0), 1.0-smoothstep(0.055,0.055,dis) );
			
				// dis=1e38;
			
				// dis=min(dis,distance(p0.xy/p0.z,uv)-dot_size);
				// dis=min(dis,distance(p1.xy/p1.z,uv)-dot_size);
				// dis=min(dis,distance(p2.xy/p2.z,uv)-dot_size);
				// dis=min(dis,distance(p3.xy/p3.z,uv)-dot_size);
			
				// color = lerp(point_col,color,smoothstep(0.,border,dis));
			
				float4 fragColor = float4(color);

				// fragColor = float4(coordinateShade, 0.0 , 1.0);
		        return fragColor;



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

























