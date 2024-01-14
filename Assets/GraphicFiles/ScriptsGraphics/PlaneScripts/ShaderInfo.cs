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
			StickerNameStringArray = new string[]{
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
				"Heart"
			};

		}

		public static string[] GetStickerNameStringArray()
		{
			return StickerNameStringArray;
		}



	}

}
