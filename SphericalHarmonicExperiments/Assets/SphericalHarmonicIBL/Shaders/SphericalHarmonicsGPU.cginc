//||||||||||||||||||||||||||||||||| (ORDER 6) RADIANCE COEFFICENTS 32 BIT FLOATS (49 float3s) |||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||| (ORDER 6) RADIANCE COEFFICENTS 32 BIT FLOATS (49 float3s) |||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||| (ORDER 6) RADIANCE COEFFICENTS 32 BIT FLOATS (49 float3s) |||||||||||||||||||||||||||||||||

//radiance order 0
float3 _RadianceCoefficents0;

//radiance order 1
float3 _RadianceCoefficents1;
float3 _RadianceCoefficents2;
float3 _RadianceCoefficents3;

//radiance order 2
float3 _RadianceCoefficents4;
float3 _RadianceCoefficents5;
float3 _RadianceCoefficents6;
float3 _RadianceCoefficents7;
float3 _RadianceCoefficents8;

//radiance order 3
float3 _RadianceCoefficents9;
float3 _RadianceCoefficents10;
float3 _RadianceCoefficents11;
float3 _RadianceCoefficents12;
float3 _RadianceCoefficents13;
float3 _RadianceCoefficents14;
float3 _RadianceCoefficents15;

//radiance order 4
float3 _RadianceCoefficents16;
float3 _RadianceCoefficents17;
float3 _RadianceCoefficents18;
float3 _RadianceCoefficents19;
float3 _RadianceCoefficents20;
float3 _RadianceCoefficents21;
float3 _RadianceCoefficents22;
float3 _RadianceCoefficents23;
float3 _RadianceCoefficents24;

//radiance order 5
float3 _RadianceCoefficents25;
float3 _RadianceCoefficents26;
float3 _RadianceCoefficents27;
float3 _RadianceCoefficents28;
float3 _RadianceCoefficents29;
float3 _RadianceCoefficents30;
float3 _RadianceCoefficents31;
float3 _RadianceCoefficents32;
float3 _RadianceCoefficents33;
float3 _RadianceCoefficents34;
float3 _RadianceCoefficents35;

//radiance order 6
float3 _RadianceCoefficents36;
float3 _RadianceCoefficents37;
float3 _RadianceCoefficents38;
float3 _RadianceCoefficents39;
float3 _RadianceCoefficents40;
float3 _RadianceCoefficents41;
float3 _RadianceCoefficents42;
float3 _RadianceCoefficents43;
float3 _RadianceCoefficents44;
float3 _RadianceCoefficents45;
float3 _RadianceCoefficents46;
float3 _RadianceCoefficents47;
float3 _RadianceCoefficents48;

//||||||||||||||||||||||||||||||||| (ORDER 2) IRRADIANCE COEFFICENTS 32 BIT FLOATS (9 float3s) |||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||| (ORDER 2) IRRADIANCE COEFFICENTS 32 BIT FLOATS (9 float3s) |||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||| (ORDER 2) IRRADIANCE COEFFICENTS 32 BIT FLOATS (9 float3s) |||||||||||||||||||||||||||||||||

//irradiance order 0
float3 _IrradianceCoefficents0;

//irradiance order 1
float3 _IrradianceCoefficents1;
float3 _IrradianceCoefficents2;
float3 _IrradianceCoefficents3;

//irradiance order 2
float3 _IrradianceCoefficents4;
float3 _IrradianceCoefficents5;
float3 _IrradianceCoefficents6;
float3 _IrradianceCoefficents7;
float3 _IrradianceCoefficents8;

//||||||||||||||||||||||||||||||||| (ORDER 2) IRRADIANCE COEFFICENTS 16 BIT HALF - FLOATS (14 ints) |||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||| (ORDER 2) IRRADIANCE COEFFICENTS 16 BIT HALF - FLOATS (14 ints) |||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||| (ORDER 2) IRRADIANCE COEFFICENTS 16 BIT HALF - FLOATS (14 ints) |||||||||||||||||||||||||||||||||

