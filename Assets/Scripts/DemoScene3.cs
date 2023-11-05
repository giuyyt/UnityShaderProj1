using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;
using kmty.gist;
using static UnityEditor.ShaderData;

public class DemoScene3 : MonoBehaviour
{

    //https://blog.csdn.net/taecg/article/details/52693557
    protected Camera cam => Camera.main;
    protected RenderTexture debugTex;
    protected Material debugMat;

    [SerializeField]
    private GameObject quad;

    int w = 0;
    int h = 0;

    private int numIn=0;

    private float timeNow;

    [SerializeField] private float timeMax = 0.1f;
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
        timeNow += Time.deltaTime;
        if (timeNow > timeMax)
        {
            timeNow = 0;
            numIn++;
        }

        debugMat.SetInt("numIn", numIn);



        Graphics.Blit(null, debugTex, debugMat);

    }


    void OnGUI()
    {
        //if (moxi == null) return;
        var s = new Vector2(Screen.width, Screen.height);
        //GUI.DrawTexture(new Rect(0, 0, s.x, s.y), debugTex);

    }



}
