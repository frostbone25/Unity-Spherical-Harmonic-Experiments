Shader "SphericalHarmonicIBL/SphericalHarmonicsRealtimeGPU"
{
    Properties
    {
        [Header(Inputs)]
        [KeywordEnum(Cubemap, Equirectangular)] _InputType("Input Type", Float) = 0
        _InputCubemapResolution("Input Cubemap Resolution", Vector) = (512, 512, 0, 0)
        _InputEquirectangularResolution("Input Equirectangular Resolution", Vector) = (512, 512, 0, 0)
        _InputCubemap("Input Cubemap", CUBE) = "white" {}
        _InputEquirectangular("Input Equirectangular", 2D) = "white" {}

        [Header(Spherical Harmonics Settings)]
        [KeywordEnum(Radiance, Irradiance)] _ConvolutionType("Convolution Type", Float) = 0
        [IntRange] _Orders("Orders", Range(0, 6)) = 3
        [KeywordEnum(Fibonacci Sphere, Random)] _SampleType("Sample Type", Float) = 0
        _SampleCount("Sample Count", Int) = 512
        [Toggle(_LINEAR_TO_GAMMA_TO_LINEAR)] _LinearToGammaToLinear("Linear To Gamma To Linear", Float) = 0
        [KeywordEnum(None, Hanning, Lanczos, Gaussian)] _DeringFilter("Dering Filter", Float) = 0
        _DeringFilterWindowSize("Dering Filter Window Size", Int) = 4
    }
    SubShader
    {
        Tags 
        { 
            "RenderType" = "Opaque" 
        }

        Cull Off
 
        Pass
        {
            CGPROGRAM
            #pragma vertex vertex_base
			#pragma fragment fragment_base

            #pragma shader_feature_local _LINEAR_TO_GAMMA_TO_LINEAR

            #pragma multi_compile _CONVOLUTIONTYPE_RADIANCE _CONVOLUTIONTYPE_IRRADIANCE
            #pragma multi_compile _INPUTTYPE_CUBEMAP _INPUTTYPE_EQUIRECTANGULAR
            #pragma multi_compile _SAMPLETYPE_FIBONACCI_SPHERE _SAMPLETYPE_RANDOM
            #pragma multi_compile _DERINGFILTER_NONE _DERINGFILTER_HANNING _DERINGFILTER_LANCZOS _DERINGFILTER_GAUSSIAN

            #include "UnityCG.cginc"

            #include "SphericalHarmonicsBasis.cginc"
			#include "SphericalHarmonicsDeringing.cginc"
			#include "SphericalHarmonicsUtility.cginc"
			#include "SphericalHarmonicsRandom.cginc"
			#include "SphericalHarmonicsSampling.cginc"

            //inputs
            float2 _InputCubemapResolution;
            float2 _InputEquirectangularResolution;

            float4 _InputCubemap_TexelSize;
            samplerCUBE _InputCubemap;

            float4 _InputEquirectangular_TexelSize;
            sampler2D _InputEquirectangular;

            //settings
            int _Orders;
            int _SampleCount;
            float _DeringFilterWindowSize;

            struct meshData
            {
                float4 vertex : POSITION;	//Vertex Position (X = Position X | Y = Position Y | Z = Position Z | W = 1)
                float3 normal : NORMAL;     //Normal Direction [-1..1] (X = Direction X | Y = Direction Y | Z = Direction)
                float3 uv0 : TEXCOORD0;    
            };

            struct vertexToFragment
            {
                float4 vertexCameraClipPosition : SV_POSITION; //Vertex Position In Camera Clip Space
                float3 vertexWorldNormal : TEXCOORD0; //Vertex Position In Camera Clip Space
                float4 vertexWorldPosition : TEXCOORD1; //Vertex World Space Position 
                float2 vertexUV : TEXCOORD2;
            };

            vertexToFragment vertex_base(meshData data)
            {
                vertexToFragment vertex;

                vertex.vertexCameraClipPosition = UnityObjectToClipPos(data.vertex);
                vertex.vertexWorldNormal = UnityObjectToWorldNormal(normalize(data.normal));
                vertex.vertexWorldPosition = mul(unity_ObjectToWorld, data.vertex);
                vertex.vertexUV = data.uv0;

                return vertex;
            }

            float3 SampleEnvironmentDirection(int sampleIndex, int sampleCount)
            {
                //rand(float2 n)
                #if defined (_SAMPLETYPE_FIBONACCI_SPHERE)
                    float angleIncrement = 10.1664073846305f; //precomputed version of (UNITY_PI * 2 * ((1 + sqrt(5)) / 2))
                    float y = 1.0f - (sampleIndex + 0.5f) / sampleCount * 2.0f;
                    float radius = sqrt(1.0f - y * y);
                    float theta = sampleIndex * angleIncrement;
                    float x = cos(theta) * radius;
                    float z = sin(theta) * radius;

                    return float3(x, y, z);
                #elif defined (_SAMPLETYPE_RANDOM)
                    float x = GenerateRandomFloat(float2(sampleIndex, sampleCount));
                    float y = GenerateRandomFloat(float2(sampleIndex, sampleCount));
                    float z = GenerateRandomFloat(float2(sampleIndex, sampleCount));
                    float3 direction = float3(x, y, z) * 2.0f - 1.0f;
                    direction = normalize(direction);

                    return direction;
                #else
                    return float3(0, 0, 0);
                #endif
            }

            float4 fragment_base(vertexToFragment vertex) : SV_Target
            {
                float3 vector_worldPosition = vertex.vertexWorldPosition.xyz; //world position vector
                float3 vector_viewPosition = _WorldSpaceCameraPos.xyz - vector_worldPosition; //camera world position
                float3 vector_viewDirection = normalize(vector_viewPosition); //camera world position direction
                float3 vector_normalDirection = vertex.vertexWorldNormal.xyz;
                float3 vector_reflectionDirection = reflect(-vector_viewDirection, vector_normalDirection);

                float3 sphericalHarmonicCoefficents[49] =
                {
                    //order 0
                    float3(0, 0, 0), //l = 0 | m = 0

                    //order 1
                    float3(0, 0, 0), //l = 1 | m = -1
                    float3(0, 0, 0), //l = 1 | m = 0
                    float3(0, 0, 0), //l = 1 | m = 1

                    //order 2
                    float3(0, 0, 0), //l = 2 | m = -2
                    float3(0, 0, 0), //l = 2 | m = -1
                    float3(0, 0, 0), //l = 2 | m = 0
                    float3(0, 0, 0), //l = 2 | m = 1
                    float3(0, 0, 0), //l = 2 | m = 2

                    //order 3
                    float3(0, 0, 0), //l = 3 | m = -3
                    float3(0, 0, 0), //l = 3 | m = -2
                    float3(0, 0, 0), //l = 3 | m = -1
                    float3(0, 0, 0), //l = 3 | m = 0
                    float3(0, 0, 0), //l = 3 | m = 1
                    float3(0, 0, 0), //l = 3 | m = 2
                    float3(0, 0, 0), //l = 3 | m = 3

                    //order 4
                    float3(0, 0, 0), //l = 4 | m = -4
                    float3(0, 0, 0), //l = 4 | m = -3
                    float3(0, 0, 0), //l = 4 | m = -2
                    float3(0, 0, 0), //l = 4 | m = -1
                    float3(0, 0, 0), //l = 4 | m = 0
                    float3(0, 0, 0), //l = 4 | m = 1
                    float3(0, 0, 0), //l = 4 | m = 2
                    float3(0, 0, 0), //l = 4 | m = 3
                    float3(0, 0, 0), //l = 4 | m = 4

                    //order 5
                    float3(0, 0, 0), //l = 5 | m = -5
                    float3(0, 0, 0), //l = 5 | m = -4
                    float3(0, 0, 0), //l = 5 | m = -3
                    float3(0, 0, 0), //l = 5 | m = -2
                    float3(0, 0, 0), //l = 5 | m = -1
                    float3(0, 0, 0), //l = 5 | m = 0
                    float3(0, 0, 0), //l = 5 | m = 1
                    float3(0, 0, 0), //l = 5 | m = 2
                    float3(0, 0, 0), //l = 5 | m = 3
                    float3(0, 0, 0), //l = 5 | m = 4
                    float3(0, 0, 0), //l = 5 | m = 5

                    //order 6
                    float3(0, 0, 0), //l = 6 | m = -6
                    float3(0, 0, 0), //l = 6 | m = -5
                    float3(0, 0, 0), //l = 6 | m = -4
                    float3(0, 0, 0), //l = 6 | m = -3
                    float3(0, 0, 0), //l = 6 | m = -2
                    float3(0, 0, 0), //l = 6 | m = -1
                    float3(0, 0, 0), //l = 6 | m = 0
                    float3(0, 0, 0), //l = 6 | m = 1
                    float3(0, 0, 0), //l = 6 | m = 2
                    float3(0, 0, 0), //l = 6 | m = 3
                    float3(0, 0, 0), //l = 6 | m = 4
                    float3(0, 0, 0), //l = 6 | m = 5
                    float3(0, 0, 0), //l = 6 | m = 6
                };

                //||||||||||||||||||||||||||||| CALCULATING COEFFICENTS |||||||||||||||||||||||||||||
                //||||||||||||||||||||||||||||| CALCULATING COEFFICENTS |||||||||||||||||||||||||||||
                //||||||||||||||||||||||||||||| CALCULATING COEFFICENTS |||||||||||||||||||||||||||||
    
                int sphericalHarmonicOrderCount = _Orders;
                int sphericalHarmonicCoefficientsCount = (sphericalHarmonicOrderCount + 1) * (sphericalHarmonicOrderCount + 1);

                //iterate through each specified order of SH
                for (int l = 0; l <= sphericalHarmonicOrderCount; l++)
                {
                    //iterate through each SH basis for the current SH order
                    for (int m = -l; m <= l; m++)
                    {
                        int sphericalHarmonicIndex = l * (l + 1) + m;

                        for (int sampleIndex = 0; sampleIndex < _SampleCount; ++sampleIndex)
                        {
                            float3 environmentSampleDirection = SampleEnvironmentDirection(sampleIndex, _SampleCount);

                            #if defined (_INPUTTYPE_CUBEMAP)
                                float3 environmentSample = texCUBElod(_InputCubemap, float4(environmentSampleDirection, 0)).rgb;
                            #elif defined (_INPUTTYPE_EQUIRECTANGULAR)
                                float3 environmentSample = tex2Dlod(_InputEquirectangular, float4(SampleSphericalMap(environmentSampleDirection), 0, 0)).rgb;
                            #endif

                            #if defined (_LINEAR_TO_GAMMA_TO_LINEAR)
                                environmentSample = LinearToGammaSpace(environmentSample);
                            #endif

                            sphericalHarmonicCoefficents[sphericalHarmonicIndex] += environmentSample * EvaluateBasisFunction(l, m, environmentSampleDirection);
                        }

                        sphericalHarmonicCoefficents[sphericalHarmonicIndex] *= 4.0f * UNITY_PI / (float)_SampleCount;
                    }
                }

                //||||||||||||||||||||||||||||| DERINGING COEFFICENTS |||||||||||||||||||||||||||||
                //||||||||||||||||||||||||||||| DERINGING COEFFICENTS |||||||||||||||||||||||||||||
                //||||||||||||||||||||||||||||| DERINGING COEFFICENTS |||||||||||||||||||||||||||||

                float3 sphericalHarmonicFilteredCoefficents[9] =
                {
                    sphericalHarmonicCoefficents[0],
                    sphericalHarmonicCoefficents[1],
                    sphericalHarmonicCoefficents[2],
                    sphericalHarmonicCoefficents[3],
                    sphericalHarmonicCoefficents[4],
                    sphericalHarmonicCoefficents[5],
                    sphericalHarmonicCoefficents[6],
                    sphericalHarmonicCoefficents[7],
                    sphericalHarmonicCoefficents[8],
                };

                #if defined (_DERINGFILTER_HANNING)
                    FilterHanning(sphericalHarmonicFilteredCoefficents, _DeringFilterWindowSize);
                #elif defined (_DERINGFILTER_LANCZOS)
                    FilterLanczos(sphericalHarmonicFilteredCoefficents, _DeringFilterWindowSize);
                #elif defined (_DERINGFILTER_GAUSSIAN)
                    FilterGaussian(sphericalHarmonicFilteredCoefficents, _DeringFilterWindowSize);
                #endif

                //||||||||||||||||||||||||||||| SHADING WITH RADIANCE |||||||||||||||||||||||||||||
                //||||||||||||||||||||||||||||| SHADING WITH RADIANCE |||||||||||||||||||||||||||||
                //||||||||||||||||||||||||||||| SHADING WITH RADIANCE |||||||||||||||||||||||||||||

                #if defined (_CONVOLUTIONTYPE_RADIANCE)

                    float3 sphericalHarmonicsRadiance = float3(0, 0, 0);

                    //order 0
                    sphericalHarmonicsRadiance += sphericalHarmonicFilteredCoefficents[0] * SphericalHarmonicBasis0(vector_reflectionDirection);

                    //order 1
                    sphericalHarmonicsRadiance += sphericalHarmonicFilteredCoefficents[1] * SphericalHarmonicBasis1(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicFilteredCoefficents[2] * SphericalHarmonicBasis2(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicFilteredCoefficents[3] * SphericalHarmonicBasis3(vector_reflectionDirection);

                    //order 2
                    sphericalHarmonicsRadiance += sphericalHarmonicFilteredCoefficents[4] * SphericalHarmonicBasis4(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicFilteredCoefficents[5] * SphericalHarmonicBasis5(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicFilteredCoefficents[6] * SphericalHarmonicBasis6(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicFilteredCoefficents[7] * SphericalHarmonicBasis7(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicFilteredCoefficents[8] * SphericalHarmonicBasis8(vector_reflectionDirection);

                    //order 3
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[9] * SphericalHarmonicBasis9(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[10] * SphericalHarmonicBasis10(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[11] * SphericalHarmonicBasis11(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[12] * SphericalHarmonicBasis12(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[13] * SphericalHarmonicBasis13(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[14] * SphericalHarmonicBasis14(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[15] * SphericalHarmonicBasis15(vector_reflectionDirection);

                    //order 4
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[16] * SphericalHarmonicBasis16(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[17] * SphericalHarmonicBasis17(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[18] * SphericalHarmonicBasis18(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[19] * SphericalHarmonicBasis19(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[20] * SphericalHarmonicBasis20(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[21] * SphericalHarmonicBasis21(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[22] * SphericalHarmonicBasis22(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[23] * SphericalHarmonicBasis23(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[24] * SphericalHarmonicBasis24(vector_reflectionDirection);

                    //order 5
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[25] * SphericalHarmonicBasis25(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[26] * SphericalHarmonicBasis26(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[27] * SphericalHarmonicBasis27(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[28] * SphericalHarmonicBasis28(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[29] * SphericalHarmonicBasis29(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[30] * SphericalHarmonicBasis30(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[31] * SphericalHarmonicBasis31(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[32] * SphericalHarmonicBasis32(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[33] * SphericalHarmonicBasis33(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[34] * SphericalHarmonicBasis34(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[35] * SphericalHarmonicBasis35(vector_reflectionDirection);

                    //order 6
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[36] * SphericalHarmonicBasis36(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[37] * SphericalHarmonicBasis37(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[38] * SphericalHarmonicBasis38(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[39] * SphericalHarmonicBasis39(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[40] * SphericalHarmonicBasis40(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[41] * SphericalHarmonicBasis41(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[42] * SphericalHarmonicBasis42(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[43] * SphericalHarmonicBasis43(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[44] * SphericalHarmonicBasis44(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[45] * SphericalHarmonicBasis45(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[46] * SphericalHarmonicBasis46(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[47] * SphericalHarmonicBasis47(vector_reflectionDirection);
                    sphericalHarmonicsRadiance += sphericalHarmonicCoefficents[48] * SphericalHarmonicBasis48(vector_reflectionDirection);

                    #if defined (_LINEAR_TO_GAMMA_TO_LINEAR)
                        sphericalHarmonicsRadiance = pow(sphericalHarmonicsRadiance, 2.2); //[Gamma -> Linear] 2.2
                    #endif

                    sphericalHarmonicsRadiance = max(0.0, sphericalHarmonicsRadiance);

                    return float4(sphericalHarmonicsRadiance, 1);
                #endif

                #if defined (_CONVOLUTIONTYPE_IRRADIANCE)
                    //||||||||||||||||||||||||||||| CALCULATING COEFFICENTS |||||||||||||||||||||||||||||
                    //||||||||||||||||||||||||||||| CALCULATING COEFFICENTS |||||||||||||||||||||||||||||
                    //||||||||||||||||||||||||||||| CALCULATING COEFFICENTS |||||||||||||||||||||||||||||

                    //iterate through each specified order of SH
                    for (int l = 0; l <= sphericalHarmonicOrderCount; l++)
                    {
                        //iterate through each SH basis for the current SH order
                        for (int m = -l; m <= l; m++)
                        {
                            int sphericalHarmonicIndex = l * (l + 1) + m;

                            for (int sampleIndex = 0; sampleIndex < _SampleCount; ++sampleIndex)
                            {
                                float3 environmentSampleDirection = SampleEnvironmentDirection(sampleIndex, _SampleCount);

                                #if defined (_INPUTTYPE_CUBEMAP)
                                    float3 environmentSample = texCUBElod(_InputCubemap, float4(environmentSampleDirection, 0)).rgb;
                                #elif defined (_INPUTTYPE_EQUIRECTANGULAR)
                                    float3 environmentSample = tex2Dlod(_InputEquirectangular, float4(SampleSphericalMap(environmentSampleDirection), 0, 0)).rgb;
                                #endif

                                sphericalHarmonicCoefficents[sphericalHarmonicIndex] += environmentSample * EvaluateBasisFunction(l, m, environmentSampleDirection);
                            }

                            sphericalHarmonicCoefficents[sphericalHarmonicIndex] *= 4.0f * UNITY_PI / (float)_SampleCount;
                        }
                    }

                    //||||||||||||||||||||||||||||| SHADING WITH RADIANCE |||||||||||||||||||||||||||||
                    //||||||||||||||||||||||||||||| SHADING WITH RADIANCE |||||||||||||||||||||||||||||
                    //||||||||||||||||||||||||||||| SHADING WITH RADIANCE |||||||||||||||||||||||||||||

                    float3 sphericalHarmonicsIrradiance = float3(0, 0, 0);

                    //apply order 0 and convolve into diffuse
                    sphericalHarmonicsIrradiance += 3.1415926535897932384f * sphericalHarmonicFilteredCoefficents[0] * SphericalHarmonicBasis0(vector_normalDirection);

                    //apply order 1 and convolve into diffuse
                    sphericalHarmonicsIrradiance += 2.0943951023931954923f * sphericalHarmonicFilteredCoefficents[1] * SphericalHarmonicBasis1(vector_normalDirection);
                    sphericalHarmonicsIrradiance += 2.0943951023931954923f * sphericalHarmonicFilteredCoefficents[2] * SphericalHarmonicBasis2(vector_normalDirection);
                    sphericalHarmonicsIrradiance += 2.0943951023931954923f * sphericalHarmonicFilteredCoefficents[3] * SphericalHarmonicBasis3(vector_normalDirection);

                    //apply order 2 and convolve into diffuse
                    sphericalHarmonicsIrradiance += 0.78539f * sphericalHarmonicFilteredCoefficents[4] * SphericalHarmonicBasis4(vector_normalDirection);
                    sphericalHarmonicsIrradiance += 0.78539f * sphericalHarmonicFilteredCoefficents[5] * SphericalHarmonicBasis5(vector_normalDirection);
                    sphericalHarmonicsIrradiance += 0.78539f * sphericalHarmonicFilteredCoefficents[6] * SphericalHarmonicBasis6(vector_normalDirection);
                    sphericalHarmonicsIrradiance += 0.78539f * sphericalHarmonicFilteredCoefficents[7] * SphericalHarmonicBasis7(vector_normalDirection);
                    sphericalHarmonicsIrradiance += 0.78539f * sphericalHarmonicFilteredCoefficents[8] * SphericalHarmonicBasis8(vector_normalDirection);

                    //Divide irradiance by PI because albedo
                    sphericalHarmonicsIrradiance /= UNITY_PI;

                    sphericalHarmonicsIrradiance = max(0.0, sphericalHarmonicsIrradiance);

                    return float4(sphericalHarmonicsIrradiance, 1);
                #endif

                return float4(0, 0, 0, 1);
            }
            ENDCG
        }
    }
}
