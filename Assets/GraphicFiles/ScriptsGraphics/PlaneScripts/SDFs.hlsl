
static float cro(in float2 a, in float2 b ) { return a.x*b.y - a.y*b.x; }
static float dot2( in float2 v ) { return dot(v,v); }

static float hash(float x) {
    return frac(abs(sin(sin(123.321 + x) * (x + 321.123)) * 456.654));
}

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



static float rotationOperation( in float2 p )
{

    float2x2 mat2 = {cos(TIME),sin(TIME),-sin(TIME),cos(TIME)};

    p = mul(mat2,(p-float2(2.0,0.0)));

    ///////this line is a generalized rotatin, that you can use on other SDF
    // return sdBox(p,float2(0.7,0.25));
    return float2(0.0, 0.0);
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


static float SDFHeart( in float2 p )
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


static float SDFHexagon( in float2 p, in float r ) 
{
    const float3 k = float3(-0.866025404,0.5,0.577350269);
    float2 s = sign(p);
    p = abs(p);
    float w = dot(k.xy,p);    
    p -= 2.0*min(w,0.0)*k.xy;
    p -= float2(clamp(p.x, -k.z*r, k.z*r), r);
    float d = length(p)*sign(p.y);

    return float(d);

}

static float SDFHorseshoe(in float2 p, in float cIn, in float r, in float le, float th )
{
    float2 c = float2(cos(cIn),sin(cIn));
    p.x = abs(p.x);
    float l = length(p);
    float2x2 mat2 = {-c.x, c.y, c.y, c.x};
    p = mul(mat2, p);
    p = float2((p.y>0.0 || p.x>0.0)?p.x:l*sign(-c.x),
             (p.x>0.0)?p.y:l );
    p = float2(p.x-le,abs(p.y-r)-th);

    return length(max(p,0.0)) + min(0.0,max(p.x,p.y));

}



static float SDFHyberbola( in float2 p, in float k, in float parameter) // k in (0,inf)
{
    float he = parameter;

    // symmetry and rotation
    p = abs(p);
    p = float2(p.x-p.y,p.x+p.y)/sqrt(2.0);

    // distance to y(x)=k/x by finding t in such that t⁴ - xt³ + kyt - k² = 0
    float x2 = p.x*p.x/16.0;
    float y2 = p.y*p.y/16.0;
    float r = k*(4.0*k - p.x*p.y)/12.0;
    float q = (x2 - y2)*k*k;
    float h = q*q + r*r*r;
    float u;
    if( h<0.0 )
    {
        float m = sqrt(-r);
        u = m*cos( acos(q/(r*m))/3.0 );
    }
    else
    {
        float m = pow(sqrt(h)-q,1.0/3.0);
        u = (m - r/m)/2.0;
    }
    float w = sqrt( u + x2 );
    float b = k*p.y - x2*p.x*2.0;
    float t = p.x/4.0 - w + sqrt( 2.0*x2 - u + b/w/4.0 );

    // comment this line out for an infinite hyperbola
    t = max(t,sqrt(he*he*0.5+k)-he/sqrt(2.0));

    // distance from t
    float d = length( p - float2(t,k/t) );

    // sign
    return p.x*p.y < k ? d : -d;
}


static float SDFHyperbolicCross( in float2 p, float k )
{
    // scale
    float s = 1.0/k - k;
    p = p*s;
    // symmetry
    p = abs(p);
    p = (p.x>p.y) ? p.yx : p.xy;
    // offset
    p += k;
    
    // solve quartic (for details see https://www.shadertoy.com/view/ftcyW8)
    float x2 = p.x*p.x/16.0;
    float y2 = p.y*p.y/16.0;
    float r = (p.x*p.y-4.0)/12.0;
    float q = y2-x2;
    float h = q*q-r*r*r;
    float u;
    if( h<0.0 )
    {
        float m = sqrt(r);
        u = m*cos( acos(q/(r*m) )/3.0 );
    }
    else
    {
        float m = pow(sqrt(h)+q,1.0/3.0);
        u = (m+r/m)/2.0;
    }
    float w = sqrt(u+x2);
    float x = p.x/4.0-w+sqrt(2.0*x2-u+(p.y-x2*p.x*2.0)/w/4.0);
    
    // clamp arm
    x = max(x,k);
    
    // compute distance to closest point
    float d = length( p - float2(x,1.0/x) ) / s;

    // sign
    return p.x*p.y < 1.0 ? -d : d;
}




static float SDFJoint2DSphere( in float2 p, in float l, in float a, float w)
{
    // if perfectly straight
    if( abs(a)<0.001 )
    {
        float v = p.y;
        p.y -= clamp(p.y,0.0,l);
        return float3( length(p), p.x, v );
    }
    
    // parameters
    float2  sc = float2(sin(a),cos(a));
    float ra = 0.5*l/a;
    
    // recenter
    p.x -= ra;
    
    // reflect
    float2 q = p - 2.0*sc*max(0.0,dot(sc,p));

    // distance
    float u = abs(ra)-length(q);
    float d = (q.y<0.0) ? length( q + float2(ra,0.0) ) : abs(u);

    // parametrization (optional)
    float s = sign(a);
    float v = ra*atan2(s*p.y,-s*p.x);
    //if( v<0.0 ) v+=sign(a)*6.283185*ra;
    u = u*s;
    if( v<0.0 )
    {
        if( s*p.x>0.0 ) { v = abs(ra)*6.283185 + v; }
        else { v = p.y; u = q.x + ra; }
    }
    
    return float3(d-w, u, v).x;
}


static float SDFJoint2DFlat( in float2 p, in float l, in float a, float w)
{
    // if perfectly straight
    if( abs(a)<0.001 )
    {
        float v = p.y;
        p.y -= clamp(p.y,0.0,l);
        return float3( length(p), p.x, v );
    }
    
    // parameters
    float2  sc = float2(sin(a),cos(a));
    float ra = 0.5*l/a;
    
    // recenter
    p.x -= ra;
    
    // reflect
    float2 q = p - 2.0*sc*max(0.0,dot(sc,p));

    // distance
    float u = abs(ra)-length(q);
    float d = max(length( float2(q.x+ra-clamp(q.x+ra,-w,w), q.y) )*sign(-q.y),abs(u) - w);
    
    return float(d);
}


#define OPERATIONSUBSTRACT(A,B) max(A,-B);
    

static float3 SDFCircleMinus( in float2 p, in float2 c, in float r ) 
{
    p -= c;
    float l = length(p);
    return float3( l-r, p/l );
}

static float3 SDFBoxMinus( in float2 p, in float2 b )
{
    float2 w = abs(p)-b;
    float2 s = float2(p.x<0.0?-1:1,p.y<0.0?-1:1);
    
    float g = max(w.x,w.y);
    float2  q = max(w,0.0);
    float l = length(q);
    
    return float3(   (g>0.0)?l: g,
                s*((g>0.0)?q/l : ((w.x>w.y)?float2(1,0):float2(0,1))));
}

static float SDFMapMinus( in float2 p )
{
    float2 off = 0.5 * sin(TIME);
    float A = SDFBoxMinus(p, float2(0.3,0.6)).x;
    float B = SDFCircleMinus(p, float2(0.0,0.2)+ off, 0.4).x;

    float d = OPERATIONSUBSTRACT(A,B);
                             
    return d;
}


static float SDFMoon(float2 p, float d, float ra, float rb )
{
    float s = sign(p.y);
    p.y = abs(p.y);

    float a = (ra*ra - rb*rb + d*d)/(2.0*d);
    float b = sqrt(max(ra*ra-a*a,0.0));
    if( d*(p.x*b-p.y*a) > d*d*max(b-p.y,0.0) )
    {
        float2 w = p-float2(a,b); float d = length(w); w.y *= s;
        return float3(d,w/d);
    }

    float2 w1 = p;         ;  
    float l1 = length(w1); float d1 = l1-ra; 
    w1.y *= s;
    float2 w2 = p - float2(d,0);
    float l2 = length(w2); float d2 = rb-l2; 
    w2.y *= s;
    
    return (d1>d2) ? float(d1) : float(d2);
}



static float SDFOOX( in float2 p )
{
    p = (p.x>p.y) ? p.yx : p.xy;
    
    float x2 = p.x*p.x/16.0;
    float y2 = p.y*p.y/16.0;
    float r = (4.0-p.x*p.y)/12.0;
    float q = x2 - y2;
    float h = q*q + r*r*r;
    float u;
    if( h<0.0 )
    {
        float m = sqrt(-r);
        u = m*cos( acos(q/(r*m))/3.0 );
    }
    else
    {
        float m = pow(sqrt(h)-q,1.0/3.0);
        u = (m - r/m)/2.0;
    }
    float w = sqrt( u + x2 );
    float b = p.y - x2*p.x*2.0;
    float t = p.x/4.0 - w + sqrt( 2.0*x2 - u + b/w/4.0 );
    
    float d = length( p - float2(t,1.0/t) );
    
    return p.x*p.y < 1.0 ? d : -d;
}



static float SDFOrientedBox( in float2 p, in float2 a, in float2 b, float th )
{
    float l = length(b-a);
    float2  d = (b-a)/l;
    float2  q = p-(a+b)*0.5;

    float2x2 mat2 = {d.x,-d.y,d.y,d.x}; 
          q = mul(mat2,q);
          q = abs(q) - float2(l*0.5,th);
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0);    
}



