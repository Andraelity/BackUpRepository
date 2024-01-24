Shader "Shaders2D/BloomEffect"
{   
    Properties
    {

        [HDR] _EmissionColor ("_EmissionColor", Color) = (2.0, 1.0, 1.0, 10.0)

        _TextureSprite ("_TextureSprite", 2D)     = "green" {}
     

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
            #pragma vertex VERTEXSHADER
            #pragma fragment FRAGMENTSHADER
            
            #pragma multi_compile_instancing
            
            #include "UnityCG.cginc"


            struct vertexPoints
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            
            };

            struct pixelPoints
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };

            float4 _EmissionColor;
            sampler2D _TextureSprite;
     
            #define PI 3.1415926535897931
            #define TIME _Time.y          


            pixelPoints VERTEXSHADER (vertexPoints VERTEXSPACE)
            {
                pixelPoints PIXELSPACE;


                PIXELSPACE.vertex = UnityObjectToClipPos(VERTEXSPACE.vertex);
 
                PIXELSPACE.uv = VERTEXSPACE.uv;
                PIXELSPACE.uv2 = VERTEXSPACE.uv2;
                return PIXELSPACE;
            }


            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////


#define colorRange 24.0


float4 getTexture(float2 uv){
    float4 textureSample = tex2D(_TextureSprite, uv);
    // return sqrt(textureSample.rgb * textureSample.a);
    return (textureSample);
}

float4 CHANNEL0(float2 uv)
{

    float4 color = 0.0;
    
    color = pow(getTexture(uv), 1.0) * 1.0;
    // float valuePow = 1.0 / 2.2;
    
    // float4 valueTexture = float4(pow(color, float3(valuePow, valuePow, valuePow)) / colorRange,1.0);

    // valueTexture = float4(valueTexture.xyz,(valueTexture.x + valueTexture.y + valueTexture.z)/ 3.0);

    return color;

}

float3 makeBloom(float lod, float2 offset, float2 bCoord){
    
    float2 pixelSize = 1.0 /2.0;

    offset += pixelSize;

    float lodFactor = exp2(lod);

    float3 bloom = 0.0;
    float2 scale = lodFactor * pixelSize;

    float2 coord = (bCoord.xy-offset)*lodFactor;
    float totalWeight = 0.0;

    float2 representation0 = abs(coord - 0.5);
    float2 representation1 = scale;

    // if (any(greaterThanEqual(abs(coord - 0.5), scale + 0.5)))
    if (representation0.x >= representation1.x || representation0.y >= representation1.y  )
        return (0.0);

    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {

            float wg = pow(1.0-length(float2(i,j)) * 0.125,6.0);

            bloom = pow(CHANNEL0(float2(i,j) * scale + lodFactor * pixelSize + coord).xyz,float3(2.2, 2.2, 2.2))* wg + bloom;
            totalWeight += wg;

        }
    }

    bloom /= totalWeight;

    return bloom;
}

float4 CHANNEL1(float2 uv)
{

    float3 blur = makeBloom(2.,float2(0.0,0.0), uv);
        blur += makeBloom(3.,float2(0.3,0.0), uv);
        blur += makeBloom(4.,float2(0.0,0.3), uv);
        blur += makeBloom(5.,float2(0.1,0.3), uv);
        blur += makeBloom(6.,float2(0.2,0.3), uv);

    return float4(pow(blur, float3(1.0 / 2.2, 1.0 / 2.2, 1.0 / 2.2)),1.0);
}


float3 jodieReinhardTonemap(float3 c){
    float l = dot(c, float3(0.2126, 0.7152, 0.0722));
    float3 tc = c / (c + 1.0);

    return lerp(c / (l + 1.0), tc, tc);
}

float3 bloomTile(float lod, float2 offset, float2 uv){
    return CHANNEL1(uv * exp2(-lod) + offset).xyz;
}

float3 getBloom(float2 uv){

    float3 blur = (0.0);

    blur = pow(bloomTile(2., float2(0.0,0.0), uv), float3(2.2, 2.2, 2.2))              + blur;
    blur = pow(bloomTile(3., float2(0.3,0.0), uv), float3(2.2, 2.2, 2.2)) * 1.3        + blur;
    blur = pow(bloomTile(4., float2(0.0,0.3), uv), float3(2.2, 2.2, 2.2)) * 1.6        + blur;
    blur = pow(bloomTile(5., float2(0.1,0.3), uv), float3(2.2, 2.2, 2.2)) * 1.9        + blur;
    blur = pow(bloomTile(6., float2(0.2,0.3), uv), float3(2.2, 2.2, 2.2)) * 2.2        + blur;

    return blur * colorRange;
}

