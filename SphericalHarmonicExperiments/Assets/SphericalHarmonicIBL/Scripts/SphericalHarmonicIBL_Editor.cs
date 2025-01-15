using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace SphericalHarmonicIBL
{
    public class SphericalHarmonicIBL_Editor : EditorWindow
    {
        //the input cubemap to generate our spherical harmonic coefficents from
        private Cubemap sourceCubemap;

        //the orders for each term, the higher the order the better the quality (but more data and expensive)
        private int radianceOrders = 3; 
        private int irradianceOrders = 2;

        //settings for spherical harmonic radiance (reflection / incoming light)
        private CoefficentPrecision radianceCoefficentPrecision = CoefficentPrecision.Float32;
        private SamplingType radianceSamplingType = SamplingType.DownsampledCubemapTexel;
        private int radianceSampleCount = 4096;
        private int radianceDownsampleFactor = 4;
        private bool radianceUseLinearToGamma = true;
        private DeringFilter radianceDeringFilter = DeringFilter.None;
        private float radianceDeringFilterWindowSize = 4.0f;

        //settings for spherical harmonic irradiance (diffuse / outgoing light)
        private CoefficentPrecision irradianceCoefficentPrecision = CoefficentPrecision.Float32;
        private SamplingType irradianceSamplingType = SamplingType.DownsampledCubemapTexel;
        private int irradianceSampleCount = 4096;
        private int irradianceDownsampleFactor = 4;
        private bool irradianceUseLinearToGamma = false;
        private DeringFilter irradianceDeringFilter = DeringFilter.None;
        private float irradianceDeringFilterWindowSize = 4.0f;

        //which device to use for generating spherical harmonic coefficents
        private GenerationDeviceType generationDeviceType = GenerationDeviceType.CPU;

        private bool debugSkyboxToggle;

        private SphericalHarmonicCoefficents irradianceCoefficients 
        { 
            get 
            {
                SphericalHarmonicCoefficents savedData = AssetDatabase.LoadAssetAtPath<SphericalHarmonicCoefficents>("Assets/SphericalHarmonicIBL/Data/GeneratedIrradianceCoefficients.asset");

                if (savedData == null)
                {
                    SphericalHarmonicCoefficents newData = new SphericalHarmonicCoefficents();
                    AssetDatabase.CreateAsset(newData, "Assets/SphericalHarmonicIBL/Data/GeneratedIrradianceCoefficients.asset");
                    savedData = newData;
                }

                return savedData;
            }
        }

        private SphericalHarmonicCoefficents radianceCoefficients
        {
            get
            {
                SphericalHarmonicCoefficents savedData = AssetDatabase.LoadAssetAtPath<SphericalHarmonicCoefficents>("Assets/SphericalHarmonicIBL/Data/GeneratedRadianceCoefficients.asset");

                if (savedData == null)
                {
                    SphericalHarmonicCoefficents newData = new SphericalHarmonicCoefficents();
                    AssetDatabase.CreateAsset(newData, "Assets/SphericalHarmonicIBL/Data/GeneratedRadianceCoefficients.asset");
                    savedData = newData;
                }

                return savedData;
            }
        }

        private Vector3[] sphericalHarmonicIrradianceCoefficients 
        { 
            get
            {
                return irradianceCoefficients.coefficents;
            }
            set
            {
                irradianceCoefficients.coefficents = value;
            }
        }

        private Vector3[] sphericalHarmonicRadianceCoefficients
        {
            get
            {
                return radianceCoefficients.coefficents;
            }
            set
            {
                radianceCoefficients.coefficents = value;
            }
        }

        private Material originalSkyboxMaterial;
        private Material objectSphericalHarmonicsRadianceMaterial;
        private Material objectSphericalHarmonicsIrradianceMaterial;
        private Material skyboxSphericalHarmonicsRadianceMaterial;

        private Shader objectSphericalHarmonicsRadianceShader => Shader.Find("SphericalHarmonicIBL/ObjectSphericalHarmonicsRadiance");
        private Shader objectSphericalHarmonicsIrradianceShader => Shader.Find("SphericalHarmonicIBL/ObjectSphericalHarmonicsIrradiance");
        private Shader skyboxSphericalHarmonicsRadianceShader => Shader.Find("SphericalHarmonicIBL/SkyboxSphericalHarmonicsRadiance");
        private ComputeShader sphericalHarmonicsGPU => AssetDatabase.LoadAssetAtPath<ComputeShader>("Assets/SphericalHarmonicIBL/Shaders/SphericalHarmonicsComputeGPU.compute");

        private GUIStyle bgLightGrey;


        [MenuItem("Custom/Spherical Harmonic IBL Editor")]
        static void Init() => GetWindow(typeof(SphericalHarmonicIBL_Editor));

        private void OnFocus() => UpdateMaterials();

        private void OnEnable() => UpdateMaterials();

        private void SetupMaterial(ref Material material, Shader shader, string name)
        {
            if (material != null)
                return;

            string path = string.Format("Assets/SphericalHarmonicIBL/Materials/{0}.mat", name);

            if (material == null)
                material = AssetDatabase.LoadAssetAtPath<Material>(path);

            if (material == null)
            {
                material = new Material(shader);
                AssetDatabase.CreateAsset(material, path);
            }    
        }

        private void SetupMaterials()
        {
            SetupMaterial(ref objectSphericalHarmonicsRadianceMaterial, objectSphericalHarmonicsRadianceShader, "objectSphericalHarmonicsRadianceMaterial");
            SetupMaterial(ref objectSphericalHarmonicsIrradianceMaterial, objectSphericalHarmonicsIrradianceShader, "objectSphericalHarmonicsIrradianceMaterial");
            SetupMaterial(ref skyboxSphericalHarmonicsRadianceMaterial, skyboxSphericalHarmonicsRadianceShader, "skyboxSphericalHarmonicsRadianceMaterial");
        }

        /// <summary>
        /// Apply generated spherical harmonic coefficents to our preview materials.
        /// </summary>
        private void UpdateMaterials()
        {
            SetupMaterials();

            int coefficientCount = 0;
            int loopCount = 0;

            if (skyboxSphericalHarmonicsRadianceMaterial != null && sphericalHarmonicRadianceCoefficients != null && sphericalHarmonicRadianceCoefficients.Length > 0)
            {
                //there are 16 max float3s, so we will clear them out first
                for (int i = 0; i < 64; ++i)
                    skyboxSphericalHarmonicsRadianceMaterial.SetVector("_RadianceCoefficents" + i.ToString(), Vector4.zero);

                coefficientCount = ((int)radianceOrders + 1) * ((int)radianceOrders + 1);
                loopCount = coefficientCount > sphericalHarmonicRadianceCoefficients.Length ? 0 : coefficientCount;

                //fill in the values
                for (int i = 0; i < loopCount; ++i)
                    skyboxSphericalHarmonicsRadianceMaterial.SetVector("_RadianceCoefficents" + i.ToString(), sphericalHarmonicRadianceCoefficients[i]);
            }

            if (objectSphericalHarmonicsRadianceMaterial != null && sphericalHarmonicRadianceCoefficients != null && sphericalHarmonicRadianceCoefficients.Length > 0)
            {
                //there are 16 max float3s, so we will clear them out first
                for (int i = 0; i < 64; ++i)
                    objectSphericalHarmonicsRadianceMaterial.SetVector("_RadianceCoefficents" + i.ToString(), Vector4.zero);

                coefficientCount = ((int)radianceOrders + 1) * ((int)radianceOrders + 1);
                loopCount = coefficientCount > sphericalHarmonicRadianceCoefficients.Length ? 0 : coefficientCount;

                for (int i = 0; i < loopCount; ++i)
                    objectSphericalHarmonicsRadianceMaterial.SetVector("_RadianceCoefficents" + i.ToString(), sphericalHarmonicRadianceCoefficients[i]);

                SphericalHarmonicsUtility.SetMaterialKeyword(objectSphericalHarmonicsRadianceMaterial, "_GAMMA_TO_LINEAR", radianceUseLinearToGamma);
            }

            if (objectSphericalHarmonicsIrradianceMaterial != null && sphericalHarmonicIrradianceCoefficients != null && sphericalHarmonicIrradianceCoefficients.Length > 0)
            {
                //there are 9 max float3s, so we will clear them out first
                for (int i = 0; i < 9; ++i)
                    objectSphericalHarmonicsIrradianceMaterial.SetVector("_IrradianceCoefficents" + i.ToString(), Vector4.zero);

                coefficientCount = ((int)irradianceOrders + 1) * ((int)irradianceOrders + 1);
                loopCount = coefficientCount > sphericalHarmonicIrradianceCoefficients.Length ? 0 : coefficientCount;

                for (int i = 0; i < loopCount; ++i)
                    objectSphericalHarmonicsIrradianceMaterial.SetVector("_IrradianceCoefficents" + i.ToString(), sphericalHarmonicIrradianceCoefficients[i]);

                SphericalHarmonicsUtility.SetMaterialKeyword(objectSphericalHarmonicsIrradianceMaterial, "_GAMMA_TO_LINEAR", irradianceUseLinearToGamma);
            }
        }

        private void OnGUI()
        {
            //get a nice little fancy grey bar for titles
            if (bgLightGrey == null)
            {
                bgLightGrey = new GUIStyle(EditorStyles.label);
                bgLightGrey.normal.background = Texture2D.linearGrayTexture;
            }

            //||||||||||||||||||||||||||||||| SOURCE CUBEMAP |||||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||||| SOURCE CUBEMAP |||||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||||| SOURCE CUBEMAP |||||||||||||||||||||||||||||||

            GUILayout.BeginVertical(bgLightGrey);
            GUILayout.Label("Input", EditorStyles.whiteLargeLabel);
            GUILayout.EndVertical();

            sourceCubemap = (Cubemap)EditorGUILayout.ObjectField("Source Cubemap", sourceCubemap, typeof(Cubemap), false);
            EditorGUILayout.Space();

            if (sourceCubemap == null)
                return;

            if (GUILayout.Button("SH Lookup Generate"))
            {
                SphericalHarmonicLookupTableGenerator.GenerateSphericalHarmonicBasisLookupTable_Order2_512x512("Assets/SphericalHarmonicBasisLookup.asset");
                SphericalHarmonicLookupTableGenerator.GenerateAndApplySphericalHarmonicBasisLookupTable_Order2_512x512("Assets/SphericalHarmonicBasisLookupAppliedTest.asset", sourceCubemap, out Vector3[] radianceOutput);
                sphericalHarmonicRadianceCoefficients = radianceOutput;
                //sphericalHarmonicRadianceCoefficients = SphericalHarmonicsUtility.CompressAndUncompressCoefficents(sphericalHarmonicRadianceCoefficients, radianceCoefficentPrecision);
                UpdateMaterials();
            }

            //||||||||||||||||||||||||||||||| SPHERICAL HARMONIC RADIANCE SETTINGS |||||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||||| SPHERICAL HARMONIC RADIANCE SETTINGS |||||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||||| SPHERICAL HARMONIC RADIANCE SETTINGS |||||||||||||||||||||||||||||||

            EditorGUILayout.Space();
            GUILayout.BeginVertical(bgLightGrey);
            GUILayout.Label("Spherical Harmonic Radiance Settings", EditorStyles.whiteLargeLabel);
            GUILayout.EndVertical();

            radianceOrders = EditorGUILayout.IntSlider("Orders", radianceOrders, 0, 6);
            radianceSamplingType = (SamplingType)EditorGUILayout.EnumPopup("Sampling Type", radianceSamplingType);

            if (radianceSamplingType == SamplingType.RandomSphereSampling || radianceSamplingType == SamplingType.FibonacciSphereSampling)
                radianceSampleCount = EditorGUILayout.IntField("Sample Count", radianceSampleCount);

            if (radianceSamplingType == SamplingType.EveryCubemapTexel)
                radianceDownsampleFactor = 1;
            else if (radianceSamplingType == SamplingType.DownsampledCubemapTexel)
                radianceDownsampleFactor = EditorGUILayout.IntField("Downsample Factor", radianceDownsampleFactor);

            //add minimum clamp to sample count
            radianceSampleCount = Mathf.Max(16, radianceSampleCount);
            radianceDownsampleFactor = Mathf.Clamp(radianceDownsampleFactor, 1, sourceCubemap.mipmapCount - 3); //NOTE: skip the few smallest mip levels because max cubemap size is 32.

            radianceDeringFilter = (DeringFilter)EditorGUILayout.EnumPopup("De-Ring Filter", radianceDeringFilter);

            if (radianceDeringFilter != DeringFilter.None)
                radianceDeringFilterWindowSize = EditorGUILayout.FloatField("Filter Window Size", radianceDeringFilterWindowSize);

            radianceUseLinearToGamma = EditorGUILayout.Toggle("Linear To Gamma", radianceUseLinearToGamma);

            radianceCoefficentPrecision = (CoefficentPrecision)EditorGUILayout.EnumPopup("Stored Coefficent Precision", radianceCoefficentPrecision);

            //||||||||||||||||||||||||||||||| SPHERICAL HARMONIC IRRADIANCE SETTINGS |||||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||||| SPHERICAL HARMONIC IRRADIANCE SETTINGS |||||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||||| SPHERICAL HARMONIC IRRADIANCE SETTINGS |||||||||||||||||||||||||||||||

            EditorGUILayout.Space();
            GUILayout.BeginVertical(bgLightGrey);
            GUILayout.Label("Spherical Harmonic Irradiance Settings", EditorStyles.whiteLargeLabel);
            GUILayout.EndVertical();

            irradianceOrders = EditorGUILayout.IntSlider("Orders", irradianceOrders, 0, 2);
            irradianceSamplingType = (SamplingType)EditorGUILayout.EnumPopup("Sampling Type", irradianceSamplingType);

            if (irradianceSamplingType == SamplingType.RandomSphereSampling || irradianceSamplingType == SamplingType.FibonacciSphereSampling)
                irradianceSampleCount = EditorGUILayout.IntField("Sample Count", irradianceSampleCount);

            if (irradianceSamplingType == SamplingType.EveryCubemapTexel)
                irradianceDownsampleFactor = 1;
            else if (irradianceSamplingType == SamplingType.DownsampledCubemapTexel)
                irradianceDownsampleFactor = EditorGUILayout.IntField("Downsample Factor", irradianceDownsampleFactor);

            //add minimum clamp to sample count
            irradianceSampleCount = Mathf.Max(16, irradianceSampleCount);
            irradianceDownsampleFactor = Mathf.Clamp(irradianceDownsampleFactor, 1, sourceCubemap.mipmapCount - 3); //NOTE: skip the few smallest mip levels because max cubemap size is 32.

            irradianceDeringFilter = (DeringFilter)EditorGUILayout.EnumPopup("De-Ring Filter", irradianceDeringFilter);

            if (irradianceDeringFilter != DeringFilter.None)
                irradianceDeringFilterWindowSize = EditorGUILayout.FloatField("Filter Window Size", irradianceDeringFilterWindowSize);

            irradianceUseLinearToGamma = EditorGUILayout.Toggle("Linear To Gamma", irradianceUseLinearToGamma);

            irradianceCoefficentPrecision = (CoefficentPrecision)EditorGUILayout.EnumPopup("Stored Coefficent Precision", irradianceCoefficentPrecision);

            //||||||||||||||||||||||||||||||| GENERATION |||||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||||| GENERATION |||||||||||||||||||||||||||||||
            //||||||||||||||||||||||||||||||| GENERATION |||||||||||||||||||||||||||||||

            EditorGUILayout.Space();
            GUILayout.BeginVertical(bgLightGrey);
            GUILayout.Label("Generation", EditorStyles.whiteLargeLabel);
            GUILayout.EndVertical();

            generationDeviceType = (GenerationDeviceType)EditorGUILayout.EnumPopup("Generate Using", generationDeviceType);

            GUILayout.BeginHorizontal();

            if (GUILayout.Button("Generate Radiance Coefficients"))
            {
                if (generationDeviceType == GenerationDeviceType.CPU)
                {
                    UpdateProgressBar("Computing Radiance Coefficients on CPU...", 0.5f);

                    if (radianceSamplingType == SamplingType.EveryCubemapTexel)
                        sphericalHarmonicRadianceCoefficients = SphericalHarmonicsCPU.ProjectIntoUniformSH(sourceCubemap, radianceOrders, radianceDeringFilter, radianceDeringFilterWindowSize, radianceUseLinearToGamma);
                    else if (radianceSamplingType == SamplingType.DownsampledCubemapTexel)
                        sphericalHarmonicRadianceCoefficients = SphericalHarmonicsCPU.ProjectIntoUniformSH(SphericalHarmonicsUtility.DownsampleCubemap(sourceCubemap, radianceDownsampleFactor), radianceOrders, radianceDeringFilter, radianceDeringFilterWindowSize, radianceUseLinearToGamma);
                    else
                        sphericalHarmonicRadianceCoefficients = SphericalHarmonicsCPU.ProjectIntoSampledSH(sourceCubemap, radianceOrders, radianceSampleCount, radianceSamplingType, radianceDeringFilter, radianceDeringFilterWindowSize, radianceUseLinearToGamma);
                }
                else
                {
                    UpdateProgressBar("Computing Radiance Coefficients on GPU...", 0.5f);

                    //if (radianceSamplingType == SamplingType.EveryCubemapTexel)
                        //sphericalHarmonicRadianceCoefficients = SphericalHarmonicsGPU.ProjectRadianceIntoUniformSH(sphericalHarmonicsGPU, sourceCubemap, radianceOrders);
                    //else if (radianceSamplingType == SamplingType.DownsampledCubemapTexel)
                        //sphericalHarmonicRadianceCoefficients = SphericalHarmonicsGPU.ProjectRadianceIntoUniformSH(sphericalHarmonicsGPU, SphericalHarmonicsUtility.DownsampleCubemap(sourceCubemap, radianceDownsampleFactor), radianceOrders);
                    //else
                        //sphericalHarmonicRadianceCoefficients = SphericalHarmonicsGPU.ProjectRadianceIntoSampledSH(sphericalHarmonicsGPU, sourceCubemap, radianceOrders, radianceSampleCount, radianceSamplingType);
                }

                sphericalHarmonicRadianceCoefficients = SphericalHarmonicsUtility.CompressAndUncompressCoefficents(sphericalHarmonicRadianceCoefficients, radianceCoefficentPrecision);
                radianceCoefficients.storedCoefficentPrecision = radianceCoefficentPrecision;
                radianceCoefficients.DebugPrintMinimumMaximums();

                UpdateMaterials();
                CloseProgressBar();
            }

            if (GUILayout.Button("Generate Irradiance Coefficients"))
            {
                if (generationDeviceType == GenerationDeviceType.CPU)
                {
                    UpdateProgressBar("Computing Irradiance Coefficients on CPU...", 0.5f);

                    if (irradianceSamplingType == SamplingType.EveryCubemapTexel)
                        sphericalHarmonicIrradianceCoefficients = SphericalHarmonicsCPU.ProjectIntoUniformSH(sourceCubemap, irradianceOrders, irradianceDeringFilter, irradianceDeringFilterWindowSize, irradianceUseLinearToGamma);
                    else if (irradianceSamplingType == SamplingType.DownsampledCubemapTexel)
                        sphericalHarmonicIrradianceCoefficients = SphericalHarmonicsCPU.ProjectIntoUniformSH(SphericalHarmonicsUtility.DownsampleCubemap(sourceCubemap, irradianceDownsampleFactor), irradianceOrders, irradianceDeringFilter, irradianceDeringFilterWindowSize, irradianceUseLinearToGamma);
                    else
                        sphericalHarmonicIrradianceCoefficients = SphericalHarmonicsCPU.ProjectIntoSampledSH(sourceCubemap, irradianceOrders, irradianceSampleCount, irradianceSamplingType, irradianceDeringFilter, irradianceDeringFilterWindowSize, irradianceUseLinearToGamma);

                }
                else
                {
                    UpdateProgressBar("Computing Irradiance Coefficients on GPU...", 0.5f);

                    //SphericalHarmonicsGPU.ProjectIrradianceIntoSampledSH(sphericalHarmonicsGPU, sourceCubemap, irradianceOrders, irradianceSampleCount, irradianceSamplingType, irradianceDeringFilter, irradianceDeringFilterWindowSize, out sphericalHarmonicIrradianceCoefficients);
                }

                sphericalHarmonicIrradianceCoefficients = SphericalHarmonicsUtility.CompressAndUncompressCoefficents(sphericalHarmonicIrradianceCoefficients, irradianceCoefficentPrecision);
                irradianceCoefficients.storedCoefficentPrecision = irradianceCoefficentPrecision;
                irradianceCoefficients.DebugPrintMinimumMaximums();

                UpdateMaterials();
                CloseProgressBar();
            }

            GUILayout.EndHorizontal();
        }

        //|||||||||||||||||||||||||||||||||||||||||||||||||||||||| UTILITIES ||||||||||||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||||||||||||| UTILITIES ||||||||||||||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||||||||||||||| UTILITIES ||||||||||||||||||||||||||||||||||||||||||||||||||||||||

        public void UpdateProgressBar(string description, float progress) => EditorUtility.DisplayProgressBar("Spherical Harmonics", description, progress);

        public void CloseProgressBar() => EditorUtility.ClearProgressBar();
    }
}