static float SDFParabola( in float2 pos, in float k )
{
    float s = sign(pos.x);
    pos.x = abs(pos.x);
    
    float ik = 1.0/k;
    float p = ik*(pos.y - 0.5*ik)/3.0;
    float q = 0.25*ik*ik*pos.x;
    
    float h = q*q - p*p*p;
    float r = sqrt(abs(h));

    float x = (h>0.0) ? 
        // 1 root
    pow(q+r,1.0/3.0) - pow(abs(q-r),1.0/3.0)*sign(r-q) :
        // 3 roots
    2.0*cos(atan2(r,q)/3.0)*sqrt(p);
    
    float z = (pos.x-x<0.0)?-1.0:1.0;
    float2 w = pos-float2(x,k*x*x); float l = length(w); w.x*=s;
    
    return z * float(l);
}


static float SDFParallelogram( in float2 p, float wi, float he, float sk )
{
    float2  e = float2(sk,he);
    float v = 1.0;
    if( p.y<0.0 ) { p=-p;v=-v;}

    // horizontal edge
    float2 w = p - e; w.x -= clamp(w.x,-wi,wi);
    float4 dsg = float4(dot(w,w),v*w,w.y);    

    // vertical edge
    float s = p.x*e.y - p.y*e.x;
    if( s<0.0 ) { p=-p; v=-v; }
    float2  q = p - float2(wi,0); q -= e*clamp(dot(q,e)/dot(e,e),-1.0,1.0);
    float d = dot(q,q);
    s = abs(s) - wi*he;
    dsg = float4( (d<dsg.x) ? float3(d,v*q) : dsg.xyz,
                (s>dsg.w) ?      s      : dsg.w );
     
    // signed distance
    d = sqrt(dsg.x)*sign(dsg.w);
    // and gradient
    return float(d);
}


