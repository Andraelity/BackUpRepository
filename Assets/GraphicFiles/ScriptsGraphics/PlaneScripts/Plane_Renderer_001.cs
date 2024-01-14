using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using ShaderInfoNamespace;
using MainStickerState;

// public struct ShaderInfo
// {
// 	public float StickerType;
// 	public Color BorderColor;
// 	public float BorderSizeOne;
// 	public float BorderSizeTwo;
// 	public float BorderBlurriness;
 
// 	public float RangeSTen_Ten0;
// 	public float RangeSTen_Ten1;
// 	public float RangeSTen_Ten2;
// 	public float RangeSTen_Ten3;
 
// 	public float RangeSOne_One0;
// 	public float RangeSOne_One1;
// 	public float RangeSOne_One2;
// 	public float RangeSOne_One3;
// }

public class Plane_Renderer_001 : MonoBehaviour
{
    // Start is called before the first frame update
	private static ShaderInfo variableShaderInfo;

	private static MaterialPropertyBlock _materialPropertyBlock;

	private Renderer renderer;

	private Material material;

	private Shader shader;

	[Range(1f, 1000f)] public float ScaleObject = 2f;

	public  string pathShader = "PlaneShaderWork";

	private Texture2D TextureToShaderChannel0;
	private Texture2D TextureToShaderChannel1;
	private Texture2D TextureToShaderChannel2;
	private Texture2D TextureToShaderChannel3;

/////////////////////////////////////////////////////////////
//////// update information
/////////////////////////////////////////////////////////////

	public string TextureChannel0;
	public string TextureChannel1;
	public string TextureChannel2;
	public string TextureChannel3;



	public Color BorderColor = Color.green;
 	[Header("StickerType")]
	[Range(1, 80)]     public int StickerType = 1;
	[Range(0, 1)]	   public int MotionState = 1;
	[Range(1f, 100f)]  public float BorderSizeOne = 1f;
	[Range(1f, 100f)]  public float BorderSizeTwo = 1f;
	[Range(0f, 152f)]  public float BorderBlurriness = 1f;
	 public float RangeSOne_One0 = 1f; // [Range(-1f, 1f)]  
	 public float RangeSOne_One1 = 1f; // [Range(-1f, 1f)]  
	 public float RangeSOne_One2 = 1f; // [Range(-1f, 1f)]  
	 public float RangeSOne_One3 = 1f; // [Range(-1f, 1f)]  
	 public float RangeSTen_Ten0 = 1f; // [Range(-10f, 10f)]
	 public float RangeSTen_Ten1 = 1f; // [Range(-10f, 10f)]
	 public float RangeSTen_Ten2 = 1f; // [Range(-10f, 10f)]
	 public float RangeSTen_Ten3 = 1f; // [Range(-10f, 10f)]

/////////////////////////////////////////////////////////////
//////// update information
/////////////////////////////////////////////////////////////

	private const string stringStickerType      = "_StickerType";
	private const string stringMotionState      = "_MotionState";

	private const string stringBorderColor      = "_BorderColor";
	private const string stringBorderSizeOne    = "_BorderSizeOne";
	private const string stringBorderSizeTwo    = "_BorderSizeTwo";
	private const string stringBorderBlurriness = "_BorderBlurriness";

	private const string stringRangeSTen_Ten0   = "_RangeSTen_Ten0";
	private const string stringRangeSTen_Ten1   = "_RangeSTen_Ten1";
	private const string stringRangeSTen_Ten2   = "_RangeSTen_Ten2";
	private const string stringRangeSTen_Ten3   = "_RangeSTen_Ten3";

	private const string stringRangeSOne_One0   = "_RangeSOne_One0";
	private const string stringRangeSOne_One1   = "_RangeSOne_One1";
	private const string stringRangeSOne_One2   = "_RangeSOne_One2";
	private const string stringRangeSOne_One3   = "_RangeSOne_One3";

    private int currentStickerValue;

