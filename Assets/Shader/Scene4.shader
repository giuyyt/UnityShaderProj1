// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Scene4"
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


            fixed4 DrawConeByMultipleCircle(float2 screenUV,float2 pos,float radiusInit,float step,int numIn,int numDe,int numPos,float ringThickness)
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
                    radiusNow = radiusNow-step;
                    posNow.y = posNow.y+numPos*step;
                    // DrawCircle(float2 screenUV,float2 pos,float radius)
                    // DrawGlowCircle(screenUV,posNow,radiusNow*0.2,radiusNow*0.95,radiusNow*1.05,20,20)
                    fixed4 _c8= DrawCircle(screenUV,posNow,radiusNow)*fixed4(Palette(
                    CircleRadius(screenUV,radiusNow)+posNow.y*5,
                    fixed3(0.8,0.5,0.4),
                    fixed3(0.2,0.4,0.2),
                    fixed3(2.0, 1.0, 1.0),
                    fixed3(0.00, 0.25, 0.25)),1)+DrawRing(screenUV,posNow,radiusNow,radiusNow+ringThickness)*fixed4(0,0,0,1);

                    

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
                


                


                fixed2 posNow1 = fixed2(0.3,0.3);
                fixed2 posNow2 = fixed2(0.3,0.7);
                
                fixed radiusNow2 = 0.2;




                
                
                fragColor = fragColor+DrawConeByMultipleCircle(screenUV,posNow1,radiusNow2,0.03,numIn,0,1,0.005);
                 fragColor = fragColor+DrawConeByMultipleCircle(screenUV,posNow2,radiusNow2,0.03,numIn,0,-1,0.005);


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