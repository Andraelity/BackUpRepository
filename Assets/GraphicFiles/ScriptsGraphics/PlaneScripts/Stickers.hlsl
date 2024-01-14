
static float cro(in float2 a, in float2 b ) { return a.x*b.y - a.y*b.x; }
static float dot2( in float2 v ) { return dot(v,v); }


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
}


static float SDFArrow( in float2 p, float2 a, float2 b, float w1, float w2 )
{
    // constant setup
    const float k = 3.0;   // arrow head ratio
    float2  ba = b - a;
    float l2 = dot(ba,ba);
    float l = sqrt(l2);

    // pixel setup
    p = p-a;
    float2x2 matrixOpe = {ba.x,-ba.y,ba.y,ba.x};
    p = mul(matrixOpe, (p/l));
    p.y = abs(p.y);
    float2 pz = p - float2(l-w2*k,w2);

    // === distance (four segments) === 

    float2 q = p;
    q.x -= clamp( q.x, 0.0, l-w2*k );
    q.y -= w1;
    float di = dot(q,q);
    //----
    q = pz;
    q.y -= clamp( q.y, w1-w2, 0.0 );
    di = min( di, dot(q,q) );
    //----
    if( p.x<w1 ) // conditional is optional
    {
    q = p;
    q.y -= clamp( q.y, 0.0, w1 );
    di = min( di, dot(q,q) );
    }
    //----
    if( pz.x>0.0 ) // conditional is optional
    {
    q = pz;
    q -= float2(k,-1.0)*clamp( (q.x*k-q.y)/(k*k+1.0), 0.0, w2 );
    di = min( di, dot(q,q) );
    }
    
    // === sign === 
    
    float si = 1.0;
    float z = l - p.x;
    if( min(p.x,z)>0.0 ) //if( p.x>0.0 && z>0.0 )
    {
      float h = (pz.x<0.0) ? w1 : z/k;
      if( p.y<h ) si = -1.0;
    }
    return si*sqrt(di);

}


static float SDFBlobbyCross( in float2 pos, float he )
{
    pos = abs(pos);
    pos = float2(abs(pos.x-pos.y),1.0-pos.x-pos.y)/sqrt(2.0);


    float p = (he-pos.y-0.25/he)/(6.0*he);
    float q = pos.x/(he*he*16.0);
    float h = q*q - p*p*p;
    
    float x;
    if( h>0.0 ) { 
    float r = sqrt(h);
    x = pow(q+r,1.0/3.0) - pow(abs(q-r),1.0/3.0)*sign(r-q); 
    }
    else        
    { 
    float r = sqrt(p);
    x = 2.0*r*cos(acos(q/(p*r))/3.0); 
    }
    x = min(x,sqrt(2.0)/2.0);
    
    float2 z = float2(x,he*(1.0-2.0*x*x)) - pos;
    return length(z) * sign(z.y);
}


static float SDFRoundBox( in float2 p, in float2 b, float r )
{
    float2  w = abs(p)-b;
    float g = max(w.x,w.y);
    return ((g>0.0)?length(max(w,0.0)):g) - r;
}


static float SDFUnevenCapsule( in float2 p, in float2 pa, in float2 pb, in float ra, in float rb )
{
    p  -= pa;
    pb -= pa;
    float h = dot(pb,pb);
    float2  q = float2( dot(p, float2(pb.y,-pb.x)), dot(p,pb) )/h;
    
    //-----------
    
    q.x = abs(q.x);
    
    float b = ra-rb;
    float2  c = float2(sqrt(h-b*b),b);
    
    float k = cro(c,q);
    float m = dot(c,q);
    float n = dot(q,q);
    
         if( k < 0.0 ) return sqrt(h*(n            )) - ra;
    else if( k > c.x ) return sqrt(h*(n+1.0-2.0*q.y)) - rb;
                       return m                       - ra;
}


static float SDFRoundedCross( in float2 p, in float h )
{
    float k = 0.5*(h+1.0/h);               // k should be const/precomputed at modeling time
    
    p = abs(p);
    return ( p.x<1.0 && p.y<p.x*(k-h)+h ) ? 
             k-sqrt(dot2(p - float2(1,k)))  :  // circular arc
           sqrt(min(dot2(p - float2(0,h)),     // top corner
                    dot2(p - float2(1,0))));   // right corner
}


static float SDFCrossFloat( in float2 p, in float2 b ) 
{
    float2 s = sign(p);
    
    p = abs(p); 

    float2  q = ((p.y>p.x)?p.yx:p.xy) - b;
    float h = max( q.x, q.y );
    float2  o = max( (h<0.0)?float2(b.y-b.x,0.0)-q:q, 0.0 );
    float l = length(o);

    float3  r = (h<0.0 && -q.x<l)?float3(-q.x,1.0,0.0):float3(l,o/l);
   
    return float( sign(h)*r.x);
}

