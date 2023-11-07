using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;
using kmty.gist;
using static UnityEditor.ShaderData;

public class DemoScene5 : MonoBehaviour
{

    //https://blog.csdn.net/taecg/article/details/52693557
    protected Camera cam => Camera.main;
    protected RenderTexture debugTex;
    protected Material debugMat;

    [SerializeField]
    private GameObject quad;

    int w = 0;
    int h = 0;

    
    [Header("LineFirst")]
    [SerializeField] private float k1 = 0.3f;
    [SerializeField] private float b1 = 0.5f;
    [SerializeField] private float chanceK1 = 40f;
    [SerializeField] private float colorK1 = 7f;
    [Range(0,1)]
    [SerializeField] private int isFirstLineShow = 1;
    
    [Header("LineSecond")]
    [SerializeField] private float k2 = 0.3f;
    [SerializeField] private float b2 = 0.5f;
    [SerializeField] private float chanceK2 = 40f;
    [SerializeField] private float colorK2 = 7f;
    [Range(0,1)]
    [SerializeField] private int isSecondLineShow = 1;
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
        debugMat.SetFloat("k1", k1);
        debugMat.SetFloat("b1", b1);
        debugMat.SetFloat("chanceK1",chanceK1);
        debugMat.SetFloat("colorK1",colorK1);
        debugMat.SetInt("isFirstLineShow",isFirstLineShow);
        
        debugMat.SetFloat("k2", k2);
        debugMat.SetFloat("b2", b2);
        debugMat.SetFloat("chanceK2",chanceK2);
        debugMat.SetFloat("colorK2",colorK2);
        debugMat.SetInt("isSecondLineShow",isSecondLineShow);



        Graphics.Blit(null, debugTex, debugMat);

    }


    void OnGUI()
    {
        //if (moxi == null) return;
        var s = new Vector2(Screen.width, Screen.height);
        //GUI.DrawTexture(new Rect(0, 0, s.x, s.y), debugTex);

    }



}
