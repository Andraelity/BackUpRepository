Shader "Unlit/ShaderPlane"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }


float cro(in float2 a, in float2 b ) { return a.x*b.y-a.y*b.x; }
float dot2( in float2 a ) { return dot(a,a); }

static float SDFTriangleIsosceles( in float2 p, in float2 q )
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
    return float(d);
}

#define TIME _Time.y

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // fixed4 col = tex2D(_MainTex, i.uv);


                // apply fog
                // UNITY_APPLY_FOG(i.fogCoord, col);

                float2 positionUV = float2((i.uv- 0.5) * 2.0);

                float2 v0 = cos( 0.5 * TIME + float2(0.0,2.0) + 0.0 );
                float2 v1 = cos( 0.5 * TIME + float2(0.0,1.5) + 1.5 );
                float2 v2 = cos( 0.5 * TIME + float2(0.0,3.0) + 4.0 );
            
                // compute traingle SDF
                float dg = SDFTriangleIsosceles( positionUV, v0);
                float d = dg;
    
  
                // coloring
                float4 col = float4(0.0,0.0,0.0, 1.0) - sign(d)*float4(1.0, 1.0, 1.0, 1.0);

                // float4 col = (d > 0.0) ? float4(0.0,0.0,0.0,0.0) : float4(1.0, 1.0, 1.0, 1.0);; //vec3(0.4,0.7,0.85);
                col *= 1.0 - exp(-48.0*abs(d));
                col *= 0.8 + 0.2*cos(120.0*d);
                col = lerp( col, float4(1.0, 1.0, 1.0, 1.0), 1.0-smoothstep(0.005,0.005,abs(d)) );


                return col;
            }

            ENDCG
        }
    }
}