static float SDFCutDisk( in float2 p, in float r, in float h )
{
    float w = sqrt(r*r-h*h); // constant for a given shape
    
    p.x = abs(p.x);
    
    // select circle or segment
    float s = max( (h-r)*p.x*p.x+w*w*(h+r-2.0*p.y), h*p.x-w*p.y );

    return (s<0.0) ? length(p)-r :        // circle
           (p.x<w) ? h - p.y     :        // segment line
                     length( p - float2(w,h)); // segment corner
}

static float SDFDollarSign( in float2 p )
{
    // symmetries
    float six = (p.y<.0) ? -p.x : p.x;
    p.x = abs(p.x);
    p.y = abs(p.y) - .2;
    float rex = p.x - min(round(p.x/.4),.4);
    float aby = abs(p.y-.2)-.6;
    
    // line segments
    float d =  dot2(float2(six,-p.y) - clamp(.5*(six-p.y),.0,.2));
    d = min(d, dot2(float2(p.x,-aby) - clamp(.5*(p.x-aby),.0,.4)));
    d = min(d, dot2(float2(rex,p.y   - clamp(p.y         ,.0,.4))));
    
    // interior vs exterior
    float s = 2.*p.x+aby+abs(aby+.4)-.4;

    return sqrt(d) * sign(s);
}



float SDFEgg( in float2 p, in float ra, in float rb )
{
    const float k = sqrt(3.0);
    
    p.x = abs(p.x);
    
    float r = ra - rb;

    return ((p.y<0.0)       ? length(float2(p.x,  p.y    )) - r :
            (k*(p.x+r)<p.y) ? length(float2(p.x,  p.y-k*r)) :
                              length(float2(p.x+r,p.y    )) - 2.0*r) - rb;
}


