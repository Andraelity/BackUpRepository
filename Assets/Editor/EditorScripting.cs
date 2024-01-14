using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

// using EditorInteraction;


// public class MyObject : ScriptableObject
// {
//     public int myInt = 42;
// }


// [CustomEditor(typeof(Plane_Renderer))]
public class EditorScripting : Editor
{
    // Start is called before the first frame update
    // void Start()
    // {
        
    // }

    // // Update is called once per frame
    // void Update()
    // {
        
    // }


        // public string custString = "String Here";
        // public bool groupEnabled;
        // public bool optionalSettings = true;
        // public float jumpMod = 1.0f;
        // public float impactMod = 0.5f;


 //    [MenuItem("Window / Custom Controls")]
 //    public static void ShowWindow()
 //    {
 //    	EditorWindow.GetWindow(typeof(EditorScripting));
 //    }
 //    private void OnGui()
 //    {
 //    	GUILayout.Label("Base Settings", EditorStyles.boldLabel);
 //    	custString = EditorGUILayout.TextField("Text Field", custString);

 //    	// groupEnabled = EditorGUILayout.BeginToogleGroup("Optional Settings", groupEnabled);
 //    	optionalSettings = EditorGUILayout.Toggle("Double Jumping Enabled", optionalSettings);
 //    	jumpMod = EditorGUILayout.Slider("Jump Modifier", jumpMod, -5, 5);
 //    	impactMod = EditorGUILayout.Slider("Impact Modifier", impactMod, -5, 5);
 //    	EditorGUILayout.EndToggleGroup();

 //    	GUI.backgroundColor = Color.red;
 //    	GUILayout.FlexibleSpace();
 //    	EditorGUILayout.BeginHorizontal();
 //    	GUILayout.FlexibleSpace();

 //    	if(GUILayout.Button("Reset", GUILayout.Width(100), GUILayout.Height(30)))
 //    	{
 //    		custString = "String Here";
 //    		optionalSettings = false;
 //    		jumpMod = 1.0f;
 //    		impactMod = 0.5f;
 //    	}

 //    	EditorGUILayout.EndHorizontal();

 //    }



    // EditorInteractionClass.StickerType;
    // EditorInteractionClass.BorderColor;
    // EditorInteractionClass.BorderSizeOne;
    // EditorInteractionClass.BorderSizeTwo;
    // EditorInteractionClass.BorderBlurriness;
    // EditorInteractionClass.RangeSTen_Ten0;
    // EditorInteractionClass.RangeSTen_Ten1;
    // EditorInteractionClass.RangeSTen_Ten2;
    // EditorInteractionClass.RangeSTen_Ten3;
    // EditorInteractionClass.RangeSOne_One0;
    // EditorInteractionClass.RangeSOne_One1;
    // EditorInteractionClass.RangeSOne_One2;
    // EditorInteractionClass.RangeSOne_One3;


    float thumbnailWidth = 70;
    float thumbnailHeight = 70;
    float labelWidth = 150f;

    string playerName = "Player 1";
    string playerLevel = "1";
    string playerElo = "5";
    string playerScore = "100";

    bool showPosition = true;
    string status = "Select a GameObject";

    public string[] options = new string[] {"Cube", "Sphere", "Plane"};
    public int index = 0;


    int selGridInt = 0;
    string[] selStrings = {"radio1", "radio2", "radio3"};

    static float scale = 0.0f;

    public static string textToSend = "Numero";

    static Color valueColor = Color.red;

    void OnGUI()
    {

    
    }

    public override void OnInspectorGUI()
    {
        GUILayout.Label("I am a label");


        if(GUILayout.Button("I am a button"))
        {
            Debug.Log("I have been pressed");
        }


        GUILayout.BeginHorizontal();
        // selGridInt = GUILayout.SelectionGrid(selGridInt, selStrings, 1,GUILayout.Width(labelWidth));
        selGridInt = GUILayout.Toolbar(selGridInt, selStrings);
    
        GUILayout.EndHorizontal();
        
        GUILayout.BeginVertical("Box");
            selGridInt = GUILayout.SelectionGrid(selGridInt, selStrings, 1);
        GUILayout.EndVertical();
    
        GUILayout.Space(20f); //2
        GUILayout.Label("Custom Editor Elements", EditorStyles.boldLabel); //3
        
        GUILayout.Space(10f);
        GUILayout.Label("Player Preferences");
        
        GUILayout.BeginHorizontal(); //4
        GUILayout.Label("Player Name", GUILayout.Width(labelWidth)); //5
        playerName = GUILayout.TextField(playerName); //6
        GUILayout.EndHorizontal(); //7
        
        GUILayout.BeginHorizontal();
        GUILayout.Label("Player Level", GUILayout.Width(labelWidth));
        playerLevel = GUILayout.TextField(playerLevel);
        GUILayout.EndHorizontal();
        
        GUILayout.BeginHorizontal();
        GUILayout.Label("Player Elo", GUILayout.Width(labelWidth));
        playerElo = GUILayout.TextField(playerElo);
        GUILayout.EndHorizontal();
        
        GUILayout.BeginHorizontal();
        GUILayout.Label("Player Score", GUILayout.Width(labelWidth)); 
        playerScore = GUILayout.TextField(playerScore);
        GUILayout.EndHorizontal();
        
        GUILayout.BeginHorizontal();
        
        if (GUILayout.Button("Save")) //8
        {
            PlayerPrefs.SetString("PlayerName", playerName); //9
            PlayerPrefs.SetString("PlayerLevel", playerLevel);
            PlayerPrefs.SetString("PlayerElo", playerElo);
            PlayerPrefs.SetString("PlayerScore", playerScore);
        
            Debug.Log("PlayerPrefs Saved");
        }
        
        if (GUILayout.Button("Reset")) //10
        {
            PlayerPrefs.DeleteAll();
            Debug.Log("PlayerPrefs Reset");
        }
        
        GUILayout.EndHorizontal();
    
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("My Label");
        EditorGUILayout.TextField("enter your text here...");
        EditorGUILayout.EndHorizontal();


//     // showPosition = EditorGUILayout.Foldout(showPosition, status);
//     //     if (showPosition)
//     //         if (Selection.activeTransform)
//     //         {
//     //             Selection.activeTransform.position =
//     //                 EditorGUILayout.Vector3Field("Position", Selection.activeTransform.position);
//     //             status = Selection.activeTransform.name;
//     //         }


        index = EditorGUILayout.Popup(index, options);
    
        // MyObject obj = ScriptableObject.CreateInstance<MyObject>();
        // SerializedObject serializedObject = new UnityEditor.SerializedObject(obj);
        // SerializedProperty serializedPropertyMyInt = serializedObject.FindProperty("myInt");
    
        // EditorGUILayout.BeginHorizontal();
        // EditorGUILayout.PropertyField(serializedPropertyMyInt,  new GUIContent("GameObject"));
        // EditorGUILayout.EndHorizontal();
        
        scale = EditorGUILayout.Slider(scale, 1, 100);
        
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("My Label");
        textToSend = EditorGUILayout.TextField("");
        EditorGUILayout.EndHorizontal();
        
    
        EditorGUILayout.LabelField(textToSend);
    
        // EditorInteractionClass.BorderColor = EditorGUILayout.ColorField("ColorBorder", EditorInteractionClass.BorderColor);

    }


}
