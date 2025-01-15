Shader "SphericalHarmonicIBL/ObjectSphericalHarmonicsIrradiance"
{
	Properties
	{
		[Toggle(_GAMMA_TO_LINEAR)] _GammaToLinear("Gamma To Linear", Float) = 0

		[Header(Irradiance Dominant Light)]
		[Toggle(_SHOW_IRRADIANCE_DOMINANT_DIRECTION)] _ShowIrradianceDominantDirection("Show Irradiance Dominant Direction", Float) = 0
		[HDR] _IrradianceDominantLightColorOverride("Irradiance Dominant Light Color Override", Color) = (1, 1, 1, 1)

		[Header(Spherical Harmonics Irradiance)]
		_IrradianceCoefficents0("_IrradianceCoefficents0", Vector) = (0, 0, 0, 0)
		_IrradianceCoefficents1("_IrradianceCoefficents1", Vector) = (0, 0, 0, 0)
		_IrradianceCoefficents2("_IrradianceCoefficents2", Vector) = (0, 0, 0, 0)
		_IrradianceCoefficents3("_IrradianceCoefficents3", Vector) = (0, 0, 0, 0)
		_IrradianceCoefficents4("_IrradianceCoefficents4", Vector) = (0, 0, 0, 0)
		_IrradianceCoefficents5("_IrradianceCoefficents5", Vector) = (0, 0, 0, 0)
		_IrradianceCoefficents6("_IrradianceCoefficents6", Vector) = (0, 0, 0, 0)
		_IrradianceCoefficents7("_IrradianceCoefficents7", Vector) = (0, 0, 0, 0)
		_IrradianceCoefficents8("_IrradianceCoefficents8", Vector) = (0, 0, 0, 0)
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
			CGPROGRAM
			#pragma vertex vertex_base
			#pragma fragment fragment_base
			#pragma target 2.0

			#pragma shader_feature_local _SHOW_IRRADIANCE_DOMINANT_DIRECTION
			#pragma shader_feature_local _GAMMA_TO_LINEAR

			#include "UnityCG.cginc"

			#include "SphericalHarmonicsBasis.cginc"
			#include "SphericalHarmonicsDeringing.cginc"
			#include "SphericalHarmonicsUtility.cginc"
			#include "SphericalHarmonicsRandom.cginc"
			#include "SphericalHarmonicsSampling.cginc"

			#include "SphericalHarmonicsIrradiance.cginc"

			float _FilterWindowSize;
			float4 _IrradianceDominantLightColorOverride;

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

				//return float4(0, 0, 0, 1);

				//------------------------- CALCULATE IRRADIANCE -------------------------
				float3 sphericalHarmonicsIrradiance = CalculateSphericalHarmonicIrradiance(vector_normalDirection);

				#if defined (_SHOW_IRRADIANCE_DOMINANT_DIRECTION)
					float3 irradianceDominantDirection = CalculateDominantLightDirectionFromIrradiance();

					float irradianceDominantLight = max(0.0, dot(vector_normalDirection, irradianceDominantDirection));

					sphericalHarmonicsIrradiance += irradianceDominantLight * _IrradianceDominantLightColorOverride;
				#endif

				sphericalHarmonicsIrradiance = max(0.0, sphericalHarmonicsIrradiance);

				return float4(sphericalHarmonicsIrradiance, 1);
			}
			ENDCG
		}
	}
	
	Fallback Off
}