static float SDFParallelogramRounded( in float2 p, float wi, float he, float sk )
{
    float2  e = float2(sk,he);
    float v = 1.0;
    if( p.y<0.0 ) { p=-p;v=-v;}

    // horizontal edge
    float2 w = p - e; w.x -= clamp(w.x,-wi,wi);
    float4 dsg = float4(dot(w,w),v*w,w.y);    

    // vertical edge
    float s = p.x*e.y - p.y*e.x;
    if( s<0.0 ) { p=-p; v=-v; }
    float2  q = p - float2(wi,0); q -= e*clamp(dot(q,e)/dot(e,e),-1.0,1.0);
    float d = dot(q,q);
    s = abs(s) - wi*he;
    dsg = float4( (d<dsg.x) ? float3(d,v*q) : dsg.xyz,
                (s>dsg.w) ?      s      : dsg.w );
     
    // signed distance
    d = sqrt(dsg.x)*sign(dsg.w);
    // and gradient
    return float(d);
}



static float SDFPie( in float2 p, in float cIn, in float r )
{
    float2 c = float2(sin(cIn), cos(cIn));
    float s = sign(p.x); p.x = abs(p.x);
    
    float l = length(p);
    float n = l - r;
    float2  q = p - c*clamp(dot(p,c),0.0,r);
    float m = length(q)* sign(c.y*p.x-c.x*p.y);
    
    float3  res = (n>m) ? float3(n,p/l) : float3(m,q/m);
    return float(res.x);
}