int _PackedIrradianceCoefficents_0R_0G;
int _PackedIrradianceCoefficents_0B_1R;
int _PackedIrradianceCoefficents_1G_1B;
int _PackedIrradianceCoefficents_2R_2G;
int _PackedIrradianceCoefficents_2B_3R;
int _PackedIrradianceCoefficents_3G_3B;
int _PackedIrradianceCoefficents_4R_4G;
int _PackedIrradianceCoefficents_4B_5R;
int _PackedIrradianceCoefficents_5G_5B;
int _PackedIrradianceCoefficents_6R_6G;
int _PackedIrradianceCoefficents_6B_7R;
int _PackedIrradianceCoefficents_7G_7B;
int _PackedIrradianceCoefficents_8R_8G;
int _PackedIrradianceCoefficents_8B;

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

//||||||||||||||||||||||||||||| SPHERICAL HARMONIC IRRADIANCE DOMINANT LIGHT DIRECTION |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SPHERICAL HARMONIC IRRADIANCE DOMINANT LIGHT DIRECTION |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| SPHERICAL HARMONIC IRRADIANCE DOMINANT LIGHT DIRECTION |||||||||||||||||||||||||||||

//Computes the dominant direction of light from the L1 band of the SH irradiance environment
float3 CalculateDominantLightDirectionFromIrradiance()
{
	float3 dominantDirection = float3(0, 0, 0);

	//Reference - https://simonstechblog.blogspot.com/2012/02/extracting-dominant-light-from.html#sh_extractDominantLight
	//Reference Equation - https://3.bp.blogspot.com/-8LYkqfaguAg/TzdcSjnzCfI/AAAAAAAAAOA/oHxeyEv6etE/s1600/LeDirRGB.png
	dominantDirection += 0.3 * float3(_IrradianceCoefficents3.r, _IrradianceCoefficents1.r, _IrradianceCoefficents2.r);
	dominantDirection += 0.59 * float3(_IrradianceCoefficents3.g, _IrradianceCoefficents1.g, _IrradianceCoefficents2.g);
	dominantDirection += 0.11 * float3(_IrradianceCoefficents3.b, _IrradianceCoefficents1.b, _IrradianceCoefficents2.b);

	//normalize to keep it in range -1..1
	dominantDirection = normalize(dominantDirection);

	return dominantDirection;
}

//||||||||||||||||||||||||||||| DERINGING SPHERICAL HARMONICS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| DERINGING SPHERICAL HARMONICS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| DERINGING SPHERICAL HARMONICS |||||||||||||||||||||||||||||

// Applies Hanning filter for given window size
void FilterHanning(float3 inputCoefficents[9], out float3 filteredCoefficents[9], float filterWindowSize)
{
	float filterWindowSizeReciprocal = 1.0f / filterWindowSize;
	float2 Factors = float2(0.5f * (1.0f + cos(UNITY_PI * filterWindowSizeReciprocal)), 0.5f * (1.0f + cos(2.0f * UNITY_PI * filterWindowSizeReciprocal)));
	
	filteredCoefficents[0] = inputCoefficents[0];
	filteredCoefficents[1] = Factors.x * inputCoefficents[1];
	filteredCoefficents[2] = Factors.x * inputCoefficents[2];
	filteredCoefficents[3] = Factors.x * inputCoefficents[3];
	filteredCoefficents[4] = Factors.y * inputCoefficents[4];
	filteredCoefficents[5] = Factors.y * inputCoefficents[5];
	filteredCoefficents[6] = Factors.y * inputCoefficents[6];
	filteredCoefficents[7] = Factors.y * inputCoefficents[7];
	filteredCoefficents[8] = Factors.y * inputCoefficents[8];
}

