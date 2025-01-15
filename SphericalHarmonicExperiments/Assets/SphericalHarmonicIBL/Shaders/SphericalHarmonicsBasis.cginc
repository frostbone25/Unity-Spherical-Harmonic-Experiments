//||||||||||||||||||||||||||||| SPHERICAL HARMONIC BASIS FUNCTIONS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SPHERICAL HARMONIC BASIS FUNCTIONS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SPHERICAL HARMONIC BASIS FUNCTIONS |||||||||||||||||||||||||||||

//||||||||||||||||||||||||||||| ORDER 0 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 0 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 0 START |||||||||||||||||||||||||||||

//ORDER = 0 | M = 0
float SphericalHarmonicBasis0(float3 dir)
{
	return 0.282094791773878f;
}

//||||||||||||||||||||||||||||| ORDER 0 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 0 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 0 END |||||||||||||||||||||||||||||

//||||||||||||||||||||||||||||| ORDER 1 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 1 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 1 START |||||||||||||||||||||||||||||

//ORDER = 1 | M = -1
float SphericalHarmonicBasis1(float3 dir)
{
	return 0.48860251190292f * dir.y;
}

//ORDER = 1 | M = 0
float SphericalHarmonicBasis2(float3 dir)
{
	return 0.48860251190292f * dir.z;
}

//ORDER = 1 | M = 1
float SphericalHarmonicBasis3(float3 dir)
{
	return 0.48860251190292f * dir.x;
}

//||||||||||||||||||||||||||||| ORDER 1 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 1 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 1 END |||||||||||||||||||||||||||||

//||||||||||||||||||||||||||||| ORDER 2 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 2 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 2 START |||||||||||||||||||||||||||||

//ORDER = 2 | M = -2
float SphericalHarmonicBasis4(float3 dir)
{
	return 1.09254843059208f * dir.x * dir.y;
}

//ORDER = 2 | M = -1
float SphericalHarmonicBasis5(float3 dir)
{
	return 1.09254843059208f * dir.y * dir.z;
}

//ORDER = 2 | M = 0
float SphericalHarmonicBasis6(float3 dir)
{
	return 0.31539156525252f * (3 * dir.z * dir.z - 1);
}

//ORDER = 2 | M = 1
float SphericalHarmonicBasis7(float3 dir)
{
	return 1.09254843059208f * dir.x * dir.z;
}

//ORDER = 2 | M = 2
float SphericalHarmonicBasis8(float3 dir)
{
	return 0.54627421529604f * (dir.x * dir.x - dir.y * dir.y);
}

//||||||||||||||||||||||||||||| ORDER 2 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 2 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 2 END |||||||||||||||||||||||||||||

//||||||||||||||||||||||||||||| ORDER 3 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 3 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 3 START |||||||||||||||||||||||||||||

//ORDER = 3 | M = -3
float SphericalHarmonicBasis9(float3 dir)
{
	return 0.590043589926643f * dir.y * (3 * dir.x * dir.x - dir.y * dir.y);
}

//ORDER = 3 | M = -2
float SphericalHarmonicBasis10(float3 dir)
{
	return 2.89061144264055f * dir.x * dir.y * dir.z;
}

//ORDER = 3 | M = -1
float SphericalHarmonicBasis11(float3 dir)
{
	return 0.457045799464466f * dir.y * (4 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y);
}

//ORDER = 3 | M = 0
float SphericalHarmonicBasis12(float3 dir)
{
	return 0.373176332590115f * (dir.z * (2 * dir.z * dir.z - 3 * dir.x * dir.x - 3 * dir.y * dir.y));
}

//ORDER = 3 | M = 1
float SphericalHarmonicBasis13(float3 dir)
{
	return 0.457045799464466f * dir.x * (4 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y);
}

//ORDER = 3 | M = 2
float SphericalHarmonicBasis14(float3 dir)
{
	return 1.44530572132028f * dir.z * (dir.x * dir.x - dir.y * dir.y);
}

//ORDER = 3 | M = 3
float SphericalHarmonicBasis15(float3 dir)
{
	return 0.590043589926643f * dir.x * (dir.x * dir.x - 3 * dir.y * dir.y);
}

//||||||||||||||||||||||||||||| ORDER 3 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 3 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 3 END |||||||||||||||||||||||||||||

//||||||||||||||||||||||||||||| ORDER 4 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 4 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 4 START |||||||||||||||||||||||||||||

