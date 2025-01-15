//||||||||||||||||||||||||| SPHERICAL FUNCTIONS |||||||||||||||||||||||||
//||||||||||||||||||||||||| SPHERICAL FUNCTIONS |||||||||||||||||||||||||
//||||||||||||||||||||||||| SPHERICAL FUNCTIONS |||||||||||||||||||||||||

float2 SampleSphericalMap(float3 direction)
{
	//const float2 invAtan = float2(1.0 / (PI * 2), 1.0 / PI);
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
	//float2 coord = uv * 2.0f - 1.0f;
	float2 coord = uv * 2.0f - 1.0f;

	// Convert to (lat, lon) angle
	float2 a = coord * float2(3.14159265, 1.57079633);

	// Convert to cartesian coordinates
	float2 c = cos(a);
	float2 s = sin(a);

	return float3(float2(s.x, c.x) * c.y, s.y);
}

float3 SampleEnvironmentDirection_FibonacciSphere(int sampleIndex, int sampleCount)
{
	float angleIncrement = 10.1664073846305f; //precomputed version of (UNITY_PI * 2 * ((1 + sqrt(5)) / 2))
	float y = 1.0f - (sampleIndex + 0.5f) / sampleCount * 2.0f;
	float radius = sqrt(1.0f - y * y);
	float theta = sampleIndex * angleIncrement;
	float x = cos(theta) * radius;
	float z = sin(theta) * radius;

	return float3(x, y, z);
}

float3 SampleEnvironmentDirection_RandomSphere(int sampleIndex, int sampleCount)
{
	float x = GenerateRandomFloat(float2(sampleIndex, sampleCount));
	float y = GenerateRandomFloat(float2(sampleIndex, sampleCount));
	float z = GenerateRandomFloat(float2(sampleIndex, sampleCount));
	float3 direction = float3(x, y, z) * 2.0f - 1.0f;
	return normalize(direction);
}