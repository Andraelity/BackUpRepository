using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using ShaderInfoNamespace;


namespace MainStickerState
{

	static public class MainStickerStateClass 
	{

	 //  	static public float StickerType = 1f;
	 //     static public Color BorderColor;
	 //  	static public float BorderSizeOne = 1f;// public float BorderSizeOne = 0.005f;//
	 //  	static public float BorderSizeTwo = 1f;// public float BorderSizeTwo = 0.005f;//
	 //  	static public float BorderBlurriness = 1f;
	 // 	static public float RangeSTen_Ten0 = 1f;
	 // 	static public float RangeSTen_Ten1 = 1f;
	 // 	static public float RangeSTen_Ten2 = 1f;
	 // 	static public float RangeSTen_Ten3 = 1f;
	 // 	static public float RangeSOne_One0 = 1f;
	 // 	static public float RangeSOne_One1 = 1f;
	 // 	static public float RangeSOne_One2 = 1f;
	 // 	static public float RangeSOne_One3 = 1f;
		
	 	static public void SetStickerState(ref ShaderInfo information)
	 	{

	 		if(information.StickerType == 1)
	 		{
	 			StickerType01(ref information);
	 		}

			if(information.StickerType == 2)
	 		{
	 			StickerType02(ref information);
	 		}

			if(information.StickerType == 3)
	 		{
	 			StickerType03(ref information);
	 		}

			if(information.StickerType == 4)
	 		{
	 			StickerType04(ref information);
	 		}

			if(information.StickerType == 5)
	 		{
	 			StickerType05(ref information);
	 		}

			if(information.StickerType == 6)
	 		{
	 			StickerType06(ref information);
	 		}

			if(information.StickerType == 7)
	 		{
	 			StickerType07(ref information);
	 		}
			
			if(information.StickerType == 8)
	 		{
	 			StickerType08(ref information);
	 		}
	 		
			if(information.StickerType == 9)
	 		{
	 			StickerType09(ref information);
	 		}	 		
		
			if(information.StickerType == 10)
	 		{
	 			StickerType10(ref information);
	 		}	 		

			if(information.StickerType == 11)
	 		{
	 			StickerType11(ref information);
	 		}	 		

			if(information.StickerType == 12)
	 		{
	 			StickerType12(ref information);
	 		}

			if(information.StickerType == 13)
	 		{
	 			StickerType13(ref information);
	 		}
	 	}

	 	static public void StickerType01(ref ShaderInfo information)
	 	{
	 		string name = "Arc";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 1f;
			information.RangeSOne_One1 = 0.11f;
			information.RangeSOne_One2 = 1f;
			information.RangeSOne_One3 = 1f;
			information.RangeSTen_Ten0 = 7f;
			information.RangeSTen_Ten1 = 3.1f;
			information.RangeSTen_Ten2 = 1f;
			information.RangeSTen_Ten3 = 1f;

	 	}


	 	static public void StickerType02(ref ShaderInfo information)
	 	{
	 		string name = "Arrow";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0f;
			information.RangeSOne_One1 = 0f;
			information.RangeSOne_One2 = 0f;
			information.RangeSOne_One3 = 0f;
			information.RangeSTen_Ten0 = 0f;
			information.RangeSTen_Ten1 = 0f;
			information.RangeSTen_Ten2 = 0f;
			information.RangeSTen_Ten3 = 0f;

	 	}

	 	static public void StickerType03(ref ShaderInfo information)
	 	{
	 		string name = "BloobyCross";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.83f;
			information.RangeSOne_One1 = 0.33f;
			information.RangeSOne_One2 = 1f;
			information.RangeSOne_One3 = 1f;
			information.RangeSTen_Ten0 = 1f;
			information.RangeSTen_Ten1 = 1f;
			information.RangeSTen_Ten2 = 1f;
			information.RangeSTen_Ten3 = 1f;

	 	}
		

		static public void StickerType04(ref ShaderInfo information)
	 	{
	 		string name = "BoxRounded";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.83f;
			information.RangeSOne_One1 = 0.33f;
			information.RangeSOne_One2 = 0.3f;
			information.RangeSOne_One3 = 1f;
			information.RangeSTen_Ten0 = 1f;
			information.RangeSTen_Ten1 = 1f;
			information.RangeSTen_Ten2 = 1f;
			information.RangeSTen_Ten3 = 1f;

	 	}


		static public void StickerType05(ref ShaderInfo information)
	 	{
	 		string name = "CapsuleUneven";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = -0.19f;
			information.RangeSOne_One1 = -0.96f;
			information.RangeSOne_One2 = 0.22f;
			information.RangeSOne_One3 = 0.3f;
			information.RangeSTen_Ten0 = 0.3f;
			information.RangeSTen_Ten1 = 0.46f;
			information.RangeSTen_Ten2 = 1f;
			information.RangeSTen_Ten3 = 1f;

	 	}

		static public void StickerType06(ref ShaderInfo information)
	 	{
	 		string name = "CircleCross";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 1.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.0f;
			information.RangeSOne_One3 = 1.0f;
			information.RangeSTen_Ten0 = 1.0f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}

		static public void StickerType07(ref ShaderInfo information)
	 	{
	 		string name = "Cross";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 1.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.0f;
			information.RangeSOne_One3 = 1.0f;
			information.RangeSTen_Ten0 = 1.0f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}
		
		static public void StickerType08(ref ShaderInfo information)
	 	{
	 		string name = "CutDisk";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 1.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.0f;
			information.RangeSOne_One3 = 1.0f;
			information.RangeSTen_Ten0 = 1.0f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}
		
		static public void StickerType09(ref ShaderInfo information)
	 	{
	 		string name = "DollarSign";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 1.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.0f;
			information.RangeSOne_One3 = 1.0f;
			information.RangeSTen_Ten0 = 1.0f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}


		static public void StickerType10(ref ShaderInfo information)
	 	{
	 		string name = "Egg";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 1.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.0f;
			information.RangeSOne_One3 = 1.0f;
			information.RangeSTen_Ten0 = 1.0f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}


		static public void StickerType11(ref ShaderInfo information)
	 	{
	 		string name = "EllipseHorizontal";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 1.0f;
			information.RangeSOne_One1 = 0.5f;
			information.RangeSOne_One2 = 1.0f;
			information.RangeSOne_One3 = 1.0f;
			information.RangeSTen_Ten0 = 1.0f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}


		static public void StickerType12(ref ShaderInfo information)
	 	{
	 		string name = "Gradient2D";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 1.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.0f;
			information.RangeSOne_One3 = 1.0f;
			information.RangeSTen_Ten0 = 1.0f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}


		static public void StickerType13(ref ShaderInfo information)
	 	{
	 		string name = "Heart";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 1.0f;
			information.RangeSOne_One1 = 1.0f;
			information.RangeSOne_One2 = 1.0f;
			information.RangeSOne_One3 = 1.0f;
			information.RangeSTen_Ten0 = 1.0f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}

	}
   
}