//ORDER = 4 | M = -4
float SphericalHarmonicBasis16(float3 dir)
{
	return 2.5033429417967f * (dir.z * dir.x * (dir.z * dir.z - dir.x * dir.x));
}

//ORDER = 4 | M = -3
float SphericalHarmonicBasis17(float3 dir)
{
	return -1.74465993438048f * (3.0f * dir.z * dir.z - dir.x * dir.x) * dir.x * dir.y;
}

//ORDER = 4 | M = -2
float SphericalHarmonicBasis18(float3 dir)
{
	float dirDot = dot(dir, dir);

	return 0.94617469575756f * (dir.z * dir.x * (7.0f * dir.y * dir.y - dirDot));
}

//ORDER = 4 | M = -1
float SphericalHarmonicBasis19(float3 dir)
{
	float dirDot = dot(dir, dir);

	return -0.598413420602149f * (dir.y * dir.x * (7.0f * dir.y * dir.y - 3.0f * dirDot));
}

//ORDER = 4 | M = 0
float SphericalHarmonicBasis20(float3 dir)
{
	return 0.105785546915204f * (35.0f * (dir.y * dir.y) * (dir.y * dir.y) - 30.0f * (dir.y * dir.y) + 3.0f);
}

//ORDER = 4 | M = 1
float SphericalHarmonicBasis21(float3 dir)
{
	float dirDot = dot(dir, dir);

	return -0.598413420602149f * (dir.y * dir.z * (7.0f * dir.y * dir.y - 3.0f * dirDot));
}

//ORDER = 4 | M = 2
float SphericalHarmonicBasis22(float3 dir)
{
	float dirDot = dot(dir, dir);

	return 0.47308734787878f * ((dir.z * dir.z - dir.x * dir.x) * (7.0f * dir.y * dir.y - dirDot));
}

//ORDER = 4 | M = 3
float SphericalHarmonicBasis23(float3 dir)
{
	return -1.74465993438048f * dir.z * dir.y * (dir.z * dir.z - 3.0f * dir.x * dir.x);
}

//ORDER = 4 | M = 4
float SphericalHarmonicBasis24(float3 dir)
{
	return 0.625835735449176f * ((dir.z * dir.z) * ((dir.z * dir.z) - 3.0f * (dir.x * dir.x)) - (dir.x * dir.x) * (3.0f * (dir.z * dir.z) - (dir.x * dir.x)));
}

//||||||||||||||||||||||||||||| ORDER 4 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 4 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 4 END |||||||||||||||||||||||||||||

//||||||||||||||||||||||||||||| ORDER 5 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 5 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 5 START |||||||||||||||||||||||||||||

//ORDER = 5 | M = -5
float SphericalHarmonicBasis25(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 0.464132203440858f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * sin(-5.0f * phi);
}

