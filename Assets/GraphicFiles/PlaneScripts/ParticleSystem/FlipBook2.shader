
Shader "UnityLibrary/Sprites/FlipBook2"
{
    Properties
    {
        [Header(Texture Sheet)]
        _MainTex("Texture", 2D) = "white" {}
        _Cutoff("Alpha Cutoff", Range(0,1)) = 0.15
        [Header(Settings)]
        _ColumnsX("Columns (X)", int) = 4
        _RowsY("Rows (Y)", int) = 4
        _AnimationSpeed("Frames Per Seconds", float) = 10
    }
    SubShader
    {
        Tags {
            "Queue" = "AlphaTest"
            "IgnoreProjector" = "True"
            "PreviewType" = "Plane"
            "RenderType" = "TransparentCutout"
            "DisableBatching" = "True"
        }

        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            float _Cutoff;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            uint _ColumnsX;
            uint _RowsY;
            float _AnimationSpeed;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                // // get single sprite size
                // float2 size = float2(1.0f / _ColumnsX, 1.0f / _RowsY);
                // uint totalFrames = _ColumnsX * _RowsY;

                // // use timer to increment index
                // uint index = _Time.y*_AnimationSpeed;

                // // wrap x and y indexes
                // uint indexX = index % _ColumnsX;
                // uint indexY = floor((index % totalFrames) / _ColumnsX);

                // // get offsets to our sprite index
                // float2 offset = float2(size.x*indexX,-size.y*indexY);

                // // get single sprite UV
                // float2 newUV = v.uv2*size;

                // // flip Y (to start 0 from top)
                // newUV.y = newUV.y + size.y*(_RowsY - 1);

                // o.uv2 = newUV + offset;
                o.uv2 = v.uv2;
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {

                // float2 uvScale = i.uv2 * 0.5;
                float2 uvScale = i.uv * 0.5;

                // get single sprite size
                float2 size = float2(1.0f / _ColumnsX, 1.0f / _RowsY);
                uint totalFrames = _ColumnsX * _RowsY;

                // use timer to increment index
                uint index = _Time.y*_AnimationSpeed;

                // wrap x and y indexes
                uint indexX = index % _ColumnsX;
                uint indexY = floor((index % totalFrames) / _ColumnsX);

                // get offsets to our sprite index
                float2 offset = float2(size.x*indexX,-size.y*indexY);

                // get single sprite UV
                float2 newUV = i.uv2 * size;
                float2 newUV2 = i.uv * size;

                // flip Y (to start 0 from top)
                newUV.y = newUV.y + size.y*(_RowsY - 1);
                newUV = newUV + offset;

                newUV2.y = newUV2.y + size.y*(_RowsY - 1);
                newUV2 = newUV2 + offset;



                fixed4 col = tex2D(_MainTex, newUV );
                fixed4 col2 = tex2D(_MainTex, newUV2 );
                // fixed4 col = tex2D(_MainTex, newUV );



                // col = 1.0;
                // cutout
                clip(col2.a - 0.50);
                clip(col.a - 0.50);

                // col= col.w ; 

                // col2 = col + col2;
                // float4 ValueOutput = col - col2;

                // float4 colBackground = float4(i.uv, 0.0, 1.0);

                // if(col.w * colBackground.w != 0)
                // {
                //     col = colBackground;
                // }

                // return colBackground;
                return col;
            }
        ENDCG
        }
    }
}