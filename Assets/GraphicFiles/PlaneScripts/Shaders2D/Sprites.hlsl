float4 PaintSprite(float2 coordinateSprite, float4 colBackground, sampler2D _TextureSprite,  float _InVariableTick, float _InVariableRatioX, float _InVariableRatioY, float _OutlineSprite)
{


    int tick  = _InVariableTick;
    int ratioX = _InVariableRatioX;
    int ratioY = _InVariableRatioY;
   
    // get single sprite size
    float2 size = float2(1.0f / ratioX, 1.0f / ratioY);
    uint totalFrames = ratioX * ratioY;
    // use timer to increment index
    uint index = TIME * tick;
    // wrap x and y indexes
    uint indexX = index % ratioX;
    uint indexY = floor((index % totalFrames) / ratioX);
    // get offsets to our sprite index
    float2 offset = float2(size.x*indexX,-size.y*indexY);
    // get single sprite UV
    float2 newUV = coordinateSprite*size;
    // flip Y (to start 0 from top) 
    newUV.y = newUV.y + size.y*(ratioY - 1);
    newUV = newUV + offset;

    float4 colorSpriteTex = tex2D(_TextureSprite, newUV);
    colorSpriteTex += tex2D(_TextureSprite, newUV + float2(0.001, 0.0)) /2.0;
    colorSpriteTex += tex2D(_TextureSprite, newUV + float2(-0.001, 0.0))/2.0;
    colorSpriteTex += tex2D(_TextureSprite, newUV + float2(0.0, 0.001)) /2.0;
    colorSpriteTex += tex2D(_TextureSprite, newUV + float2(0.0, -0.001))/2.0;
    
    float4 colorSpriteTexBase = 0.0;
    clip(colorSpriteTex.a - 0.15);
    colorSpriteTex.xyz += 1.0;
    colorSpriteTex.w *= -1.0;
    if(colorSpriteTex.w  < 0)
    {
        colorSpriteTex = colBackground;
        colorSpriteTexBase = colBackground;
    }
    
    float2 newUV2 = (coordinateSprite + float2(0.01, 0.01))*size;
    newUV2.y = newUV2.y + size.y*(ratioY - 1);
    newUV2 = newUV2 + offset;
    float4 colorSpriteTex2 = tex2D(_TextureSprite, newUV2);
    colorSpriteTex2.xyz -= 2.0;
    colorSpriteTex2.w *= -1.0;
    colorSpriteTex2 += colorSpriteTexBase;
    if(colorSpriteTex2.w  < 0)
    {
        colorSpriteTex2 = 0.0;
    }
    colorSpriteTex2.xyz = 0.0;
    
    if(colorSpriteTex2.w > 0)
    {
        colorSpriteTexBase.xyz = 0.0; 
    }
    bool OutlineStatus = (_OutlineSprite == 0)?false:true;

    if(OutlineStatus)
    {
        return colorSpriteTexBase;
    }
    else
    {
        return colorSpriteTex;
    }

}