// Applies Lanczos filter for given window size
void FilterLanczos(float3 inputCoefficents[9], out float3 filteredCoefficents[9], float filterWindowSize)
{
	float filterWindowSizeReciprocal = 1.0f / filterWindowSize;
	float2 Factors = float2(sin(UNITY_PI * filterWindowSizeReciprocal) / (UNITY_PI * filterWindowSizeReciprocal), sin(2.0f * UNITY_PI * filterWindowSizeReciprocal) / (2.0f * UNITY_PI * filterWindowSizeReciprocal));
	
	filteredCoefficents[0] = inputCoefficents[0];
	filteredCoefficents[1] = Factors.x * inputCoefficents[1];
	filteredCoefficents[2] = Factors.x * inputCoefficents[2];
	filteredCoefficents[3] = Factors.x * inputCoefficents[3];
	filteredCoefficents[4] = Factors.y * inputCoefficents[4];
	filteredCoefficents[5] = Factors.y * inputCoefficents[5];
	filteredCoefficents[6] = Factors.y * inputCoefficents[6];
	filteredCoefficents[7] = Factors.y * inputCoefficents[7];
	filteredCoefficents[8] = Factors.y * inputCoefficents[8];
}

// Applies gaussian filter for given window size
void FilterGaussian(float3 inputCoefficents[9], out float3 filteredCoefficents[9], float filterWindowSize)
{
	float filterWindowSizeReciprocal = 1.0f / filterWindowSize;
	float2 Factors = float2(exp(-0.5f * (UNITY_PI * filterWindowSizeReciprocal) * (UNITY_PI * filterWindowSizeReciprocal)), exp(-0.5f * (2.0f * UNITY_PI * filterWindowSizeReciprocal) * (2.0f * UNITY_PI * filterWindowSizeReciprocal)));
	
	filteredCoefficents[0] = inputCoefficents[0];
	filteredCoefficents[1] = Factors.x * inputCoefficents[1];
	filteredCoefficents[2] = Factors.x * inputCoefficents[2];
	filteredCoefficents[3] = Factors.x * inputCoefficents[3];
	filteredCoefficents[4] = Factors.y * inputCoefficents[4];
	filteredCoefficents[5] = Factors.y * inputCoefficents[5];
	filteredCoefficents[6] = Factors.y * inputCoefficents[6];
	filteredCoefficents[7] = Factors.y * inputCoefficents[7];
	filteredCoefficents[8] = Factors.y * inputCoefficents[8];
}

//||||||||||||||||||||||||||||| CALCULATING SPHERICAL HARMONIC RADIANCE ORDERS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| CALCULATING SPHERICAL HARMONIC RADIANCE ORDERS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| CALCULATING SPHERICAL HARMONIC RADIANCE ORDERS |||||||||||||||||||||||||||||

float3 ApplySphericalHarmonicsRadianceOrder0(float3 direction)
{
	return _RadianceCoefficents0 * SphericalHarmonicBasis0(direction);
}

