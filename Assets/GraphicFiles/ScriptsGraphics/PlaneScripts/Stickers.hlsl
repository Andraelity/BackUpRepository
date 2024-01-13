
// void operationBorderSize(float one, float two)
// {

// }


static float4 ColorSign(in float dSign, in float4 backGround, in float4 borderColor, in float borderSizeOne, in float borderSizeTwo, in float blurriness)
{
    float valueOne = borderSizeOne/1000;
    float valueTwo = borderSizeTwo/1000;

    float4 col = (dSign>0.0) ? float4(0.0,0.0,0.0,0.0) : float4(backGround.xyzw); //vec3(0.4,0.7,0.85);

    col *= 1.0 - exp(-blurriness*abs(dSign));
    // col *= 0.8 + 0.2*cos(120.0*dSign);
    // col = lerp( col, float4(borderColor), 1.0-smoothstep(borderSizeOne, borderSizeTwo,abs(dSign)));
    col = lerp( col, float4(borderColor), 1.0-smoothstep(valueTwo, valueTwo,abs(dSign)));
     
    return col;
}

static float SDFArc( in float2 p, in float ta, in float tb, in float r1, in float r2 )
{
    float ra = r1;
    float rb = r2;
    float2 sca = float2(sin(ta), cos(ta));
    float2 scb = float2(sin(tb), cos(tb));

    float2 q = p;
 
    float2x2 ma = {sca.x,-sca.y,sca.y,sca.x};
    p = mul(ma,p);
 
    float s = sign(p.x); p.x = abs(p.x);
     
    float3 dOut;

    if( scb.y*p.x > scb.x*p.y )
    {
        float2  w = p - ra*scb;
        float d = length(w);
        dOut = float3( d-rb, mul(float2(s*w.x,w.y),mul(ma,1/d)) );
    }
    else
    {
        float l = length(q);
        float w = l - ra;
        dOut = float3( abs(w)-rb, sign(w)*q/l );
    }
 
    float dSign = dOut.x;
    
    return dSign;
    // float4 col = float4(0.0,0.0,0.0, 1.0) - sign(dSign)*float4(backGround); 
}

static float PaintSticker(in float stickerType, in float2 coordUV, in float parameterOne1, in float parameterOne2, in float parameterOne3, in float parameterOne4,
                          in float parameterTen1, in float parameterTen2, in float parameterTen3, in  float parameterTen4)

{
    float signFunctionNULL = 0;
    if(stickerType == 1.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        //
        ////////////////////////////////////////////////////////////////////////////////////
        return SDFArc(coordUV, parameterTen1, parameterTen2, parameterOne1, parameterOne2);
    }
    return signFunctionNULL;
}

// float3 sdfArc( in float2 p, in float2 sca, in float2 scb, in float ra, in float rb )
// {
//     return float3(1.0, 1.0, 1.0);
// }







