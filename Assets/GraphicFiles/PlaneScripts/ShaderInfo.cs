using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace ShaderInfoNamespace
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

}




namespace StickerName
{
	public static class StickerNameClass
	{

		public static string[] StickerNameStringArray;

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

		public static void SetShaderPathStringArray()
		{

			StickerNameStringArray = new string[]
			{
				"Shaders2D/BallOfFire",
				"Shader2D/BookShelf",
				"Shader2D/BubblingPuls",
				"Shader2D/Waves",
				"Shader2D/PlasmaFlower",
				"Shader2D/PlaneShaderWork",
				"Shader2D/MandelFire",
				"Shader2D/FireAndWater",
				"Shader2D/Noise2D",
				"Shader2D/PlanetSpace",
				"Shader2D/Star",
				"Shader2D/CirclesDisco",
				"Shader2D/PaintTexture",
				"Shader2D/FractalPyramid",
				"Shader2D/Bubble",
				"Shader2D/StarFractal",
				"Shader2D/WetNeural",
				"Shader2D/PulsatingPink",
				"Shader2D/LaserBeam",
				"Shader2D/Clouds",
				"Shader2D/GlowingMarbling"

			};

		}


		public static string[] GetStickerNameStringArray()
		{
			return StickerNameStringArray;
		}



	}

}