    void Start()
    {
    	renderer = GetComponent<Renderer>();
    	// material = renderer.material;
    	material = new Material(Shader.Find(pathShader));

    	renderer.material = material;
		// shader = material.shader;

		if (SystemInfo.supportsInstancing)
		{
			material.enableInstancing = true;
		}

		TextureToShaderChannel0 = (Texture2D)Resources.Load(TextureChannel0);
		TextureToShaderChannel1 = (Texture2D)Resources.Load(TextureChannel1);
		TextureToShaderChannel2 = (Texture2D)Resources.Load(TextureChannel2);
		TextureToShaderChannel3 = (Texture2D)Resources.Load(TextureChannel3);

		material.SetTexture("_TextureChannel0", TextureToShaderChannel0);
		material.SetTexture("_TextureChannel1", TextureToShaderChannel1);
		material.SetTexture("_TextureChannel2", TextureToShaderChannel2);
		material.SetTexture("_TextureChannel3", TextureToShaderChannel3);
		// material.SetFloat("_ValueFloat", 1.0f);


		variableShaderInfo = new ShaderInfo
		{
			StickerType = StickerType,
			MotionState = MotionState,
			BorderColor = BorderColor,
			BorderSizeOne = BorderSizeOne, 
			BorderSizeTwo = BorderSizeTwo, 
			BorderBlurriness = BorderBlurriness,

			RangeSTen_Ten0 = RangeSTen_Ten0,
			RangeSTen_Ten1 = RangeSTen_Ten1,
			RangeSTen_Ten2 = RangeSTen_Ten2,
			RangeSTen_Ten3 = RangeSTen_Ten3,

			RangeSOne_One0 = RangeSOne_One0,
			RangeSOne_One1 = RangeSOne_One1,
			RangeSOne_One2 = RangeSOne_One2,
			RangeSOne_One3 = RangeSOne_One3
		};

		// SetInitialValues(StickerType);
		// SetInitialValuesRef(ref variableShaderInfo);

		_materialPropertyBlock = SetMaterialPropertyBlock();

		renderer.SetPropertyBlock(_materialPropertyBlock);

		currentStickerValue = (int)variableShaderInfo.StickerType;

		// Vector4 globalVector = new Vector4(0.5f, 1.0f, 1.0f, 1.0f);

		// Shader.SetGlobalVector("_VectorVariable", globalVector);
		// Shader.SetGlobalFloat("_FloatVariable", 1.0f);

		// renderer.material.SetFloat("_FloatNumber", 1.0f);

    }


