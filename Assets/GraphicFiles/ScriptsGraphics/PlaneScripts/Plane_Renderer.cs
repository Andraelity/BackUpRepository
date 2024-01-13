using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public struct ShaderInfo
{
	public float StickerType;
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

public class Plane_Renderer : MonoBehaviour
{
    // Start is called before the first frame update
	static ShaderInfo variableShaderInfo;

	private static MaterialPropertyBlock _materialPropertyBlock;

	private static Renderer renderer;

	private static Material material;

	private static Shader shader;

	[Range(1f, 1000f)] public float ScaleObject = 2f;

	public  string pathShader = "";

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


	[Range(1f, 100f)]   public float StickerType = 1f;
					    public Color BorderColor;
	[Range(1f, 100f)]  	public float BorderSizeOne = 1f;// public float BorderSizeOne = 0.005f;//
	[Range(1f, 100f)]  	public float BorderSizeTwo = 1f;// public float BorderSizeTwo = 0.005f;//
	[Range(0f, 152f)]  	public float BorderBlurriness = 1f;

	[Range(-10f, 10f)]  public float RangeSTen_Ten0 = 1f;
	[Range(-10f, 10f)]  public float RangeSTen_Ten1 = 1f;
	[Range(-10f, 10f)]  public float RangeSTen_Ten2 = 1f;
	[Range(-10f, 10f)]  public float RangeSTen_Ten3 = 1f;

	[Range(-1f, 1f)]  public float RangeSOne_One0 = 1f;
	[Range(-1f, 1f)]  public float RangeSOne_One1 = 1f;
	[Range(-1f, 1f)]  public float RangeSOne_One2 = 1f;
	[Range(-1f, 1f)]  public float RangeSOne_One3 = 1f;

/////////////////////////////////////////////////////////////
//////// update information
/////////////////////////////////////////////////////////////



	private const string stringStickerType      = "_StickerType";
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
		material.SetFloat("_ValueFloat", 1.0f);

		variableShaderInfo = new ShaderInfo
		{
			StickerType = StickerType,
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

		_materialPropertyBlock = SetMaterialPropertyBlock();

		renderer.SetPropertyBlock(_materialPropertyBlock);

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
		_materialPropertyBlock.SetColor(stringBorderColor,       variableShaderInfo.BorderColor);
		_materialPropertyBlock.SetFloat(stringBorderSizeOne,     variableShaderInfo.BorderSizeOne);
		_materialPropertyBlock.SetFloat(stringBorderSizeTwo,     variableShaderInfo.BorderSizeTwo);
		_materialPropertyBlock.SetFloat(stringBorderBlurriness,  variableShaderInfo.BorderBlurriness);

		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten0,    variableShaderInfo.RangeSTen_Ten0);
		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten1,    variableShaderInfo.RangeSTen_Ten1);
		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten2,    variableShaderInfo.RangeSTen_Ten2);
		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten3,    variableShaderInfo.RangeSTen_Ten3);

		_materialPropertyBlock.SetFloat(stringRangeSOne_One0,    variableShaderInfo.RangeSOne_One0);
		_materialPropertyBlock.SetFloat(stringRangeSOne_One1,    variableShaderInfo.RangeSOne_One1);
		_materialPropertyBlock.SetFloat(stringRangeSOne_One2,    variableShaderInfo.RangeSOne_One2);
		_materialPropertyBlock.SetFloat(stringRangeSOne_One3,    variableShaderInfo.RangeSOne_One3);

		return _materialPropertyBlock;
	}



    // Update is called once per frame
    void Update()
    {
        
		variableShaderInfo = new ShaderInfo
		{
			StickerType = StickerType,
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

		_materialPropertyBlock = SetMaterialPropertyBlock();

		renderer.SetPropertyBlock(_materialPropertyBlock);

		// Shader.SetGlobalVector("_ValueFloat", new Vector3(1.0f, 1.0f, 1.0f));
		// Shader.SetGlobalFloat("_ValueFloat", 1.0f);


		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////// CONCEPT //////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



		Shader.SetGlobalVector("_ValueVector", new Vector4(1.0f, 1.0f, 1.0f, 1.0f));

		Vector4 globalShaderTime = Shader.GetGlobalVector("_Time");


		print(Application.dataPath);
		print(Application.persistentDataPath);

       	// Debug.Log("shader timeV: " + globalShaderTime + " shader _Time.y: " + globalShaderTime.y + " timeSinceLevelLoad:" + Time.timeSinceLevelLoad);
		Vector4 globalShaderValueTime = new Vector4(1.0f, globalShaderTime.y, globalShaderTime.z, globalShaderTime.w);


		Vector4 globalVector = new Vector4(0.5f, 1.0f, 1.0f, 1.0f);

		// Shader.SetGlobalVector("_VectorVariable", globalVector);
		// Shader.SetGlobalFloat("_FloatVariable", 0.5f);

		// renderer.material.SetFloat("_FloatNumber", 1.0f);


		// Shader.SetGlobalVector("_VectorVariable", globalVector);

		Shader.SetGlobalInt("_IntVariable", 1);

		renderer.material.SetInt("_IntNumber", 1);

		if(Input.GetKeyDown(KeyCode.L))
		{

			renderer.material.SetFloat("_FloatNumber", 1.0f);
			Shader.SetGlobalVector("_VectorVariable", globalVector);

			Shader.SetGlobalFloat("_FloatVariable", 1.0f);

		}


		if(Input.GetKeyDown(KeyCode.K))
		{
			renderer.material.SetFloat("_FloatNumber", 0.0f);

			Shader.SetGlobalVector("_VectorVariable", globalVector);
			Shader.SetGlobalFloat("_FloatVariable", 1.0f);

		}



		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////// CONCEPT //////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    }
    //////////UPDATE OUT //////////////







}
