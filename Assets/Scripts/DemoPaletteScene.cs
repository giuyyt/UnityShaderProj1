using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;
using kmty.gist;
using static UnityEditor.ShaderData;

public class DemoPaletteScene : MonoBehaviour
{

    //https://blog.csdn.net/taecg/article/details/52693557
    protected Camera cam => Camera.main;
    protected RenderTexture debugTex;
    protected Material debugMat;

    [SerializeField]
    private GameObject quad;

    int w = 0;
    int h = 0;
    
    
    [Header("A")]
    [SerializeField] private float ax = 0.5f;
    [SerializeField] private float ay = 0.5f;
    [SerializeField] private float az = 0.5f;
    
    [Header("B")]
    [SerializeField] private float bx = 0.5f;
    [SerializeField] private float by = 0.5f;
    [SerializeField] private float bz = 0.5f;
    
    [Header("C")]
    [SerializeField] private float cx = 1f;
    [SerializeField] private float cy = 1f;
    [SerializeField] private float cz = 1f;
    
    [Header("D")]
    [SerializeField] private float dx = 0f;
    [SerializeField] private float dy = 0.33f;
    [SerializeField] private float dz = 0.67f;
    // Start is called before the first frame update
    void Start()
    {
        w = Screen.width;
        h = Screen.height;
        RenderTextureUtil.Build(ref debugTex, w, h);
        debugMat = quad.GetComponent<MeshRenderer>().material; 
    }

    //Palette的Shader来自Shadertoy：
    //https://www.shadertoy.com/view/ll2GD3
    //相关文章：
    //https://iquilezles.org/articles/palettes
    // Update is called once per frame
    void Update()
    {
        debugMat.SetFloat("ax", ax);
        debugMat.SetFloat("ay", ay);
        debugMat.SetFloat("az", az);
        
        debugMat.SetFloat("bx", bx);
        debugMat.SetFloat("by", by);
        debugMat.SetFloat("bz", bz);
        
        debugMat.SetFloat("cx", cx);
        debugMat.SetFloat("cy", cy);
        debugMat.SetFloat("cz", cz);
        
        debugMat.SetFloat("dx", dx);
        debugMat.SetFloat("dy", dy);
        debugMat.SetFloat("dz", dz);



        Graphics.Blit(null, debugTex, debugMat);

    }


    void OnGUI()
    {
        //if (moxi == null) return;
        var s = new Vector2(Screen.width, Screen.height);
        //GUI.DrawTexture(new Rect(0, 0, s.x, s.y), debugTex);

    }



}
