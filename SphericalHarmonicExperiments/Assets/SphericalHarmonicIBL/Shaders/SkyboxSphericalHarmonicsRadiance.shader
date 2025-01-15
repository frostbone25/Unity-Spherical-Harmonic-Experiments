Shader "SphericalHarmonicIBL/SkyboxSphericalHarmonicsRadiance"
{
	Properties
	{
		[Header(Reference Cubemaps)]
		[Toggle(_USE_CUBEMAP)] _UseCubemap("Use Cubemap", Float) = 1
		_ReferenceCubemap("Reference Cubemap", CUBE) = "white" {}

		[Header(Spherical Harmonic Coefficents)]
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
			"Queue" = "Background" 
			"RenderType" = "Background" 
			"PreviewType" = "Skybox" 
		}

		Cull Off ZWrite Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vertex_base
			#pragma fragment fragment_base
			#pragma target 2.0

			#pragma shader_feature_local _USE_CUBEMAP

			#include "UnityCG.cginc"
			
			#include "SphericalHarmonicsBasis.cginc"
			#include "SphericalHarmonicsDeringing.cginc"
			#include "SphericalHarmonicsUtility.cginc"
			#include "SphericalHarmonicsRandom.cginc"
			#include "SphericalHarmonicsSampling.cginc"

			#include "SphericalHarmonicsRadiance.cginc"

			samplerCUBE _ReferenceCubemap;

			struct meshData
			{
				float4 vertex : POSITION;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct vertexToFragment
			{
				float4 vertex : SV_POSITION;
				float3 texcoord : TEXCOORD0;

				UNITY_VERTEX_OUTPUT_STEREO
			};

			vertexToFragment vertex_base(meshData data)
			{
				vertexToFragment o;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.vertex = UnityObjectToClipPos(data.vertex);
				o.texcoord = data.vertex.xyz;

				return o;
			}

			fixed4 fragment_base(vertexToFragment vertex) : SV_Target
			{
				float3 direction = vertex.texcoord.xyz;
				
				//return float4(direction, 1);

				float3 result = float3(0.0f, 0.0f, 0.0f);

				//order 0
				//result += SphericalHarmonicBasis0(direction);

				//order 1
				//result = SphericalHarmonicBasis1(direction);
				//result = SphericalHarmonicBasis2(direction);
				//result = SphericalHarmonicBasis3(direction);

				//order 2
				//result = SphericalHarmonicBasis4(direction);
				//result = SphericalHarmonicBasis5(direction);
				//result = SphericalHarmonicBasis6(direction);
				//result = SphericalHarmonicBasis7(direction);
				//result = SphericalHarmonicBasis8(direction);

				return float4(result, 1);

				#if defined (_USE_CUBEMAP)
					return texCUBElod(_ReferenceCubemap, float4(direction, 0));
				#else
					return float4(max(0.0, CalculateSphericalHarmonicRadiance(direction)), 1);
				#endif
			}
			ENDCG
		}
	}
	
	Fallback Off
}
