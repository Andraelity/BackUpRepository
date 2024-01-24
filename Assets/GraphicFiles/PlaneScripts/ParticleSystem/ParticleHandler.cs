using System.Collections;
using System.Collections.Generic;
using UnityEngine;


using ShaderInfo_Namespace;
using MainStickerState_Namespace;
using StickerName_Namespace;
using ShaderName_Enum_Namespace;


public class ParticleHandler : MonoBehaviour
{
	// Start is called before the first frame update

	private static ShaderInfo variableShaderInfo;
	private static ShaderInfoSprite variableShaderInfoSprite;

	private ParticleSystemRenderer particleSystemRenderer;

	public Material material;




	[Header("Set active to use selected SHADER")]
	public bool UsePathShader_bool = false;

	[Header("Set active the box up to use predetermined path")]
	public string pathShader_string = "Shaders2D/CirclesDisco";
	private string pathShader_string2 = "Shaders2D/CirclesDisco";
	
	[Header("Set active OnPlayMode to change the SHADER using Path")]
	public bool Path_LOADSHADERONRUNTIME = false;


	[Header("Set active OnPlayMode to change the SHADER using Name")]
	public ShaderName_Enum shaderName_enum;
	public bool LOADSHADERONRUNTIME = false;


/////////////////////////////////////////////////////////////////////////////////////////
//////////////////////TEXTURE INFORMATION ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

	private string containerTextureSprite = "_TextureSprite";

	private string containerTextureChannel0 = "_TextureChannel0";
	private string containerTextureChannel1 = "_TextureChannel1";
	private string containerTextureChannel2 = "_TextureChannel2";
	private string containerTextureChannel3 = "_TextureChannel3";

	private Texture2D TextureToShaderSprite;

	private Texture2D TextureToShaderChannel0;
	private Texture2D TextureToShaderChannel1;
	private Texture2D TextureToShaderChannel2;
	private Texture2D TextureToShaderChannel3;

	[Header("TEXTURE NAME DETAIL ON RESOURCES FOLDER")]
	public string TextureSprite = "SpriteImage0";

	public string TextureChannel0 = "GeometryImage21";
	public string TextureChannel1 = "GeometryImage17";
	public string TextureChannel2 = "GeometryImage25";
	public string TextureChannel3 = "GeometryImage26";
	
	[Header("Set Active to reload nex TEXTURES at runtime")]
	public bool LOADTEXTUREONRUNTIME = false;


/////////////////////////////////////////////////////////////////////////////////////////
//////////////////////TEXTURE INFORMATION ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////



	[Header("UNACTIVE == STICKERMODE /// ACTIVE == SPRITEMODE")]
	public bool OverlaySelection = false;
	private bool OverlaySelectionCurrent = false;

	/////////////////////////////////STICKER INFORMATION/////////////////////////////////
	// [Header("EditMode")]
	[Header("Set active to Edit STICKERPROPERTIES")]
	public bool EditValueSticker = false;

	[Header("StickerType")]
	[Range(1, 80)]      public int StickerType = 1;
						public Color BorderColor = Color.green;

	[Range(0, 1)]       public int MotionState = 1;
	[Range(1f, 100f)]   public float BorderSizeOne = 1f;
	[Range(1f, 100f)]   public float BorderSizeTwo = 1f;
	[Range(0f, 152f)]   public float BorderBlurriness = 1f;

	public float RangeSOne_One0 = 1f; // [Range(-1f, 1f)]  
	public float RangeSOne_One1 = 1f; // [Range(-1f, 1f)]  
	public float RangeSOne_One2 = 1f; // [Range(-1f, 1f)]  
	public float RangeSOne_One3 = 1f; // [Range(-1f, 1f)]  
	public float RangeSTen_Ten0 = 1f; // [Range(-10f, 10f)]
	public float RangeSTen_Ten1 = 1f; // [Range(-10f, 10f)]
	public float RangeSTen_Ten2 = 1f; // [Range(-10f, 10f)]
	public float RangeSTen_Ten3 = 1f; // [Range(-10f, 10f)]
	/////////////////////////////////STICKER INFORMATION/////////////////////////////////


