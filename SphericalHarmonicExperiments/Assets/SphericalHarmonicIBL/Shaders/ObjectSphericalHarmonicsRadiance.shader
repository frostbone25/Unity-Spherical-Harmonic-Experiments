Shader "SphericalHarmonicIBL/ObjectSphericalHarmonicsRadiance"
{
	Properties
	{
		[Toggle(_GAMMA_TO_LINEAR)] _GammaToLinear("Gamma To Linear", Float) = 0

		[Header(Spherical Harmonics Radiance)]
		_RadianceCoefficents0("_RadianceCoefficents0", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents1("_RadianceCoefficents1", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents2("_RadianceCoefficents2", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents3("_RadianceCoefficents3", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents4("_RadianceCoefficents4", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents5("_RadianceCoefficents5", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents6("_RadianceCoefficents6", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents7("_RadianceCoefficents7", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents8("_RadianceCoefficents8", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents9("_RadianceCoefficents9", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents10("_RadianceCoefficents10", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents11("_RadianceCoefficents11", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents12("_RadianceCoefficents12", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents13("_RadianceCoefficents13", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents14("_RadianceCoefficents14", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents15("_RadianceCoefficents15", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents16("_RadianceCoefficents16", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents17("_RadianceCoefficents17", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents18("_RadianceCoefficents18", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents19("_RadianceCoefficents19", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents20("_RadianceCoefficents20", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents21("_RadianceCoefficents21", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents22("_RadianceCoefficents22", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents23("_RadianceCoefficents23", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents24("_RadianceCoefficents24", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents25("_RadianceCoefficents25", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents26("_RadianceCoefficents26", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents27("_RadianceCoefficents27", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents28("_RadianceCoefficents28", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents29("_RadianceCoefficents29", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents30("_RadianceCoefficents30", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents31("_RadianceCoefficents31", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents32("_RadianceCoefficents32", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents33("_RadianceCoefficents33", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents34("_RadianceCoefficents34", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents35("_RadianceCoefficents35", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents36("_RadianceCoefficents36", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents37("_RadianceCoefficents37", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents38("_RadianceCoefficents38", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents39("_RadianceCoefficents39", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents40("_RadianceCoefficents40", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents41("_RadianceCoefficents41", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents42("_RadianceCoefficents42", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents43("_RadianceCoefficents43", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents44("_RadianceCoefficents44", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents45("_RadianceCoefficents45", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents46("_RadianceCoefficents46", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents47("_RadianceCoefficents47", Vector) = (0, 0, 0, 0)
		_RadianceCoefficents48("_RadianceCoefficents48", Vector) = (0, 0, 0, 0)
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

			#pragma shader_feature_local _GAMMA_TO_LINEAR

			#include "UnityCG.cginc"

			#include "SphericalHarmonicsBasis.cginc"
			#include "SphericalHarmonicsDeringing.cginc"
			#include "SphericalHarmonicsUtility.cginc"
			#include "SphericalHarmonicsRandom.cginc"
			#include "SphericalHarmonicsSampling.cginc"

			#include "SphericalHarmonicsRadiance.cginc"

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

				//------------------------- CALCULATE RADIANCE -------------------------
				float3 sphericalHarmonicsRadiance = CalculateSphericalHarmonicRadiance(vector_reflectionDirection);

				sphericalHarmonicsRadiance = max(0.0, sphericalHarmonicsRadiance);

				return float4(sphericalHarmonicsRadiance, 1);
			}
			ENDCG
		}
	}
	
	Fallback Off
}