static float SDFQuad( in float2 p, in float2 v[4] )
{
    float gs = cro(v[0]-v[3],v[1]-v[0]);
    float4 res;
    
    // edge 0
    {
    float2  e = v[1]-v[0];
    float2  w = p-v[0];
    float2  q = w-e*clamp(dot(w,e)/dot(e,e),0.0,1.0);
    float d = dot(q,q);
    float s = gs*cro(w,e);
    res = float4(d,q,s);
    }
    
    // edge 1
    {
    float2  e = v[2]-v[1];
    float2  w = p-v[1];
    float2  q = w-e*clamp(dot(w,e)/dot(e,e),0.0,1.0);
    float d = dot(q,q);
    float s = gs*cro(w,e);
    res = float4( (d<res.x) ? float3(d,q) : res.xyz,
                (s>res.w) ?      s    : res.w );
    }
    
    // edge 2
    {
    float2  e = v[3]-v[2];
    float2  w = p-v[2];
    float2  q = w-e*clamp(dot(w,e)/dot(e,e),0.0,1.0);
    float d = dot(q,q);
    float s = gs*cro(w,e);
    res = float4( (d<res.x) ? float3(d,q) : res.xyz,
                (s>res.w) ?      s    : res.w );
    }

    // edge 3
    {
    float2  e = v[0]-v[3];
    float2  w = p-v[3];
    float2  q = w-e*clamp(dot(w,e)/dot(e,e),0.0,1.0);
    float d = dot(q,q);
    float s = gs*cro(w,e);
    res = float4( (d<res.x) ? float3(d,q) : res.xyz,
                (s>res.w) ?      s    : res.w );
    }    
    
    // distance and sign
    float d = sqrt(res.x)*sign(res.w);
    
    // return float3(d,res.yz/d).x;
    return d;

}


static float SDFQuadParameter( in float2 p, in float2 p0, in float2 p1, in float2 p2, in float2 p3 )
{
    float2 e0 = p1 - p0;
    float2 v0 = p - p0;
    float2 e1 = p2 - p1;
    float2 v1 = p - p1;
    float2 e2 = p3 - p2;
    float2 v2 = p - p2;
    float2 e3 = p0 - p3;
    float2 v3 = p - p3;

    float2 pq0 = v0 - e0*clamp( dot(v0,e0)/dot(e0,e0), 0.0, 1.0 );
    float2 pq1 = v1 - e1*clamp( dot(v1,e1)/dot(e1,e1), 0.0, 1.0 );
    float2 pq2 = v2 - e2*clamp( dot(v2,e2)/dot(e2,e2), 0.0, 1.0 );
    float2 pq3 = v3 - e3*clamp( dot(v3,e3)/dot(e3,e3), 0.0, 1.0 );
    
    float2 ds = min( min( float2( dot( pq0, pq0 ), v0.x*e0.y-v0.y*e0.x ),
                          float2( dot( pq1, pq1 ), v1.x*e1.y-v1.y*e1.x )),
                     min( float2( dot( pq2, pq2 ), v2.x*e2.y-v2.y*e2.x ),
                          float2( dot( pq3, pq3 ), v3.x*e3.y-v3.y*e3.x ) ));

    float d = sqrt(ds.x);

    return (ds.y>0.0) ? -d : d;
}



static float SDFQuadraticCircle( in float2 p )
{
    p = abs(p); if( p.y>p.x ) p=p.yx; // symmetries

    float a = p.x-p.y;
    float b = p.x+p.y;
    float c = (2.0*b-1.0)/3.0;
    float h = a*a + c*c*c;
    float t;
    if( h>=0.0 )
    {   
        h = sqrt(h);
        t = sign(h-a)*pow(abs(h-a),1.0/3.0) - pow(h+a,1.0/3.0);
    }
    else
    {   
        float z = sqrt(-c);
        float v = acos(a/(c*z))/3.0;
        t = -z*(cos(v)+sin(v)*1.732050808);
    }
    t *= 0.5;
    float2 w = float2(-t,t) + 0.75 - t*t - p;
    return length(w) * sign( a*a*0.5+b-1.5 );
}


static float SDFRhombus( in float2 p, float w, float h )
{
    p = abs(p); p.x -= w;
    
    float f = clamp( (p.y-p.x)/(h+w), 0.0, 1.0 );
    
    float2 q = abs(p-f * float2(-w,h));
    
    return max(q.x,q.y)*((h*p.x+w*p.y>0.0)?1.0:-1.0);
}



static float SDFRing( in float2 p, in float t, in float r, in float th )
{

    float2 n = float2(cos(t),sin(t));

    p.x = abs(p.x);
    
    float2x2 mat2 = {n.x,n.y,-n.y,n.x};
    p = mul(mat2,p);

    return max( abs(length(p)-r)-th*0.5,
                length(float2(p.x,max(0.0,abs(r-p.y)-th*0.5)))*sign(p.x) );
}