	/////////////////////////////////SPRITE INFORMATION/////////////////////////////////

	[Header("Set active to Edit STICKERPROPERTIES")]
	public bool EditValueSprite = false;

	[Header("SPRITE SIZE X-AXIS")]
	public int InVariableRatioX = 1;
	[Header("SPRITE SIZE Y-AXIS")]
	public int InVariableRatioY = 1;
	[Header("TIME BETWEEN SPRITES")]
	public int InVariableTick  = 10;
    [Header("ACTIVE TO ADD OUTLINE")]
    public bool OutlineSprite = false;
	public Color OutlineColor = Color.black;    


	/////////////////////////////////SPRITE INFORMATION/////////////////////////////////


/////////////////////////////////////////////////////////////
//////// update information
/////////////////////////////////////////////////////////////



	private const string stringOverlaySelection =  "_OverlaySelection";

	
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

	private const string stringInVariableTick   =  "_InVariableTick";
	private const string stringInVariableRatioX =  "_InVariableRatioX";
	private const string stringInVariableRatioY =  "_InVariableRatioY";
    private const string stringOutlineSprite 	=  "_OutlineSprite";
    private const string stringOutlineColor 	=  "_OutlineColor";

	private int currentInstanceID;


	void Start()
	{
	
		EditValueSticker = false;
		EditValueSprite = false;

		currentInstanceID = gameObject.GetInstanceID();


		pathShader_string = "Shaders2D/CirclesDisco";
		


		//////////////////////////// CHANGE THIS TO FALSE TO SET RANDOM BACKGROUND ON STICKERS////////////// 
		if(UsePathShader_bool == true)
		{
			pathShader_string = GetRandomStringShaderPath(currentInstanceID);
			pathShader_string2 = GetRandomStringShaderPath(currentInstanceID + 10);

		}                       


		particleSystemRenderer = GetComponent<ParticleSystemRenderer>();
		// Debug.Log(particleSystemRenderer.material);
		// Debug.Log(particleSystemRenderer.material.shader);
		// Debug.Log(material);


		if (SystemInfo.supportsInstancing)
		{
			// material2.enableInstancing = true;
			// material.enableInstancing = true;
			// material2.enableInstancing = true;
		}

		material = new Material(Shader.Find(pathShader_string));

		particleSystemRenderer.material = material;



		float _OverlaySelectionFloat = (OverlaySelection)?1.0f:0.0f;

		material.SetFloat(stringOverlaySelection, _OverlaySelectionFloat);
		


		TextureToShaderSprite = (Texture2D)Resources.Load("SPRITE/" + TextureSprite);
		TextureToShaderChannel0 = (Texture2D)Resources.Load(TextureChannel0);
		TextureToShaderChannel1 = (Texture2D)Resources.Load(TextureChannel1);
		TextureToShaderChannel2 = (Texture2D)Resources.Load(TextureChannel2);
		TextureToShaderChannel3 = (Texture2D)Resources.Load(TextureChannel3);

		material.SetTexture(containerTextureSprite, TextureToShaderSprite);
		material.SetTexture(containerTextureChannel0, TextureToShaderChannel0);
		material.SetTexture(containerTextureChannel1, TextureToShaderChannel1);
		material.SetTexture(containerTextureChannel2, TextureToShaderChannel2);
		material.SetTexture(containerTextureChannel3, TextureToShaderChannel3);


		variableShaderInfoSprite = new ShaderInfoSprite
		{

			InVariableTick  = (float)InVariableTick,
			InVariableRatioX = (float)InVariableRatioX,
			InVariableRatioY = (float)InVariableRatioY,
			OutlineSprite = (float)((OutlineSprite)?1.0f:0.0f),
			OutlineColor = OutlineColor
		};


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
		SetInitialValuesRef(ref variableShaderInfo);
		material = SetMaterialPropertiesSticker(material);
		material = SetMaterialPropertiesSprite(material);

		currentStickerValue = (int)variableShaderInfo.StickerType;
 
		

	}


