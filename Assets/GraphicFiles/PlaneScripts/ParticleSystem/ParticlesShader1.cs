// using System.Collections;
// using System.Collections.Generic;
// using System;

// using UnityEngine;

// using ShaderInfo_Namespace;
// using MainStickerState_Namespace;
// using StickerName_Namespace;
// using ShaderName_Enum_Namespace;

// // public enum Direction {North, East, South, West};


// public class ParticleShader : MonoBehaviour
// {
//     // Start is called before the first frame update


// 	private static ShaderInfo variableShaderInfo;

// 	private static MaterialPropertyBlock _materialPropertyBlock;

// 	private Renderer renderer;

// 	public Material material;
// 	private Material material2;

// 	private Shader shader;




//  	[Header("Set active to use selected SHADER")]
// 	public bool UsePathShader_bool = false;

//  	[Header("Set active the box up to use predetermined path")]
// 	public string pathShader_string = "Shaders2D/CirclesDisco";
// 	private string pathShader_string2 = "Shaders2D/CirclesDisco";
//  	[Header("Set active OnPlayMode to change the SHADER using Path")]
// 	public bool Path_LOADSHADERONRUNTIME = false;


//  	[Header("Set active OnPlayMode to change the SHADER using Name")]
// 	public ShaderName_Enum shaderName_enum;
// 	public bool LOADSHADERONRUNTIME = false;




// /////////////////////////////////////////////////////////////
// //////// update information
// /////////////////////////////////////////////////////////////


// 	private string containerTextureChannel0 = "_TextureChannel0";
// 	private string containerTextureChannel1 = "_TextureChannel1";
// 	private string containerTextureChannel2 = "_TextureChannel2";
// 	private string containerTextureChannel3 = "_TextureChannel3";

// 	private Texture2D TextureToShaderChannel0;
// 	private Texture2D TextureToShaderChannel1;
// 	private Texture2D TextureToShaderChannel2;
// 	private Texture2D TextureToShaderChannel3;

//  	[Header("TEXTURE NAME DETAIL ON RESOURCES FOLDER")]
// 	public string TextureChannel0 = "GeometryImage23";
// 	public string TextureChannel1 = "GeometryImage24";
// 	public string TextureChannel2 = "GeometryImage25";
// 	public string TextureChannel3 = "GeometryImage26";
	
//  	[Header("TEXTURE NAME ")]
// 	public bool LOADTEXTUREONRUNTIME = false;


//  	// [Header("EditMode")]
//  	[Header("Set active to Edit STICKERPROPERTIES")]
// 	public bool EditValue = false;

//  	[Header("StickerType")]
// 	[Range(1, 80)]     	public int StickerType = 1;
// 					   	public Color BorderColor = Color.green;

// 	[Range(0, 1)]	   	public int MotionState = 1;
// 	[Range(1f, 100f)]  	public float BorderSizeOne = 1f;
// 	[Range(1f, 100f)]  	public float BorderSizeTwo = 1f;
// 	[Range(0f, 152f)]  	public float BorderBlurriness = 1f;

// 	public float RangeSOne_One0 = 1f; // [Range(-1f, 1f)]  
// 	public float RangeSOne_One1 = 1f; // [Range(-1f, 1f)]  
// 	public float RangeSOne_One2 = 1f; // [Range(-1f, 1f)]  
// 	public float RangeSOne_One3 = 1f; // [Range(-1f, 1f)]  
// 	public float RangeSTen_Ten0 = 1f; // [Range(-10f, 10f)]
// 	public float RangeSTen_Ten1 = 1f; // [Range(-10f, 10f)]
// 	public float RangeSTen_Ten2 = 1f; // [Range(-10f, 10f)]
// 	public float RangeSTen_Ten3 = 1f; // [Range(-10f, 10f)]


//     private MeshCollider elementMeshCollider;
// 	[Header("Set active to ENABLE MeshCollider/COLLISSION")]
// 	public bool stateMeshCollider = false;
// 	private bool meshColliderCurrent = false;

// 	[Header("Set active to ENABLE RandomMotion")]
// 	public bool enableMotion = false;

// /////////////////////////////////////////////////////////////
// //////// update information
// /////////////////////////////////////////////////////////////

// 	private const string stringStickerType      = "_StickerType";
// 	private const string stringMotionState      = "_MotionState";

