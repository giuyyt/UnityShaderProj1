// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/CircleTest"
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

            float _Angle1;
			float _Angle2;
			float _Angle3;
            float _Angle4;
            float _Angle5;
            float _Angle6;
            float _Angle7;

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

                

                fixed2 posCircleNow1 = CircularMotion(fixed2(0.3,0.55),0.03,-2,_Time.y,0);
                fixed2 posCircleNow2 = CircularMotion(fixed2(0.28,0.5),0.1,3.2,_Time.y,3.14);
                fixed2 posCircleNow3 = CircularMotion(fixed2(0.32,0.5),0.1,-3.2,_Time.y,0);
                fixed2 posCircleNow4 = CircularMotion(fixed2(0.3,0.3),0.03,2,_Time.y,0);
                fixed radiusNow = 0.25;

                

                //fixed4 _c0=DrawHSVCircle(screenUV,posCircleNow,radiusNow,
                //50,90.0,
                //20.0,0.02,
                //100);


                
            //fixed4 _c0 =  DrawHalfConstantHueCircle(screenUV,posCircleNow,radiusNow,
            //0,_Angle1,
            //10.0,0.02,
            //1,120.0,80.0);

            //            fixed4 _c1 =  DrawHalfConstantHueCircle(screenUV,posCircleNow,radiusNow,
            //0,_Angle2,
            //10.0,0.02,
            //1,240.0,80.0);

            //            fixed4 _c2 =  DrawHalfConstantHueCircle(screenUV,posCircleNow,radiusNow,
            //0,_Angle3,
            //10.0,0.02,
            //1,0.0,80.0);

            //                        fixed4 _c3 =  DrawHalfConstantHueCircle(screenUV,posCircleNow,radiusNow,
            //0,_Angle4,
            //10.0,0.02,
            //1,120.0,80.0);

            //                        fixed4 _c4 =  DrawHalfConstantHueCircle(screenUV,posCircleNow,radiusNow,
            //0,_Angle5,
            //10.0,0.02,
            //1,240.0,80.0);

            //                                    fixed4 _c5 =  DrawHalfConstantHueCircle(screenUV,posCircleNow,radiusNow,
            //0,_Angle6,
            //10.0,0.02,
            //1,0.0,80.0);

            //                                    fixed4 _c6 =  DrawHalfConstantHueCircle(screenUV,posCircleNow,radiusNow,
            //0,_Angle7,
            //10.0,0.02,
            //1,0.0,80.0);


            
                fixed4 _c7=DrawGradientCircle(screenUV,posCircleNow1,radiusNow/4,radiusNow/2,0.5)*fixed4(1,0,0,0);
                fixed4 _c8=DrawGradientCircle(screenUV,posCircleNow2,radiusNow/4,radiusNow/2,0.5)*fixed4(0,1,0,0);
                fixed4 _c9=DrawGradientCircle(screenUV,posCircleNow3,radiusNow/4,radiusNow/2,0.5)*fixed4(0,0,1,0);
                fixed4 _c10=DrawGradientCircle(screenUV,posCircleNow4,radiusNow/4,radiusNow/2,0.5)*fixed4(0,1,1,0);
                //fixed4 _c7=DrawCircle(screenUV,posCircleNow,radiusNow/18)*fixed4(0.5,0.5,0.5,1);
                //fixed4 _c1 = DrawHSVCircle(screenUV,fixed2(0.8,0.4),0.3,-73,24.0);
                //fixed4 _c2 = DrawHSVCircle(screenUV,fixed2(1.2,0.7),0.4,57,143.0);
                //fixed4 _c1=DrawCircle(screenUV,fixed2(0.6,0.5),0.4)*fixed4(0,1,0,1);
                //fixed4 _c2=DrawCircle(screenUV,fixed2(0.8,0.5),0.2)*fixed4(0,0,1,1);

                //fixed4 fragColor = normalize(_layer0+_c0+_c1+_c2+_c3+_c4+_c5+_c6)*4;
                fixed4 fragColor = _layer0+_c7+_c8+_c9;

                

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