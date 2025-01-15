Shader "SphericalHarmonicIBL/ObjectUnityModifiedSphericalHarmonics"
{
	Properties
	{
		[Toggle(_GAMMA_TO_LINEAR)] _GammaToLinear("Gamma To Linear", Float) = 0

		[Header(Spherical Harmonics)]
		[KeywordEnum(Irradiance, Radiance)] _SphericalHarmonicsTerm("Unity Spherical Harmonics Term", Float) = 0
		[KeywordEnum(Order0, Order1, Order2)] _SphericalHarmonicsOrders("Unity Spherical Harmonic Orders", Float) = 2

		[Header(Deringing)]
		[KeywordEnum(None, Hanning, Lanczos, Gaussian)] _DeringFilter("Dering Filter", Float) = 0
		_DeringFilterWindowSize("Dering Filter Window Size", Int) = 4

		[Header(Irradiance Dominant Light)]
		[Toggle(_SHOW_IRRADIANCE_DOMINANT_DIRECTION)] _ShowIrradianceDominantDirection("Show Irradiance Dominant Direction", Float) = 0
		[HDR] _IrradianceDominantLightColorOverride("Irradiance Dominant Light Color Override", Color) = (1, 1, 1, 1)

		[Header(Unity SH Coefficents)]
		_TEST("_TEST", Float) = 1
		unity_SHAr("unity_SHAr", Vector) = (0, 0, 0, 0)
		unity_SHAg("unity_SHAg", Vector) = (0, 0, 0, 0)
		unity_SHAb("unity_SHAb", Vector) = (0, 0, 0, 0)
		unity_SHBr("unity_SHBr", Vector) = (0, 0, 0, 0)
		unity_SHBg("unity_SHBg", Vector) = (0, 0, 0, 0)
		unity_SHBb("unity_SHBb", Vector) = (0, 0, 0, 0)
		unity_SHC("unity_SHC", Vector) = (0, 0, 0, 0)
	}

	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
		}

		Cull Off
		ZWrite On

		Pass
		{
			Tags 
			{ 
				"LightMode" = "ForwardBase" 
			}

			CGPROGRAM
			#pragma vertex vertex_base
			#pragma fragment fragment_base
			#pragma target 2.0

			#pragma shader_feature_local _SHOW_IRRADIANCE_DOMINANT_DIRECTION
			#pragma shader_feature_local _GAMMA_TO_LINEAR

			#pragma multi_compile _DERINGFILTER_NONE _DERINGFILTER_HANNING _DERINGFILTER_LANCZOS _DERINGFILTER_GAUSSIAN
			#pragma multi_compile _SPHERICALHARMONICSORDERS_ORDER0 _SPHERICALHARMONICSORDERS_ORDER1 _SPHERICALHARMONICSORDERS_ORDER2
			#pragma multi_compile _SPHERICALHARMONICSTERM_IRRADIANCE _SPHERICALHARMONICSTERM_RADIANCE

			#include "UnityCG.cginc"
			
			#include "SphericalHarmonicsBasis.cginc"
			#include "SphericalHarmonicsDeringing.cginc"
			#include "SphericalHarmonicsUtility.cginc"
			#include "SphericalHarmonicsRandom.cginc"
			#include "SphericalHarmonicsSampling.cginc"

			#include "SphericalHarmonicsIrradiance.cginc"

			float _DeringFilterWindowSize;
			float4 _IrradianceDominantLightColorOverride;
			float _TEST;

			float3 GetUnityDominantSphericalHarmoncsDirection()
			{
				//add the L1 bands from the spherical harmonics probe to get our direction.
				float3 sphericalHarmonics_dominantDirection = unity_SHAr.xyz * 0.3 + unity_SHAg.xyz * 0.59 + unity_SHAb.xyz * 0.11;

				//#if defined (SPHERICAL_HARMONICS_BETTER_QUALITY)
					sphericalHarmonics_dominantDirection += unity_SHBr.xyz * 0.3 + unity_SHBg.xyz * 0.59 + unity_SHBb.xyz * 0.11 + unity_SHC; //add the L2 bands for better precision
				//#endif

				return sphericalHarmonics_dominantDirection;
			}

			struct meshData
			{
				float4 vertex : POSITION;	//Vertex Position (X = Position X | Y = Position Y | Z = Position Z | W = 1)
				float3 normal : NORMAL;     //Normal Direction [-1..1] (X = Direction X | Y = Direction Y | Z = Direction)

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct vertexToFragment
			{
				float4 vertexCameraClipPosition : SV_POSITION; //Vertex Position In Camera Clip Space
				float3 vertexWorldNormal : TEXCOORD0; //Vertex Position In Camera Clip Space
				float4 vertexWorldPosition : TEXCOORD1; //Vertex World Space Position 

				UNITY_VERTEX_OUTPUT_STEREO
			};

			vertexToFragment vertex_base(meshData data)
			{
				vertexToFragment vertex;

				UNITY_SETUP_INSTANCE_ID(data);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(vertex);

				vertex.vertexCameraClipPosition = UnityObjectToClipPos(data.vertex);
				vertex.vertexWorldNormal = UnityObjectToWorldNormal(normalize(data.normal));
				vertex.vertexWorldPosition = mul(unity_ObjectToWorld, data.vertex);

				return vertex;
			}

			fixed4 fragment_base(vertexToFragment vertex) : SV_Target
			{
				float3 vector_worldPosition = vertex.vertexWorldPosition.xyz; //world position vector
				float3 vector_viewPosition = _WorldSpaceCameraPos.xyz - vector_worldPosition; //camera world position
				float3 vector_viewDirection = normalize(vector_viewPosition); //camera world position direction
				float3 vector_normalDirection = vertex.vertexWorldNormal.xyz;
				float3 vector_reflectionDirection = reflect(-vector_viewDirection, vector_normalDirection);

				/*
				* ------------------------------------------------------------------
				- Unity SH lighting environment (SHADER/GPU)

				- 7 float4's (28 floats)
				float4 unity_SHAr;
				float4 unity_SHAg;
				float4 unity_SHAb;
				float4 unity_SHBr;
				float4 unity_SHBg;
				float4 unity_SHBb;
				float4 unity_SHC; //The 4th channel for this is always 1

				------------------------------------------------------------------
				- Unity SH lighting environment (CPU)

				- Constant + Linear
				float4 unity_SHAr = float4(sh[0, 3], sh[0, 1], sh[0, 2], sh[0, 0] - sh[0, 6]);
				float4 unity_SHAg = float4(sh[1, 3], sh[1, 1], sh[1, 2], sh[1, 0] - sh[1, 6]);
				float4 unity_SHAb = float4(sh[2, 3], sh[2, 1], sh[2, 2], sh[2, 0] - sh[2, 6]);

				- Quadratic polynomials
				float4 unity_SHBr = float4(sh[0, 4], sh[0, 6], sh[0, 5] * 3, sh[0, 7]);
				float4 unity_SHBg = float4(sh[1, 4], sh[1, 6], sh[1, 5] * 3, sh[1, 7]);
				float4 unity_SHBb = float4(sh[2, 4], sh[2, 6], sh[2, 5] * 3, sh[2, 7]);

				- Final quadratic polynomial
				float4 unity_SHC = float4(sh[0, 8], sh[2, 8], sh[1, 8], 1);
				------------------------------------------------------------------
				- Recovering the raw SH coefficents from the Unity SH lighting environment
				- 3 bands (RGB), 9 coefficients
				- 27 total coefficents

				According to Unity - https://docs.unity3d.com/ScriptReference/Rendering.SphericalHarmonicsL2.Index_operator.html
				When accessing the generated SH coefficents... 
				- First index is the RGB color (0 = RED, 1 = GREEN, 2 = BLUE)
				- Second index is the spherical harmonic terms all in order (9 coefficents max)
				*/

				/*
				//Band 1 (RED)
				float unity_sh_0_0 = unity_SHAr.a + unity_SHBr.g;
				float unity_sh_0_1 = unity_SHAr.g;
				float unity_sh_0_2 = unity_SHAr.b;
				float unity_sh_0_3 = unity_SHAr.r;
				float unity_sh_0_4 = unity_SHBr.r;
				float unity_sh_0_5 = unity_SHBr.b / 3;
				float unity_sh_0_6 = unity_SHBr.g;
				float unity_sh_0_7 = unity_SHBr.a;
				float unity_sh_0_8 = unity_SHC.r;

				//Band 2 (GREEN)
				float unity_sh_1_0 = unity_SHAg.a + unity_SHBg.g;
				float unity_sh_1_1 = unity_SHAg.g;
				float unity_sh_1_2 = unity_SHAg.b;
				float unity_sh_1_3 = unity_SHAg.r;
				float unity_sh_1_4 = unity_SHBg.r;
				float unity_sh_1_5 = unity_SHBg.b / 3;
				float unity_sh_1_6 = unity_SHBg.g;
				float unity_sh_1_7 = unity_SHBg.a;
				float unity_sh_1_8 = unity_SHC.b;

				//Band 3 (BLUE)
				float unity_sh_2_0 = unity_SHAb.a + unity_SHBb.g;
				float unity_sh_2_1 = unity_SHAb.g;
				float unity_sh_2_2 = unity_SHAb.b;
				float unity_sh_2_3 = unity_SHAb.r;
				float unity_sh_2_4 = unity_SHBb.r;
				float unity_sh_2_5 = unity_SHBb.b / 3;
				float unity_sh_2_6 = unity_SHBb.g;
				float unity_sh_2_7 = unity_SHBb.a;
				float unity_sh_2_8 = unity_SHC.g;
				*/

				//Band 1 (RED)
				float unity_sh_0_0 = unity_SHAr.a + (unity_SHBr.b / 3.0f);
				float unity_sh_0_1 = unity_SHAr.g;
				float unity_sh_0_2 = unity_SHAr.b;
				float unity_sh_0_3 = unity_SHAr.r;

				float unity_sh_0_4 = unity_SHBr.r;
				float unity_sh_0_5 = unity_SHBr.g;
				float unity_sh_0_6 = unity_SHBr.b / 3.0f;
				float unity_sh_0_7 = unity_SHBr.a;
				float unity_sh_0_8 = unity_SHC.r;

				//Band 2 (GREEN)
				float unity_sh_1_0 = unity_SHAg.a + (unity_SHBg.b / 3.0f);
				float unity_sh_1_1 = unity_SHAg.g;
				float unity_sh_1_2 = unity_SHAg.b;
				float unity_sh_1_3 = unity_SHAg.r;

				float unity_sh_1_4 = unity_SHBg.r;
				float unity_sh_1_5 = unity_SHBg.g;
				float unity_sh_1_6 = unity_SHBg.b / 3.0f;
				float unity_sh_1_7 = unity_SHBg.a;
				float unity_sh_1_8 = unity_SHC.g;

				//Band 3 (BLUE)
				float unity_sh_2_0 = unity_SHAb.a + (unity_SHBb.b / 3.0f);
				float unity_sh_2_1 = unity_SHAb.g;
				float unity_sh_2_2 = unity_SHAb.b;
				float unity_sh_2_3 = unity_SHAb.r;

				float unity_sh_2_4 = unity_SHBb.r;
				float unity_sh_2_5 = unity_SHBb.g;
				float unity_sh_2_6 = unity_SHBb.b / 3.0f;
				float unity_sh_2_7 = unity_SHBb.a;
				float unity_sh_2_8 = unity_SHC.b;

				float3 sphericalHarmonicFilteredCoefficents[9] =
				{
					float3(unity_sh_0_0, unity_sh_1_0, unity_sh_2_0), //l = 0 | m = 0
					float3(unity_sh_0_1, unity_sh_1_1, unity_sh_2_1), //l = 1 | m = -1
					float3(unity_sh_0_2, unity_sh_1_2, unity_sh_2_2), //l = 1 | m = 0
					float3(unity_sh_0_3, unity_sh_1_3, unity_sh_2_3), //l = 1 | m = 1

					float3(unity_sh_0_4, unity_sh_1_4, unity_sh_2_4), //l = 2 | m = -2
					float3(unity_sh_0_5, unity_sh_1_5, unity_sh_2_5), //l = 2 | m = -1
					float3(unity_sh_0_6, unity_sh_1_6, unity_sh_2_6), //l = 2 | m = 0
					float3(unity_sh_0_7, unity_sh_1_7, unity_sh_2_7), //l = 2 | m = 1
					float3(unity_sh_0_8, unity_sh_1_8, unity_sh_2_8), //l = 2 | m = 2
				};

				//*
				//sphericalHarmonicFilteredCoefficents[0] = (sphericalHarmonicFilteredCoefficents[0] * UNITY_PI) / 0.2820947917738781434740397257803862929220253146644994284220428608f;

				//sphericalHarmonicFilteredCoefficents[1] = (sphericalHarmonicFilteredCoefficents[1] * UNITY_PI) / 0.4886025119029199215863846228383470045758856081942277021382431574f;
				//sphericalHarmonicFilteredCoefficents[2] = (sphericalHarmonicFilteredCoefficents[2] * UNITY_PI) / 0.4886025119029199215863846228383470045758856081942277021382431574f;
				//sphericalHarmonicFilteredCoefficents[3] = (sphericalHarmonicFilteredCoefficents[3] * UNITY_PI) / 0.4886025119029199215863846228383470045758856081942277021382431574f;

				//sphericalHarmonicFilteredCoefficents[4] = (sphericalHarmonicFilteredCoefficents[4] * UNITY_PI) / 1.0925484305920790705433857058026884026904329595042589753478516999f;
				//sphericalHarmonicFilteredCoefficents[5] = (sphericalHarmonicFilteredCoefficents[5] * UNITY_PI) / 1.0925484305920790705433857058026884026904329595042589753478516999f;
				//sphericalHarmonicFilteredCoefficents[6] = (sphericalHarmonicFilteredCoefficents[6] * UNITY_PI) / 0.3153915652525200060308936902957104933242475070484115878434078878f;
				//sphericalHarmonicFilteredCoefficents[7] = (sphericalHarmonicFilteredCoefficents[7] * UNITY_PI) / 1.0925484305920790705433857058026884026904329595042589753478516999f;
				//sphericalHarmonicFilteredCoefficents[8] = (sphericalHarmonicFilteredCoefficents[8] * UNITY_PI) / 0.5462742152960395352716928529013442013452164797521294876739258499f;
				//*/

				#if defined (_DERINGFILTER_HANNING)
					FilterHanning(sphericalHarmonicFilteredCoefficents, _DeringFilterWindowSize);
				#elif defined (_DERINGFILTER_LANCZOS)
					FilterLanczos(sphericalHarmonicFilteredCoefficents, _DeringFilterWindowSize);
				#elif defined (_DERINGFILTER_GAUSSIAN)
					FilterGaussian(sphericalHarmonicFilteredCoefficents, _DeringFilterWindowSize);
				#endif

				float3 sphericalHarmonicsTerm = float3(0, 0, 0);

				#if defined	(_SPHERICALHARMONICSTERM_IRRADIANCE) //convolve into diffuse (irradiance)
					#if defined (_SPHERICALHARMONICSORDERS_ORDER0)
						//order 0
						sphericalHarmonicsTerm += 3.1415926535897932384f * sphericalHarmonicFilteredCoefficents[0] * SphericalHarmonicBasis0(vector_normalDirection);
					#elif defined (_SPHERICALHARMONICSORDERS_ORDER1)
						//order 0
						sphericalHarmonicsTerm += 3.1415926535897932384f * sphericalHarmonicFilteredCoefficents[0] * SphericalHarmonicBasis0(vector_normalDirection);

						//order 1
						sphericalHarmonicsTerm += 2.0943951023931954923f * sphericalHarmonicFilteredCoefficents[1] * SphericalHarmonicBasis1(vector_normalDirection);
						sphericalHarmonicsTerm += 2.0943951023931954923f * sphericalHarmonicFilteredCoefficents[2] * SphericalHarmonicBasis2(vector_normalDirection);
						sphericalHarmonicsTerm += 2.0943951023931954923f * sphericalHarmonicFilteredCoefficents[3] * SphericalHarmonicBasis3(vector_normalDirection);
					#elif defined (_SPHERICALHARMONICSORDERS_ORDER2)
						//order 0
						sphericalHarmonicsTerm += 3.1415926535897932384f * sphericalHarmonicFilteredCoefficents[0] * SphericalHarmonicBasis0(vector_normalDirection);

						//order 1
						sphericalHarmonicsTerm += 2.0943951023931954923f * sphericalHarmonicFilteredCoefficents[1] * SphericalHarmonicBasis1(vector_normalDirection);
						sphericalHarmonicsTerm += 2.0943951023931954923f * sphericalHarmonicFilteredCoefficents[2] * SphericalHarmonicBasis2(vector_normalDirection);
						sphericalHarmonicsTerm += 2.0943951023931954923f * sphericalHarmonicFilteredCoefficents[3] * SphericalHarmonicBasis3(vector_normalDirection);

						//float test = 1.5;
						float test = _TEST;

						//order 2
						sphericalHarmonicsTerm += 0.78539f * sphericalHarmonicFilteredCoefficents[4] * SphericalHarmonicBasis4(vector_normalDirection) * test;
						sphericalHarmonicsTerm += 0.78539f * sphericalHarmonicFilteredCoefficents[5] * SphericalHarmonicBasis5(vector_normalDirection) * test;
						sphericalHarmonicsTerm += 0.78539f * sphericalHarmonicFilteredCoefficents[6] * SphericalHarmonicBasis6(vector_normalDirection) * test;
						sphericalHarmonicsTerm += 0.78539f * sphericalHarmonicFilteredCoefficents[7] * SphericalHarmonicBasis7(vector_normalDirection) * test;
						sphericalHarmonicsTerm += 0.78539f * sphericalHarmonicFilteredCoefficents[8] * SphericalHarmonicBasis8(vector_normalDirection) * test;
					#endif

					//NOTE: Normally we would divide by PI since we are convolving into irradiance...
					//However it seems that just after convolving irradiance coefficents they are already divded by PI anyway.
					//So no need to do a divide by PI here.

				#elif defined (_SPHERICALHARMONICSTERM_RADIANCE) //convolve into reflections (radiance)
					#if defined (_SPHERICALHARMONICSORDERS_ORDER0)
						//order 0
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[0] * SphericalHarmonicBasis0(vector_reflectionDirection);
					#elif defined (_SPHERICALHARMONICSORDERS_ORDER1)
						//order 0
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[0] * SphericalHarmonicBasis0(vector_reflectionDirection);

						//order 1
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[1] * SphericalHarmonicBasis1(vector_reflectionDirection);
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[2] * SphericalHarmonicBasis2(vector_reflectionDirection);
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[3] * SphericalHarmonicBasis3(vector_reflectionDirection);
					#elif defined (_SPHERICALHARMONICSORDERS_ORDER2)
						//order 0
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[0] * SphericalHarmonicBasis0(vector_reflectionDirection);

						//order 1
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[1] * SphericalHarmonicBasis1(vector_reflectionDirection);
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[2] * SphericalHarmonicBasis2(vector_reflectionDirection);
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[3] * SphericalHarmonicBasis3(vector_reflectionDirection);

						//order 2
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[4] * SphericalHarmonicBasis4(vector_reflectionDirection);
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[5] * SphericalHarmonicBasis5(vector_reflectionDirection);
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[6] * SphericalHarmonicBasis6(vector_reflectionDirection);
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[7] * SphericalHarmonicBasis7(vector_reflectionDirection);
						sphericalHarmonicsTerm += sphericalHarmonicFilteredCoefficents[8] * SphericalHarmonicBasis8(vector_reflectionDirection);
					#endif

					//NOTE: Normally we would divide by PI since we are convolving into irradiance...
					//However it seems that just after convolving irradiance coefficents they are already divded by PI anyway.
					//So if we are to extract the original radiance we need to multiply the coefficents by PI
					sphericalHarmonicsTerm *= UNITY_PI;

				#endif

				//sphericalHarmonicsTerm = LinearToGammaSpace(sphericalHarmonicsTerm);


				//sphericalHarmonicsTerm = max(sphericalHarmonicsTerm, half3(0.h, 0.h, 0.h));
				// An almost-perfect approximation from http://chilliant.blogspot.com.au/2012/08/srgb-approximations-for-hlsl.html?m=1
				//sphericalHarmonicsTerm = max(1.055h * pow(sphericalHarmonicsTerm, 0.416666667h) - 0.055h, 0.h);

				#if defined (_GAMMA_TO_LINEAR)
					sphericalHarmonicsTerm = pow(sphericalHarmonicsTerm, 2.2); //[Gamma -> Linear] 2.2
				#endif

				#if defined (_SHOW_IRRADIANCE_DOMINANT_DIRECTION)
					float3 irradianceDominantDirection = GetUnityDominantSphericalHarmoncsDirection();

					float irradianceDominantLight = max(0.0, dot(vector_normalDirection, irradianceDominantDirection));

					sphericalHarmonicsTerm += irradianceDominantLight * _IrradianceDominantLightColorOverride;
				#endif

				//sphericalHarmonicsTerm = ShadeSH9(float4(vector_normalDirection, 1));
				sphericalHarmonicsTerm = max(0.0, sphericalHarmonicsTerm);

				return float4(sphericalHarmonicsTerm, 1);
			}
			ENDCG
		}
	}
	
	Fallback Off
}