// 	private const string stringBorderColor      = "_BorderColor";
// 	private const string stringBorderSizeOne    = "_BorderSizeOne";
// 	private const string stringBorderSizeTwo    = "_BorderSizeTwo";
// 	private const string stringBorderBlurriness = "_BorderBlurriness";

// 	private const string stringRangeSTen_Ten0   = "_RangeSTen_Ten0";
// 	private const string stringRangeSTen_Ten1   = "_RangeSTen_Ten1";
// 	private const string stringRangeSTen_Ten2   = "_RangeSTen_Ten2";
// 	private const string stringRangeSTen_Ten3   = "_RangeSTen_Ten3";

// 	private const string stringRangeSOne_One0   = "_RangeSOne_One0";
// 	private const string stringRangeSOne_One1   = "_RangeSOne_One1";
// 	private const string stringRangeSOne_One2   = "_RangeSOne_One2";
// 	private const string stringRangeSOne_One3   = "_RangeSOne_One3";

//     private int currentStickerValue;

//     private int currentInstanceID;

//     Vector3 scaleValuesInitial;


//     void Start()
//     {


//     	scaleValuesInitial = transform.localScale;

//     	currentInstanceID = gameObject.GetInstanceID();


//     	pathShader_string = "Shaders2D/XTexture";


//     	//////////////////////////// CHANGE THIS TO FALSE TO SET RANDOM BACKGROUND ON STICKERS////////////// 
//     	if(UsePathShader_bool == true)
//     	{
// 		 	pathShader_string = GetRandomStringShaderPath(currentInstanceID);
// 			pathShader_string2 = GetRandomStringShaderPath(currentInstanceID + 10);

//     	}						


//     	renderer = GetComponent<Renderer>();

// 		material = new Material(Shader.Find(pathShader_string));

//     	material2 = new Material(Shader.Find(pathShader_string2));

//     	// renderer.material = material2;
//     	renderer.material = material;

// 		// shader = material.shader;

// 		if (SystemInfo.supportsInstancing)
// 		{
// 			material2.enableInstancing = true;
// 			material.enableInstancing = true;
// 			// material2.enableInstancing = true;
// 		}
	

// 		TextureToShaderChannel0 = (Texture2D)Resources.Load(TextureChannel0);
// 		TextureToShaderChannel1 = (Texture2D)Resources.Load(TextureChannel1);
// 		TextureToShaderChannel2 = (Texture2D)Resources.Load(TextureChannel2);
// 		TextureToShaderChannel3 = (Texture2D)Resources.Load(TextureChannel3);

// 		material.SetTexture(containerTextureChannel0, TextureToShaderChannel0);
// 		material.SetTexture(containerTextureChannel1, TextureToShaderChannel1);
// 		material.SetTexture(containerTextureChannel2, TextureToShaderChannel2);
// 		material.SetTexture(containerTextureChannel3, TextureToShaderChannel3);

// 		material2.SetTexture(containerTextureChannel0, TextureToShaderChannel0);
// 		material2.SetTexture(containerTextureChannel1, TextureToShaderChannel1);
// 		material2.SetTexture(containerTextureChannel2, TextureToShaderChannel2);
// 		material2.SetTexture(containerTextureChannel3, TextureToShaderChannel3);

// 		// material.SetFloat("_ValueFloat", 1.0f);

// 		variableShaderInfo = new ShaderInfo
// 		{
// 			StickerType = StickerType,
// 			MotionState = MotionState,
// 			BorderColor = BorderColor,
// 			BorderSizeOne = BorderSizeOne, 
// 			BorderSizeTwo = BorderSizeTwo, 
// 			BorderBlurriness = BorderBlurriness,

// 			RangeSTen_Ten0 = RangeSTen_Ten0,
// 			RangeSTen_Ten1 = RangeSTen_Ten1,
// 			RangeSTen_Ten2 = RangeSTen_Ten2,
// 			RangeSTen_Ten3 = RangeSTen_Ten3,

// 			RangeSOne_One0 = RangeSOne_One0,
// 			RangeSOne_One1 = RangeSOne_One1,
// 			RangeSOne_One2 = RangeSOne_One2,
// 			RangeSOne_One3 = RangeSOne_One3
// 		};

// 		// SetInitialValues(StickerType);
// 		// SetInitialValuesRef(ref variableShaderInfo);

