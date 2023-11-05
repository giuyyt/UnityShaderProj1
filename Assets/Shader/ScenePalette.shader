Shader "Converted/Template"
{
    Properties
    {
        _MainTex ("iChannel0", 2D) = "white" {}
        _SecondTex ("iChannel1", 2D) = "white" {}
        _ThirdTex ("iChannel2", 2D) = "white" {}
        _FourthTex ("iChannel3", 2D) = "white" {}
        _Mouse ("Mouse", Vector) = (0.5, 0.5, 0.5, 0.5)
        [ToggleUI] _GammaCorrect ("Gamma Correction", Float) = 1
        _Resolution ("Resolution (Change if AA is bad)", Range(1, 1024)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float ax,ay,az;
            float bx,by,bz;
            float cx,cy,cz;
            float dx,dy,dz;

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

            // Built-in properties
            sampler2D _MainTex;   float4 _MainTex_TexelSize;
            sampler2D _SecondTex; float4 _SecondTex_TexelSize;
            sampler2D _ThirdTex;  float4 _ThirdTex_TexelSize;
            sampler2D _FourthTex; float4 _FourthTex_TexelSize;
            float4 _Mouse;
            float _GammaCorrect;
            float _Resolution;

            // GLSL Compatability macros
            #define glsl_mod(x,y) (((x)-(y)*floor((x)/(y))))
            #define texelFetch(ch, uv, lod) tex2Dlod(ch, float4((uv).xy * ch##_TexelSize.xy + ch##_TexelSize.xy * 0.5, 0, lod))
            #define textureLod(ch, uv, lod) tex2Dlod(ch, float4(uv, 0, lod))
            #define iResolution float3(_Resolution, _Resolution, _Resolution)
            #define iFrame (floor(_Time.y / 60))
            #define iChannelTime float4(_Time.y, _Time.y, _Time.y, _Time.y)
            #define iDate float4(2020, 6, 18, 30)
            #define iSampleRate (44100)
            #define iChannelResolution float4x4(                      \
                _MainTex_TexelSize.z,   _MainTex_TexelSize.w,   0, 0, \
                _SecondTex_TexelSize.z, _SecondTex_TexelSize.w, 0, 0, \
                _ThirdTex_TexelSize.z,  _ThirdTex_TexelSize.w,  0, 0, \
                _FourthTex_TexelSize.z, _FourthTex_TexelSize.w, 0, 0)

            // Global access to uv data
            static v2f vertex_output;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv =  v.uv;
                return o;
            }

            float3 pal(in float t, in float3 a, in float3 b, in float3 c, in float3 d)
            {
                return a+b*cos(6.28318*(c*t+d));
            }

            float4 frag (v2f __vertex_output) : SV_Target
            {
                vertex_output = __vertex_output;
                float4 fragColor = 0;
                float2 fragCoord = vertex_output.uv * _Resolution;
                float2 p = fragCoord.xy/iResolution.xy;
                p.x += 0.05*_Time.y;
                float3 col = pal(p.x, float3(ax, ay, az), float3(bx, by, bz), float3(cx, cy, cz), float3(dx, dy, dz));
                if (p.y>1./7.)
                    col = pal(p.x, float3(0.5, 0.5, 0.5), float3(0.5, 0.5, 0.5), float3(1., 1., 1.), float3(0., 0.1, 0.2));
                    
                if (p.y>2./7.)
                    col = pal(p.x, float3(0.5, 0.5, 0.5), float3(0.5, 0.5, 0.5), float3(1., 1., 1.), float3(0.3, 0.2, 0.2));
                    
                if (p.y>3./7.)
                    col = pal(p.x, float3(0.5, 0.5, 0.5), float3(0.5, 0.5, 0.5), float3(1., 1., 0.5), float3(0.8, 0.9, 0.3));
                    
                if (p.y>4./7.)
                    col = pal(p.x, float3(0.5, 0.5, 0.5), float3(0.5, 0.5, 0.5), float3(1., 0.7, 0.4), float3(0., 0.15, 0.2));
                    
                if (p.y>5./7.)
                    col = pal(p.x, float3(0.5, 0.5, 0.5), float3(0.5, 0.5, 0.5), float3(2., 1., 0.), float3(0.5, 0.2, 0.25));
                    
                if (p.y>6./7.)
                    col = pal(p.x, float3(0.8, 0.5, 0.4), float3(0.2, 0.4, 0.2), float3(2., 1., 1.), float3(0., 0.25, 0.25));
                    
                float f = frac(p.y*7.);
                col *= smoothstep(0.49, 0.47, abs(f-0.5));
                col *= 0.5+0.5*sqrt(4.*f*(1.-f));
                fragColor = float4(col, 1.);
                if (_GammaCorrect) fragColor.rgb = pow(fragColor.rgb, 2.2);
                return fragColor;
            }
            ENDCG
        }
    }
}