static float SDFEllipeHorizontal( in float2 p, in float2 r )
{
    p = abs(p);
    p = max(p,(p-r).yx); // idea by oneshade
    
    float m = dot(r,r);
    float d = p.y-p.x;
    return p.x - (r.y*sqrt(m-d*d)-r.x*d) * r.x/m;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


static float SDFGradient2DMin( in float a, in float b )
{
    return (a<b) ? a : b;
}
static float SDFGradient2DMax( in float a, in float b )
{
    return (a>b) ? a : b;
}
static float SDFGradient2DBox( in float2 p, in float2 b )
{
    float2 w = abs(p)-b;
    float2 s = float2(p.x<0.0?-1:1,p.y<0.0?-1:1);
    
    float g = max(w.x,w.y);
    float2  q = max(w,0.0);
    float l = length(q);
    
    return(g>0.0)?l:g; 
}

static float SDFGradient2DSegment( in float2 p, in float2 a, in float2 b )
{
    float2 ba = b-a;
    float2 pa = p-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    float2  q = pa-h*ba;
    float d = length(q);
    return d;
}

static float SDFGradient2DMap( in float2 p, in float rateChange )
{
    float dg1 = SDFGradient2DBox(p, float2(0.8,0.3));
    float dg2 = SDFGradient2DSegment( p, float2(-1.0,-0.5), float2(0.7,0.7) ) - float3(0.15,0.0,0.0);

    float dg;

    dg = (rateChange > 0)? SDFGradient2DMin(dg1,dg2):SDFGradient2DMax(dg1,dg2); 

    return dg;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float SDFHeart( in float2 p )
{
    float sx = p.x<0.0?-1.0:1.0;
    
    p.x = abs(p.x);

    if( p.y+p.x>1.0 )
    {
        const float r = sqrt(2.0)/4.0;
        float2 q0 = p - float2(0.25,0.75);
        float l = length(q0);
        float3 d = float3(l-r,q0/l);
        d.y *= sx;
        return d.x;
    }
    else
    {
        float2 q1 = p - float2(0.0,1.0);
        float3 d1 = float3(dot(q1,q1),q1);
        float2 q2 = p-0.5*max(p.x+p.y,0.0); 
        float3 d2 = float3(dot(q2,q2),q2);
        float3 d = (d1.x<d2.x) ? d1 : d2;
        d.x = sqrt(d.x);
        d.yz /= d.x;
        d *= ((p.x>p.y)?1.0:-1.0);
        d.y *= sx;
        return d.x;    
    }
}




// static float PaintSticker(float stickerType, float2 coordUV, float motionState ,float parameterOne0, float parameterOne1, float parameterOne2, float parameterOne3,
                           // float parameterTen0, float parameterTen1, float parameterTen2, float parameterTen3)

static float PaintSticker(in float stickerType, in float2 coordUV, in float motionState, in float parameterOne0, in float parameterOne1, in float parameterOne2, in float parameterOne3,
                                                                                         in float parameterTen0, in float parameterTen1, in float parameterTen2, in  float parameterTen3)
{
    
    float2 coordinate = coordUV;
    float2 coordinateBase = coordUV/(float2(2.0, 2.0));
    float2 coordinateFull = ceil(coordinateBase);
    coordUV = (coordinate - 0.5) * 2.0 ;

    float signFunctionNULL = 0;

    if(stickerType == 1.0)
    {
    
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/if(motionState == 1)    
        /**/{
        /**/    parameterTen0 = 3.14*(0.5 + 0.5 * cos(TIME* 0.52+2.0));
        /**/    parameterTen1 = 3.14*(0.5 + 0.5 * cos(TIME* 0.31+2.0));
        /**/    parameterOne0 = 0.1 + abs(sin(TIME * 0.5));
        /**/    parameterOne1 = 0.15*(0.5 + 0.5 * cos(TIME* 0.41+1.0));
        /**/}
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFArc(coordUV, parameterTen0, parameterTen1, parameterOne0, parameterOne1);
        return outSDF;
    
    }


    if(stickerType == 2.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/float2 firstParameter = float2(parameterTen0, parameterTen1);
        /**/float2 secondParameter = float2(parameterTen2, parameterTen3);
        /**/
        /**/firstParameter  = firstParameter + float2(-1.2,0.0) + float2(0.4,0.6) * cos( 1.0 * float2(1.1,1.3) + float2(0.0,1.0));//-0.9838790776527441 , -0.3997656127678944
        /**/secondParameter = secondParameter + float2( 1.2,0.0) + float2(0.4,0.6) * cos(1.0 * float2(1.2,1.5) + float2(0.3,2.0));//1.228294880667081, -0.5618740123744778
        /**/parameterOne0 = parameterOne0 + 0.1*(1.0+0.5*cos(1.0 * 3.1 + 2.0)); // 1.2889888713564903
        /**/parameterOne1 = parameterOne1 + parameterOne0 + 0.15; // 1.4389888713564902
        /**/parameterOne2 = parameterOne2 + 0.05 + 0.05*sin(0.0 * 7.0);//0.08284932993593946
        /**/  
        /**/  
        /**/if(motionState == 1)
        /**/{   
        /**/
        /**/    firstParameter = float2(-1.2,0.0) + float2(0.4,0.6) * cos( TIME * float2(1.1,1.3) + float2(0.0,1.0));//-0.9838790776527441 , -0.3997656127678944
        /**/    secondParameter = float2( 1.2,0.0) + float2(0.4,0.6) * cos(TIME * float2(1.2,1.5) + float2(0.3,2.0));//1.228294880667081, -0.5618740123744778
        /**/    parameterOne0 = 0.1*(1.0+0.5*cos(TIME * 3.1 + 2.0)); // 1.2889888713564903
        /**/    parameterOne1 = parameterOne0 + 0.15; // 1.4389888713564902
        /**/    parameterOne2 = 0.05 + 0.05*sin(TIME * 7.0);//0.08284932993593946
        /**/    
        /**/}
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFArrow(coordUV, firstParameter, secondParameter, parameterOne0, parameterOne1) - parameterOne2;

        return outSDF;
    
    }


    if(stickerType == 3.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/if(motionState == 1)
        /**/{
        /**/    parameterOne0 = sin(TIME*0.43+4.0); 
        /**/    parameterOne0 = (0.001+abs(parameterOne0)) * ((parameterOne0>=0.0)?1.0:-1.0);
        /**/     
        /**/    parameterOne1 = 0.1 + 0.5*(0.5+0.5*sin(TIME*1.7)) + max(0.0,parameterOne0 - 0.7);
        /**/}
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        // parameterOne0 = abs(sin(TIME));
        // parameterOne1 = abs(sin(TIME));

        float outSDF = SDFBlobbyCross(coordUV, parameterOne0) - parameterOne1;

        return outSDF;

    }


    if(stickerType == 4.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/float2 firstParameter = float2(parameterOne0, parameterOne1);
        /**/
        /**/if(motionState == 1)
        /**/{
        /**/        
        /**/    firstParameter = float2(abs(cos(TIME)), abs(sin(TIME)));   
        /**/    parameterOne2 = abs(sin(TIME) + 0.2);    
        /**/        
        /**/}
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        // parameterOne0 = abs(sin(TIME));
        // parameterOne1 = abs(sin(TIME));

        float outSDF = SDFRoundBox(coordUV, firstParameter, parameterOne2);

        return outSDF;

    }


    if(stickerType == 5.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.4;
        /**/
        /**/float2 firstParameter = float2(parameterOne0, parameterOne1);
        /**/float2 secondParameter = float2(parameterOne2, parameterOne3);
        /**/
        /**/if(motionState == 1)
        /**/{
        /**/    firstParameter = cos( TIME + float2(0.0,2.00) + 0.0 );
        /**/    secondParameter = cos( TIME + float2(0.0,1.50) + 1.5 );
        /**/    parameterTen0 = 0.5+0.1*sin(TIME);
        /**/    parameterTen1 = 0.3+0.1*sin(1.0 + 2.3 * TIME);
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        // parameterOne0 = abs(sin(TIME));
        // parameterOne1 = abs(sin(TIME));

        float outSDF = SDFUnevenCapsule(coordUV, firstParameter, secondParameter, parameterTen0, parameterTen1);

        return outSDF;

    }


    if(stickerType == 6.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.4;
        /**/
        /**/if(motionState == 1)
        /**/{
        /**/
        /**/    parameterOne0 = 0.501-0.499*cos(TIME*1.1+0.0);
        /**/    parameterOne1 = 0.100+0.100*sin(TIME*1.7+2.0);
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        // parameterOne0 = abs(sin(TIME));
        // parameterOne1 = abs(sin(TIME));

        float outSDF = SDFRoundedCross(coordUV, parameterOne0) - parameterOne1;

        return outSDF;

    }


    if(stickerType == 7.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.4;
        /**/
        /**/float2 firstParameter = float2(parameterOne0, parameterOne1);
        /**/if( firstParameter.x < firstParameter.y ) firstParameter = firstParameter.yx;
        /**/
        /**/if(motionState == 1)
        /**/{
        /**/
        /**/    firstParameter = 0.5 + 0.3*cos( TIME + float2(0.0,1.57) + 0.0 );     
        /**/    if( firstParameter.x < firstParameter.y ) firstParameter=firstParameter.yx;
        /**/    // corner radious
        /**/    parameterOne2 =0.1*(0.5+0.5*sin(TIME*1.2));
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        
        // parameterOne0 = abs(sin(TIME));
        // parameterOne1 = abs(sin(TIME));

        float outSDF = SDFCrossFloat(coordUV, firstParameter) - parameterOne2;

        return outSDF;
    }
    

    if(stickerType == 8.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/if(motionState == 1.0)
        /**/{
        /**/
        /**/    parameterOne0 = 0.75;
        /**/    parameterOne1 = parameterOne0 * clamp(cos(TIME*0.8),-0.999999,0.999999);
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        
        // parameterOne0 = abs(sin(TIME));
        // parameterOne1 = abs(sin(TIME));

        float outSDF = SDFCutDisk(coordUV, parameterOne0, parameterOne1);

        return outSDF;
    }
    

    if(stickerType == 9.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/if(motionState == 1.0)
        /**/{
        /**/
        /**/    parameterOne0 = abs(sin(TIME * 0.5));
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        
        // parameterOne0 = abs(sin(TIME));
        // parameterOne1 = abs(sin(TIME));

        float outSDF = SDFDollarSign(coordUV) - parameterOne0;

        return outSDF;
    }


    if(stickerType == 10.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.5;
        /**/
        /**/if(motionState == 1.0)
        /**/{
        /**/
        /**/    parameterOne0 = 0.6;
        /**/    parameterOne1 = parameterOne0 * (0.55+0.45 * cos(2.0 * TIME));
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        
        // parameterOne0 = abs(sin(TIME));
        // parameterOne1 = abs(sin(TIME));

        float outSDF = SDFEgg(coordUV, parameterOne0, parameterOne1);

        return outSDF;
    }


    if(stickerType == 11.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.5;
        /**/
        /**/float2 firstParameter = float2(parameterOne0, parameterOne1);
        /**/ 
        /**/if(motionState == 1.0)
        /**/{
        /**/
        /**/    firstParameter = float2(0.7,0.2) + 0.5 * (abs(sin( TIME * float2(1.1,1.3) + float2(0,1))));
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFEllipeHorizontal(coordUV, firstParameter);

        return outSDF;
    }
    

    if(stickerType == 12.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.5;
        /**/
        /**/ 
        /**/if(motionState == 1.0)
        /**/{
        /**/
        /**/    parameterOne0 = sin(TIME);
        /**/    coordUV = coordUV * sin(TIME) * 2.0;
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFGradient2DMap(coordUV, parameterOne0);

        return outSDF;
    }


    if(stickerType == 13.0)
    {

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.5;
        /**/
        /**/
        /**/coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/coordUV = coordUV * parameterOne2; 
        /**/if(motionState == 1.0)
        /**/{
        /**/    
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * sin(TIME);
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFHeart(coordUV);

        return outSDF;
    }


    return signFunctionNULL;

}

// float3 sdfArc( in float2 p, in float2 sca, in float2 scb, in float ra, in float rb )
// {
//     return float3(1.0, 1.0, 1.0);
// }