// 		_materialPropertyBlock = SetMaterialPropertyBlock();

// 		renderer.SetPropertyBlock(_materialPropertyBlock);

// 		currentStickerValue = (int)variableShaderInfo.StickerType;

// 		elementMeshCollider = GetComponent<MeshCollider>();

// 		if(stateMeshCollider == false)
// 		{
// 			elementMeshCollider.enabled = false;
// 		}




//     }


//     static string GetRandomStringShaderPath(int valueSeed)
//     {

//     	System.DateTime valueTime = new System.DateTime();

//     	int valueDateint = valueTime.Hour + valueTime.Minute + valueTime.Second;
    	
//     	System.Random variableRandom = new System.Random(valueDateint + valueSeed);



// 		StickerNameClass.SetShaderPathNameStringArray();
// 		string[]  nameShaderArray = StickerNameClass.GetShaderPathNameStringArray();

// 		// foreach(string nameShader in nameShaderArray)
// 		// {
// 		// 	Debug.Log("Name Shader Path == " + nameShader);
// 		// }

//     	int indexNameShaderArray = variableRandom.Next(0, nameShaderArray.Length);

//     	return nameShaderArray[indexNameShaderArray];
//     }

// 	static MaterialPropertyBlock SetMaterialPropertyBlock()
// 	{
// 		if (_materialPropertyBlock == null)
// 		{
// 			_materialPropertyBlock = new MaterialPropertyBlock();
// 		}
		
// 		_materialPropertyBlock.SetFloat(stringStickerType,  	 variableShaderInfo.StickerType);
// 		_materialPropertyBlock.SetFloat(stringMotionState,  	 variableShaderInfo.MotionState);

// 		_materialPropertyBlock.SetColor(stringBorderColor,       variableShaderInfo.BorderColor);
// 		_materialPropertyBlock.SetFloat(stringBorderSizeOne,     variableShaderInfo.BorderSizeOne);
// 		_materialPropertyBlock.SetFloat(stringBorderSizeTwo,     variableShaderInfo.BorderSizeTwo);
// 		_materialPropertyBlock.SetFloat(stringBorderBlurriness,  variableShaderInfo.BorderBlurriness);

// 		_materialPropertyBlock.SetFloat(stringRangeSOne_One0,    variableShaderInfo.RangeSOne_One0);
// 		_materialPropertyBlock.SetFloat(stringRangeSOne_One1,    variableShaderInfo.RangeSOne_One1);
// 		_materialPropertyBlock.SetFloat(stringRangeSOne_One2,    variableShaderInfo.RangeSOne_One2);
// 		_materialPropertyBlock.SetFloat(stringRangeSOne_One3,    variableShaderInfo.RangeSOne_One3);

// 		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten0,    variableShaderInfo.RangeSTen_Ten0);
// 		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten1,    variableShaderInfo.RangeSTen_Ten1);
// 		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten2,    variableShaderInfo.RangeSTen_Ten2);
// 		_materialPropertyBlock.SetFloat(stringRangeSTen_Ten3,    variableShaderInfo.RangeSTen_Ten3);


// 		return _materialPropertyBlock;
// 	}



// 	void SetInitialValuesRef(ref ShaderInfo information)
// 	{
// 		MainStickerStateClass.SetStickerState(ref information);
 
// 		// StickerType = information.StickerType;
// 		MotionState = (int)information.MotionState;

// 		BorderColor = information.BorderColor;
// 		BorderSizeOne = information.BorderSizeOne; 
// 		BorderSizeTwo = information.BorderSizeTwo; 
// 		BorderBlurriness = information.BorderBlurriness;

// 		RangeSOne_One0 = information.RangeSOne_One0;
// 		RangeSOne_One1 = information.RangeSOne_One1;
// 		RangeSOne_One2 = information.RangeSOne_One2;
// 		RangeSOne_One3 = information.RangeSOne_One3;

// 		RangeSTen_Ten0 = information.RangeSTen_Ten0;
// 		RangeSTen_Ten1 = information.RangeSTen_Ten1;
// 		RangeSTen_Ten2 = information.RangeSTen_Ten2;
// 		RangeSTen_Ten3 = information.RangeSTen_Ten3;
 
// 	}


