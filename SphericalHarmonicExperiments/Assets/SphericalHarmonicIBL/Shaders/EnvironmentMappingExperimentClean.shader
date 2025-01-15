Shader "SphericalHarmonicIBL/EnvironmentMappingExperimentClean"
{
    Properties
    {
        [Header(Inputs)]
        [KeywordEnum(Cubemap, Equirectangular)] _InputType("Input Type", Float) = 0
        _InputCubemap("Input Cubemap", CUBE) = "white" {}
        _InputEquirectangular("Input Equirectangular", 2D) = "white" {}

        _Resolution("Resolution", Vector) = (0, 0, 0, 0)
        _MipLevel("Mip Level Max", Int) = 1

        _TestInt1("_TestInt1", Int) = 1
        _TestFloat1("_TestFloat1", Float) = 1
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque" 
        }

        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vertex_base
            #pragma fragment fragment_base

            #pragma multi_compile _INPUTTYPE_CUBEMAP _INPUTTYPE_EQUIRECTANGULAR

            #include "UnityCG.cginc"

            samplerCUBE _InputCubemap;
            sampler2D _InputEquirectangular;
            float4 _InputEquirectangular_TexelSize;
            int _MipLevel;
            float4 _Resolution;

            int _TestInt1;
            float _TestFloat1;

            //||||||||||||||||||||||||||||| RANDOM FUNCTIONS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| RANDOM FUNCTIONS |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| RANDOM FUNCTIONS |||||||||||||||||||||||||||||

            float _Seed;

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

            //#define _ANIMATE_NOISE

            //float GenerateRandomFloat(float2 screenUV)
            float GenerateRandomFloat(float2 uv)
            {
                #if defined (_ANIMATE_NOISE)
                    float time = unity_DeltaTime.y * _Time.y + _Seed;
                    _Seed += 1.0;
                    //return GenerateHashedRandomFloat(uint3(screenUV * _ScreenParams.xy, time));
                    return GenerateHashedRandomFloat(uint3(uv * _InputEquirectangular_TexelSize.zw, time));
                #else
                    _Seed += 1.0;
                    //return GenerateHashedRandomFloat(uint3(screenUV * _ScreenParams.xy, _Seed));
                    //return GenerateHashedRandomFloat(uint3(uv * _InputEquirectangular_TexelSize.zw, _Seed));
                    return GenerateHashedRandomFloat(uint3(uv * _InputEquirectangular_TexelSize.zw, _Seed + _TestInt1));
                #endif
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
                #if defined (_INPUTTYPE_EQUIRECTANGULAR)
                    // Scale the 2D coordinates to the appropriate mip level, then sample the color value at this location.
                    float3 sampledColor = tex2Dlod(_InputEquirectangular, float4(imageCoord, 0, mipLevel)).rgb;
                #else
                    float3 sampledColor = texCUBElod(_InputCubemap, float4(SampleEquirectangular(imageCoord), mipLevel)).rgb;
                #endif

                // Calculate the luminance (brightness) of the color as the "weight" of this pixel
                // We use luminance as the weight to prioritize bright regions in sampling.
                return length(sampledColor);
            }

            // Samples a coordinate from an HDR environment map by iteratively refining 'startUV' based on pixel weights.
            // The function starts sampling from the highest mip level and gradually descends to refine the selected coordinate.
            // 'mipMaxLevel' specifies the highest mip level to begin the sampling process.
            float2 SampleWeightedCoordinate(float2 startUV, int mipMaxLevel) 
            {
                #if defined (_INPUTTYPE_EQUIRECTANGULAR)
                    // Calculate the initial offset for sampling based on texture resolution at the highest mip level
                    float2 texelOffset = _InputEquirectangular_TexelSize.xy * pow(2, mipMaxLevel - 1);
                #else
                    float2 texelOffset = float2(1.0f / _Resolution.x, 1.0f / _Resolution.y) * pow(2, mipMaxLevel - 1);
                #endif

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
                float4 vertex : POSITION;	//Vertex Position (X = Position X | Y = Position Y | Z = Position Z | W = 1)
                float3 uv0 : TEXCOORD0;
            };

            struct vertexToFragment
            {
                float4 vertexCameraClipPosition : SV_POSITION; //Vertex Position In Camera Clip Space
                float2 vertexUV : TEXCOORD0;
                float4 screenPosition : TEXCOORD1;
            };

            vertexToFragment vertex_base(meshData data)
            {
                vertexToFragment vertex;

                vertex.vertexCameraClipPosition = UnityObjectToClipPos(data.vertex);
                vertex.vertexUV = data.uv0;
                vertex.screenPosition = UnityStereoTransformScreenSpaceTex(ComputeScreenPos(vertex.vertexCameraClipPosition));

                return vertex;
            }

            float4 fragment_base(vertexToFragment vertex) : SV_Target
            {
                float2 meshUV = vertex.vertexUV;

                #if defined (_INPUTTYPE_EQUIRECTANGULAR)
                    float2 uv = SampleWeightedCoordinate(meshUV, _MipLevel - 1);

                    //uv = frac(uv);
                    uv.x = min(uv.x, 1.0f);
                    uv.y = min(uv.y, 1.0f);

                    if (uv.y > 1.0f || uv.x > 1.0f) 
                        uv = float2(0, 0);
                        //return float4(0, 0, 0, 1); 

                    //return float4(1, 1, 1, 1); 
                    return float4(uv, 0, 1);
                #else
                    float2 uv = SampleWeightedCoordinate(meshUV, _MipLevel - 1);

                    if (uv.y > 1.0f || uv.x > 1.0f) 
                        return float4(0, 0, 0, 1); 

                    return float4(1, 1, 1, 1); 
                    //return texCUBElod(_InputCubemap, float4(SampleEquirectangular(vertex.vertexUV), 0));
                #endif
            }
            ENDCG
        }
    }
}
