//||||||||||||||||||||||||| UTILITY FUNCTIONS |||||||||||||||||||||||||
//||||||||||||||||||||||||| UTILITY FUNCTIONS |||||||||||||||||||||||||
//||||||||||||||||||||||||| UTILITY FUNCTIONS |||||||||||||||||||||||||

float DifferentialSolidAngle(float2 textureSize, float2 uv)
{
    float2 inv = 1.0f / textureSize;
    float u = 2.0f * (uv.x + 0.5f * inv.x) - 1.0f;
    float v = 2.0f * (uv.y + 0.5f * inv.y) - 1.0f;
    float x0 = u - inv.x;
    float y0 = v - inv.y;
    float x1 = u + inv.x;
    float y1 = v + inv.y;

    float x0_y0 = atan2(x0 * y0, sqrt(x0 * x0 + y0 * y0 + 1));
    float x0_y1 = atan2(x0 * y1, sqrt(x0 * x0 + y1 * y1 + 1));
    float x1_y0 = atan2(x1 * y0, sqrt(x1 * x1 + y0 * y0 + 1));
    float x1_y1 = atan2(x1 * y1, sqrt(x1 * x1 + y1 * y1 + 1));

    return x0_y0 - x0_y1 - x1_y0 + x1_y1;
}

float DifferentialSolidAngle(float textureSize, float2 uv)
{
    float inv = 1.0f / textureSize;
    float u = 2.0f * (uv.x + 0.5f * inv) - 1.0f;
    float v = 2.0f * (uv.y + 0.5f * inv) - 1.0f;
    float x0 = u - inv;
    float y0 = v - inv;
    float x1 = u + inv;
    float y1 = v + inv;

    float x0_y0 = atan2(x0 * y0, sqrt(x0 * x0 + y0 * y0 + 1));
    float x0_y1 = atan2(x0 * y1, sqrt(x0 * x0 + y1 * y1 + 1));
    float x1_y0 = atan2(x1 * y0, sqrt(x1 * x1 + y0 * y0 + 1));
    float x1_y1 = atan2(x1 * y1, sqrt(x1 * x1 + y1 * y1 + 1));

    return x0_y0 - x0_y1 - x1_y0 + x1_y1;
}

float3 DirectionFromCubemapTexel(int face, float u, float v)
{
    switch (face)
    {
        case 0: //+X
            return normalize(float3(1.0f, v * -2.0f + 1.0f, u * -2.0f + 1.0f));
        case 1: //-X
            return normalize(float3(-1.0f, v * -2.0f + 1.0f, u * 2.0f - 1.0f));
        case 2: //+Y
            return normalize(float3(u * 2.0f - 1.0f, 1.0f, v * 2.0f - 1.0f));
        case 3: //-Y
            return normalize(float3(u * 2.0f - 1.0f, -1.0f, v * -2.0f + 1.0f));
        case 4: //+Z
            return normalize(float3(u * 2.0f - 1.0f, v * -2.0f + 1.0f, 1.0f));
        case 5: //-Z
            return normalize(float3(u * -2.0f + 1.0f, v * -2.0f + 1.0f, -1.0f));
        default:
            return float3(0, 0, 0);
    }
}

float LinearToGammaSpace(float linearValue)
{
    return pow(linearValue, 0.454545f);
}

float2 LinearToGammaSpace(float2 linearValue)
{
    return float2(LinearToGammaSpace(linearValue.r), LinearToGammaSpace(linearValue.g));
}

float3 LinearToGammaSpace(float3 linearValue)
{
    return float3(LinearToGammaSpace(linearValue.r), LinearToGammaSpace(linearValue.g), LinearToGammaSpace(linearValue.b));
}

float4 LinearToGammaSpace(float4 linearValue)
{
    return float4(LinearToGammaSpace(linearValue.r), LinearToGammaSpace(linearValue.g), LinearToGammaSpace(linearValue.b), LinearToGammaSpace(linearValue.a));
}

float GammaToLinearSpace(float gammaValue)
{
    return pow(gammaValue, 2.2f);
}

float2 GammaToLinearSpace(float2 gammaValue)
{
    return float2(GammaToLinearSpace(gammaValue.r), GammaToLinearSpace(gammaValue.g));
}

float3 GammaToLinearSpace(float3 gammaValue)
{
    return float3(GammaToLinearSpace(gammaValue.r), GammaToLinearSpace(gammaValue.g), GammaToLinearSpace(gammaValue.b));
}

float4 GammaToLinearSpace(float4 gammaValue)
{
    return float4(GammaToLinearSpace(gammaValue.r), GammaToLinearSpace(gammaValue.g), GammaToLinearSpace(gammaValue.b), GammaToLinearSpace(gammaValue.a));
}

// texelArea = 4.0 / (resolution * resolution).
// Ref: http://bpeers.com/blog/?itemid=1017
// This version is less accurate, but much faster than this one:
// http://www.rorydriscoll.com/2012/01/15/cubemap-texel-solid-angle/
float ComputeCubemapTexelSolidAngle(float3 L, float texelArea)
{
	// Stretch 'L' by (1/d) so that it points at a side of a [-1, 1]^2 cube.
	//float d = Max3(abs(L.x), abs(L.y), abs(L.z));
	float d = max(max(abs(L.x), abs(L.y)), abs(L.z));

	// Since 'L' is a unit vector, we can directly compute its
	// new (inverse) length without dividing 'L' by 'd' first.
	float invDist = d;

	// dw = dA * cosTheta / (dist * dist), cosTheta = 1.0 / dist,
	// where 'dA' is the area of the cube map texel.
	return texelArea * invDist * invDist * invDist;
}

// Only makes sense for Monte-Carlo integration.
// Normalize by dividing by the total weight (or the number of samples) in the end.
// Integrate[6*(u^2+v^2+1)^(-3/2), {u,-1,1},{v,-1,1}] = 4 * Pi
// Ref: "Stupid Spherical Harmonics Tricks", p. 9.
float ComputeCubemapTexelSolidAngle(float2 uv)
{
	float u = uv.x;
	float v = uv.y;

	return pow(1 + u * u + v * v, -1.5);
}

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
	float sinPhi;
	float cosPhi;

	sincos(phi, sinPhi, cosPhi);

	return SphericalToCartesian(cosPhi, sinPhi, cosTheta);
}

// Converts Cartesian coordinates given in the right-handed coordinate system
// with Z pointing upwards (OpenGL style) to the coordinates in the left-handed
// coordinate system with Y pointing up and Z facing forward (DirectX style).
float3 TransformGLtoDX(float3 v)
{
	return v.xzy;
}

// Performs conversion from equiareal map coordinates to Cartesian (DirectX cubemap) ones.
float3 ConvertEquiarealToCubemap(float2 uv)
{
	float phi = UNITY_TWO_PI - UNITY_TWO_PI * uv.x;
	float cosTheta = 1.0 - 2.0 * uv.y;

	return TransformGLtoDX(SphericalToCartesian(phi, cosTheta));
}