// 	int counterXZ = 0;
// 	int counterNegative = 0;
// 	// float negativeSign = -1.0f;
// 	float currentTime = 0.0f;
// 	float active0 = 0.0f;
// 	float active1 = 1.0f;
//     float lastInterval = 0.0f;
//     float updateInterval = 0.5f;
//     // Update is called once per frame


//     void Update()
//     {
// 		// SetInitialValuesRef(ref variableShaderInfo);


// 		float timeNow = Time.realtimeSinceStartup;

//     	// transform.localScale =  scaleValuesInitial + new Vector3((float)(Math.Sin(timeNow * 10)) * 1.0f, 0.0f, (float)(Math.Sin(timeNow * 10)) * 1.0f ); 

//     	// Debug.Log((float)Math.Abs(Math.Sin(timeNow * 9475)));

//     	if(LOADTEXTUREONRUNTIME)
//     	{
//     		LOADTEXTUREONRUNTIME = false;

// 			TextureToShaderChannel0 = (Texture2D)Resources.Load(TextureChannel0);
// 			TextureToShaderChannel1 = (Texture2D)Resources.Load(TextureChannel1);
// 			TextureToShaderChannel2 = (Texture2D)Resources.Load(TextureChannel2);
// 			TextureToShaderChannel3 = (Texture2D)Resources.Load(TextureChannel3);
	
// 			material.SetTexture(containerTextureChannel0, TextureToShaderChannel0);
// 			material.SetTexture(containerTextureChannel1, TextureToShaderChannel1);
// 			material.SetTexture(containerTextureChannel2, TextureToShaderChannel2);
// 			material.SetTexture(containerTextureChannel3, TextureToShaderChannel3);

//     	}


// 		if(Path_LOADSHADERONRUNTIME)
// 		{

// 			Path_LOADSHADERONRUNTIME = false;

// 			string pathToShader = pathShader_string;

// 			Shader shaderOnRuntime  = Shader.Find(pathToShader);
// 			material.shader = shaderOnRuntime;

// 		}

// 		if(LOADSHADERONRUNTIME)
// 		{

// 			LOADSHADERONRUNTIME = false;
// 			StickerNameClass.SetShaderPathNameStringArray();
// 			string[] nameShaderArray = StickerNameClass.GetShaderPathNameStringArray();

// 			int currentEnumValue = (int)shaderName_enum;
// 			string nameShader_string = nameShaderArray[currentEnumValue];

// 			pathShader_string = nameShader_string;

// 			Shader shaderOnRuntime  = Shader.Find(nameShader_string);
// 			material.shader = shaderOnRuntime;

// 		}


//     	if(EditValue == true)
//     	{
// 			variableShaderInfo = new ShaderInfo
// 			{
// 				StickerType = StickerType,
// 				MotionState = MotionState,
// 				BorderColor = BorderColor,
// 				BorderSizeOne = BorderSizeOne, 
// 				BorderSizeTwo = BorderSizeTwo, 
// 				BorderBlurriness = BorderBlurriness,
	
	
// 				RangeSOne_One0 = RangeSOne_One0,
// 				RangeSOne_One1 = RangeSOne_One1,
// 				RangeSOne_One2 = RangeSOne_One2,
// 				RangeSOne_One3 = RangeSOne_One3,
	
// 				RangeSTen_Ten0 = RangeSTen_Ten0,
// 				RangeSTen_Ten1 = RangeSTen_Ten1,
// 				RangeSTen_Ten2 = RangeSTen_Ten2,
// 				RangeSTen_Ten3 = RangeSTen_Ten3
// 			};
	
// 			_materialPropertyBlock = SetMaterialPropertyBlock();
	
// 			renderer.SetPropertyBlock(_materialPropertyBlock);
	
	
// 			if(((int)variableShaderInfo.StickerType )!= currentStickerValue)
// 			{
	
// 				SetInitialValuesRef(ref variableShaderInfo);
// 				currentStickerValue = (int) variableShaderInfo.StickerType;
// 			}
// 		}

		
// 		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 		///////////////////////////////////////////////// CONCEPT //////////////////////////////////////////////////////////
// 		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 		if(Input.GetKeyDown(KeyCode.L))
// 		{

// 			string pathToShader = GetRandomStringShaderPath(currentInstanceID + 15);

// 			// Shader shaderClouds  = Shader.Find("Shaders2D/CirclesDisco");
// 			Shader shaderToModify  = Shader.Find(pathToShader);
// 			material.shader = shaderToModify;
// 			renderer.material = material;

