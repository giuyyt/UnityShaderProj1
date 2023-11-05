using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;
using kmty.gist;
using static UnityEditor.ShaderData;

public class Demo : MonoBehaviour
{

    //https://blog.csdn.net/taecg/article/details/52693557
    protected Camera cam => Camera.main;
    protected RenderTexture debugTex;
    protected Material debugMat;

    [SerializeField]
    private GameObject quad;

    int w = 0;
    int h = 0;

    private float angle1,angle2,angle3,angle4,angle5,angle6,angle7;
    // Start is called before the first frame update
    void Start()
    {
        w = Screen.width;
        h = Screen.height;
        RenderTextureUtil.Build(ref debugTex, w, h);
        debugMat = quad.GetComponent<MeshRenderer>().material; 
    }

    // Update is called once per frame
    void Update()
    {

        debugMat.SetFloat("_Angle1", angle1);
        debugMat.SetFloat("_Angle2", angle2);
        debugMat.SetFloat("_Angle3", angle3);
        debugMat.SetFloat("_Angle4", angle4);
        debugMat.SetFloat("_Angle5", angle5);
        debugMat.SetFloat("_Angle6", angle6);
        debugMat.SetFloat("_Angle7", angle7);

        Graphics.Blit(null, debugTex, debugMat);

    }


    void OnGUI()
    {
        //if (moxi == null) return;
        var s = new Vector2(Screen.width, Screen.height);
        //GUI.DrawTexture(new Rect(0, 0, s.x, s.y), debugTex);

    }



}