	static string GetRandomStringShaderPath(int valueSeed)
	{

		System.DateTime valueTime = new System.DateTime();

		int valueDateint = valueTime.Hour + valueTime.Minute + valueTime.Second;
		
		System.Random variableRandom = new System.Random(valueDateint + valueSeed);



		StickerNameClass.SetShaderPathNameStringArray();
		string[]  nameShaderArray = StickerNameClass.GetShaderPathNameStringArray();

		// foreach(string nameShader in nameShaderArray)
		// {
		//  Debug.Log("Name Shader Path == " + nameShader);
		// }

		int indexNameShaderArray = variableRandom.Next(0, nameShaderArray.Length);

		return nameShaderArray[indexNameShaderArray];
		
	}


	static Material SetMaterialPropertiesSticker(Material materialObject)
	{
		
		materialObject.SetFloat(stringStickerType,       variableShaderInfo.StickerType);
		materialObject.SetFloat(stringMotionState,       variableShaderInfo.MotionState);

		materialObject.SetColor(stringBorderColor,       variableShaderInfo.BorderColor);
		materialObject.SetFloat(stringBorderSizeOne,     variableShaderInfo.BorderSizeOne);
		materialObject.SetFloat(stringBorderSizeTwo,     variableShaderInfo.BorderSizeTwo);
		materialObject.SetFloat(stringBorderBlurriness,  variableShaderInfo.BorderBlurriness);

		materialObject.SetFloat(stringRangeSOne_One0,    variableShaderInfo.RangeSOne_One0);
		materialObject.SetFloat(stringRangeSOne_One1,    variableShaderInfo.RangeSOne_One1);
		materialObject.SetFloat(stringRangeSOne_One2,    variableShaderInfo.RangeSOne_One2);
		materialObject.SetFloat(stringRangeSOne_One3,    variableShaderInfo.RangeSOne_One3);

		materialObject.SetFloat(stringRangeSTen_Ten0,    variableShaderInfo.RangeSTen_Ten0);
		materialObject.SetFloat(stringRangeSTen_Ten1,    variableShaderInfo.RangeSTen_Ten1);
		materialObject.SetFloat(stringRangeSTen_Ten2,    variableShaderInfo.RangeSTen_Ten2);
		materialObject.SetFloat(stringRangeSTen_Ten3,    variableShaderInfo.RangeSTen_Ten3);

		return materialObject;

	}

