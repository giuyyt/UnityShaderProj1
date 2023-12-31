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
            #include "Color.cginc"

            int numIn;

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


            fixed4 DrawConeByMultipleCircle(float2 screenUV,float2 pos,float radiusInit,float step,int numIn,float skew,int numDe)
            {
                int num = ceil(radiusInit/step);
                fixed radiusNow =  radiusInit;
                fixed2 posNow = pos;
                fixed4 resColor = fixed4(0,0,0,0);
                if(numDe>numIn)return resColor;
                else numIn = numIn-numDe;
                for(int i=0;i<numIn;i++)
                {
                    if(i>num)break;
                    radiusNow = radiusNow-0.005;
                    posNow.y = posNow.y+skew;
                    // DrawCircle(float2 screenUV,float2 pos,float radius)
                    // DrawGlowCircle(screenUV,posNow,radiusNow*0.2,radiusNow*0.95,radiusNow*1.05,20,20)
                    fixed4 _c8= DrawCircle(screenUV,posNow,radiusNow)*fixed4(Palette(
                    CircleRadius(screenUV,radiusNow)+posNow.y*2+_Time.y*0.1,
                    fixed3(0.5,0.5,0.5),
                    fixed3(0.5,0.5,0.5),
                    fixed3(2.0, 1.0, 0.0),
                    fixed3(0.50, 0.20, 0.25)),1)+DrawRing(screenUV,posNow,radiusNow,radiusNow+0.001)*fixed4(0,0,0,1);

                    

                    if(_c8.r<0.001f&&_c8.g<0.001f&&_c8.b<0.001f&&_c8.a<0.001f)continue;
                    else resColor = _c8;
                    
                }

                return resColor;
                
            }


            fixed4 fcos(fixed4 x )
            {
                fixed4 w = fwidth(x);
	            #if 1
                return cos(x) * sin(0.5*w)/(0.5*w);       // exact
	            #else
                return cos(x) * smoothstep(6.2832,0.0,w); // approx
	            #endif    
            }   
    
            

            fixed4 frag (v2f i) : SV_Target
            {

                
                //fixed2 posCircle = fixed2(1,0.5);

                fixed2 screenUV=i.uv;
                screenUV.x*=_ScreenParams.x/_ScreenParams.y;


                fixed4 fragColor = fixed4(0,0,0,0);
                fixed4 _layer0=fixed4(0.01,0.02,0.05,1);
                


                

                fixed2 posNow = fixed2(0.2,0.6);
                fixed2 posNow2 = fixed2(0.3,0.32);
                fixed2 posNow3 = fixed2(0.4,0.6);
                fixed2 posNow4 = fixed2(0.4,0.85);
                fixed2 posNow5 = fixed2(0.2,0.85);
                fixed2 posNow6 = fixed2(0.3,0.73);
                fixed2 posNow7 = fixed2(0.47,0.73);
                fixed2 posNow8= fixed2(0.13,0.73);

                
                fixed radiusNow = 0.1;
                fixed radiusNow2 = 0.2;
                fixed radiusNow3 = 0.1;
                fixed radiusNow4 = 0.08;
                fixed radiusNow5 = 0.08;
                fixed radiusNow6 = 0.03;
                fixed radiusNow7 = 0.03;
                fixed radiusNow8 = 0.03;

                int numDe1 = 50;
                int numDe2 = 75;
                int numDe3 = 95;

                

               fragColor = fragColor+ DrawConeByMultipleCircle(screenUV,posNow,radiusNow,0.003,numIn,0.007,numDe1);
                fragColor = fragColor+DrawConeByMultipleCircle(screenUV,posNow2,radiusNow2,0.003,numIn,0.003,0);
                fragColor = fragColor+DrawConeByMultipleCircle(screenUV,posNow3,radiusNow3,0.003,numIn,0.007,numDe1);
                fragColor = fragColor+DrawConeByMultipleCircle(screenUV,posNow4,radiusNow4,0.003,numIn,0.003,numDe2);
                fragColor = fragColor+DrawConeByMultipleCircle(screenUV,posNow5,radiusNow5,0.003,numIn,0.003,numDe2);
                fragColor = fragColor+DrawConeByMultipleCircle(screenUV,posNow6,radiusNow6,0.003,numIn,0.01,numDe3);
                fragColor = fragColor+DrawConeByMultipleCircle(screenUV,posNow7,radiusNow7,0.003,numIn,0.01,numDe3);
                fragColor = fragColor+DrawConeByMultipleCircle(screenUV,posNow8,radiusNow8,0.003,numIn,0.01,numDe3);

                //DrawCircle(float2 screenUV,float2 pos,float radius)
                //DrawRing(screenUV,posNow5,radiusNow,radiusNow+0.1)*fixed4(1,1,1,1)
                
                fragColor = fragColor;
                
                
               

                if(fragColor.x <0.001&&fragColor.y <0.001&&fragColor.z <0.001&&fragColor.w <0.001)
                {
                    fragColor = _layer0;
                }
                

                

                //if(f)
                //{
                //    fragColor = fixed4(0,0,0,1);
                //}

                // fixed4 fragColorRGB = CMYKtoRGB(fragColor);
                // fragColorRGB.w = 1;



                return fragColor;
            }
            ENDCG
        }
    }
}