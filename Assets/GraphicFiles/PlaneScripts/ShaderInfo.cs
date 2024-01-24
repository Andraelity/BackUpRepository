using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace ShaderInfo_Namespace
{

	public struct ShaderInfo
	{
		public float StickerType;
		public float MotionState;

		public Color BorderColor;
		public float BorderSizeOne;
		public float BorderSizeTwo;
		public float BorderBlurriness;
	
		public float RangeSTen_Ten0;
		public float RangeSTen_Ten1;
		public float RangeSTen_Ten2;
		public float RangeSTen_Ten3;
	
		public float RangeSOne_One0;
		public float RangeSOne_One1;
		public float RangeSOne_One2;
		public float RangeSOne_One3;
	}

	public struct ShaderInfoSprite
	{
    	public float InVariableTick;
    	public float InVariableRatioX;
    	public float InVariableRatioY;
    	public float OutlineSprite;
		public Color OutlineColor;
	}

}




namespace StickerName_Namespace
{
	public static class StickerNameClass
	{

		public static string[] StickerNameStringArray;
		public static string[] ShaderPathNameStringArray;



		public static void SetStickerNameStringArray()
		{
			StickerNameStringArray = new string[]
			{
				"Arc",
				"Arrow", 
				"BlobbyCross",
				"BoxRounded",
				"CapsuleUneven",
				"CircleCross",
				"Cross",
				"CutDisk",
				"DollarSign",
				"Egg",
				"EllipseHorizontal",
				"Gradient2D",
				"Heart",
				"Hexagon",
				"Horseshoe",
				"Hyperbola",
				"Joint2DSphere",
				"Joint2DFlat",
				"MinusShape",
				"Moon",
				"OrientedBox",
				"Parabola",
				"Parallelogram",
				"ParallelogramRounded",
				"Pie",
				"QuadParameter",
				"QuadraticCircle",
				"Rhombus",
				"Ring",
				"RoundedBox",
				"RoundedX",
				"Segment",
				"Squircle",
				"Stairs",
				"StarN",
				"Star",
				"Triangle2D",
				"TriangleForm",
				"TriangleIsosceles",
				"TriangleRounded",
				"Trapezoid",
				"Tunnel",
				"Vesica",
				"VessicaSegment",

			};

		}


		public static string[] GetStickerNameStringArray()
		{
			return StickerNameStringArray;
		}


		public static void SetShaderPathNameStringArray()
		{

			ShaderPathNameStringArray = new string[]
			{
				"Shaders2D/BallOfFire",
				"Shaders2D/BookShelf",
				"Shaders2D/BubblingPuls",
				"Shaders2D/Waves",
				"Shaders2D/PlasmaFlower",
				"Shaders2D/PlaneShaderWork",
				"Shaders2D/MandelFire",
				"Shaders2D/FireAndWater",
				"Shaders2D/Noise2D",
				"Shaders2D/PlanetSpace",
				"Shaders2D/Star",
				"Shaders2D/CirclesDisco",
				"Shaders2D/PaintTexture",
				"Shaders2D/FractalPyramid",
				"Shaders2D/Bubble",
				"Shaders2D/StarFractal",
				"Shaders2D/WetNeural",
				"Shaders2D/PulsatingPink",
				"Shaders2D/LaserBeam",
				"Shaders2D/Clouds",
				"Shaders2D/GlowingMarbling",
				"Shaders2D/PortalGreen",
				"Shaders2D/SimplicityGalaxy",
				"Shaders2D/DigitalBrain",
				"Shaders2D/SpiralRainbow",
				"Shaders2D/FurSphere",
				"Shaders2D/GlowingBlobs",
				"Shaders2D/XBall",
				"Shaders2D/WarpSpeed",
				"Shaders2D/70SPaint"
			};

		}

		public static string[] GetShaderPathNameStringArray()
		{
			return ShaderPathNameStringArray;
		}

	}

}
namespace ShaderName_Enum_Namespace
{
	public enum ShaderName_Enum 
	{
		BallOfFire,
		BookShelf,
		BubblingPuls,
		Waves,
		PlasmaFlower,
		PlaneShaderWork,
		MandelFire,
		FireAndWater,
		Noise2D,
		PlanetSpace,
		Star,
		CirclesDisco,
		PaintTexture,
		FractalPyramid,
		Bubble,
		StarFractal,
		WetNeural,
		PulsatingPink,
		LaserBeam,
		Clouds,
		GlowingMarbling,
		PortalGreen,
		SimplicityGalaxy,
		DigitalBrain,
		SpiralRainbow,
		FurSphere,
		GlowingBlobs,
		XBall,
		WarpSpeed
	};


}