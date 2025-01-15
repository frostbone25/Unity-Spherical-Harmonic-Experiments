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

	#if defined (_GAMMA_TO_LINEAR)
		sphericalHarmonicsRadiance = max(0.0f, sphericalHarmonicsRadiance);
		sphericalHarmonicsRadiance = pow(sphericalHarmonicsRadiance, 2.2); //[Gamma -> Linear] 2.2
	#endif

	return sphericalHarmonicsRadiance;
}