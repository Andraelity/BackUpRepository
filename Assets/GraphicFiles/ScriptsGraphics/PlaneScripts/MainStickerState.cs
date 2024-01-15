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
	 	
			if(information.StickerType == 14)
	 		{
	 			StickerType14(ref information);
	 		}

			if(information.StickerType == 15)
	 		{
	 			StickerType15(ref information);
	 		}

			if(information.StickerType == 16)
	 		{
	 			StickerType16(ref information);
	 		}

			if(information.StickerType == 17)
	 		{
	 			StickerType17(ref information);
	 		}

			if(information.StickerType == 18)
	 		{
	 			StickerType18(ref information);
	 		}

			if(information.StickerType == 19)
	 		{
	 			StickerType19(ref information);
	 		}

			if(information.StickerType == 20)
	 		{
	 			StickerType20(ref information);
	 		}
	 	
			if(information.StickerType == 21)
	 		{
	 			StickerType21(ref information);
	 		}

			if(information.StickerType == 22)
	 		{
	 			StickerType22(ref information);
	 		}

			if(information.StickerType == 23)
	 		{
	 			StickerType23(ref information);
	 		}

			if(information.StickerType == 24)
	 		{
	 			StickerType24(ref information);
	 		}

			if(information.StickerType == 25)
	 		{
	 			StickerType25(ref information);
	 		}

			if(information.StickerType == 26)
	 		{
	 			StickerType26(ref information);
	 		}

			if(information.StickerType == 27)
	 		{
	 			StickerType27(ref information);
	 		}

			if(information.StickerType == 28)
	 		{
	 			StickerType28(ref information);
	 		}

			if(information.StickerType == 29)
	 		{
	 			StickerType29(ref information);
	 		}

			if(information.StickerType == 30)
	 		{
	 			StickerType30(ref information);
	 		}

			if(information.StickerType == 31)
	 		{
	 			StickerType31(ref information);
	 		}

			if(information.StickerType == 32)
	 		{
	 			StickerType32(ref information);
	 		}

			if(information.StickerType == 33)
	 		{
	 			StickerType33(ref information);
	 		}

			if(information.StickerType == 34)
	 		{
	 			StickerType34(ref information);
	 		}

			if(information.StickerType == 35)
	 		{
	 			StickerType35(ref information);
	 		}

			if(information.StickerType == 36)
	 		{
	 			StickerType36(ref information);
	 		}

			if(information.StickerType == 37)
	 		{
	 			StickerType37(ref information);
	 		}

			if(information.StickerType == 38)
	 		{
	 			StickerType38(ref information);
	 		}

			if(information.StickerType == 39)
	 		{
	 			StickerType39(ref information);
	 		}

			if(information.StickerType == 40)
	 		{
	 			StickerType39(ref information);
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


		static public void StickerType14(ref ShaderInfo information)
	 	{
	 		string name = "Hexagon";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 0.71f;
			information.RangeSOne_One3 = 0.31f;
			information.RangeSTen_Ten0 = 1.0f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}


		static public void StickerType15(ref ShaderInfo information)
	 	{
	 		string name = "Horseshoe";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = -0.75f;
			information.RangeSOne_One3 = 1.3f;
			information.RangeSTen_Ten0 = 1.75f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}

		static public void StickerType16(ref ShaderInfo information)
	 	{
	 		string name = "Hyperbola";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = -1.11f;
			information.RangeSOne_One2 = 1.0f;
			information.RangeSOne_One3 = 1.0f;
			information.RangeSTen_Ten0 = 1.0f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}

	 	static public void StickerType17(ref ShaderInfo information)
	 	{
	 		string name = "Hyperbola";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = -0.75f;
			information.RangeSOne_One3 = 2.0f;
			information.RangeSTen_Ten0 = 1.0f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}

	 	static public void StickerType18(ref ShaderInfo information)
	 	{
	 		string name = "Joint2DSphere";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 2.0f;
			information.RangeSOne_One3 = 0.35f;
			information.RangeSTen_Ten0 = 0.2f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}


	 	static public void StickerType19(ref ShaderInfo information)
	 	{
	 		string name = "Joint2DFlat";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 2.0f;
			information.RangeSOne_One3 = 0.35f;
			information.RangeSTen_Ten0 = 0.2f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}

	 	static public void StickerType20(ref ShaderInfo information)
	 	{
	 		string name = "MinusShape";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 2.0f;
			information.RangeSOne_One3 = 0.35f;
			information.RangeSTen_Ten0 = 0.2f;
			information.RangeSTen_Ten1 = 1.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}

	 	static public void StickerType21(ref ShaderInfo information)
	 	{
	 		string name = "Moon";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.24f;
			information.RangeSOne_One3 = 0.2f;
			information.RangeSTen_Ten0 = 0.61f;
			information.RangeSTen_Ten1 = 0.27f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}


	 	static public void StickerType22(ref ShaderInfo information)
	 	{
	 		string name = "OOX";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.11f;
			information.RangeSOne_One3 = 0.0f;
			information.RangeSTen_Ten0 = 0.0f;
			information.RangeSTen_Ten1 = 0.0f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}

	 	static public void StickerType23(ref ShaderInfo information)
	 	{
	 		string name = "OrientedBox";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.24f;
			information.RangeSOne_One3 = 0.2f;
			information.RangeSTen_Ten0 = 0.61f;
			information.RangeSTen_Ten1 = 0.27f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}


	 	static public void StickerType24(ref ShaderInfo information)
	 	{
	 		string name = "Parabola";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.24f;
			information.RangeSOne_One3 = 0.2f;
			information.RangeSTen_Ten0 = 0.61f;
			information.RangeSTen_Ten1 = 0.27f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}


	 	static public void StickerType25(ref ShaderInfo information)
	 	{
	 		string name = "Parallelogram";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.24f;
			information.RangeSOne_One3 = 0.2f;
			information.RangeSTen_Ten0 = 0.61f;
			information.RangeSTen_Ten1 = 0.27f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}

	 	static public void StickerType26(ref ShaderInfo information)
	 	{
	 		string name = "ParallelogramRounded";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.24f;
			information.RangeSOne_One3 = 0.2f;
			information.RangeSTen_Ten0 = 0.61f;
			information.RangeSTen_Ten1 = 0.27f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}


	 	static public void StickerType27(ref ShaderInfo information)
	 	{
	 		string name = "Pie";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 0.72f;
			information.RangeSOne_One3 = 2.3f;
			information.RangeSTen_Ten0 = 0.81f;
			information.RangeSTen_Ten1 = 0.93f;
			information.RangeSTen_Ten2 = 1.0f;
			information.RangeSTen_Ten3 = 1.0f;

	 	}


	 	static public void StickerType28(ref ShaderInfo information)
	 	{
	 		string name = "Quad";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.27f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 0.79f;
			information.RangeSOne_One3 = 0.41f;
			information.RangeSTen_Ten0 = -0.95f;
			information.RangeSTen_Ten1 = 0.86f;
			information.RangeSTen_Ten2 = -0.68f;
			information.RangeSTen_Ten3 = 0.6f;

	 	}


	 	static public void StickerType29(ref ShaderInfo information)
	 	{
	 		string name = "QuadParameter";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.06f;
			information.RangeSOne_One1 = 0.09f;
			information.RangeSOne_One2 = -0.12f;
			information.RangeSOne_One3 = -0.96f;
			information.RangeSTen_Ten0 = -1.54f;
			information.RangeSTen_Ten1 = -0.74f;
			information.RangeSTen_Ten2 = -1.15f;
			information.RangeSTen_Ten3 = 0.39f;
	 	}


	 	static public void StickerType30(ref ShaderInfo information)
	 	{
	 		string name = "QuadraticCircle";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.06f;
			information.RangeSOne_One1 = 0.09f;
			information.RangeSOne_One2 = -0.12f;
			information.RangeSOne_One3 = -0.96f;
			information.RangeSTen_Ten0 = -1.54f;
			information.RangeSTen_Ten1 = -0.74f;
			information.RangeSTen_Ten2 = -1.15f;
			information.RangeSTen_Ten3 = 0.39f;
	 	}


	 	static public void StickerType31(ref ShaderInfo information)
	 	{
	 		string name = "Rhombus";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = -0.66f;
			information.RangeSOne_One1 = -0.47f;
			information.RangeSOne_One2 = 0.56f;
			information.RangeSOne_One3 = 0.53f;
			information.RangeSTen_Ten0 = 0.35f;
			information.RangeSTen_Ten1 = 0.0f;
			information.RangeSTen_Ten2 = -1.15f;
			information.RangeSTen_Ten3 = 0.39f;
	 	}


	 	static public void StickerType32(ref ShaderInfo information)
	 	{
	 		string name = "Ring";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 0.5f;
			information.RangeSOne_One3 = -1.45f;
			information.RangeSTen_Ten0 = 0.5f;
			information.RangeSTen_Ten1 = 0.2f;
			information.RangeSTen_Ten2 = -1.15f;
			information.RangeSTen_Ten3 = 0.39f;
	 	}


	 	static public void StickerType33(ref ShaderInfo information)
	 	{
	 		string name = "RoundedBox";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.06f;
			information.RangeSOne_One1 = 0.09f;
			information.RangeSOne_One2 = -0.95f;
			information.RangeSOne_One3 = -0.96f;
			information.RangeSTen_Ten0 = 1.5f;
			information.RangeSTen_Ten1 = 0.3f;
			information.RangeSTen_Ten2 = -1.15f;
			information.RangeSTen_Ten3 = 0.39f;
	 	}


	 	static public void StickerType34(ref ShaderInfo information)
	 	{
	 		string name = "RoundedSquare";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.0f;
			information.RangeSOne_One1 = 0.0f;
			information.RangeSOne_One2 = 1.4f;
			information.RangeSOne_One3 = 1.0f;
			information.RangeSTen_Ten0 = 1.5f;
			information.RangeSTen_Ten1 = 0.3f;
			information.RangeSTen_Ten2 = -1.15f;
			information.RangeSTen_Ten3 = 0.39f;
	 	}


	 	static public void StickerType35(ref ShaderInfo information)
	 	{
	 		string name = "RoundedX";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.06f;
			information.RangeSOne_One1 = 0.09f;
			information.RangeSOne_One2 = -0.95f;
			information.RangeSOne_One3 = -0.96f;
			information.RangeSTen_Ten0 = 1.5f;
			information.RangeSTen_Ten1 = 0.3f;
			information.RangeSTen_Ten2 = -1.15f;
			information.RangeSTen_Ten3 = 0.39f;
	 	}


	 	static public void StickerType36(ref ShaderInfo information)
	 	{
	 		string name = "Segment";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.36f;
			information.RangeSOne_One1 = 0.93f;
			information.RangeSOne_One2 = 0.14f;
			information.RangeSOne_One3 = 0.06f;
			information.RangeSTen_Ten0 = 0.17f;
			information.RangeSTen_Ten1 = 0.38f;
			information.RangeSTen_Ten2 = -0.33f;
			information.RangeSTen_Ten3 = -0.03f;
	 	}


	 	static public void StickerType37(ref ShaderInfo information)
	 	{
	 		string name = "Squircle";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.27f;
			information.RangeSOne_One1 = 0.2f;
			information.RangeSOne_One2 = 1.16f;
			information.RangeSOne_One3 = 11.19f;
			information.RangeSTen_Ten0 = 0.17f;
			information.RangeSTen_Ten1 = 0.38f;
			information.RangeSTen_Ten2 = -0.33f;
			information.RangeSTen_Ten3 = -0.03f;
	 	}


		static public void StickerType38(ref ShaderInfo information)
	 	{
	 		string name = "Stairs";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.27f;
			information.RangeSOne_One1 = 0.2f;
			information.RangeSOne_One2 = 1.16f;
			information.RangeSOne_One3 = 6.0f;
			information.RangeSTen_Ten0 = 0.0f;
			information.RangeSTen_Ten1 = 0.0f;
			information.RangeSTen_Ten2 = 0.0f;
			information.RangeSTen_Ten3 = 0.0f;
	 	}


		static public void StickerType39(ref ShaderInfo information)
	 	{
	 		string name = "StarN";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 23f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.27f;
			information.RangeSOne_One1 = 0.2f;
			information.RangeSOne_One2 = 1.16f;
			information.RangeSOne_One3 = 6.0f;
			information.RangeSTen_Ten0 = 0.0f;
			information.RangeSTen_Ten1 = 0.0f;
			information.RangeSTen_Ten2 = 0.0f;
			information.RangeSTen_Ten3 = 0.0f;
	 	}


		static public void StickerType40(ref ShaderInfo information)
	 	{
	 		string name = "Star";

			information.MotionState = 1f;
			information.BorderSizeOne = 1f;//
			information.BorderSizeTwo = 10.0f;//
			information.BorderBlurriness = 40f;

			information.RangeSOne_One0 = 0.27f;
			information.RangeSOne_One1 = -0.07f;
			information.RangeSOne_One2 = 0.09f;
			information.RangeSOne_One3 = 0.16f;
			information.RangeSTen_Ten0 = 0.65f;
			information.RangeSTen_Ten1 = 0.0f;
			information.RangeSTen_Ten2 = 0.0f;
			information.RangeSTen_Ten3 = 0.0f;
	 	}


	}
   
}