//ORDER = 5 | M = -4
float SphericalHarmonicBasis26(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 1.46771489830575f * (sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * cos(-4.0f * phi);
}

//ORDER = 5 | M = -3
float SphericalHarmonicBasis27(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 0.34594371914684f * (sinTheta * sinTheta * sinTheta) * (9.0f * dir.z * dir.z - 1.0f) * sin(-3.0f * phi);
}

//ORDER = 5 | M = -2
float SphericalHarmonicBasis28(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 1.6947711832609f * (sinTheta * sinTheta) * (3.0f * dir.z * dir.z * dir.z - dir.z) * cos(-2.0f * phi);
}

//ORDER = 5 | M = -1
float SphericalHarmonicBasis29(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 0.320281648576215f * sinTheta * (21.0f * dir.z * dir.z * dir.z * dir.z - 14.0f * dir.z * dir.z + 1.0f) * sin(-1.0f * phi);
}

//ORDER = 5 | M = 0
float SphericalHarmonicBasis30(float3 dir)
{
	return 0.116950322453424f * (63.0f * dir.z * dir.z * dir.z * dir.z * dir.z - 70.0f * dir.z * dir.z * dir.z + 15.0f * dir.z);
}

//ORDER = 5 | M = 1
float SphericalHarmonicBasis31(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return -0.320281648576215f * sinTheta * (21.0f * dir.z * dir.z * dir.z * dir.z - 14.0f * dir.z * dir.z + 1.0f) * cos(phi);
}

//ORDER = 5 | M = 2
float SphericalHarmonicBasis32(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 1.6947711832609f * (sinTheta * sinTheta) * (3.0f * dir.z * dir.z * dir.z - dir.z) * sin(2.0f * phi);
}

//ORDER = 5 | M = 3
float SphericalHarmonicBasis33(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return -0.34594371914684f * (sinTheta * sinTheta * sinTheta) * (9.0f * dir.z * dir.z - 1.0f) * cos(3.0f * phi);
}

//ORDER = 5 | M = 4
float SphericalHarmonicBasis34(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 1.46771489830575f * (sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * sin(4.0f * phi);
}

//ORDER = 5 | M = 5
float SphericalHarmonicBasis35(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return -0.464132203440858f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * cos(5.0f * phi);
}

//||||||||||||||||||||||||||||| ORDER 5 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 5 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 5 END |||||||||||||||||||||||||||||

//||||||||||||||||||||||||||||| ORDER 6 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 6 START |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 6 START |||||||||||||||||||||||||||||

//ORDER = 6 | M = -6
float SphericalHarmonicBasis36(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 0.483084113580066f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * sin(-6.0f * phi);
}

//ORDER = 6 | M = -5
float SphericalHarmonicBasis37(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 1.6734524581001f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * cos(-5.0f * phi);
}

//ORDER = 6 | M = -4
float SphericalHarmonicBasis38(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 0.356781262853998f * (sinTheta * sinTheta * sinTheta * sinTheta) * (11.0f * dir.z * dir.z - 1.0f) * sin(-4.0f * phi);
}

//ORDER = 6 | M = -3
float SphericalHarmonicBasis39(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 0.651390485867716f * (sinTheta * sinTheta * sinTheta) * (11.0f * dir.z * dir.z * dir.z - 3.0f * dir.z) * cos(-3.0f * phi);
}

//ORDER = 6 | M = -2
float SphericalHarmonicBasis40(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 0.325695242933858f * (sinTheta * sinTheta) * (33.0f * dir.z * dir.z * dir.z * dir.z - 18.0f * dir.z * dir.z + 1.0f) * sin(-2.0f * phi);
}

//ORDER = 6 | M = -1
float SphericalHarmonicBasis41(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 0.411975516301141f * sinTheta * (33.0f * dir.z * dir.z * dir.z * dir.z * dir.z - 30.0f * dir.z * dir.z * dir.z + 5.0f * dir.z) * cos(-1.0f * phi);
}

//ORDER = 6 | M = 0
float SphericalHarmonicBasis42(float3 dir)
{
	return 0.0635692022676284f * (231.0f * dir.z * dir.z * dir.z * dir.z * dir.z * dir.z - 315.0f * dir.z * dir.z * dir.z * dir.z + 105.0f * dir.z * dir.z - 5.0f);
}

//ORDER = 6 | M = 1
float SphericalHarmonicBasis43(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return -0.411975516301141f * sinTheta * (33.0f * dir.z * dir.z * dir.z * dir.z * dir.z - 30.0f * dir.z * dir.z * dir.z + 5.0f * dir.z) * sin(phi);
}

//ORDER = 6 | M = 2
float SphericalHarmonicBasis44(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 0.325695242933858f * (sinTheta * sinTheta) * (33.0f * dir.z * dir.z * dir.z * dir.z - 18.0f * dir.z * dir.z + 1.0f) * cos(2.0f * phi);
}

//ORDER = 6 | M = 3
float SphericalHarmonicBasis45(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return -0.651390485867716f * (sinTheta * sinTheta * sinTheta) * (11.0f * dir.z * dir.z * dir.z - 3.0f * dir.z) * sin(3.0f * phi);
}

//ORDER = 6 | M = 4
float SphericalHarmonicBasis46(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 0.356781262853998f * (sinTheta * sinTheta * sinTheta * sinTheta) * (11.0f * dir.z * dir.z - 1.0f) * cos(4.0f * phi);
}

//ORDER = 6 | M = 5
float SphericalHarmonicBasis47(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return -1.6734524581001f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * sin(5.0f * phi);
}

//ORDER = 6 | M = 6
float SphericalHarmonicBasis48(float3 dir)
{
	float phi = atan2(dir.y, dir.x);
	float sinTheta = sqrt(1.0f - dir.z * dir.z);

	return 0.483084113580066f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * cos(6.0f * phi);
}

//||||||||||||||||||||||||||||| ORDER 6 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 6 END |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| ORDER 6 END |||||||||||||||||||||||||||||

float EvaluateBasisFunction(int l, int m, float3 dir)
{
	// Base case for l = 0, m = 0
	if (l == 0 && m == 0)
		return SphericalHarmonicBasis0(dir);
	else if (l == 1) // First order (l = 1)
	{
		if (m == -1)
			return SphericalHarmonicBasis1(dir);
		if (m == 0)
			return SphericalHarmonicBasis2(dir);
		if (m == 1)
			return SphericalHarmonicBasis3(dir);
	}
	else if (l == 2) // Second order (l = 2)
	{
		if (m == -2)
			return SphericalHarmonicBasis4(dir);
		if (m == -1)
			return SphericalHarmonicBasis5(dir);
		if (m == 0)
			return SphericalHarmonicBasis6(dir);
		if (m == 1)
			return SphericalHarmonicBasis7(dir);
		if (m == 2)
			return SphericalHarmonicBasis8(dir);
	}
	else if (l == 3) // Third order (l = 3)
	{
		if (m == -3)
			return SphericalHarmonicBasis9(dir);
		if (m == -2)
			return SphericalHarmonicBasis10(dir);
		if (m == -1)
			return SphericalHarmonicBasis11(dir);
		if (m == 0)
			return SphericalHarmonicBasis12(dir);
		if (m == 1)
			return SphericalHarmonicBasis13(dir);
		if (m == 2)
			return SphericalHarmonicBasis14(dir);
		if (m == 3)
			return SphericalHarmonicBasis15(dir);
	}
	else if (l == 4) // Fourth order (l = 4)
	{
		if (m == -4)
			return SphericalHarmonicBasis16(dir);
		if (m == -3)
			return SphericalHarmonicBasis17(dir);
		if (m == -2)
			return SphericalHarmonicBasis18(dir);
		if (m == -1)
			return SphericalHarmonicBasis19(dir);
		if (m == 0)
			return SphericalHarmonicBasis20(dir);
		if (m == 1)
			return SphericalHarmonicBasis21(dir);
		if (m == 2)
			return SphericalHarmonicBasis22(dir);
		if (m == 3)
			return SphericalHarmonicBasis23(dir);
		if (m == 4)
			return SphericalHarmonicBasis24(dir);
	}
	else if (l == 5) // Fifth order (l = 5)
	{
		if (m == -5)
			return SphericalHarmonicBasis25(dir);
		else if (m == -4)
			return SphericalHarmonicBasis26(dir);
		else if (m == -3)
			return SphericalHarmonicBasis27(dir);
		else if (m == -2)
			return SphericalHarmonicBasis28(dir);
		else if (m == -1)
			return SphericalHarmonicBasis29(dir);
		else if (m == 0)
			return SphericalHarmonicBasis30(dir);
		else if (m == 1)
			return SphericalHarmonicBasis31(dir);
		else if (m == 2)
			return SphericalHarmonicBasis32(dir);
		else if (m == 3)
			return SphericalHarmonicBasis33(dir);
		else if (m == 4)
			return SphericalHarmonicBasis34(dir);
		else if (m == 5)
			return SphericalHarmonicBasis35(dir);
	}
	else if (l == 6) // Sixth order (l = 6)
	{
		if (m == -6)
			return SphericalHarmonicBasis36(dir);
		else if (m == -5)
			return SphericalHarmonicBasis37(dir);
		else if (m == -4)
			return SphericalHarmonicBasis38(dir);
		else if (m == -3)
			return SphericalHarmonicBasis39(dir);
		else if (m == -2)
			return SphericalHarmonicBasis40(dir);
		else if (m == -1)
			return SphericalHarmonicBasis41(dir);
		else if (m == 0)
			return SphericalHarmonicBasis42(dir);
		else if (m == 1)
			return SphericalHarmonicBasis43(dir);
		else if (m == 2)
			return SphericalHarmonicBasis44(dir);
		else if (m == 3)
			return SphericalHarmonicBasis45(dir);
		else if (m == 4)
			return SphericalHarmonicBasis46(dir);
		else if (m == 5)
			return SphericalHarmonicBasis47(dir);
		else if (m == 6)
			return SphericalHarmonicBasis48(dir);
	}

	// Fallback for unhandled cases
	return 0;
}