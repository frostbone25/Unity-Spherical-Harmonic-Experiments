Shader "ZH3_Demo"
{
    Properties
    {
        [ToggleUI] _LumAxis("Use shared luminance axis", Int) = 0
        [ToggleUI] _L2("Include L2 contribution", Int) = 0
    }
    SubShader
    {
        Pass
        {
            Tags { "RenderType" = "Opaque" "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            #include "ZH3.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };   

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            bool _LumAxis;
            bool _L2;

            float4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.normal);
                float3 col;
                if (_LumAxis)
                {
                    if (_L2)
                    {
                        col = ShadeSH9_ZH3Hallucinate_LumAxis(float4(normal, 1));
                    }
                    else
                    {
                        col = SHEvalLinearL0L1_ZH3Hallucinate_LumAxis(float4(normal, 1));
                    }
                }
                else
                {
                    if (_L2)
                    {
                        col = ShadeSH9_ZH3Hallucinate(float4(normal, 1));
                    }
                    else
                    {
                        col = SHEvalLinearL0L1_ZH3Hallucinate(float4(normal, 1));
                    }
                }
                return float4(col, 1);
            }
            ENDCG
        }
    }
}