	static Material SetMaterialPropertiesSprite(Material materialObject)
	{
		
		materialObject.SetFloat(stringInVariableTick,       variableShaderInfoSprite.InVariableTick);
		materialObject.SetFloat(stringInVariableRatioX,     variableShaderInfoSprite.InVariableRatioX);
		materialObject.SetFloat(stringInVariableRatioY,     variableShaderInfoSprite.InVariableRatioY);
		materialObject.SetFloat(stringOutlineSprite,     	variableShaderInfoSprite.OutlineSprite);
		materialObject.SetColor(stringOutlineColor, 		variableShaderInfoSprite.OutlineColor);

		return materialObject;

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


	void Update()
	{

		float timeNow = Time.realtimeSinceStartup;

		if(OverlaySelection == true && EditValueSprite == true)
		{

				variableShaderInfoSprite = new ShaderInfoSprite
				{		
					InVariableTick  = (float)InVariableTick,
					InVariableRatioX = (float)InVariableRatioX,
					InVariableRatioY = (float)InVariableRatioY,
					OutlineSprite = (float)((OutlineSprite)?1.0f:0.0f),
					OutlineColor = OutlineColor
				};

			
				material = SetMaterialPropertiesSprite(material);


		}  


		if(LOADTEXTUREONRUNTIME)
		{
			LOADTEXTUREONRUNTIME = false;

			TextureToShaderSprite = (Texture2D)Resources.Load("SPRITE/" + TextureSprite);
			TextureToShaderChannel0 = (Texture2D)Resources.Load(TextureChannel0);
			TextureToShaderChannel1 = (Texture2D)Resources.Load(TextureChannel1);
			TextureToShaderChannel2 = (Texture2D)Resources.Load(TextureChannel2);
			TextureToShaderChannel3 = (Texture2D)Resources.Load(TextureChannel3);
	
			material.SetTexture(containerTextureSprite, TextureToShaderSprite);
			material.SetTexture(containerTextureChannel0, TextureToShaderChannel0);
			material.SetTexture(containerTextureChannel1, TextureToShaderChannel1);
			material.SetTexture(containerTextureChannel2, TextureToShaderChannel2);
			material.SetTexture(containerTextureChannel3, TextureToShaderChannel3);

		}


		if(Path_LOADSHADERONRUNTIME)
		{

			Path_LOADSHADERONRUNTIME = false;

			string pathToShader = pathShader_string;

			Shader shaderOnRuntime  = Shader.Find(pathToShader);
			material.shader = shaderOnRuntime;

		}


		if(LOADSHADERONRUNTIME)
		{

			LOADSHADERONRUNTIME = false;
			StickerNameClass.SetShaderPathNameStringArray();
			string[] nameShaderArray = StickerNameClass.GetShaderPathNameStringArray();

			int currentEnumValue = (int)shaderName_enum;
			string nameShader_string = nameShaderArray[currentEnumValue];

			pathShader_string = nameShader_string;

			Shader shaderOnRuntime  = Shader.Find(nameShader_string);
			material.shader = shaderOnRuntime;

		}
		
		if(OverlaySelectionCurrent != OverlaySelection)
		{
			OverlaySelectionCurrent = OverlaySelection;

			float _OverlaySelectionFloat = (OverlaySelection)?1.0f:0.0f;
	
			material.SetFloat(stringOverlaySelection, _OverlaySelectionFloat);

		}


		if(EditValueSticker == true)
		{
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
	
			material = SetMaterialPropertiesSticker(material);
		
			if(((int)variableShaderInfo.StickerType )!= currentStickerValue)
			{
	
				SetInitialValuesRef(ref variableShaderInfo);
				currentStickerValue = (int) variableShaderInfo.StickerType;
			}
		}
		
	}
}

































































/*

// Debug.Log(particleSystemRenderer.activeTrailVertexStreamsCount);
// Debug.Log(particleSystemRenderer.activeVertexStreamsCount);
// Debug.Log(particleSystemRenderer.alignment);
// Debug.Log(particleSystemRenderer.allowRoll);
// Debug.Log(particleSystemRenderer.cameraVelocityScale);
// Debug.Log(particleSystemRenderer.enableGPUInstancing);
// Debug.Log(particleSystemRenderer.flip);
// Debug.Log(particleSystemRenderer.freeformStretching);
// Debug.Log(particleSystemRenderer.lengthScale);
// Debug.Log(particleSystemRenderer.maskInteraction);
// Debug.Log(particleSystemRenderer.maxParticleSize);
// Debug.Log(particleSystemRenderer.mesh);
// Debug.Log(particleSystemRenderer.meshCount);
// Debug.Log(particleSystemRenderer.meshDistribution);
// Debug.Log(particleSystemRenderer.minParticleSize);
// Debug.Log(particleSystemRenderer.normalDirection);
// Debug.Log(particleSystemRenderer.pivot);
// Debug.Log(particleSystemRenderer.renderMode);
// Debug.Log(particleSystemRenderer.rotateWithStretchDirection);
// Debug.Log(particleSystemRenderer.shadowBias);
// Debug.Log(particleSystemRenderer.sortingFudge);
// Debug.Log(particleSystemRenderer.sortMode);
// Debug.Log(particleSystemRenderer.supportsMeshInstancing);
// Debug.Log(particleSystemRenderer.trailMaterial);
// Debug.Log(particleSystemRenderer.velocityScale);

Debug.Log(particleSystemRenderer.gameObject + "                 "+  "The game object this component is attached to. A component is always attached to a game object.");
Debug.Log(particleSystemRenderer.tag + "                 "+     "The tag of this game object.");
Debug.Log(particleSystemRenderer.transform + "                 "+   "The Transform attached to this GameObject.");
Debug.Log(particleSystemRenderer.hideFlags + "                 "+   "Should the object be hidden, saved with the Scene or modifiable by the user?");
Debug.Log(particleSystemRenderer.name + "                 "+    "The name of the object.");
Debug.Log(particleSystemRenderer.allowOcclusionWhenDynamic + "                 "+   "Controls if dynamic occlusion culling should be performed for this renderer.");
Debug.Log(particleSystemRenderer.bounds + "                 "+  "The bounding box of the renderer in world space.");
Debug.Log(particleSystemRenderer.enabled + "                 "+     "Makes the rendered 3D object visible if enabled.");
Debug.Log(particleSystemRenderer.forceRenderingOff + "                 "+   "Allows turning off rendering for a specific component.");
Debug.Log(particleSystemRenderer.isPartOfStaticBatch + "                 "+     "Indicates whether the renderer is part of a static batch with other renderers.");
Debug.Log(particleSystemRenderer.isVisible + "                 "+   "Is this renderer visible in any camera? (Read Only)");
Debug.Log(particleSystemRenderer.lightmapIndex + "                 "+   "The index of the baked lightmap applied to this renderer.");
Debug.Log(particleSystemRenderer.lightmapScaleOffset + "                 "+     "The UV scale & offset used for a lightmap.");
Debug.Log(particleSystemRenderer.lightProbeProxyVolumeOverride + "                 "+   "If set, the Renderer will use the Light Probe Proxy Volume component attached to the source GameObject.");
Debug.Log(particleSystemRenderer.lightProbeUsage + "                 "+     "The light probe interpolation type.");
Debug.Log(particleSystemRenderer.localBounds + "                 "+     "The bounding box of the renderer in local space.");
Debug.Log(particleSystemRenderer.localToWorldMatrix + "                 "+  "Matrix that transforms a point from local space into world space (Read Only).");
Debug.Log(particleSystemRenderer.material + "                 "+    "Returns the first instantiated Material assigned to the renderer.");
Debug.Log(particleSystemRenderer.materials + "                 "+   "Returns all the instantiated materials of this object.");
Debug.Log(particleSystemRenderer.motionVectorGenerationMode + "                 "+  "Specifies the mode for motion vector rendering.");
Debug.Log(particleSystemRenderer.probeAnchor + "                 "+     "If set, Renderer will use this Transform's position to find the light or reflection probe.");
Debug.Log(particleSystemRenderer.rayTracingMode + "                 "+  "Describes how this renderer is updated for ray tracing.");
Debug.Log(particleSystemRenderer.realtimeLightmapIndex + "                 "+   "The index of the real-time lightmap applied to this renderer.");
Debug.Log(particleSystemRenderer.realtimeLightmapScaleOffset + "                 "+     "The UV scale & offset used for a real-time lightmap.");
Debug.Log(particleSystemRenderer.receiveShadows + "                 "+  "Does this object receive shadows?");
Debug.Log(particleSystemRenderer.reflectionProbeUsage + "                 "+    "Should reflection probes be used for this Renderer?");
Debug.Log(particleSystemRenderer.rendererPriority + "                 "+    "This value sorts renderers by priority. Lower values are rendered first and higher values are rendered last.");
Debug.Log(particleSystemRenderer.renderingLayerMask + "                 "+  "Determines which rendering layer this renderer lives on.");
Debug.Log(particleSystemRenderer.shadowCastingMode + "                 "+   "Does this object cast shadows?");
Debug.Log(particleSystemRenderer.sharedMaterial + "                 "+  "The shared material of this object.");
Debug.Log(particleSystemRenderer.sharedMaterials + "                 "+     "All the shared materials of this object.");
Debug.Log(particleSystemRenderer.sortingLayerID + "                 "+  "Unique ID of the Renderer's sorting layer.");
Debug.Log(particleSystemRenderer.sortingLayerName + "                 "+    "Name of the Renderer's sorting layer.");
Debug.Log(particleSystemRenderer.sortingOrder + "                 "+    "Renderer's order within a sorting layer.");
Debug.Log(particleSystemRenderer.staticShadowCaster + "                 "+  "Is this renderer a static shadow caster?");
Debug.Log(particleSystemRenderer.worldToLocalMatrix + "                 "+  "Matrix that transforms a point from world space into local space (Read Only).");

Debug.Log("");
Debug.Log("");
Debug.Log("");
Debug.Log("");
Debug.Log("");
Debug.Log("");
Debug.Log("");
Debug.Log("");
Debug.Log("");
Debug.Log("");
Debug.Log("");

Debug.Log(particleSystemRenderer.activeTrailVertexStreamsCount + "        " +   "The number of currently active custom trail vertex streams.");
Debug.Log(particleSystemRenderer.activeVertexStreamsCount + "        " +    "The number of currently active custom vertex streams.");
Debug.Log(particleSystemRenderer.alignment + "        " +   "Control the direction that particles face.");
Debug.Log(particleSystemRenderer.allowRoll + "        " +   "Allow billboard particles to roll around their z-axis.");
Debug.Log(particleSystemRenderer.cameraVelocityScale + "        " + "How much do the particles stretch depending on the Camera's speed.");
Debug.Log(particleSystemRenderer.enableGPUInstancing + "        " + "Enables GPU Instancing on platforms that support it.");
Debug.Log(particleSystemRenderer.flip + "        " +    "Flip a percentage of the particles, along each axis.");
Debug.Log(particleSystemRenderer.freeformStretching + "        " +  "Enables freeform stretching behavior.");
Debug.Log(particleSystemRenderer.lengthScale + "        " + "How much are the particles stretched in their direction of motion, defined as the length of the particle compared to its width.");
Debug.Log(particleSystemRenderer.maskInteraction + "        " + "Specifies how the Particle System Renderer interacts with SpriteMask.");
Debug.Log(particleSystemRenderer.maxParticleSize + "        " + "Clamp the maximum particle size.");
Debug.Log(particleSystemRenderer.mesh + "        " +    "The Mesh that the particle uses instead of a billboarded Texture.");
Debug.Log(particleSystemRenderer.meshCount + "        " +   "The number of Meshes the system uses for particle rendering.");
Debug.Log(particleSystemRenderer.meshDistribution + "        " +    "Specifies how the system randomly assigns meshes to particles.");
Debug.Log(particleSystemRenderer.minParticleSize + "        " + "Clamp the minimum particle size.");
Debug.Log(particleSystemRenderer.normalDirection + "        " + "Specifies how to calculate lighting for the billboard.");
Debug.Log(particleSystemRenderer.pivot + "        " +   "Modify the pivot point used for rotating particles.");
Debug.Log(particleSystemRenderer.renderMode + "        " +  "Specifies how the system draws particles.");
Debug.Log(particleSystemRenderer.rotateWithStretchDirection + "        " +  "Rotate the particles based on the direction they are stretched in. This is added on top of other particle rotation.");
Debug.Log(particleSystemRenderer.shadowBias + "        " +  "Apply a shadow bias to prevent self-shadowing artifacts. The specified value is the proportion of the particle size.");
Debug.Log(particleSystemRenderer.sortingFudge + "        " +    "Biases Particle System sorting amongst other transparencies.");
Debug.Log(particleSystemRenderer.sortMode + "        " +    "Specifies how to sort particles within a system.");
Debug.Log(particleSystemRenderer.supportsMeshInstancing + "        " +  "Determines whether the Particle System can be rendered using GPU Instancing.");
Debug.Log(particleSystemRenderer.trailMaterial + "        " +   "Set the Material that the TrailModule uses to attach trails to particles.");
Debug.Log(particleSystemRenderer.velocityScale + "        " +   "Specifies how much particles stretch depending on their velocity.");

*/