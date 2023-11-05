// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Scene3"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "CircleDraw.cginc"
            #include "ColorConvertion.cginc"
            #include "Motion.cginc"
            #include "SimplexNoise.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };


            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv=v.uv;
                return o;
            }

            

            fixed4 frag (v2f i) : SV_Target
            {

                
                //fixed2 posCircle = fixed2(1,0.5);

                fixed2 screenUV=i.uv;
                screenUV.x*=_ScreenParams.x/_ScreenParams.y;

                fixed4 _layer0=fixed4(0,0,0,0);

                fixed4 fragColor = _layer0;



                fixed2 posCircleNow3;
                fixed radiusNow = 0.04;
                fixed2 posCircleStable;

                for(int j = 0;j<8;j++)
                {
                    for(int i = 0;i<11;i++)
                    {
                        float rand1 = 0;
                        float rand2 = 0.6;
                        float rand3 = 1;

                        fixed3 colorF = fixed3(rand1,rand2,rand3);
                        fixed3 colorS = fixed3(1,1,1)-colorF;

                        //0.06*j+0.02,0.03+i*0.09
                        //0.06+i*0.085
                        posCircleStable = fixed2(0.03*j+0.19,0.3+i*0.05);
                        posCircleNow3 = LinearMotion(fixed2(posCircleStable.x,posCircleStable.y),fixed2(posCircleStable.x+0.009,posCircleStable.y-0.009),3,_Time.y,-screenUV.x*10);
                        fixed4 _c8=DrawGradientCircle(screenUV,posCircleStable,radiusNow/4,radiusNow/2,20)*fixed4(colorF,0);
                        fixed4 _c9=DrawGradientCircle(screenUV,posCircleNow3,radiusNow/4,radiusNow/2,20)*fixed4(colorS,0);
                        fragColor = fragColor+_c8+_c9;
                    }
                }
                
               

        
                

                

                //if(f)
                //{
                //    fragColor = fixed4(0,0,0,1);
                //}

                fixed4 fragColorRGB = CMYKtoRGB(fragColor);
                fragColorRGB.w = 1;



                return fragColorRGB;
            }
            ENDCG
        }
    }
}