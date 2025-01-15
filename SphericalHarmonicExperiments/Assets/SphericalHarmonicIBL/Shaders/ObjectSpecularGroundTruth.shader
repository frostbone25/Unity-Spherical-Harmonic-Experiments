Shader "Unlit/ObjectSpecularGroundTruth"
{
    Properties
    {
        [Header(Rendering)]
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Int) = 2

        [Header(Environment)]
        _InputCubemap("Input Cubemap", CUBE) = "white" {}

        [Header(Quality)]
        //_SampleCount("Sample Count", Int) = 512
        _SampleCount("Sample Count", Range(1, 64)) = 16
        [Toggle(_USE_BLUE_NOISE)] _UseBlueNoise("Use Blue Noise", Float) = 0
        _BlueNoise("Blue Noise Stack", 3D) = "white" {}
        _BlueNoiseResolution("BlueNoise", Vector) = (64, 64, 64, 0)

        [Header(Material)]
        _Smoothness("Smoothness", Range(0, 1)) = 0.75
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        Cull[_CullMode]

        Pass
        {
            Name "ObjectSpecularGroundTruth_ForwardBase"

            Tags
            {
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM
            #pragma vertex vertex_forward_base
            #pragma fragment fragment_forward_base

            //||||||||||||||||||||||||||||| UNITY3D KEYWORDS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D KEYWORDS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D KEYWORDS |||||||||||||||||||||||||||||

            #pragma multi_compile_fwdbase

            //||||||||||||||||||||||||||||| SHADER KEYWORDS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| SHADER KEYWORDS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| SHADER KEYWORDS |||||||||||||||||||||||||||||

            #pragma shader_feature_local _USE_BLUE_NOISE

            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UNITY3D INCLUDES |||||||||||||||||||||||||||||

            //BUILT IN RENDER PIPELINE
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "UnityShadowLibrary.cginc"
            #include "UnityLightingCommon.cginc"
            #include "UnityStandardBRDF.cginc"

            //||||||||||||||||||||||||||||| SHADER PARAMETERS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| SHADER PARAMETERS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| SHADER PARAMETERS |||||||||||||||||||||||||||||

            samplerCUBE _InputCubemap;
            int _SampleCount;
            float _Smoothness;
            float _Seed;

            sampler3D _BlueNoise;
            float3 _BlueNoiseResolution;

            //||||||||||||||||||||||||||||| RANDOM FUNCTIONS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| RANDOM FUNCTIONS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| RANDOM FUNCTIONS |||||||||||||||||||||||||||||

            // A single iteration of Bob Jenkins' One-At-A-Time hashing algorithm.
            uint JenkinsHash(uint x)
            {
                x += (x << 10u);
                x ^= (x >> 6u);
                x += (x << 3u);
                x ^= (x >> 11u);
                x += (x << 15u);
                return x;
            }

            // Compound versions of the hashing algorithm.
            uint JenkinsHash(uint2 v)
            {
                return JenkinsHash(v.x ^ JenkinsHash(v.y));
            }

            uint JenkinsHash(uint3 v)
            {
                return JenkinsHash(v.x ^ JenkinsHash(v.yz));
            }

            uint JenkinsHash(uint4 v)
            {
                return JenkinsHash(v.x ^ JenkinsHash(v.yzw));
            }

            // Construct a float with half-open range [0, 1) using low 23 bits.
            // All zeros yields 0, all ones yields the next smallest representable value below 1.
            float ConstructFloat(int m) {
                const int ieeeMantissa = 0x007FFFFF; // Binary FP32 mantissa bitmask
                const int ieeeOne = 0x3F800000; // 1.0 in FP32 IEEE

                m &= ieeeMantissa;                   // Keep only mantissa bits (fractional part)
                m |= ieeeOne;                        // Add fractional part to 1.0

                float  f = asfloat(m);               // Range [1, 2)
                return f - 1;                        // Range [0, 1)
            }

            float ConstructFloat(uint m)
            {
                return ConstructFloat(asint(m));
            }

            // Pseudo-random value in half-open range [0, 1). The distribution is reasonably uniform.
            // Ref: https://stackoverflow.com/a/17479300
            float GenerateHashedRandomFloat(uint x)
            {
                return ConstructFloat(JenkinsHash(x));
            }

            float GenerateHashedRandomFloat(uint2 v)
            {
                return ConstructFloat(JenkinsHash(v));
            }

            float GenerateHashedRandomFloat(uint3 v)
            {
                return ConstructFloat(JenkinsHash(v));
            }

            float GenerateHashedRandomFloat(uint4 v)
            {
                return ConstructFloat(JenkinsHash(v));
            }

            float GenerateRandomFloat(float2 screenUV)
            {
                #if defined (_ANIMATE_NOISE)
                    float time = unity_DeltaTime.y * _Time.y + _Seed;
                    _Seed += 1.0;
                    return GenerateHashedRandomFloat(uint3(screenUV * _ScreenParams.xy, time));
                #else
                    _Seed += 1.0;
                    return GenerateHashedRandomFloat(uint3(screenUV * _ScreenParams.xy, _Seed));
                #endif
            }

            //||||||||||||||||||||||||||||| SAMPLING FUNCTIONS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| SAMPLING FUNCTIONS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| SAMPLING FUNCTIONS |||||||||||||||||||||||||||||

            // Assumes that (0 <= x <= Pi).
            float SinFromCos(float cosX)
            {
                return sqrt(saturate(1 - cosX * cosX));
            }

            // Transforms the unit vector from the spherical to the Cartesian (right-handed, Z up) coordinate.
            float3 SphericalToCartesian(float cosPhi, float sinPhi, float cosTheta)
            {
                float sinTheta = SinFromCos(cosTheta);

                return float3(float2(cosPhi, sinPhi) * sinTheta, cosTheta);
            }

            float3 SphericalToCartesian(float phi, float cosTheta)
            {
                float sinPhi, cosPhi;
                sincos(phi, sinPhi, cosPhi);

                return SphericalToCartesian(cosPhi, sinPhi, cosTheta);
            }

            float3 SampleSphereUniform(float u1, float u2)
            {
                float phi = UNITY_TWO_PI * u2;
                float cosTheta = 1.0 - 2.0 * u1;

                return SphericalToCartesian(phi, cosTheta);
            }

            // Cosine-weighted sampling without the tangent frame.
            // Ref: http://www.amietia.com/lambertnotangent.html
            float3 SampleHemisphereCosine(float u1, float u2, float3 normal)
            {
                // This function needs to used safenormalize because there is a probability
                // that the generated direction is the exact opposite of the normal and that would lead
                // to a nan vector otheriwse.
                float3 pointOnSphere = SampleSphereUniform(u1, u2);
                return normalize(normal + pointOnSphere);
            }

            //||||||||||||||||||||||||||||| UTILITY FUNCTIONS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UTILITY FUNCTIONS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| UTILITY FUNCTIONS |||||||||||||||||||||||||||||

            //https://github.com/Unity-Technologies/Graphics/blob/master/Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl
            uint BitFieldInsert(uint mask, uint src, uint dst)
            {
                return (src & mask) | (dst & ~mask);
            }

            float CopySign(float x, float s, bool ignoreNegZero = true)
            {
                if (ignoreNegZero)
                {
                    return (s >= 0) ? abs(x) : -abs(x);
                }
                else
                {
                    uint negZero = 0x80000000u;
                    uint signBit = negZero & asuint(s);
                    return asfloat(BitFieldInsert(negZero, signBit, asuint(x)));
                }
            }

            float FastSign(float s, bool ignoreNegZero = true)
            {
                return CopySign(1.0, s, ignoreNegZero);
            }

            //https://github.com/Unity-Technologies/Graphics/blob/master/Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl
            float3x3 GetLocalFrame(float3 localZ)
            {
                float x = localZ.x;
                float y = localZ.y;
                float z = localZ.z;
                float sz = FastSign(z);
                float a = 1 / (sz + z);
                float ya = y * a;
                float b = x * ya;
                float c = x * sz;

                float3 localX = float3(c * x * a - 1, sz * b, c);
                float3 localY = float3(b, y * ya - sz, y);

                return float3x3(localX, localY, localZ);
            }

            //||||||||||||||||||||||||||||| PBR SHADING FUNCTIONS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| PBR SHADING FUNCTIONS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| PBR SHADING FUNCTIONS |||||||||||||||||||||||||||||

            void SampleAnisoGGXVisibleNormal(float2 u,
                float3 V,
                float3x3 localToWorld,
                float roughnessX,
                float roughnessY,
                out float3 localV,
                out float3 localH,
                out float  VdotH)
            {
                localV = mul(V, transpose(localToWorld));

                // Construct an orthonormal basis around the stretched view direction
                float3 N = normalize(float3(roughnessX * localV.x, roughnessY * localV.y, localV.z));
                float3 T = (N.z < 0.9999) ? normalize(cross(float3(0, 0, 1), N)) : float3(1, 0, 0);
                float3 B = cross(N, T);

                // Compute a sample point with polar coordinates (r, phi)
                float r = sqrt(u.x);
                float phi = 2.0 * UNITY_PI * u.y;
                float t1 = r * cos(phi);
                float t2 = r * sin(phi);
                float s = 0.5 * (1.0 + N.z);
                t2 = (1.0 - s) * sqrt(1.0 - t1 * t1) + s * t2;

                // Reproject onto hemisphere
                localH = t1 * T + t2 * B + sqrt(max(0.0, 1.0 - t1 * t1 - t2 * t2)) * N;

                // Transform the normal back to the ellipsoid configuration
                localH = normalize(float3(roughnessX * localH.x, roughnessY * localH.y, max(0.0, localH.z)));

                VdotH = saturate(dot(localV, localH));
            }

            // GGX VNDF via importance sampling
            half3 ImportanceSampleGGX_VNDF(float2 random, half3 normalWS, half3 viewDirWS, half roughness, out bool valid)
            {
                half3x3 localToWorld = GetLocalFrame(normalWS);

                half VdotH;
                half3 localV, localH;
                SampleAnisoGGXVisibleNormal(random, viewDirWS, localToWorld, roughness, roughness, localV, localH, VdotH);

                // Compute the reflection direction
                half3 localL = 2.0 * VdotH * localH - localV;
                half3 outgoingDir = mul(localL, localToWorld);

                half NdotL = dot(normalWS, outgoingDir);

                valid = (NdotL >= 0.001);

                return outgoingDir;
            }

            //https://google.github.io/filament/Filament.html#materialsystem
            //u = (View Direction) dot (Half Direction)
            //f0 = Reflectance at normal incidence
            float3 F_Schlick(float u, float3 f0)
            {
                float f = pow(1.0 - u, 5.0);
                float3 f90 = saturate(50.0 * f0); // cheap luminance approximation
                return f0 + (f90 - f0) * f;
            }

            struct meshData
            {
                float4 vertex : POSITION;   //Vertex Position (X = Position X | Y = Position Y | Z = Position Z | W = 1)
                float3 normal : NORMAL;     //Normal Direction [-1..1] (X = Direction X | Y = Direction Y | Z = Direction)
                float4 tangent : TANGENT;   //Tangent Direction [-1..1] (X = Direction X | Y = Direction Y | Z = Direction)

                UNITY_VERTEX_INPUT_INSTANCE_ID //Instancing
            };

            struct vertexToFragment
            {
                float4 vertexCameraClipPosition : SV_POSITION;                    //Vertex Position In Camera Clip Space
                float4 vertexWorldPosition : TEXCOORD0;               //Vertex World Space Position 
                float3 vertexNormal : TEXCOORD1;
                float4 screenPosition : TEXCOORD2;

                UNITY_VERTEX_OUTPUT_STEREO //Instancing
            };

            vertexToFragment vertex_forward_base(meshData data)
            {
                vertexToFragment vertex;

                //Instancing
                UNITY_SETUP_INSTANCE_ID(data);
                UNITY_INITIALIZE_OUTPUT(vertexToFragment, vertex);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(vertex);

                //transforms a point from object space to the camera's clip space
                vertex.vertexCameraClipPosition = UnityObjectToClipPos(data.vertex);

                //define our world position vector
                vertex.vertexWorldPosition = mul(unity_ObjectToWorld, data.vertex);

                //the world normal of the mesh
                vertex.vertexNormal = UnityObjectToWorldNormal(normalize(data.normal));

                vertex.screenPosition = UnityStereoTransformScreenSpaceTex(ComputeScreenPos(vertex.vertexCameraClipPosition));

                return vertex;
            }

            float4 fragment_forward_base(vertexToFragment vertex) : SV_Target
            {
                //||||||||||||||||||||||||||||||| VECTORS |||||||||||||||||||||||||||||||
                //||||||||||||||||||||||||||||||| VECTORS |||||||||||||||||||||||||||||||
                //||||||||||||||||||||||||||||||| VECTORS |||||||||||||||||||||||||||||||
                //main shader vectors used for textures or lighting calculations.

                float3 vector_worldPosition = vertex.vertexWorldPosition.xyz; //world position vector
                float3 vector_viewPosition = _WorldSpaceCameraPos.xyz - vector_worldPosition; //camera world position
                float3 vector_viewDirection = normalize(vector_viewPosition); //camera world position direction
                float3 vector_normalDirection = vertex.vertexNormal;
                float3 vector_reflectionDirection = reflect(-vector_viewDirection, vector_normalDirection);
                float2 vector_screenUV = vertex.screenPosition.xy / vertex.screenPosition.w;

                //||||||||||||||||||||||||||||||| FINAL COLOR |||||||||||||||||||||||||||||||
                //||||||||||||||||||||||||||||||| FINAL COLOR |||||||||||||||||||||||||||||||
                //||||||||||||||||||||||||||||||| FINAL COLOR |||||||||||||||||||||||||||||||

                float4 finalColor = float4(0, 0, 0, 1);

                float smoothness = _Smoothness;
                float perceptualRoughness = 1.0 - smoothness;
                float roughness = perceptualRoughness * perceptualRoughness;
                int accumulatedSamples = 0;

                for (int i = 0; i < _SampleCount; i++)
                {
                    #if defined (_USE_BLUE_NOISE)
                        float2 noiseTexelSize = _ScreenParams.xy / _BlueNoiseResolution.xy;
                        float2 noise = tex3Dlod(_BlueNoise, float4(vector_screenUV.xy * noiseTexelSize, (1.0f / _SampleCount) * i, 0)).xy;
                    #else
                        float2 noise = float2(GenerateRandomFloat(vector_screenUV), GenerateRandomFloat(vector_screenUV));
                    #endif

                    bool valid;

                    half3 vector_reflectionDirection = ImportanceSampleGGX_VNDF(noise, vector_normalDirection, vector_viewDirection, roughness, valid);

                    if (valid)
                    {
                        float3 cubemapSample = texCUBElod(_InputCubemap, float4(vector_reflectionDirection, 0)).rgb;

                        finalColor.rgb += cubemapSample;

                        accumulatedSamples++;
                    }
                }

                finalColor /= accumulatedSamples;

                return finalColor;
            }
            ENDCG
        }
    }
}