float4 BLOOMENDSTEP(float2 uv)
{
 
    float3 color = pow(CHANNEL0(uv).xyz * colorRange, float3(2.2, 2.2, 2.2));
    color = pow(color, float3(2.2, 2.2, 2.2));
    color += pow(getBloom(uv), float3(2.2, 2.2, 2.2));

    float valuePow = 1.0 / 3.2;
    // color = pow(color, float3(valuePow, valuePow, valuePow));
    // 
    // color = jodieReinhardTonemap(color);
    
    return float4(color,1.0);

}


float pixelSizeHash(float distanceToPoint, float2 p)
{

    float3 p3  = frac(float3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    float outputVar = distanceToPoint * frac((p3.x + p3.y) * p3.z);
    return outputVar;

}


float pixelSizeHashTwo(float p)
{

    p = frac(p * .1031);
    p *= p + 33.33;
    p *= p + p;
    return frac(p);

}


static float Threshold = 0.0;
static float Intensity = 1.0;
static float BlurSize = 3.0;


float4 BlurColor (in float2 Coord, in float MipBias)
{
    float2 TexelSize = MipBias/float2(100,100);
    
    float4  Color  = tex2D(_TextureSprite, Coord);
            Color += tex2D(_TextureSprite, Coord + float2(TexelSize.x,0.0));      
            Color += tex2D(_TextureSprite, Coord + float2(-TexelSize.x,0.0));     
            Color += tex2D(_TextureSprite, Coord + float2(0.0,TexelSize.y));      
            Color += tex2D(_TextureSprite, Coord + float2(0.0,-TexelSize.y));     
            Color += tex2D(_TextureSprite, Coord + float2(TexelSize.x,TexelSize.y));      
            Color += tex2D(_TextureSprite, Coord + float2(-TexelSize.x,TexelSize.y));     
            Color += tex2D(_TextureSprite, Coord + float2(TexelSize.x,-TexelSize.y));     
            Color += tex2D(_TextureSprite, Coord + float2(-TexelSize.x,-TexelSize.y));    

    return Color/9.0;
}



            fixed4 FRAGMENTSHADER (pixelPoints PIXELSPACE) : SV_Target
            {

                //////////////////////////////////////////////////////////////////////////////////////////////
                /// DEFAULT
                //////////////////////////////////////////////////////////////////////////////////////////////
                float2 coordinateSprite = PIXELSPACE.uv2;
                float2 coordinateSprite2 = PIXELSPACE.uv2;

                float2 coordinate = PIXELSPACE.uv;
                
                float2 coordinateScale = (PIXELSPACE.uv - 0.5) * 2.0 ;
                
                float2 coordinateShade = coordinateScale/(float2(2.0, 2.0));
                
                float2 coordinateFull = ceil(coordinateShade);

                float3 colBase  = 0.0;  

                float3 colTexture = float3(coordinateScale.x + coordinateScale.y, coordinateScale.y - coordinateScale.x, pow(coordinate.x,2.0f));



                // float4 valueTexture = tex2D(_TextureSprite, coordinate);
                // float4 valueTexture2 = tex2D(_TextureSprite, coordinate);

                float4 fragColor = float4(coordinate, 0.0, 1.0);


    float2 uv = coordinate;
    
    // valueTexture = CHANNEL0(uv);
    // valueTexture = BLOOMENDSTEP(uv);
    // float2 size = textureSize(t0, 0);
    
    float2 tex_coord = coordinate;
    float uv_x = coordinate.x;
    float uv_y = coordinate.y;

    float4 sum = 0.0;

    // for (int n = 0; n < 9; n++) 
    
    // {

        // uv_y = (tex_coord.y) + 1.0 * (n - 4);

        // float ratioDivision = 3.5;
        // float ratioDivisionTwo = 7.0;
        // float ratioDivisionThree = 10.0;

        // float pixelSize = 0.05;
        // float4 h_sum = 0.0;
         
        // // which is the appreciation

        // for(int i = 0; i < 100; i++)
        // {

        //     float valueContainer = pixelSize;

        //     float operative = pixelSizeHash(pixelSize,  float2(0.01 * i + 1,  0.01 * i  + 3));
        //     float operative2 = pixelSizeHash(pixelSize, float2(0.01 * i + 2,  0.01 * i  + 4));
        //     h_sum += tex2D(_TextureSprite, float2(uv_x + operative, uv_y + operative )) / ratioDivision;
        //     operative = pixelSizeHash(pixelSize, uv + float2(-0.01  * i + 1,  0.01 * i + 3));
        //     operative2 = pixelSizeHash(pixelSize, uv + float2(-0.01 * i + 2,  0.01 * i + 4));
        //     h_sum += tex2D(_TextureSprite, float2(uv_x - operative, uv_y + operative )) / ratioDivision;
        //     operative = pixelSizeHash(pixelSize, uv + float2(-0.01  * i + 1, -0.01 * i + 3));
        //     operative2 = pixelSizeHash(pixelSize, uv + float2(-0.01 * i + 2, -0.01 * i + 4));
        //     h_sum += tex2D(_TextureSprite, float2(uv_x - operative, uv_y - operative )) / ratioDivision;
        //     operative = pixelSizeHash(pixelSize, uv + float2( 0.01  * i + 1, -0.01 * i + 3));
        //     operative2 = pixelSizeHash(pixelSize, uv + float2( 0.01 * i + 2, -0.01 * i + 4));
        //     h_sum += tex2D(_TextureSprite, float2(uv_x + operative, uv_y - operative )) / ratioDivision;



        // }   
        // sum += h_sum /70.0;

    // float uv_x = newUV2.x;
    // float uv_y = newUV2.y;
    // float ratioDivision = 5.0;

    // float pixelSize = 0.02;
    // float4 sum = 0.0;
    // float4 h_sum = 0.0;
     
    // // which is the appreciation
    // for(int i = 0; i < 100; i++)
    // {
    //     float valueContainer = pixelSize;
    //     float operative = pixelSizeHash(pixelSize,  float2(0.01 * i + 1,  0.01 * i  + 3));
    //     float operative2 = pixelSizeHash(pixelSize, float2(0.01 * i + 2,  0.01 * i  + 4));
    //     h_sum += tex2D(_TextureSprite, float2(uv_x + operative, uv_y + operative )) / ratioDivision;
    //     operative = pixelSizeHash(pixelSize,  newUV2 + float2(-0.01  * i + 1,  0.01 * i + 3));
    //     operative2 = pixelSizeHash(pixelSize, newUV2 + float2(-0.01 * i + 2,  0.01 * i + 4));
    //     h_sum += tex2D(_TextureSprite, float2(uv_x - operative, uv_y + operative )) / ratioDivision;
    //     operative = pixelSizeHash(pixelSize,  newUV2 + float2(-0.01  * i + 1, -0.01 * i + 3));
    //     operative2 = pixelSizeHash(pixelSize, newUV2 + float2(-0.01 * i + 2, -0.01 * i + 4));
    //     h_sum += tex2D(_TextureSprite, float2(uv_x - operative, uv_y - operative )) / ratioDivision;
    //     operative = pixelSizeHash(pixelSize,  newUV2 + float2( 0.01  * i + 1, -0.01 * i + 3));
    //     operative2 = pixelSizeHash(pixelSize, newUV2 + float2( 0.01 * i + 2, -0.01 * i + 4));
    //     h_sum += tex2D(_TextureSprite, float2(uv_x + operative, uv_y - operative )) / ratioDivision;
    // }   
    // sum += h_sum /70.0;

    // float4 colorSpriteTex2 = tex2D(_TextureSprite, newUV2) + sum;

    // colorSpriteTex2 = smoothstep(float4(COLOR1, 1.0), colorSpriteTex2, 0.1);


    // colorSpriteTex2.xyz -= 2.0;
    // colorSpriteTex2.w *= 1.0;
    // colorSpriteTex2.w += (colorSpriteTexBase.w * -3.0);
    // if(colorSpriteTex2.w  < 0)
    // {
    //     colorSpriteTex2 += float4(0,0,0,0.0);
    //     colorSpriteTex2 = colorSpriteTexBase;

    // }
    // // colorSpriteTex2.xyz += 2.0;
    
    // if(colorSpriteTex2.w > 0)
    // {
    //     colorSpriteTexBase.xyz = 0.0; 
    // }

    // }


    // float4 pixel = tex2D(_TextureSprite, tex_coord) + sum; //- ((sum / 9.0) * bloom_intensity);
    
    // float2 coordinateValue = coordinate * float2(1.0, -1.0);
// 
 // 
    // float4 Color = tex2D(_TextureSprite, coordinateValue);
    // float4 Highlight = clamp(BlurColor(coordinateValue, BlurSize)-Threshold,0.0,1.0)*1.0/(1.0-Threshold);
        
    // pixel = 1.0-(1.0-Color)*(1.0-Highlight*Intensity); //Screen Blend Mode
    


    float4 pixel = float4(0.0, 0.0, 0.0, 1.0);


                return pixel;






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
