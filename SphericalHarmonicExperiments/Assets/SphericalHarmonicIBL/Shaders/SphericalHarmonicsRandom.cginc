//||||||||||||||||||||||||| RANDOM |||||||||||||||||||||||||
//||||||||||||||||||||||||| RANDOM |||||||||||||||||||||||||
//||||||||||||||||||||||||| RANDOM |||||||||||||||||||||||||

float rand(float2 n)
{
	return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453);
}

//https://github.com/Unity-Technologies/Graphics/blob/master/Packages/com.unity.render-pipelines.core/ShaderLibrary/Random.hlsl
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

float _Seed;

float GenerateRandomFloat(float2 screenUV)
{
	_Seed += 1.0;
	return GenerateHashedRandomFloat(uint3(screenUV, _Seed));
}