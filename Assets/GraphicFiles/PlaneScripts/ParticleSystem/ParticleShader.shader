Shader "Unlit/ParticleShader"
{   
    Properties
    {
        _ColorOperation ("ColorForSomething", Color) = (1.0, 1.0, 1.0, 1.0)

        _TextureChannel0 ("Texture", 2D) = "gray" {}
        _TextureChannel1 ("Texture", 2D) = "gray" {}
        _TextureChannel2 ("Texture", 2D) = "gray" {}
        _TextureChannel3 ("Texture", 2D) = "gray" {}

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
            };

            struct pixel
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };


            sampler2D _TextureChannel0;
            sampler2D _TextureChannel1;
            sampler2D _TextureChannel2;
            sampler2D _TextureChannel3;
            

            float _StickerType;
            float _MotionState;

            float4 _BorderColor;
            float _BorderSizeOne;
            float _BorderSizeTwo;
            float _BorderBlurriness;

            float _RangeSOne_One0; 
            float _RangeSOne_One1; 
            float _RangeSOne_One2; 
            float _RangeSOne_One3; 

            float _RangeSTen_Ten0;
            float _RangeSTen_Ten1;
            float _RangeSTen_Ten2;
            float _RangeSTen_Ten3;
            #define PI 3.1415926535897931
            #define TIME _Time.y          


            pixel vert (vertexPoints v)
            {
                pixel o;


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

            float saturate(float color)
            {
                return clamp(color, 0.0, 1.0);
            }
            
            float2 saturate(float2 color)
            {
                return clamp(color, 0.0, 1.0);
            }
            
            float3 saturate(float3 color)
            {
                return clamp(color, 0.0, 1.0);
            }
            
            float4 saturate(float4 color)
            {
                return clamp(color, 0.0, 1.0);
            }





            fixed4 frag (pixel PIXEL) : SV_Target
            {

                //////////////////////////////////////////////////////////////////////////////////////////////
                /// DEFAULT
                //////////////////////////////////////////////////////////////////////////////////////////////

                float2 coordinate = PIXEL.uv;
                
                float2 coordinateScale = (PIXEL.uv - 0.5) * 2.0 ;
                
                float2 coordinateShade = coordinateScale/(float2(2.0, 2.0));
                
                float2 coordinateFull = ceil(coordinateShade);

                float3 colBase  = 0.0;  

                float3 colTexture = float3(coordinateScale.x + coordinateScale.y, coordinateScale.y - coordinateScale.x, pow(coordinate.x,2.0f));


                float4 col = float4(colTexture, 1.0);

                col = tex2D(_TextureChannel0, coordinateScale);

                float paintPoint = float2(0.0, 0.0);
                float radio = 1;
                float lenghtRadio = length(coordinateScale - paintPoint);
 




    float2 glUV = coordinate;
    float4 cvSplashData = float4(2.0, 2.0, TIME, 0.0);  
    float2 InUV = glUV * 2.0 - 1.0; 
    
    //////////////////////////////////////////////////////////////
    // End of ShaderToy Input Compat
    //////////////////////////////////////////////////////////////
    
    // Constants
    const float TimeElapsed     = cvSplashData.z;
    const float Brightness      = sin(TimeElapsed) * 0.1;
    const float2 Resolution     = float2(cvSplashData.x, cvSplashData.y);
    const float AspectRatio     = 1.0;
    const float3 InnerColor     = float3( 0.50, 0.50, 0.50 );
    const float3 OuterColor     = float3( 0.00, 0.45, 0.00 );
    const float3 WaveColor      = float3( 1.00, 1.00, 1.00 );
        
    // Input
    float2 uv               = (InUV + 1.0) / 2.0;

    // Output
    float4 outColor         = float4(0.0, 0.0, 0.0, 0.0);

    // Positioning 
    float2 outerPos         = -0.5 + uv;
    outerPos.x              *= AspectRatio;

    float2 innerPos         = InUV * ( 2.0 - Brightness );
    innerPos.x              *= AspectRatio;

    // "logic" 
    float innerWidth        = length(outerPos); 
    float circleRadius      = 0.24 + Brightness * 0.1;
    float invCircleRadius   = 1.0 / circleRadius;   
    float circleFade        = pow(length(2.0 * outerPos), 0.5);
    float invCircleFade     = 1.0 - circleFade;
    float circleIntensity   = pow(invCircleFade * max(1.1 - circleFade, 0.0), 2.0) * 40.0;
    float circleWidth       = dot(innerPos,innerPos);
    float circleGlow        = ((1.0 - sqrt(abs(1.0 - circleWidth))) / circleWidth) + Brightness * 0.5;
    float outerGlow         = min( max( 1.0 - innerWidth * ( 1.0 - Brightness ), 0.0 ), 1.0 );
    float waveIntensity     = 0.0;
    
    // Inner circle logic
    if( innerWidth < circleRadius )
    {
        circleIntensity     *= pow(innerWidth * invCircleRadius, 24.0);
        
        float waveWidth     = 0.05;
        float2 waveUV       = InUV;

        waveUV.y            += 0.14 * cos(TimeElapsed + (waveUV.x * 2.0));
        waveIntensity       += abs(1.0 / (130.0 * waveUV.y));
            
        waveUV.x            += 0.14 * sin(TimeElapsed + (waveUV.y * 2.0));
        waveIntensity       += abs(1.0 / (130.0 * waveUV.x));

        waveIntensity       *= 1.0 - pow((innerWidth / circleRadius), 3.0);
    }   

    // Compose outColor
    outColor.rgb    = outerGlow * OuterColor;   
    outColor.rgb    += circleIntensity * InnerColor;    
    outColor.rgb    += circleGlow * InnerColor * (0.6 + Brightness * 1.2);
    outColor.rgb    += WaveColor * waveIntensity;
    outColor.rgb    += circleIntensity * InnerColor;
    outColor.a      = 1.0;

    // Fade in
    outColor.rgb    = saturate(outColor.rgb);
    outColor.rgb    *= min(TimeElapsed / 2.0, 1.0);

    //////////////////////////////////////////////////////////////
    // Start of ShaderToy Output Compat
    //////////////////////////////////////////////////////////////


    float4 fragColor = outColor;









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



                // return  float4(_StickerType/10, _BorderSizeOne/10, _BorderSizeTwo/10, 1.0);
                // return  col;
                // if (lenghtRadio < radio)
                // {
                //     return float4(1.0, 1.0, 1.0, 1.0) + col;
                //     // return col;
                // }
                // else
                // {
                //     return 0.0;
                // }
            }




            ENDHLSL
        }
    }
}