static float SDFRoundBox2( in float2 p, in float2 b, in float4 r ) 
{
    r.xy = (p.x>0.0)?r.xy : r.zw;
    r.x  = (p.y>0.0)?r.x  : r.y;
    float2 q = abs(p)-b+r.x;
    return min(max(q.x,q.y),0.0) + length(max(q,0.0)) - r.x;
}


static float SDFRoundSquare( in float2 p, in float s, in float r ) 
{
    float2 q = abs(p)-s+r;
    return min(max(q.x,q.y),0.0) + length(max(q,0.0)) - r;
}



static float SDFRoundedX( in float2 p, in float w, in float r )
{
    p = abs(p);
    return length(p-min(p.x+p.y,w)*0.5) - r;
}



static float SDFSegment( in float2 p, in float2 a, in float2 b, in float th )
{
    float2 ba = b-a;
    float2 pa = p-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    float2  q = pa-h*ba;
    return length(q) - th;
}


static float SDFSquircle(float2 p, float n)
{
    // symmetries
    float2 k = sign(p); p = abs(p);
    bool m = p.y>p.x; if( m ) p=p.yx;
   
    const int num = 16; // tesselate into 8x16=128 segments, more denselly at the corners
    float s = 1.0;
    float d = 1e20;
    float2 oq = float2(1.0,0.0);
    float2  g = float2(0.0,0.0);
    for( int i=1; i<=num; i++ )
    {
        float h = (6.283185/8.0)*float(i)/float(num);
        float2  q = pow(float2(cos(h),sin(h)),float2(2.0/n, 2.0/n));
        float2  pa = p-oq;
        float2  ba = q-oq;
        float2  z = pa - ba*clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
        float d2 = dot(z,z);
        if( d2<d )
        {
            d = d2;
            s = pa.x*ba.y - pa.y*ba.x;
            g = z;
        }
        oq = q;
    }
    
    // undo symmetries
    if( m ) g=g.yx; g*=k; 
    
    d = sign(s)*sqrt(d);
    return d;
}


static float SDFSquareStairs( in float2 p, in float s, in float n )
{
    // constant for a given shape
    const float kS2 = sqrt(2.0);
    float w = 2.0*n+1.0;
    
    // pixel dependent computations
    p = float2( abs(p.y+p.x), p.y-p.x ) * (0.5/s);

    float x1 = p.x-w;
    float x2 = abs(p.x-2.0*min(round(p.x/2.0),n))-1.0;
    
    float d1 = dot2( float2(x1, p.y) + clamp(0.5*(-x1-p.y), 0.0, w  ) );
    float d2 = dot2( float2(x2,-p.y) + clamp(0.5*(-x2+p.y), 0.0, 1.0) );

    return sqrt(min(d1,d2)) *
           sign(max(x1-p.y,(x2+p.y)*kS2)) *
           s*kS2;
}

static float SDFStarN(in float2 p, in float r, in int n, in float m) // m=[2,n]
{
    // these 4 lines can be precomputed for a given shape
    float an = 3.141593/float(n);
    float en = 3.141593/m;
    float2  acs = float2(cos(an),sin(an));
    float2  ecs = float2(cos(en),sin(en)); // ecs=vec2(0,1) and simplify, for regular polygon,

    // symmetry (optional)
    p.x = abs(p.x);
    
    // reduce to first sector
    float bn = fmod(atan2(p.x,p.y),2.0*an) - an;
    p = length(p)*float2(cos(bn),abs(sin(bn)));

    // line sdf
    p -= r*acs;
    p += ecs*clamp( -dot(p,ecs), 0.0, r*acs.y/ecs.y);
    return length(p)*sign(p.x);
}



static float SDFStar(in float2 p, in float r, in float rf)
{
    const float2 k1 = float2(0.809016994375, -0.587785252292);
    const float2 k2 = float2(-k1.x,k1.y);

    // repeat domain 5x
    p.x = abs(p.x);
    p -= 2.0*max(dot(k1,p),0.0)*k1;
    p -= 2.0*max(dot(k2,p),0.0)*k2;
    p.x = abs(p.x);
    
    // draw triangle
    p.y -= r;
    float2 ba = rf*float2(-k1.y,k1.x) - float2(0.0 ,1.0);
    float h = clamp( dot(p,ba)/dot(ba,ba), 0.0, r );
    return length(p-ba*h) * sign(p.y*ba.x-p.x*ba.y);
}
