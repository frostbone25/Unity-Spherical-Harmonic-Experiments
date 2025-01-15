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
	sphericalHarmonicsIrradiance += 0.78539f * ApplySphericalHarmonicsIrradianceOrder2(vector_normalDirection);

	//Divide irradiance by PI because albedo
	sphericalHarmonicsIrradiance /= UNITY_PI;

	#if defined (_GAMMA_TO_LINEAR)
		sphericalHarmonicsIrradiance = max(0.0f, sphericalHarmonicsIrradiance);
		sphericalHarmonicsIrradiance = pow(sphericalHarmonicsIrradiance, 2.2); //[Gamma -> Linear] 2.2
	#endif

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

	//apply filtering
	FilterHanning(inputCoefficents, filterWindowSize);

	//apply order 0 and convolve into diffuse
	sphericalHarmonicsIrradiance += 3.1415926535897932384f * inputCoefficents[0] * SphericalHarmonicBasis0(vector_normalDirection);

	//apply order 1 and convolve into diffuse
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * inputCoefficents[1] * SphericalHarmonicBasis1(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * inputCoefficents[2] * SphericalHarmonicBasis2(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * inputCoefficents[3] * SphericalHarmonicBasis3(vector_normalDirection);

	//apply order 2 and convolve into diffuse
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[4] * SphericalHarmonicBasis4(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[5] * SphericalHarmonicBasis5(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[6] * SphericalHarmonicBasis6(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[7] * SphericalHarmonicBasis7(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[8] * SphericalHarmonicBasis8(vector_normalDirection);

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

	//apply filtering
	//FilterLanczos(inputCoefficents, filterWindowSize);

	//apply order 0 and convolve into diffuse
	sphericalHarmonicsIrradiance += 3.1415926535897932384f * inputCoefficents[0] * SphericalHarmonicBasis0(vector_normalDirection);

	//apply order 1 and convolve into diffuse
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * inputCoefficents[1] * SphericalHarmonicBasis1(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * inputCoefficents[2] * SphericalHarmonicBasis2(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * inputCoefficents[3] * SphericalHarmonicBasis3(vector_normalDirection);

	//apply order 2 and convolve into diffuse
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[4] * SphericalHarmonicBasis4(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[5] * SphericalHarmonicBasis5(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[6] * SphericalHarmonicBasis6(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[7] * SphericalHarmonicBasis7(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[8] * SphericalHarmonicBasis8(vector_normalDirection);

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

	//apply filtering
	//FilterGaussian(inputCoefficents, filterWindowSize);

	//apply order 0 and convolve into diffuse
	sphericalHarmonicsIrradiance += 3.1415926535897932384f * inputCoefficents[0] * SphericalHarmonicBasis0(vector_normalDirection);

	//apply order 1 and convolve into diffuse
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * inputCoefficents[1] * SphericalHarmonicBasis1(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * inputCoefficents[2] * SphericalHarmonicBasis2(vector_normalDirection);
	sphericalHarmonicsIrradiance += 2.0943951023931954923f * inputCoefficents[3] * SphericalHarmonicBasis3(vector_normalDirection);

	//apply order 2 and convolve into diffuse
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[4] * SphericalHarmonicBasis4(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[5] * SphericalHarmonicBasis5(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[6] * SphericalHarmonicBasis6(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[7] * SphericalHarmonicBasis7(vector_normalDirection);
	sphericalHarmonicsIrradiance += 0.78539f * inputCoefficents[8] * SphericalHarmonicBasis8(vector_normalDirection);

	//Divide irradiance by PI because albedo
	sphericalHarmonicsIrradiance /= UNITY_PI;

	return sphericalHarmonicsIrradiance;
}