	static MaterialPropertyBlock SetMaterialPropertyBlock()
	{
		if (_materialPropertyBlock == null)
		{
			_materialPropertyBlock = new MaterialPropertyBlock();
		}
		
		_materialPropertyBlock.SetFloat(stringStickerType,  	 variableShaderInfo.StickerType);
		_materialPropertyBlock.SetFloat(stringMotionState,  	 variableShaderInfo.MotionState);

		_materialPropertyBlock.SetColor(stringBorderColor,       variableShaderInfo.BorderColor);
		_materialPropertyBlock.SetFloat(stringBorderSizeOne,     variableShaderInfo.BorderSizeOne);
		_materialPropertyBlock.SetFloat(stringBorderSizeTwo,     variableShaderInfo.BorderSizeTwo);
		_materialPropertyBlock.SetFloat(stringBorderBlurriness,  variableShaderInfo.BorderBlurriness);

		_materialPropertyBlock.SetFloat(stringRangeSOne_One0,    variableShaderInfo.RangeSOne_One0);
		_materialPropertyBlock.SetFloat(stringRangeSOne_One1,    variableShaderInfo.RangeSOne_One1);
		_materialPropertyBlock.SetFloat(stringRangeSOne_One2,    variableShaderInfo.RangeSOne_One2);
		_materialPropertyBlock.SetFloat(stringRangeSOne_One3,    variableShaderInfo.RangeSOne_One3);

		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten0,    variableShaderInfo.RangeSTen_Ten0);
		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten1,    variableShaderInfo.RangeSTen_Ten1);
		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten2,    variableShaderInfo.RangeSTen_Ten2);
		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten3,    variableShaderInfo.RangeSTen_Ten3);


		return _materialPropertyBlock;
	}


	void SetInitialValues(float StickerType)
	{
		if(StickerType == 1)
		{
			BorderSizeOne = 1f;//
			BorderSizeTwo = 23f;//
			BorderBlurriness = 90f;
			RangeSOne_One0 = 1f;
			RangeSOne_One1 = 0.11f;
			RangeSOne_One2 = 1f;
			RangeSOne_One3 = 1f;
			RangeSTen_Ten0 = 7f;
			RangeSTen_Ten1 = 3.1f;
			RangeSTen_Ten2 = 1f;
			RangeSTen_Ten3 = 1f;
		}

	}


	void SetInitialValuesRef(ref ShaderInfo information)
	{
		MainStickerStateClass.SetStickerState(ref information);
 
		// StickerType = information.StickerType;
		MotionState = (int)information.MotionState;

		BorderColor = information.BorderColor;
		BorderSizeOne = information.BorderSizeOne; 
		BorderSizeTwo = information.BorderSizeTwo; 
		BorderBlurriness = information.BorderBlurriness;

		RangeSOne_One0 = information.RangeSOne_One0;
		RangeSOne_One1 = information.RangeSOne_One1;
		RangeSOne_One2 = information.RangeSOne_One2;
		RangeSOne_One3 = information.RangeSOne_One3;

		RangeSTen_Ten0 = information.RangeSTen_Ten0;
		RangeSTen_Ten1 = information.RangeSTen_Ten1;
		RangeSTen_Ten2 = information.RangeSTen_Ten2;
		RangeSTen_Ten3 = information.RangeSTen_Ten3;
 
	}




    // Update is called once per frame
    void Update()
    {
		// SetInitialValuesRef(ref variableShaderInfo);

		variableShaderInfo = new ShaderInfo
		{
			StickerType = StickerType,
			MotionState = MotionState,
			BorderColor = BorderColor,
			BorderSizeOne = BorderSizeOne, 
			BorderSizeTwo = BorderSizeTwo, 
			BorderBlurriness = BorderBlurriness,


			RangeSOne_One0 = RangeSOne_One0,
			RangeSOne_One1 = RangeSOne_One1,
			RangeSOne_One2 = RangeSOne_One2,
			RangeSOne_One3 = RangeSOne_One3,

			RangeSTen_Ten0 = RangeSTen_Ten0,
			RangeSTen_Ten1 = RangeSTen_Ten1,
			RangeSTen_Ten2 = RangeSTen_Ten2,
			RangeSTen_Ten3 = RangeSTen_Ten3
		};

		_materialPropertyBlock = SetMaterialPropertyBlock();

		renderer.SetPropertyBlock(_materialPropertyBlock);


		if(((int)variableShaderInfo.StickerType )!= currentStickerValue)
		{

			SetInitialValuesRef(ref variableShaderInfo);
			currentStickerValue = (int) variableShaderInfo.StickerType;
		}


		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////// CONCEPT //////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		// Shader.SetGlobalVector("_ValueFloat", new Vector3(1.0f, 1.0f, 1.0f));
		// Shader.SetGlobalFloat("_ValueFloat", 1.0f);
		Shader.SetGlobalVector("_ValueVector", new Vector4(1.0f, 1.0f, 1.0f, 1.0f));

		Vector4 globalShaderTime = Shader.GetGlobalVector("_Time");


		// print(Application.dataPath);
		// print(Application.persistentDataPath);

       	// Debug.Log("shader timeV: " + globalShaderTime + " shader _Time.y: " + globalShaderTime.y + " timeSinceLevelLoad:" + Time.timeSinceLevelLoad);
		Vector4 globalShaderValueTime = new Vector4(1.0f, globalShaderTime.y, globalShaderTime.z, globalShaderTime.w);


		Vector4 globalVector = new Vector4(0.5f, 1.0f, 1.0f, 1.0f);

		// Shader.SetGlobalVector("_VectorVariable", globalVector);
		// Shader.SetGlobalFloat("_FloatVariable", 0.5f);

		// renderer.material.SetFloat("_FloatNumber", 1.0f);


		// Shader.SetGlobalVector("_VectorVariable", globalVector);

		// Shader.SetGlobalInt("_IntVariable", 1);

		// renderer.material.SetInt("_IntNumber", 1);

		if(Input.GetKeyDown(KeyCode.L))
		{
			BorderSizeTwo += 1.0f;
			// renderer.material.SetFloat("_FloatNumber", 1.0f);
			// Shader.SetGlobalVector("_VectorVariable", globalVector);
			// Shader.SetGlobalFloat("_FloatVariable", 1.0f);

		}


		if(Input.GetKeyDown(KeyCode.K))
		{
			BorderSizeTwo -= 1.0f;

			// renderer.material.SetFloat("_FloatNumber", 0.0f);
			// Shader.SetGlobalVector("_VectorVariable", globalVector);
			// Shader.SetGlobalFloat("_FloatVariable", 1.0f);

		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////// CONCEPT //////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    }
    //////////UPDATE OUT //////////////



}