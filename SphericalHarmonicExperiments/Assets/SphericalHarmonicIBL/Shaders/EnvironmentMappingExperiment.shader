Shader "SphericalHarmonicIBL/EnvironmentMappingExperiment"
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








            //||||||||||||||||||||||||||||| TEXTURE MAP IMPORTANCE SAMPLE |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| TEXTURE MAP IMPORTANCE SAMPLE |||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||| TEXTURE MAP IMPORTANCE SAMPLE |||||||||||||||||||||||||||||
            //https://compute.toys/view/19

            //this returns a random float 0..1
            float pcg_random(inout uint seed) 
            {
                seed = seed * 747796405u + 2891336453u;
                uint word = ((seed >> ((seed >> 28u) + 4u)) ^ seed) * 277803737u;
                return float((word >> 22u) ^ word) / float(0xffffffffu);
            }

            // weighted coin flip (bernoulli)
            //fn flip(state: ptr<function, uint>, p: float) -> bool 
            //bool flip(inout uint state, float p)
            bool flip(float2 uv, float p)
            {
                //return pcg_random(state) <= p;
                return GenerateRandomFloat(uv) * 2.0 <= p;
            }

            // relative weight of given region of image
            //fn weight(pos: int2, mip: int) -> float 
            //float weight(int2 pos, int mip) 
            float weight(float2 pos, int mip) 
            {
                //return length(textureLoad(channel0, pos, mip).rgb);
                //return length(tex2Dlod(_InputEquirectangular, float4(pos, 0, mip)).rgb);

                float2 scaledUV = pos.xy;
                //float2 scaledUV = float2(pos.x / _InputEquirectangular_TexelSize.z, pos.y / _InputEquirectangular_TexelSize.w);
                //float2 scaledUV = float2(pos.x * _InputEquirectangular_TexelSize.x, pos.y * _InputEquirectangular_TexelSize.y);
                //float2 scaledUV = float2(pos.x / _Resolution.x, pos.y / _Resolution.y);
                float3 textureSample = tex2Dlod(_InputEquirectangular, float4(scaledUV, 0, mip)).rgb;
                return length(textureSample);
            }

            // sample location from image according to pixel weights
            //fn sample_coord(state: ptr<function, uint>, mipmax: int) -> int2 
            //int2 sample_coord(inout uint state, int mipmax) 
            //float2 sample_coord(inout uint state, int mipmax)
            float2 sample_coord(float2 uv, int mipmax)
            {
                //float2 offset = _InputEquirectangular_TexelSize.xy;
                //float2 offset = _InputEquirectangular_TexelSize.xy;
                //offset *= 2;

                //for(int i = 0; i < mipmax - 1; i++)
                    //offset *= 2;
                    //offset *= offset;

                //offset *= pow(2, mipmax - 1);
                float2 offset = _InputEquirectangular_TexelSize.xy * pow(2, mipmax - 1);

                //var pos = int2(0, 0);
                //int2 pos = int2(0, 0);
                float2 pos = uv;

                //for (var mip = mipmax - 1; mip >= 0; mip -= 1) 
                for (int mip = mipmax - 1; mip >= 0; mip -= 1) 
                {
                    //pos *= 2;
                    //offset *= 2;
                    //offset = _InputEquirectangular_TexelSize.xy * pow(2, mip);
                    //offset /= 2;

                    //let w00 = weight(pos + int2(0, 0), mip);
                    float w00 = weight(pos + int2(0, 0), mip);

                    //let w01 = weight(pos + int2(0, 1), mip);
                    //float w01 = weight(pos + int2(0, 1), mip);
                    float w01 = weight(pos + float2(0, offset.y), mip);

                    //let w10 = weight(pos + int2(1, 0), mip);
                    //float w10 = weight(pos + int2(1, 0), mip);
                    float w10 = weight(pos + float2(offset.x, 0), mip);

                    //let w11 = weight(pos + int2(1, 1), mip);
                    //float w11 = weight(pos + int2(1, 1), mip);
                    float w11 = weight(pos + float2(offset.x, offset.y), mip);

                    //let w0 = w00 + w01; // weight of column 0
                    float w0 = w00 + w01; // weight of column 0

                    //let w1 = w10 + w11; // weight of column 1
                    float w1 = w10 + w11; // weight of column 1

                    //let w = w0 + w1; // total weight
                    float w = w0 + w1; // total weight

                    //pos += select(
                        //int2(0, select(0, 1, flip(state, w01 / w0))), // cond prob of row 1 given col 0
                        //int2(1, select(0, 1, flip(state, w11 / w1))), // cond prob of row 1 given col 1
                        //flip(state, w1 / w)); // prob of col 1

                    //if(flip(state, w1 / w))
                    if(flip(uv, w1 / w))
                    {
                        pos.x += 1;

                        //if(flip(state, w11 / w1))
                        if(flip(uv, w11 / w1))
                            pos.y += 1;
                    }
                    else
                    {
                        //if(flip(state, w01 / w0))
                        if(flip(uv, w01 / w0))
                            pos.y += 1;
                    }
                }

                //if(pos.x > 1.0f || pos.y > 1.0f)
                    //return float2(0, 0);

                return pos;
                //return pos / _InputEquirectangular_TexelSize.zw;
                //return (pos / _InputEquirectangular_TexelSize.zw) + uv;
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

            float4 fragment_base(vertexToFragment vertex) : SV_Target
            {
                float2 meshUV = vertex.vertexUV;
                //meshUV.x *= _Resolution.x;

                float test2 = (vertex.vertexUV.x * _Resolution.x) + (vertex.vertexUV.y * _Resolution.y);

                float2 vector_screenUV = vertex.screenPosition.xy / vertex.screenPosition.w;
                //uint test = GenerateRandomFloat(vector_screenUV);
                //float test = GenerateRandomFloat(vector_screenUV);
                float test = GenerateRandomFloat(meshUV);

                #if defined (_INPUTTYPE_EQUIRECTANGULAR)
                    //int2 uv = sample_coord(test2, _MipLevel);
                    //uv.x /= _Resolution.x;
                    //uv.y /= _Resolution.y;
                    //return float4(uv, 0, 1);
                    //return float4(sampleCoord(meshUV, _MipLevel), 0, 1);
                    //return float4(tex2Dlod(_InputEquirectangular, float4(sampleCoord(meshUV, _MipLevel), 0, 0)).rgb, 1);

                    //return float4(tex2Dlod(_InputEquirectangular, float4(MySampleCord(meshUV, _MipLevel), 0, 0)).rgb, 1);
                    //return float4(tex2Dlod(_InputEquirectangular, float4(ImportanceSample(meshUV), 0, 0)).rgb, 1);








                    //let screen_size = uint2(textureDimensions(screen));
                    //uint2 screen_size = uint2(_InputEquirectangular_TexelSize.z, _InputEquirectangular_TexelSize.w);
                    //uint2 screen_size = uint2(_ScreenParams.x, _ScreenParams.y);

                    //var seed = id.x + id.y * screen_size.x + time.frame * screen_size.x * screen_size.y;
                    //uint seed = meshUV.x + meshUV.y * screen_size.x * screen_size.y;
                    //uint seed = vector_screenUV.x + vector_screenUV.y * screen_size.x * screen_size.y;
                    //uint seed = (vector_screenUV.x * screen_size.x) + (vector_screenUV.y * screen_size.y);

                    //let mipmax = int(textureNumLevels(channel0)) - 1;
                    int mipmax = _MipLevel - 1;

                    //let uv = float2(sample_coord(&seed, mipmax)) / float2(textureDimensions(channel0));
                    //float2 uv = sample_coord(seed, mipmax) / float2(_InputEquirectangular_TexelSize.z, _InputEquirectangular_TexelSize.w);
                    //float2 uv = sample_coord(seed, mipmax);
                    //float2 uv = sample_coord(testInt, mipmax);
                    //float2 uv = sample_coord(meshUV, mipmax);
                    //float2 uv = sample_coord(meshUV, mipmax);
                    float2 uv = sample_coord(meshUV, mipmax);

                    if (uv.y > 1.0f || uv.x > 1.0f) 
                    //if (uv.y < 1.0f || uv.x < 1.0f) 
                        return float4(0, 0, 0, 1); 

                    //if (flip(seed, 0.25)) 
                    //if (flip(testInt, 0.25)) 
                    //{
                    return float4(1, 1, 1, 1); 
                        //textureStore(screen, int2(uv * float2(textureDimensions(screen))), float4(1.));
                        //return float4(uv, 0, 1);
                    //}

                    //return float4(tex2Dlod(_InputEquirectangular, float4(uv, 0, 0)).rgb, 1);

                    //return float4(tex2Dlod(_InputEquirectangular, float4(meshUV, 0, 0)).rgb, 1);
                    //return tex2Dlod(_InputEquirectangular, float4(SampleSphericalMap(SampleEquirectangular(vertex.vertexUV)), 0, 0));
                    return float4(0, 0, 0, 1); 
                #else
                    return texCUBElod(_InputCubemap, float4(SampleEquirectangular(vertex.vertexUV), 0));
                #endif
            }
            ENDCG
        }
    }
}
