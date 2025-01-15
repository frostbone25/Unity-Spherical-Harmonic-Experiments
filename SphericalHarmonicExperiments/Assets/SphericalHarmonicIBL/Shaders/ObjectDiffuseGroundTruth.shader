Shader "Unlit/ObjectDiffuseGroundTruth"
{
    Properties
    {
        [Header(Rendering)]
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Int) = 2

        [Header(Environment)]
        _InputCubemap("Input Cubemap", CUBE) = "white" {}
        _InputCubemapResolution("Input Cubemap Resolution", Vector) = (0, 0, 0, 0)
        _InputCubemapMips("Input Cubemap Mips", Int) = 11

        [Header(Quality)]
        //_SampleCount("Sample Count", Int) = 512
        _SampleCount("Sample Count", Range(1, 64)) = 16
        [Toggle(_USE_BLUE_NOISE)] _UseBlueNoise("Use Blue Noise", Float) = 0
        _BlueNoise("Blue Noise Stack", 3D) = "white" {}
        _BlueNoiseResolution("BlueNoise", Vector) = (64, 64, 64, 0)
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
            Name "ObjectDiffuseGroundTruth_ForwardBase"

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
            float _Seed;

            float4 _InputCubemapResolution;
            int _InputCubemapMips;

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

            float2 SampleSphericalMap(float3 direction)
            {
                //const float2 invAtan = float2(1.0f / (UNITY_PI * 2.0f), 1.0f / UNITY_PI);
                const float2 invAtan = float2(0.159154943091895f, 0.318309886183791f);
                float2 uv = float2(atan2(direction.x, direction.z), asin(direction.y));
                uv *= invAtan;
                uv += 0.5f;
                return uv;
            }

            float3 SampleEquirectangular(float2 uv)
            {
                uv = float2(uv.y, uv.x);

                // X from -1..+1, Y from -1..+1
                float2 coord = uv * 2.0f - 1.0f;

                // Convert to (lat, lon) angle
                float2 a = coord * float2(3.14159265, 1.57079633);
 
                // Convert to cartesian coordinates
                float2 c = cos(a);
                float2 s = sin(a);

                return float3(float2(s.x, c.x) * c.y, s.y);
            }

            //||||||||||||||||||||||||||||| TEXTURE MAP IMPORTANCE SAMPLE |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| TEXTURE MAP IMPORTANCE SAMPLE |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| TEXTURE MAP IMPORTANCE SAMPLE |||||||||||||||||||||||||||||
            //https://compute.toys/view/19

            // Returns true with a probability 'probabilityThreshold', based on a random value generated from 'uv'.
            // Used as a probabilistic "coin flip" to decide between paths during sampling.
            // 'uv' provides a unique input for random number generation, and 'probabilityThreshold' is between 0 and 1.
            bool PerformWeightedCoinFlip(float2 uv, float probabilityThreshold) 
            {
                // Generate a random value based on 'uv', and compare it against 'probabilityThreshold'
                return GenerateRandomFloat(uv) * 2.0f <= probabilityThreshold;
            }

            // Calculates the weight of a pixel region in an HDR image at a given mipmap level.
            // The weight is determined by the luminance of the sampled pixel at 'imageCoord' for the specified mip level.
            // This function is essential for guiding sampling towards brighter regions of the HDR image.
            float GetPixelWeight(float2 imageCoord, int mipLevel) 
            {
                // Scale the 2D coordinates to the appropriate mip level, then sample the color value at this location.
                //float3 sampledColor = tex2Dlod(_InputEquirectangular, float4(imageCoord, 0, mipLevel)).rgb;
                float3 sampledColor = texCUBElod(_InputCubemap, float4(SampleEquirectangular(imageCoord), mipLevel)).rgb;

                // Calculate the luminance (brightness) of the color as the "weight" of this pixel
                // We use luminance as the weight to prioritize bright regions in sampling.
                return length(sampledColor);
            }

            // Samples a coordinate from an HDR environment map by iteratively refining 'startUV' based on pixel weights.
            // The function starts sampling from the highest mip level and gradually descends to refine the selected coordinate.
            // 'mipMaxLevel' specifies the highest mip level to begin the sampling process.
            float2 SampleWeightedCoordinate(float2 startUV, int mipMaxLevel) 
            {
                // Calculate the initial offset for sampling based on texture resolution at the highest mip level
                //float2 texelOffset = _InputEquirectangular_TexelSize.xy * pow(2, mipMaxLevel - 1);
                float2 texelOffset = float2(1.0f / _InputCubemapResolution.x, 1.0f / _InputCubemapResolution.y) * pow(2, mipMaxLevel - 1);

                // Initialize position with the starting UV coordinates
                float2 sampledCoord = startUV;

                // Begin iterating through mip levels from high (low-res) to low (high-res), refining the coordinate each time
                for (int mipLevel = mipMaxLevel - 1; mipLevel >= 0; mipLevel -= 1) 
                {
                    // Fetch weights for the 2x2 pixel region around the current coordinate
                    float weightTopLeft =     GetPixelWeight(sampledCoord + float2(0, 0), mipLevel);
                    float weightBottomLeft =  GetPixelWeight(sampledCoord + float2(0, texelOffset.y), mipLevel);
                    float weightTopRight =    GetPixelWeight(sampledCoord + float2(texelOffset.x, 0), mipLevel);
                    float weightBottomRight = GetPixelWeight(sampledCoord + texelOffset, mipLevel);

                    // Sum weights for the left and right columns of this 2x2 region
                    float leftColumnWeight = weightTopLeft + weightBottomLeft;
                    float rightColumnWeight = weightTopRight + weightBottomRight;

                    // Total weight of the 2x2 region
                    float totalWeight = leftColumnWeight + rightColumnWeight;

                    // Determine whether to move to the right column based on its weight proportion of total weight
                    if (PerformWeightedCoinFlip(startUV, rightColumnWeight / totalWeight)) 
                    {
                        // Move to the right column
                        sampledCoord.x += 1;

                        // For the chosen column, determine whether to move to the bottom cell
                        if (PerformWeightedCoinFlip(startUV, weightBottomRight / rightColumnWeight))
                        {
                            sampledCoord.y += 1;
                        }
                    } 
                    else 
                    {
                        // For the left column, determine whether to move to the bottom cell
                        if (PerformWeightedCoinFlip(startUV, weightBottomLeft / leftColumnWeight))
                        {
                            sampledCoord.y += 1;
                        }
                    }
                }

                return sampledCoord;
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

                for (int i = 1; i <= _SampleCount; i++)
                {
                    #if defined (_USE_BLUE_NOISE)
                        float2 noiseTexelSize = _ScreenParams.xy / _BlueNoiseResolution.xy;
                        float2 noise = tex3Dlod(_BlueNoise, float4(vector_screenUV.xy * noiseTexelSize, (1.0f / _SampleCount) * i, 0)).xy;
                    #else
                        float2 noise = float2(GenerateRandomFloat(vector_screenUV), GenerateRandomFloat(vector_screenUV));
                    #endif

                    float3 vector_rayDirection = SampleHemisphereCosine(noise.x, noise.y, vector_normalDirection);

                    float2 importanceSampleUV = SampleWeightedCoordinate(SampleSphericalMap(-vector_rayDirection), _InputCubemapMips - 1);
                    //float2 importanceSampleUV = SampleWeightedCoordinate(SampleSphericalMap(SphericalToCartesian(vector_rayDirection.x, vector_rayDirection.y, vector_rayDirection.z)), _InputCubemapMips - 1);
                    

                    float3 cubemapSample = float3(0, 0, 0);

                    if (importanceSampleUV.y > 1.0f || importanceSampleUV.x > 1.0f) 
                        cubemapSample = texCUBElod(_InputCubemap, float4(SampleEquirectangular(importanceSampleUV), 0)).rgb;
                        //importanceSampleUV = float2(0, 0);

                    //cubemapSample = texCUBElod(_InputCubemap, float4(vector_rayDirection, 0)).rgb
                    //cubemapSample = texCUBElod(_InputCubemap, float4(SampleEquirectangular(importanceSampleUV), 0)).rgb;

                    //float2 sampledUV =  sample_coord(vector_screenUV, _InputCubemapMips);
                    //float2 sampledUV =  sample_coord(SampleSphericalMap(vector_rayDirection), _InputCubemapMips);
                    //float3 cubemapSample = texCUBElod(_InputCubemap, float4(SampleEquirectangular(sampledUV), 0)).rgb;

                    //cubemapSample *= max(0.0, dot(vector_normalDirection, vector_rayDirection));

                    finalColor.rgb += cubemapSample;
                }

                finalColor /= _SampleCount;

                return finalColor;
            }
            ENDCG
        }
    }
}
