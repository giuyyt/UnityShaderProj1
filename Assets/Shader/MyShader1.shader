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

#if 1
            float3 intersectCoordSys(in float3 ro, in float3 rd, float3 dc, float3 du, float3 dv)
            {
                float3 oc = ro-dc;
                return float3(dot(cross(du, dv), oc), dot(cross(oc, du), rd), dot(cross(dv, oc), rd))/dot(cross(dv, du), rd);
            }

#else
            float3 intersectCoordSys(in float3 ro, in float3 rd, float3 dc, float3 du, float3 dv)
            {
                float3 oc = ro-dc;
                float3 no = cross(du, dv);
                float t = -dot(no, oc)/dot(rd, no);
                float r = dot(du, oc+rd*t);
                float s = dot(dv, oc+rd*t);
                return float3(t, s, r);
            }

#endif
            float3 hash3(float n)
            {
                return frac(sin(float3(n, n+1., n+2.))*float3(43758.547, 12578.1455, 19642.35));
            }

            float3 shade(in float4 res)
            {
                float ra = length(res.yz);
                float an = atan2(res.y, res.z)+2.*_Time.y;
                float pa = sin(3.*an);
                float3 cola = 0.5+0.5*sin(res.w/32.*3.5+float3(0., 1., 2.));
                float3 col = ((float3)0.);
                col += cola*0.4*(1.-smoothstep(0.9, 1., ra));
                col += cola*1.*(1.-smoothstep(0., 0.03, abs(ra-0.8)))*(0.5+0.5*pa);
                col += cola*1.*(1.-smoothstep(0., 0.2, abs(ra-0.8)))*(0.5+0.5*pa);
                col += cola*0.5*(1.-smoothstep(0.05, 0.1, abs(ra-0.5)))*(0.5+0.5*pa);
                col += cola*0.7*(1.-smoothstep(0., 0.3, abs(ra-0.5)))*(0.5+0.5*pa);
                return col*0.3;
            }

            float3 render(in float3 ro, in float3 rd)
            {
                float3 col = ((float3)0.);
                for (int i = 0;i<32; i++)
                {
                    float3 r = 1.5*(-1.+2.*hash3(float(i)));
                    float3 u = normalize(r.zxy);
                    float3 v = normalize(cross(u, float3(0., 1., 0.)));
                    float3 tmp = intersectCoordSys(ro, rd, r, u, v);
                    if (dot(tmp.yz, tmp.yz)<1.&&tmp.x>0.)
                    {
                        col += shade(float4(tmp, float(i)));
                    }
                    
                }
                return col;
            }

            float4 frag (v2f __vertex_output) : SV_Target
            {
                vertex_output = __vertex_output;
                float4 fragColor = 0;
                float2 fragCoord = vertex_output.uv * _Resolution;
                float2 p = (2.*fragCoord-iResolution.xy)/iResolution.y;
                float3 ro = 1.5*float3(cos(0.05*_Time.y), 0., sin(0.05*_Time.y));
                float3 ta = float3(0., 0., 0.);
                float3 ww = normalize(ta-ro);
                float3 uu = normalize(cross(ww, float3(0., 1., 0.)));
                float3 vv = normalize(cross(uu, ww));
                float3 rd = normalize(p.x*uu+p.y*vv+1.*ww);
                float3 col = render(ro, rd);
                fragColor = float4(col, 1.);
                if (_GammaCorrect) fragColor.rgb = pow(fragColor.rgb, 2.2);
                return fragColor;
            }
            ENDCG
        }
    }
}