float3 ApplySphericalHarmonicsRadianceOrder1(float3 direction)
{
	float3 sphericalHarmonicsRadiance = float3(0, 0, 0);
	sphericalHarmonicsRadiance += _RadianceCoefficents1 * SphericalHarmonicBasis1(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents2 * SphericalHarmonicBasis2(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents3 * SphericalHarmonicBasis3(direction);
	return sphericalHarmonicsRadiance;
}

float3 ApplySphericalHarmonicsRadianceOrder2(float3 direction)
{
	float3 sphericalHarmonicsRadiance = float3(0, 0, 0);
	sphericalHarmonicsRadiance += _RadianceCoefficents4 * SphericalHarmonicBasis4(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents5 * SphericalHarmonicBasis5(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents6 * SphericalHarmonicBasis6(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents7 * SphericalHarmonicBasis7(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents8 * SphericalHarmonicBasis8(direction);
	return sphericalHarmonicsRadiance;
}

float3 ApplySphericalHarmonicsRadianceOrder3(float3 direction)
{
	float3 sphericalHarmonicsRadiance = float3(0, 0, 0);
	sphericalHarmonicsRadiance += _RadianceCoefficents9 * SphericalHarmonicBasis9(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents10 * SphericalHarmonicBasis10(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents11 * SphericalHarmonicBasis11(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents12 * SphericalHarmonicBasis12(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents13 * SphericalHarmonicBasis13(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents14 * SphericalHarmonicBasis14(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents15 * SphericalHarmonicBasis15(direction);
	return sphericalHarmonicsRadiance;
}

float3 ApplySphericalHarmonicsRadianceOrder4(float3 direction)
{
	float3 sphericalHarmonicsRadiance = float3(0, 0, 0);
	sphericalHarmonicsRadiance += _RadianceCoefficents16 * SphericalHarmonicBasis16(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents17 * SphericalHarmonicBasis17(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents18 * SphericalHarmonicBasis18(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents19 * SphericalHarmonicBasis19(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents20 * SphericalHarmonicBasis20(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents21 * SphericalHarmonicBasis21(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents22 * SphericalHarmonicBasis22(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents23 * SphericalHarmonicBasis23(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents24 * SphericalHarmonicBasis24(direction);
	return sphericalHarmonicsRadiance;
}

float3 ApplySphericalHarmonicsRadianceOrder5(float3 direction)
{
	float3 sphericalHarmonicsRadiance = float3(0, 0, 0);
	sphericalHarmonicsRadiance += _RadianceCoefficents25 * SphericalHarmonicBasis25(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents26 * SphericalHarmonicBasis26(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents27 * SphericalHarmonicBasis27(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents28 * SphericalHarmonicBasis28(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents29 * SphericalHarmonicBasis29(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents30 * SphericalHarmonicBasis30(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents31 * SphericalHarmonicBasis31(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents32 * SphericalHarmonicBasis32(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents33 * SphericalHarmonicBasis33(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents34 * SphericalHarmonicBasis34(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents35 * SphericalHarmonicBasis35(direction);
	return sphericalHarmonicsRadiance;
}

float3 ApplySphericalHarmonicsRadianceOrder6(float3 direction)
{
	float3 sphericalHarmonicsRadiance = float3(0, 0, 0);
	sphericalHarmonicsRadiance += _RadianceCoefficents36 * SphericalHarmonicBasis36(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents37 * SphericalHarmonicBasis37(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents38 * SphericalHarmonicBasis38(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents39 * SphericalHarmonicBasis39(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents40 * SphericalHarmonicBasis40(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents41 * SphericalHarmonicBasis41(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents42 * SphericalHarmonicBasis42(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents43 * SphericalHarmonicBasis43(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents44 * SphericalHarmonicBasis44(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents45 * SphericalHarmonicBasis45(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents46 * SphericalHarmonicBasis46(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents47 * SphericalHarmonicBasis47(direction);
	sphericalHarmonicsRadiance += _RadianceCoefficents48 * SphericalHarmonicBasis48(direction);
	return sphericalHarmonicsRadiance;
}

float3 CalculateSphericalHarmonicRadiance(float3 direction)
{
	float3 sphericalHarmonicsRadiance = float3(0, 0, 0);

	//apply orders
	sphericalHarmonicsRadiance += ApplySphericalHarmonicsRadianceOrder0(direction);
	sphericalHarmonicsRadiance += ApplySphericalHarmonicsRadianceOrder1(direction);
	sphericalHarmonicsRadiance += ApplySphericalHarmonicsRadianceOrder2(direction);
	sphericalHarmonicsRadiance += ApplySphericalHarmonicsRadianceOrder3(direction);
	sphericalHarmonicsRadiance += ApplySphericalHarmonicsRadianceOrder4(direction);
	sphericalHarmonicsRadiance += ApplySphericalHarmonicsRadianceOrder5(direction);
	sphericalHarmonicsRadiance += ApplySphericalHarmonicsRadianceOrder6(direction);

	//[Gamma -> Linear] 2.2
	sphericalHarmonicsRadiance = pow(sphericalHarmonicsRadiance, 2.2);

	return sphericalHarmonicsRadiance;
}

//||||||||||||||||||||||||||||| CALCULATING SPHERICAL HARMONIC IRRADIANCE ORDERS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| CALCULATING SPHERICAL HARMONIC IRRADIANCE ORDERS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| CALCULATING SPHERICAL HARMONIC IRRADIANCE ORDERS |||||||||||||||||||||||||||||

float3 ApplySphericalHarmonicsIrradianceOrder0(float3 direction)
{
	return _IrradianceCoefficents0 * SphericalHarmonicBasis0(direction);
}

float3 ApplySphericalHarmonicsIrradianceOrder1(float3 direction)
{
	float3 sphericalHarmonicsIrradiance = float3(0, 0, 0);
	sphericalHarmonicsIrradiance += _IrradianceCoefficents1 * SphericalHarmonicBasis1(direction);
	sphericalHarmonicsIrradiance += _IrradianceCoefficents2 * SphericalHarmonicBasis2(direction);
	sphericalHarmonicsIrradiance += _IrradianceCoefficents3 * SphericalHarmonicBasis3(direction);
	return sphericalHarmonicsIrradiance;
}

float3 ApplySphericalHarmonicsIrradianceOrder2(float3 direction)
{
	float3 sphericalHarmonicsIrradiance = float3(0, 0, 0);
	sphericalHarmonicsIrradiance += _IrradianceCoefficents4 * SphericalHarmonicBasis4(direction);
	sphericalHarmonicsIrradiance += _IrradianceCoefficents5 * SphericalHarmonicBasis5(direction);
	sphericalHarmonicsIrradiance += _IrradianceCoefficents6 * SphericalHarmonicBasis6(direction);
	sphericalHarmonicsIrradiance += _IrradianceCoefficents7 * SphericalHarmonicBasis7(direction);
	sphericalHarmonicsIrradiance += _IrradianceCoefficents8 * SphericalHarmonicBasis8(direction);
	return sphericalHarmonicsIrradiance;
}

float3 CalculateSphericalHarmonicIrradiance(float3 vector_normalDirection)
{
	float3 sphericalHarmonicsIrradiance = float3(0, 0, 0);

	//apply orders (irradiance) and convolve into diffuse
	sphericalHarmonicsIrradiance += 3.1415926535897932384f * ApplySphericalHarmonicsIrradianceOrder0(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * ApplySphericalHarmonicsIrradianceOrder1(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539 * ApplySphericalHarmonicsIrradianceOrder2(vector_normalDirection);

	//Divide irradiance by PI because albedo
	sphericalHarmonicsIrradiance /= UNITY_PI;

	return float4(sphericalHarmonicsIrradiance, 1);
}

void Unpack_2_Float32_From_Int32(int halfAB, out float floatA, out float floatB)
{
	uint halfA = (uint)(halfAB >> 16);
	uint halfB = (uint)(halfAB & 0xFFFF);

	floatA = f16tof32(halfA);
	floatB = f16tof32(halfB);
}

float3 CalculateSphericalHarmonicIrradiance16(float3 vector_normalDirection)
{
	float3 sphericalHarmonicsIrradiance = float3(0, 0, 0);

	float UnpackedIrradianceCoefficents0_R = 0;
	float UnpackedIrradianceCoefficents0_G = 0;
	float UnpackedIrradianceCoefficents0_B = 0;

	float UnpackedIrradianceCoefficents1_R = 0;
	float UnpackedIrradianceCoefficents1_G = 0;
	float UnpackedIrradianceCoefficents1_B = 0;

	float UnpackedIrradianceCoefficents2_R = 0;
	float UnpackedIrradianceCoefficents2_G = 0;
	float UnpackedIrradianceCoefficents2_B = 0;

	float UnpackedIrradianceCoefficents3_R = 0;
	float UnpackedIrradianceCoefficents3_G = 0;
	float UnpackedIrradianceCoefficents3_B = 0;

	float UnpackedIrradianceCoefficents4_R = 0;
	float UnpackedIrradianceCoefficents4_G = 0;
	float UnpackedIrradianceCoefficents4_B = 0;

	float UnpackedIrradianceCoefficents5_R = 0;
	float UnpackedIrradianceCoefficents5_G = 0;
	float UnpackedIrradianceCoefficents5_B = 0;

	float UnpackedIrradianceCoefficents6_R = 0;
	float UnpackedIrradianceCoefficents6_G = 0;
	float UnpackedIrradianceCoefficents6_B = 0;

	float UnpackedIrradianceCoefficents7_R = 0;
	float UnpackedIrradianceCoefficents7_G = 0;
	float UnpackedIrradianceCoefficents7_B = 0;

	float UnpackedIrradianceCoefficents8_R = 0;
	float UnpackedIrradianceCoefficents8_G = 0;
	float UnpackedIrradianceCoefficents8_B = 0;

	float UNUSED_0 = 0;

	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_0R_0G, UnpackedIrradianceCoefficents0_R, UnpackedIrradianceCoefficents0_G);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_0B_1R, UnpackedIrradianceCoefficents0_B, UnpackedIrradianceCoefficents1_R);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_1G_1B, UnpackedIrradianceCoefficents1_G, UnpackedIrradianceCoefficents1_B);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_2R_2G, UnpackedIrradianceCoefficents2_R, UnpackedIrradianceCoefficents2_G);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_2B_3R, UnpackedIrradianceCoefficents2_B, UnpackedIrradianceCoefficents3_R);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_3G_3B, UnpackedIrradianceCoefficents3_G, UnpackedIrradianceCoefficents3_B);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_4R_4G, UnpackedIrradianceCoefficents4_R, UnpackedIrradianceCoefficents4_G);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_4B_5R, UnpackedIrradianceCoefficents4_B, UnpackedIrradianceCoefficents5_R);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_5G_5B, UnpackedIrradianceCoefficents5_G, UnpackedIrradianceCoefficents5_B);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_6R_6G, UnpackedIrradianceCoefficents6_R, UnpackedIrradianceCoefficents6_G);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_6B_7R, UnpackedIrradianceCoefficents6_B, UnpackedIrradianceCoefficents7_R);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_7G_7B, UnpackedIrradianceCoefficents7_G, UnpackedIrradianceCoefficents7_B);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_8R_8G, UnpackedIrradianceCoefficents8_R, UnpackedIrradianceCoefficents8_G);
	Unpack_2_Float32_From_Int32(_PackedIrradianceCoefficents_8B, UnpackedIrradianceCoefficents8_B, UNUSED_0);

	float3 UnpackedIrradianceCoefficents0 = float3(UnpackedIrradianceCoefficents0_R, UnpackedIrradianceCoefficents0_G, UnpackedIrradianceCoefficents0_B);
	float3 UnpackedIrradianceCoefficents1 = float3(UnpackedIrradianceCoefficents1_R, UnpackedIrradianceCoefficents1_G, UnpackedIrradianceCoefficents1_B);
	float3 UnpackedIrradianceCoefficents2 = float3(UnpackedIrradianceCoefficents2_R, UnpackedIrradianceCoefficents2_G, UnpackedIrradianceCoefficents2_B);
	float3 UnpackedIrradianceCoefficents3 = float3(UnpackedIrradianceCoefficents3_R, UnpackedIrradianceCoefficents3_G, UnpackedIrradianceCoefficents3_B);
	float3 UnpackedIrradianceCoefficents4 = float3(UnpackedIrradianceCoefficents4_R, UnpackedIrradianceCoefficents4_G, UnpackedIrradianceCoefficents4_B);
	float3 UnpackedIrradianceCoefficents5 = float3(UnpackedIrradianceCoefficents5_R, UnpackedIrradianceCoefficents5_G, UnpackedIrradianceCoefficents5_B);
	float3 UnpackedIrradianceCoefficents6 = float3(UnpackedIrradianceCoefficents6_R, UnpackedIrradianceCoefficents6_G, UnpackedIrradianceCoefficents6_B);
	float3 UnpackedIrradianceCoefficents7 = float3(UnpackedIrradianceCoefficents7_R, UnpackedIrradianceCoefficents7_G, UnpackedIrradianceCoefficents7_B);
	float3 UnpackedIrradianceCoefficents8 = float3(UnpackedIrradianceCoefficents8_R, UnpackedIrradianceCoefficents8_G, UnpackedIrradianceCoefficents8_B);

	//order 0
	sphericalHarmonicsIrradiance += 3.1415926535897932384f * UnpackedIrradianceCoefficents0 * SphericalHarmonicBasis0(vector_normalDirection);

	//order 1
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * UnpackedIrradianceCoefficents1 * SphericalHarmonicBasis1(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * UnpackedIrradianceCoefficents2 * SphericalHarmonicBasis2(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * UnpackedIrradianceCoefficents3 * SphericalHarmonicBasis3(vector_normalDirection);

	//order 2
	sphericalHarmonicsIrradiance += 0.78539 * UnpackedIrradianceCoefficents4 * SphericalHarmonicBasis4(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539 * UnpackedIrradianceCoefficents5 * SphericalHarmonicBasis5(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539 * UnpackedIrradianceCoefficents6 * SphericalHarmonicBasis6(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539 * UnpackedIrradianceCoefficents7 * SphericalHarmonicBasis7(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539 * UnpackedIrradianceCoefficents8 * SphericalHarmonicBasis8(vector_normalDirection);

	//Divide irradiance by PI because albedo
	sphericalHarmonicsIrradiance /= UNITY_PI;

	return float4(sphericalHarmonicsIrradiance, 1);
}

float3 CalculateSphericalHarmonicIrradianceDeringHanning(float3 vector_normalDirection, float filterWindowSize)
{
	float3 sphericalHarmonicsIrradiance = float3(0, 0, 0);

	float3 inputCoefficents[9] =
	{
		//order 0
		_IrradianceCoefficents0,

		//order 1
		_IrradianceCoefficents1,
		_IrradianceCoefficents2,
		_IrradianceCoefficents3,

		//order 2
		_IrradianceCoefficents4,
		_IrradianceCoefficents5,
		_IrradianceCoefficents6,
		_IrradianceCoefficents7,
		_IrradianceCoefficents8
	};

	//output coefficents
	float3 filteredCoefficents[9];

	//apply filtering
	FilterHanning(inputCoefficents, filteredCoefficents, filterWindowSize);

	//apply order 0 and convolve into diffuse
	sphericalHarmonicsIrradiance += 3.1415926535897932384f * filteredCoefficents[0] * SphericalHarmonicBasis0(vector_normalDirection);

	//apply order 1 and convolve into diffuse
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * filteredCoefficents[1] * SphericalHarmonicBasis1(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * filteredCoefficents[2] * SphericalHarmonicBasis2(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * filteredCoefficents[3] * SphericalHarmonicBasis3(vector_normalDirection);

	//apply order 2 and convolve into diffuse
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[4] * SphericalHarmonicBasis4(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[5] * SphericalHarmonicBasis5(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[6] * SphericalHarmonicBasis6(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[7] * SphericalHarmonicBasis7(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[8] * SphericalHarmonicBasis8(vector_normalDirection);

	//Divide irradiance by PI because albedo
	sphericalHarmonicsIrradiance /= UNITY_PI;

	return sphericalHarmonicsIrradiance;
}

float3 CalculateSphericalHarmonicIrradianceDeringLanczos(float3 vector_normalDirection, float filterWindowSize)
{
	float3 sphericalHarmonicsIrradiance = float3(0, 0, 0);

	float3 inputCoefficents[9] =
	{
		//order 0
		_IrradianceCoefficents0,

		//order 1
		_IrradianceCoefficents1,
		_IrradianceCoefficents2,
		_IrradianceCoefficents3,

		//order 2
		_IrradianceCoefficents4,
		_IrradianceCoefficents5,
		_IrradianceCoefficents6,
		_IrradianceCoefficents7,
		_IrradianceCoefficents8
	};

	//output coefficents
	float3 filteredCoefficents[9];

	//apply filtering
	FilterLanczos(inputCoefficents, filteredCoefficents, filterWindowSize);

	//apply order 0 and convolve into diffuse
	sphericalHarmonicsIrradiance += 3.1415926535897932384f * filteredCoefficents[0] * SphericalHarmonicBasis0(vector_normalDirection);

	//apply order 1 and convolve into diffuse
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * filteredCoefficents[1] * SphericalHarmonicBasis1(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * filteredCoefficents[2] * SphericalHarmonicBasis2(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * filteredCoefficents[3] * SphericalHarmonicBasis3(vector_normalDirection);

	//apply order 2 and convolve into diffuse
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[4] * SphericalHarmonicBasis4(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[5] * SphericalHarmonicBasis5(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[6] * SphericalHarmonicBasis6(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[7] * SphericalHarmonicBasis7(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[8] * SphericalHarmonicBasis8(vector_normalDirection);

	//Divide irradiance by PI because albedo
	sphericalHarmonicsIrradiance /= UNITY_PI;

	return sphericalHarmonicsIrradiance;
}

float3 CalculateSphericalHarmonicIrradianceDeringGaussian(float3 vector_normalDirection, float filterWindowSize)
{
	float3 sphericalHarmonicsIrradiance = float3(0, 0, 0);

	float3 inputCoefficents[9] =
	{
		//order 0
		_IrradianceCoefficents0,

		//order 1
		_IrradianceCoefficents1,
		_IrradianceCoefficents2,
		_IrradianceCoefficents3,

		//order 2
		_IrradianceCoefficents4,
		_IrradianceCoefficents5,
		_IrradianceCoefficents6,
		_IrradianceCoefficents7,
		_IrradianceCoefficents8
	};

	//output coefficents
	float3 filteredCoefficents[9];

	//apply filtering
	FilterGaussian(inputCoefficents, filteredCoefficents, filterWindowSize);

	//apply order 0 and convolve into diffuse
	sphericalHarmonicsIrradiance += 3.1415926535897932384f * filteredCoefficents[0] * SphericalHarmonicBasis0(vector_normalDirection);

	//apply order 1 and convolve into diffuse
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * filteredCoefficents[1] * SphericalHarmonicBasis1(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * filteredCoefficents[2] * SphericalHarmonicBasis2(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * filteredCoefficents[3] * SphericalHarmonicBasis3(vector_normalDirection);

	//apply order 2 and convolve into diffuse
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[4] * SphericalHarmonicBasis4(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[5] * SphericalHarmonicBasis5(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[6] * SphericalHarmonicBasis6(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[7] * SphericalHarmonicBasis7(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * filteredCoefficents[8] * SphericalHarmonicBasis8(vector_normalDirection);

	//Divide irradiance by PI because albedo
	sphericalHarmonicsIrradiance /= UNITY_PI;

	return sphericalHarmonicsIrradiance;
}

//||||||||||||||||||||||||||||| UTILITY |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| UTILITY |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| UTILITY |||||||||||||||||||||||||||||

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

//||||||||||||||||||||||||| UTILITY FUNCTIONS |||||||||||||||||||||||||
//||||||||||||||||||||||||| UTILITY FUNCTIONS |||||||||||||||||||||||||
//||||||||||||||||||||||||| UTILITY FUNCTIONS |||||||||||||||||||||||||

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