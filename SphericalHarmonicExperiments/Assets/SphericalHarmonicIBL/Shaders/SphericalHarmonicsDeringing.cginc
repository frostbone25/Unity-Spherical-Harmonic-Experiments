//||||||||||||||||||||||||||||| DERINGING SPHERICAL HARMONICS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| DERINGING SPHERICAL HARMONICS |||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||| DERINGING SPHERICAL HARMONICS |||||||||||||||||||||||||||||

// Applies Hanning filter for given window size
void FilterHanning(inout float3 coefficents[9], float filterWindowSize)
{
	float filterWindowSizeReciprocal = 1.0f / filterWindowSize;
	float2 Factors = float2(
		0.5f * (1.0f + cos(UNITY_PI * filterWindowSizeReciprocal)),
		0.5f * (1.0f + cos(2.0f * UNITY_PI * filterWindowSizeReciprocal))
		);

	//order 0 coefficents
    coefficents[0] = coefficents[0];
	
	//order 1 coefficents
    coefficents[1] *= Factors.x;
    coefficents[2] *= Factors.x;
    coefficents[3] *= Factors.x;
	
	//order 2 coefficents
    coefficents[4] *= Factors.y;
    coefficents[5] *= Factors.y;
    coefficents[6] *= Factors.y;
    coefficents[7] *= Factors.y;
    coefficents[8] *= Factors.y;
}

// Applies Lanczos filter for given window size
void FilterLanczos(inout float3 coefficents[9], float filterWindowSize)
{
	float filterWindowSizeReciprocal = 1.0f / filterWindowSize;
	float2 Factors = float2(
		sin(UNITY_PI * filterWindowSizeReciprocal) / (UNITY_PI * filterWindowSizeReciprocal),
		sin(2.0f * UNITY_PI * filterWindowSizeReciprocal) / (2.0f * UNITY_PI * filterWindowSizeReciprocal)
		);

	//order 0 coefficents
    coefficents[0] = coefficents[0];
	
	//order 1 coefficents
    coefficents[1] *= Factors.x;
    coefficents[2] *= Factors.x;
    coefficents[3] *= Factors.x;
	
	//order 2 coefficents
    coefficents[4] *= Factors.y;
    coefficents[5] *= Factors.y;
    coefficents[6] *= Factors.y;
    coefficents[7] *= Factors.y;
    coefficents[8] *= Factors.y;
}

// Applies gaussian filter for given window size
void FilterGaussian(inout float3 coefficents[9], float filterWindowSize)
{
	float filterWindowSizeReciprocal = 1.0f / filterWindowSize;
	float2 Factors = float2(
		exp(-0.5f * (UNITY_PI * filterWindowSizeReciprocal) * (UNITY_PI * filterWindowSizeReciprocal)),
		exp(-0.5f * (2.0f * UNITY_PI * filterWindowSizeReciprocal) * (2.0f * UNITY_PI * filterWindowSizeReciprocal))
		);

	//order 0 coefficents
    coefficents[0] = coefficents[0];
	
	//order 1 coefficents
    coefficents[1] *= Factors.x;
    coefficents[2] *= Factors.x;
    coefficents[3] *= Factors.x;
	
	//order 2 coefficents
    coefficents[4] *= Factors.y;
    coefficents[5] *= Factors.y;
    coefficents[6] *= Factors.y;
    coefficents[7] *= Factors.y;
    coefficents[8] *= Factors.y;
}