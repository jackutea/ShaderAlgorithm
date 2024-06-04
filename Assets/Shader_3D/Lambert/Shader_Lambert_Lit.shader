Shader "ShaderAlgorithm/3D/Shader_Lambert_Lit"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _AmbientColor ("Ambient Color", Color) = (0.1,0.1,0.1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            uniform float4 _Color;
            uniform float4 _AmbientColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float d = dot(i.normal, lightDir);
                d = max(d, 0);
                
                return _Color * d;
            }
            ENDCG
        }
    }
}
