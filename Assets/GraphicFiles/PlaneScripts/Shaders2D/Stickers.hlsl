

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
        TIME = TIME + parameterOne2 + 1.0;
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
        TIME = TIME + parameterOne2 + 2.0;
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

        TIME = TIME + parameterOne2 + 3.0;
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

        TIME = TIME + parameterOne2 + 4.0;
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

        TIME = TIME + parameterOne2 + 5.0;
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

        TIME = TIME + parameterOne2 + 6.0;
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

        TIME = TIME + parameterOne2 + 7.0;
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
        TIME = TIME + parameterOne2 + 8.0;
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

        TIME = TIME + parameterOne2 + 9.0;
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

        TIME = TIME + parameterOne2 + 10.0;
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

        TIME = TIME + parameterOne2 + 11.0;
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

        TIME = TIME + parameterOne2 + 12.0;
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

        TIME = TIME + parameterOne2 + 13.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.5;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/   coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/   coordUV = coordUV * parameterOne2; 
        /**/    
        /**/}
        /**/
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



    if(stickerType == 14.0)
    {

        TIME = TIME + parameterOne2 + 14.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.5;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/   coordUV = coordUV + float2(parameterOne0, parameterOne1);
        // /**/   coordUV = coordUV * parameterOne2; 
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{
        /**/     
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        // /**/    coordUV = coordUV * sin(TIME) * 0.2;
        /**/     
        /**/    
        /**/    parameterOne2 = 0.3 + 0.5 * abs(cos( TIME )) ;
        /**/    
        /**/    parameterOne3 = 0.3*(0.5+0.5*sin(TIME));
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFHexagon(coordUV, parameterOne2) - parameterOne3;

        return outSDF;
    }


    if(stickerType == 15.0)
    {

        TIME = TIME + parameterOne2 + 15.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.5;
        /**/float firstParameter;
        /**/float2 secondParameter;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/   coordUV = coordUV + float2(parameterOne0, parameterOne1);
      ///**/   coordUV = coordUV * parameterOne2; 
        /**/   firstParameter = parameterOne3;
        /**/   secondParameter = float2(parameterTen0, parameterTen1);
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{
        /**/     
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        // /**/    coordUV = coordUV * sin(TIME) * 0.2;
        /**/     
        /**/    parameterOne2 = 0;
        /**/    
        /**/    firstParameter = 3.14* (0.5+0.5*cos(TIME * 0.5));
        /**/    secondParameter = float2(0.750,0.25)*(0.5+0.5*cos(TIME * float2(0.7,1.1) + float2(0.0,3.0)));
        /**/            
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFHorseshoe(coordUV, firstParameter, 0.5, secondParameter.x, secondParameter.y)- parameterOne2;

        return outSDF;
    }


    if(stickerType == 16.0)
    {

        TIME = TIME + parameterOne2 + 16.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 3.0;
        /**/
        /**/
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/    parameterOne0 = 0.8 + 5.0 * smoothstep(-0.2,0.2,sin(0.2));
        /**/    parameterOne1 = sin(parameterOne1);
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{
        /**/     
        /**/    parameterOne0 = 0.8 + 5.0 * smoothstep(-0.2,0.2,sin(0.2));
        /**/
        /**/    parameterOne1 =  (sin(TIME));
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFHyberbola(coordUV, parameterOne1, parameterOne0); 

        return outSDF;
    }



    if(stickerType == 17.0)
    {

        TIME = TIME + parameterOne2 + 17.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/
        /**/coordUV = coordUV * 3.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2; 
        /**/    
        /**/    parameterOne3 = 0.5 + 0.45 * sin(3.14159 * parameterOne3);
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * sin(TIME) * 0.5;
        /**/     
        /**/    parameterOne3 = 0.5 + 0.45 * sin(3.14159 * TIME);
        /**/
        /**/}
        /**/
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFHyperbolicCross(coordUV, parameterOne3);

        return outSDF;
    }


    if(stickerType == 18.0)
    {

        TIME = TIME + parameterOne2 + 18.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 3.0;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        ///**/    coordUV = coordUV * parameterOne2; 
        /**/    if(parameterOne3 > 0)
        /**/    {
        // /**/        parameterOne3 = abs()
        /**/    }
        ///**/    parameterOne3 = 0.5 + 0.45 * sin(3.14159 * parameterOne3);
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * abs(sin(TIME * 0.8)) * 0.5;
        /**/
        /**/    parameterOne2 = 1.0;
        /**/    parameterOne3 = 1.5 * sin(TIME);
        /**/    parameterTen0 = 0.1;
        /**/
        /**/}
        /**/
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFJoint2DSphere(coordUV, parameterOne2, parameterOne3, parameterTen0);

        return outSDF;
    }


    if(stickerType == 19.0)
    {

        TIME = TIME + parameterOne2 + 19.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 3.0;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/  
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * abs(sin(TIME * 0.8)) * 0.5;
        /**/
        /**/    parameterOne2 = 1.0;
        /**/    parameterOne3 = 1.5 * sin(TIME);
        /**/    parameterTen0 = 0.1;
        /**/
        /**/}
        /**/
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFJoint2DFlat(coordUV, parameterOne2, parameterOne3, parameterTen0);

        return outSDF;
    }


    if(stickerType == 20.0)
    {

        TIME = TIME + parameterOne2 + 20.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 3.0;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * 0.2 * parameterOne2;
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * abs(sin(TIME * 0.8)) * 0.5;
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFMapMinus(coordUV);

        return outSDF;
    }



    if(stickerType == 21.0)
    {

        TIME = TIME + parameterOne2 + 21.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 3.0;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * 0.2 * parameterOne2;
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * abs(sin(TIME * 0.8)) * 0.5;
        /**/    parameterOne3 = 1.2*cos(TIME+3.9);
        /**/    parameterTen0 = 0.9;
        /**/    parameterTen1 = 0.7;
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFMoon(coordUV, parameterOne3, parameterTen0, parameterTen1);

        return outSDF;
    }


    if(stickerType == 22.0)
    {

        TIME = TIME + parameterOne2 + 22.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordinate * 3.0;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        // /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        // /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * abs(sin(TIME * 0.8)) ;
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFOOX(coordUV);

        return outSDF;
    }


    if(stickerType == 23.0)
    {

        TIME = TIME + parameterOne2 + 23.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.0;
        /**/float2 firstParameter;
        /**/float2 secondParameter;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        // /**/    coordUV = coordUV * parameterOne2;
        /**/    firstParameter = cos( parameterTen0 * 0.5 + float2(0.0, 1.00) + 0.0 );
        /**/    secondParameter = cos( parameterTen1 * 0.5 + float2(0.0, 3.00) + 1.5 );
        /**/    parameterOne3 = 0.3 * (0.5 + 0.5 * cos(parameterOne3 * 1.1 + 1.0));
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        // /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        // /**/    coordUV = coordUV * abs(sin(TIME * 0.8)) ;
        /**/    // animation
        /**/    firstParameter = cos( TIME * 0.8 + float2(0.0,1.00) + 0.0 );
        /**/    secondParameter = cos( TIME * 0.8 + float2(0.0,3.00) + 1.5 );
        /**/    parameterOne3 = 0.3*(0.5+0.5*cos(TIME*1.1+1.0));
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFOrientedBox(coordUV, firstParameter, secondParameter, parameterOne3);

        return outSDF;
    }


    if(stickerType == 24.0)
    {

        TIME = TIME + parameterOne2 + 24.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.0;
        /**/
        /**/
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/    parameterOne3 =  0.0 + 0.4 * cos(parameterOne3 * 1.1 + 5.5); // x position
        /**/    parameterTen0 = -0.4 + 0.2 * cos(parameterTen0 * 1.2 + 3.0); // y position
        /**/    parameterTen1 =  8.0 + 7.5 * cos(parameterTen1 * 1.3 + 3.5); // width
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        ///**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        ///**/    coordUV = coordUV * abs(sin(TIME * 0.8)) ;
        /**/    float t = TIME/2.0;
        /**/    parameterOne3 =  0.0 + 0.4 * cos(t * 1.1 + 5.5); // x position
        /**/    parameterTen0 = -0.4 + 0.2 * cos(t * 1.2 + 3.0); // y position
        /**/    parameterTen1 =  8.0 + 7.5 * cos(t * 1.3 + 3.5); // width
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFParabola(coordUV - float2(parameterOne3, parameterTen0), parameterTen1);

        return outSDF;
    }


    if(stickerType == 25.0)
    {

        TIME = TIME + parameterOne2 + 25.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.35;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/    parameterOne3 = parameterOne3;
        /**/    parameterTen0 = parameterTen0;
        /**/    parameterTen1 = sin(parameterTen1);
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        // /**/    coordUV = coordUV * abs(sin(TIME * 0.8)) ;
        /**/    parameterOne3 = 0.4;
        /**/    parameterTen0 = 0.6;
        /**/    parameterTen1 = sin(TIME);
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFParallelogram( coordUV, parameterOne3, parameterTen0, parameterTen1);

        return outSDF;
    }


    if(stickerType == 26.0)
    {

        TIME = TIME + parameterOne2 + 26.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.35;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/    parameterOne3 = parameterOne3;
        /**/    parameterTen0 = parameterTen0;
        /**/    parameterTen1 = sin(parameterTen1);
        /**/    parameterTen2 = 0.1 + 0.1*sin(3.1416); 
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        // /**/    coordUV = coordUV * abs(sin(TIME * 0.8)) ;
        /**/    parameterOne3 = 0.4;
        /**/    parameterTen0 = 0.6;
        /**/    parameterTen1 = sin(TIME);
        /**/    parameterTen2 = 0.1 + 0.1*sin(3.1416); 
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        

        float outSDF = SDFParallelogramRounded( coordUV, parameterOne3, parameterTen0, parameterTen1) - parameterTen2;

        return outSDF;
    }


    if(stickerType == 27.0)
    {

        TIME = TIME + parameterOne2 + 27.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 1.35;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/    
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/    parameterOne3 = parameterOne3;
        /**/    parameterTen0 = parameterTen0;
        /**/    
        /**/}
        /**/    
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3)  ;
        /**/    parameterOne3 = 3.14*(0.5+0.5*cos(TIME * 0.52));
        // /**/    parameterTen0 = float2(0.50,0.25)*(0.5+0.5*cos(TIME * float2(1.1,1.3) + float2(0.0,2.0)));
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        
        float outSDF = SDFPie( coordUV, parameterOne3, parameterTen0);

        return outSDF;
    }


    if(stickerType == 28.0)
    {

        TIME = TIME + parameterOne2 + 28.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/float2 v[4]; 
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/    v[0] = float2(-parameterTen0,-parameterTen0); //+ 0.3*cos( 0.7 * parameterTen0 + float2(0.0,1.7) + 2.0 );
        /**/    v[1] = float2( parameterTen1,-parameterTen1); //+ 0.3*cos( 0.9 * parameterTen1 + float2(0.0,1.3) + 1.0 );
        /**/    v[2] = float2( parameterTen2, parameterTen2); //+ 0.3*cos( 1.1 * parameterTen2 + float2(0.0,1.5) + 0.0 ); 
        /**/    v[3] = float2(-parameterTen3, parameterTen3); //+ 0.3*cos( 0.5 * parameterOne3 + float2(0.0,1.9) + 4.0 );
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        // /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        // /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3)  ;
        /**/
        /**/    float time = TIME;
        /**/    v[0] = float2(-0.9,-0.5) + 0.3*cos( 0.5*time + float2(0.0,1.9) + 4.0 );
        /**/    v[1] = float2( 0.9,-0.5) + 0.3*cos( 0.7*time + float2(0.0,1.7) + 2.0 );
        /**/    v[2] = float2( 0.9, 0.5) + 0.3*cos( 0.9*time + float2(0.0,1.3) + 1.0 );
        /**/    v[3] = float2(-0.9, 0.5) + 0.3*cos( 1.1*time + float2(0.0,1.5) + 0.0 );
        /**/        
        /**/    parameterTen3 = 0.1*(0.5+0.5*sin(TIME*1.2));
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFQuad( coordUV, v) - parameterOne3;

        return outSDF;
    }


    if(stickerType == 29.0)
    {

        TIME = TIME + parameterOne2 + 29.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/float2 firstParameter;
        /**/float2 secondParameter;
        /**/float2 thirdParameter;
        /**/float2 forthParameter;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        // /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        // /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/    firstParameter =  float2(parameterOne0 , parameterOne1);  
        /**/    secondParameter =  float2(parameterOne2 , parameterOne3);  
        /**/    thirdParameter =  float2(parameterTen0 , parameterTen1);  
        /**/    forthParameter =  float2(parameterTen2 , parameterTen3);  
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        // /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        // /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3)  ;
        /**/
        /**/    firstParameter = 0.8 * cos( TIME + float2(0.0,2.00) + 1.0 );
        /**/    secondParameter = 0.8 * cos( TIME + float2(0.0,1.50) + 2.5 );
        /**/    thirdParameter = 0.8 * cos( TIME + float2(0.0,3.00) + 4.0 );
        /**/    forthParameter = 0.8 * cos( TIME + float2(1.0,3.00) + 5.0 );
        /**/        
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFQuadParameter( coordUV, firstParameter, secondParameter, thirdParameter, forthParameter);

        return outSDF;
    }


    if(stickerType == 30.0)
    {

        TIME = TIME + parameterOne2 + 30.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3)  ;
        /**/
        /**/        
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFQuadraticCircle(coordUV);

        return outSDF;
    }



    if(stickerType == 31.0)
    {

        TIME = TIME + parameterOne2 + 31.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/    
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3)  ;
        /**/    parameterOne3 = 1.0*abs(cos( 0.11 * TIME + 0.0 ));
        /**/    parameterTen0 = 0.8*abs(cos( 0.13 * TIME + 1.0 ));
        /**/        
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFRhombus(coordUV, parameterOne3, parameterTen0);

        return outSDF;
    }



    if(stickerType == 32.0)
    {

        TIME = TIME + parameterOne2 + 32.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/    parameterOne3 = PI * (0.5 + 0.5 * cos(parameterOne3 * 0.52));
        /**/    parameterTen0 = parameterTen0;
        /**/    parameterTen1 = parameterTen1;
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);
        /**/    parameterOne3 = PI * (0.5 + 0.5 * cos(TIME*0.52));
        /**/    parameterTen0 = 0.5;
        /**/    parameterTen1 = 0.2;
        /**/        
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFRing(coordUV, parameterOne3, parameterTen0, parameterTen1);

        return outSDF;
    }


    if(stickerType == 33.0)
    {

        TIME = TIME + parameterOne2 + 33.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 3.0;
        /**/
        /**/float4 firstParameter;
        /**/float2 secondParameter;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/    firstParameter = 0.3 + 0.3*cos( 2.0*parameterOne3 + float4(0.0,1.0,2.0,3.0) );
        // /**/    secondParameter = float2(0.9,0.6) + 0.3 ;
        /**/    secondParameter = float2(parameterTen0, parameterTen1);
        /**/    firstParameter = min(firstParameter, min(secondParameter.x, secondParameter.y));
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);   
        /**/
        /**/    firstParameter = 0.3 + 0.3*cos( 2.0*TIME + float4(0.0,1.0,2.0,3.0) );
        /**/    secondParameter = float2(0.9,0.6) + 0.3 * cos(TIME + float2(0.0,2.0));
        /**/    firstParameter = min(firstParameter, min(secondParameter.x, secondParameter.y));
        /**/        
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFRoundBox2(coordUV, secondParameter, firstParameter);

        return outSDF;
    }


    if(stickerType == 34.0)
    {

        TIME = TIME + parameterOne2 + 34.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        // /**/    parameterOne3 = parameterOne3;
        /**/    parameterTen0 = parameterOne3 * (0.5 - 0.5*cos(3.1 * parameterOne3 + 4.0));
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);   
        /**/    parameterOne3 = 0.7;
        /**/    parameterTen0 = parameterOne3 * (0.5 - 0.5*cos(3.1 * TIME+4.0));
        /**/    
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFRoundSquare(coordUV, parameterOne3, parameterTen0);

        return outSDF;
    }

    if(stickerType == 35.0)
    {

        TIME = TIME + parameterOne2 + 35.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);   
        /**/    parameterOne3 = 0.5 + 0.3 * cos( TIME + 2.0 );
        /**/    parameterTen0 = 0.1 + 0.08 * sin(TIME * 1.2);
        /**/    
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFRoundedX(coordUV, parameterOne3, parameterTen0);

        return outSDF;
    }

    if(stickerType == 36.0)
    {

        TIME = TIME + parameterOne2 + 36.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 3.0;
        /**/
        /**/float2 firstParameter;
        /**/float2 secondParameter;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/    
        /**/    firstParameter = float2(parameterTen0, parameterTen1);
        /**/    secondParameter = float2(parameterTen2, parameterTen3);
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);
        /**/    parameterOne3 = abs(sin(TIME)) + 0.0;
        /**/    firstParameter = float2(sin(TIME), cos(TIME)) * abs(sin(TIME)) * 2.0 ;
        /**/    secondParameter = float2(-sin(TIME), -cos(TIME)) * abs(sin(TIME)) * 2.0 ;
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFSegment(coordUV, firstParameter, secondParameter, parameterOne3);

        return outSDF;
    }


    if(stickerType == 37.0)
    {

        TIME = TIME + parameterOne2 + 37.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/}
        /**/
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);
        /**/    parameterOne3 = 3.0 + 2.5*sin(6.283185*TIME/3.0);
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFSquircle(coordUV, parameterOne3);

        return outSDF;
    }


    if(stickerType == 37.0)
    {

        TIME = TIME + parameterOne2 + 37.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/}
        /**/
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);
        /**/    parameterOne3 = 3.0 + 2.5*sin(6.283185*TIME/3.0);
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFSquircle(coordUV, parameterOne3);

        return outSDF;
    }



    if(stickerType == 37.0)
    {

        TIME = TIME + parameterOne2 + 37.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/}
        /**/
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);
        /**/    parameterOne3 = 3.0 + 2.5*sin(6.283185*TIME/3.0);
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFSquircle(coordUV, parameterOne3);

        return outSDF;
    }

    if(stickerType == 37.0)
    {

        TIME = TIME + parameterOne2 + 37.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/}
        /**/
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);
        /**/    parameterOne3 = 3.0 + 2.5*sin(6.283185*TIME/3.0);
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFSquircle(coordUV, parameterOne3);

        return outSDF;
    }

    if(stickerType == 37.0)
    {

        TIME = TIME + parameterOne2 + 37.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/}
        /**/
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);
        /**/    parameterOne3 = 3.0 + 2.5*sin(6.283185*TIME/3.0);
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFSquircle(coordUV, parameterOne3);

        return outSDF;
    }


    if(stickerType == 38.0)
    {

        TIME = TIME + parameterOne2 + 38.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/float value = 1.0/8.0;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/    parameterOne3 = floor( abs(parameterOne3));
        /**/
        /**/}
        /**/
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);
        /**/    parameterOne3 = floor( 3.95*(0.5 + 0.5*cos(TIME*3.0)));
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFSquareStairs(coordUV, value, parameterOne3);

        return outSDF;
    }


    if(stickerType == 39.0)
    {

        TIME = TIME + parameterOne2 + 39.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/ 
        /**/    parameterTen0 = 3.0 + fmod(floor(parameterOne3), 9.0);  
        /**/    parameterTen1 = frac(parameterOne3);                 
        /**/    parameterTen2 = 2.0 + parameterTen1 * parameterTen1 * (parameterTen0 - 2.0);        
        /**/
        /**/}
        /**/
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);
        /**/
        /**/    parameterTen0 = 3.0 + fmod(floor(TIME/3.0), 9.0); 
        /**/    parameterTen1 = frac(TIME/3.0);                 
        /**/    parameterTen2 = 2.0 + parameterTen1 * parameterTen1 * (parameterTen0 - 2.0);
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFStarN(coordUV, 0.7 , int(parameterTen0), parameterTen2);

        return outSDF;
    }



    if(stickerType == 40.0)
    {

        TIME = TIME + parameterOne2 + 40.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/}
        /**/
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);
        /**/    parameterOne3 = abs(sin(TIME));
        /**/    parameterTen0 = sin(TIME) * 0.4 + 0.6;
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFStar(coordUV, parameterOne3, parameterTen0);

        return outSDF;
    }


    if(stickerType == 41.0)
    {

        TIME = TIME + parameterOne2 + 41.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/    float2 firstParameter;
        /**/    float2 secondParameter;
        /**/    float2 thirdParameter;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        // /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/    firstParameter = float2(parameterOne2, parameterOne3);
        /**/    secondParameter = float2(parameterTen0, parameterTen1);
        /**/    thirdParameter = float2(parameterTen2, parameterTen3);    
        /**/
        /**/}
        /**/
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) + 0.3);
        /**/    firstParameter = cos(  2.0 * TIME + float2(0.0,2.0) + 0.0 );
        /**/    secondParameter = cos( 2.0 * TIME + float2(0.0,1.5) + 1.5 );
        /**/    thirdParameter = cos(  2.0 * TIME + float2(0.0,3.0) + 4.0 );
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFTriangle2D(coordUV, firstParameter, secondParameter, thirdParameter);

        return outSDF;
    }


    if(stickerType == 42.0)
    {

        TIME = TIME + parameterOne2 + 42.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 4.0;
        /**/
        /**/    float2 firstParameter;
        /**/    float2 secondParameter;
        /**/    float2 thirdParameter;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        // /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/    firstParameter = float2(parameterOne2, parameterOne3);
        /**/    secondParameter = float2(parameterTen0, parameterTen1);
        /**/    thirdParameter = float2(parameterTen2, parameterTen3);    
        /**/
        /**/}
        /**/
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) );
        /**/    firstParameter = cos(  2.0 * TIME + float2(0.0,1.0) + 0.0 );
        /**/    secondParameter = cos( 2.0 * TIME + float2(0.0,1.5) + 1.5 );
        /**/    thirdParameter = cos(  2.0 * TIME + float2(0.0,3.0) + 2.4 );
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        // The UV coordinates are not used as center. but instead as parameter of the Triangle.
        float outSDF = SDFTriangleForm(coordUV, firstParameter, secondParameter, thirdParameter);

        return outSDF;
    }



    if(stickerType == 43.0)
    {

        TIME = TIME + parameterOne2 + 43.0;
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/    float2 firstParameter;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/    firstParameter = float2(parameterOne3, parameterTen0);
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) );
        /**/    firstParameter = float2(0.5,-0.5) + float2(0.3,-0.3)*cos( TIME + float2(0.0,1.57) );
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFTriangleIsosceles(coordUV, firstParameter);

        return outSDF;
    }


    if(stickerType == 44.0)
    {

        TIME = TIME + parameterOne2 + 44.0;

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/float2 firstParameter[3];
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        // /**/    coordUV = coordUV + float2(0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne1;
        /**/
        /**/    float2 v[3] = {
        /**/    float2(parameterOne2, parameterOne3),
        /**/    float2(parameterTen0, parameterTen1),
        /**/    float2(parameterTen2, parameterTen3)};
        /**/
        /**/    firstParameter = v;
        /**/    
        /**/    
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.8)) );
        /**/    float2 v[3] = {
        /**/    float2(-0.8,-0.3) + 0.5*cos( 0.5 * TIME + float2(0.0,1.9) + 4.0 ),
        /**/    float2( 0.8,-0.3) + 0.5*cos( 0.7 * TIME + float2(0.0,1.7) + 2.0 ),
        /**/    float2( 0.0, 0.3) + 0.5*cos( 0.9 * TIME + float2(0.0,1.3) + 1.0 ) };
        /**/    firstParameter = v;
        /**/    parameterOne0 = 0.1*(0.5+0.5*sin(TIME*1.2));
        /**/        
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////

        float outSDF = SDFTriangleRounded(coordUV, firstParameter) - parameterOne0;
        
        return outSDF;
    }


    if(stickerType == 45.0)
    {

        TIME = TIME + parameterOne2 + 45.0;

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.2)) );
        /**/    parameterOne3 = 0.2 + 0.15 * sin(TIME*1.3+0.0);
        /**/    parameterTen0 = 0.2 + 0.15 * sin(TIME*1.4+1.1);
        /**/    parameterTen1 = 0.5 + 0.2 * sin(1.3*TIME);
        /**/        
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////



        float outSDF = SDFTrapezoid(coordUV, parameterOne3, parameterTen0, parameterTen1);
        
        return outSDF;
    }


    if(stickerType == 46.0)
    {

        TIME = TIME + parameterOne2 + 46.0;

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/float2 firstParameter;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterOne2;
        /**/    firstParameter = float2(parameterOne3, parameterTen0);
        /**/
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.2)) );
        /**/    firstParameter = 0.4 + 0.4*sin(TIME * float2(1.1,1.2) + float2(3.0,1.0));
        /**/        
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////



        float outSDF = SDFTunnel(coordUV, firstParameter);
        
        return outSDF;
    }


    if(stickerType == 47.0)
    {

        TIME = TIME + parameterOne2 + 47.0;

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterTen2;
        // /**/    parameterOne3 = 0.5;//0.5*cos(1.0);
        // /**/    parameterTen1 = 0.5;//0.2*sin(1.0); 
        /**/    
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.2)) );
        /**/    parameterOne3 = 0.5*cos(TIME+12.0);
        /**/    parameterTen1 = 0.2*sin(TIME*1.4); 
        /**/
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////


        float outSDF = SDFVesica(coordUV, parameterTen0, parameterOne3) + parameterTen1; 
        
        return outSDF;

    }



    if(stickerType == 48.0)
    {

        TIME = TIME + parameterOne2 + 48.0;

        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        /**/
        /**/coordUV = coordUV * 2.0;
        /**/
        /**/float2 firstParameter;
        /**/float2 secondParameter;
        /**/
        /**/if(motionState == 0.0)
        /**/{
        /**/
        // /**/    coordUV = coordUV + float2(parameterOne0, parameterOne1);
        /**/    coordUV = coordUV * parameterTen3;
        /**/    firstParameter = float2(parameterOne0, parameterOne1);
        /**/    secondParameter = float2(parameterOne2, parameterOne3);
        /**/    
        /**/}
        /**/if(motionState == 1.0)
        /**/{   
        /**/        
        /**/    coordUV = coordUV + float2(cos(TIME), sin(TIME));
        /**/    coordUV = coordUV * (abs(sin(TIME * 0.2)) );
        /**/
        /**/    firstParameter = cos( TIME * 0.5 + float2(0.0,1.00) + 0.0 );
        /**/    secondParameter = cos( TIME * 0.5 + float2(0.0,3.00) + 1.5 );
        /**/    parameterTen0 = 0.40 * (0.5 + 0.495 * cos(TIME * 1.1+2.0));
        /**/    parameterTen1 = 0.15 * (0.5 + 0.495 * cos(TIME * 1.3+1.0));
        /**/    float2 value = smoothstep( -0.5, 0.5, sin(TIME + 0.1));
        /**/    parameterTen1 *= 1.0 - value;
        /**/}
        /**/
        ////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////


        float outSDF = SDFVesicaSegment(coordUV, firstParameter, secondParameter, parameterTen0) - parameterTen1;
        
        return outSDF;
    }

    

    return signFunctionNULL;

}

// float3 sdfArc( in float2 p, in float2 sca, in float2 scb, in float ra, in float rb )
// {
//     return float3(1.0, 1.0, 1.0);
// }







