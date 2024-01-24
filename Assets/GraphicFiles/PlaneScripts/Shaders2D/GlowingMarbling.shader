Shader "Shaders2D/GlowingMarbling"
{
    Properties
    {

        _ColorOperation ("ColorForSomething", Color) = (1.0, 1.0, 1.0, 1.0)

        _TextureSprite ("_TextureSprite", 2D)     = "green" {}
        _TextureChannel0 ("_TextureChannel0", 2D) = "green" {}
        _TextureChannel1 ("_TextureChannel1", 2D) = "green" {}
        _TextureChannel2 ("_TextureChannel2", 2D) = "green" {}
        _TextureChannel3 ("_TextureChannel3", 2D) = "green" {}


        _OverlaySelection("_OverlaySelection", Range(0.0, 1.0)) = 1.0

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

        _InVariableTickY(" _InVariableTickY", Float) = 1.0
        _InVariableRatioX("_InVariableRatioX", Float) = 1.0
        _InVariableRatioY("_InVariableRatioY", Float) = 1.0
        _OutlineColor("_OutlineColor", Color) = (1.0, 1.0, 1.0, 1.0)
        _OutlineSprite("_OutlineSprite", Float) = 1.0


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


            sampler2D _TextureSprite;
            sampler2D _TextureChannel0;
            sampler2D _TextureChannel1;
            sampler2D _TextureChannel2;
            sampler2D _TextureChannel3;
            
            float _OverlaySelection;

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

            float _InVariableTick;
            float _InVariableRatioX;
            float _InVariableRatioY;
            float4 _OutlineColor;
            float _OutlineSprite;

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


            #define Number _FloatNumber
            #define NumberOne _FloatVariable

            #include "SDfs.hlsl"
            #include "Stickers.hlsl"
            #include "Sprites.hlsl"



            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////


            //////////////////////////////////////////////////////////////////////////////////////////////
            /// DEFAULT
            //////////////////////////////////////////////////////////////////////////////////////////////


            fixed4 FRAGMENTSHADER (pixelPoints PIXELSPACE) : SV_Target
            {
                float2 coordinateSprite = PIXELSPACE.uv2;

                float2 coordinate = PIXELSPACE.uv;
                
                float2 coordinateScale = (PIXELSPACE.uv - 0.5) * 2.0 ;
                
                float2 coordinateShade = coordinateScale/(float2(2.0, 2.0));
                
                float2 coordinateFull = ceil(coordinateShade);

                float3 colBase  = 0.0;  

                float3 colTexture = float3(coordinateScale.x + coordinateScale.y, coordinateScale.y - coordinateScale.x, pow(coordinate.x,2.0f));


			//////////////////////////////////////////////////////////////////////////////////////////////
			///	DEFAULT
			//////////////////////////////////////////////////////////////////////////////////////////////

	                colBase = 0.0;

            //////////////////////////////////////////////////////////////////////////////////////////////
                
 


				float2 uv = coordinateScale * 2.0;


    			for(float i = 1.0; i < 10.0; i++){
    			    uv.x += 0.6 / i * cos(i * 2.5* uv.y  + TIME);
    			    uv.y += 0.6 / i * cos(i * 1.5 * uv.x + TIME);
    			}
    			
    			float4 fragColor = float4(float3(0.1, 0.1, 0.1)/abs(sin(TIME-uv.y-uv.x)),1.0);
                                       

///////////////////////////////////////↓↓↓↓↓↓↓↓↓// THIS IS THE LAST STEP ON THE PROCESS
///////////////////////////////////////↓↓↓↓↓↓↓↓↓// THIS IS THE LAST STEP ON THE PROCESS
                float4 colBackground = fragColor;

                bool StickerSprite = (_OverlaySelection == 0)?true:false;
                if(StickerSprite)
                {

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

                }
                else
                {

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LINES OF CODE FOR THE SPRITES ///////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    float4 colorOutputTotal = PaintSprite(coordinateSprite, colBackground, _TextureSprite, _OutlineColor,
                                                            _InVariableTick, _InVariableRatioX, _InVariableRatioY, _OutlineSprite);

                    return colorOutputTotal;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LINES OF CODE FOR THE SPRITES ///////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                }



                // float radio = 0.5;
                // float2 point = float2(0.0, 0.0);
				// float lenghtRadio = length(uv - point);
                // if (lenghtRadio < radio)
                // {
                //     return float4(1.0, 1.0, 1.0, 1.0) ;
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

























