Shader "ShaderAlgorithm/3D/Shader_Lambert_Lit" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _AmbientColor ("Ambient Color", Color) = (0.1,0.1,0.1,1)
        _SpecularColor ("Specular Color", Color) = (1,1,1,1)
    }
    SubShader {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // 从CPU传递到GPU的数据结构
            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            uniform float4 _Color;
            uniform float4 _AmbientColor;
            uniform float4 _SpecularColor;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 frag (v2f i) : SV_Target {

                float4 diffuse = _Color;
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.vertex.xyz);

                float3 lightDir = _WorldSpaceLightPos0.xyz;
                lightDir = normalize(lightDir);

                // - Lambert (diffuse)
                // float NdotL = dot(i.normal, lightDir); // -1, 0(明暗交界线), 1

                // - Half-Lambert (diffuse)
                float NdotL = dot(i.normal, lightDir) * 0.5 + 0.5; // 0, 0.5(明暗交界线), 1
                NdotL = max(NdotL, 0.0); // 防止负数

                // 光照颜色
                float3 lightColor = float3(1, 0.9, 0.9) * NdotL;

                float3 specColor = _SpecularColor.rgb;
                if (NdotL > 0.0) {
                    // - Specular: Phong
                    // {
                    //     float shiness = 8.0; // 越大表面越光滑, 越小表面越粗糙
                    //     float3 reflectVec = reflect(-lightDir, i.normal);
                    //     specCo = pow(max(0.0, dot(viewDir, reflectVec)), shiness);
                    // }
                    
                    // - Specular: Blinn-Phong (性能更好, 效果略有差别-高光弱一些)
                    {
                        float shiness = 8.0; // 越大表面越光滑, 越小表面越粗糙
                        float3 halfVec = normalize(lightDir + viewDir);
                        float specPow = pow(max(0.0, dot(halfVec, i.normal)), shiness);
                        specColor += specPow;
                    }
                }

                float4 final = diffuse * float4(specColor, 1.0) * float4(lightColor, 1.0);

                // Ambient light
                final += _AmbientColor * 0.01f * diffuse;

                // Gamma Correction
                float gamma = 1.0f/2.2f;
                final = pow(final, gamma);

                return final;
            }
            ENDCG
        }
    }
}