// 		}

// 		if(Input.GetKeyDown(KeyCode.K))
// 		{
// 	    	// material = new Material(Shader.Find("Shaders2D/XBall"));

// 			renderer.material = material2;

// 		}
// 		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 		///////////////////////////////////////////////// CONCEPT //////////////////////////////////////////////////////////
// 		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




// 		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 		/////////////////////////////////////////////////  MOTION  /////////////////////////////////////////////////////////
// 		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 		if(meshColliderCurrent != stateMeshCollider)
// 		{
// 			meshColliderCurrent = stateMeshCollider;

// 			bool enabledMeshCollider = elementMeshCollider.enabled;
// 			elementMeshCollider.enabled = meshColliderCurrent;

// 			// public bool stateMeshCollider = false;
// 			// private bool meshColliderCurrent = false;

// 		}





// 		if(enableMotion == true)
// 		{

// 			// Quaternion rotationParameter = Quaternion.Euler(180.0f * (float)Math.Sin(timeNow + 204985), 90.0f * (float)Math.Sin(timeNow + 9034875), 270.0f * (float)Math.Sin(timeNow + 23904));
// 			Quaternion rotationParameter = Quaternion.Euler(90.0f, 90.0f * (float)Math.Sin(timeNow + 9034875), 180.0f);
// 	    	transform.rotation = Quaternion.Slerp(transform.rotation, rotationParameter, Time.deltaTime * 5f); 
	 
// 	    	// transform.position = new Vector3((float)Math.Abs(Math.Sin(timeNow * 9475)), (float)Math.Abs(Math.Sin(timeNow * 93745)), 0.0f);
	
// 	    	counterNegative++;
// 	    	counterXZ++;
// 	    	if(counterNegative == 1000 || counterXZ == 100)
// 	    	{
// 		    	if(transform.position.x < 120 && transform.position.x > -20 && transform.position.z < 120 && transform.position.z > -20 )
// 		    	{
		
		
// 					if(counterNegative == 1000)
// 		    		{
// 		    			counterNegative = 0;
// 		    			active0 *= -1;
// 		    			active1 *= -1;
// 		    		}    		
// 		    		if(counterXZ == 100)
// 		    		{
// 		    			counterXZ = 0;
// 		    			float variableHolder0 = active0;
// 		    			float variableHolder1 = active1;
// 		    			active0 = variableHolder1;
// 		    			active1 = variableHolder0;
		
// 		    		}
		
// 		    	}
// 		    }
	
// 			System.Random valueRandom = new System.Random(currentInstanceID);
// 			float firstValue = (float)valueRandom.NextDouble() * 3;
// 	   		Vector3 valueToUpdate = new Vector3( active0 * firstValue, 0.0f, active1 * firstValue);
// 	   		transform.position = Vector3.Slerp(transform.position, transform.position + valueToUpdate, Time.deltaTime);
	
// 	    	if(transform.position.x > 140)
// 	    	{
// 				System.Random valueRandomY = new System.Random(currentInstanceID);
// 				float randomY = (float)valueRandomY.Next(1, 11);
// 	    		transform.position = new Vector3(90f, randomY, transform.position.z);
// 	    	}
	 		
// 	    	if(transform.position.x < -40)
// 	    	{
// 				System.Random valueRandomY = new System.Random(currentInstanceID);
// 				float randomY = (float)valueRandomY.Next(1, 11);
// 	    		transform.position  = new Vector3(10f, randomY, transform.position.z);
// 	    	}
	
// 	    	if(transform.position.z > 140)
// 	    	{
// 				System.Random valueRandomY = new System.Random(currentInstanceID);
// 				float randomY = (float)valueRandomY.Next(1, 11);
// 	    		transform.position = new Vector3(transform.position.x, randomY, 90);
// 	    	}
	 		
// 	    	if(transform.position.z < -40)
// 	    	{
// 				System.Random valueRandomY = new System.Random(currentInstanceID);
// 				float randomY = (float)valueRandomY.Next(1, 11);
// 	    		transform.position  = new Vector3(transform.position.x, randomY, 10);
// 	    	}

//     	}


// 		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 		/////////////////////////////////////////////////  MOTION  /////////////////////////////////////////////////////////
// 		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////









//     }
//     //////////UPDATE OUT //////////////



// }