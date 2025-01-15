using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

namespace SphericalHarmonicIBL
{
    public static class SphericalHarmonicsGPU
    {
        //Size of the thread groups for compute shaders.
        //These values should match the #define ones in the compute shaders.
        private static int THREAD_GROUP_SIZE_X = 8;
        private static int THREAD_GROUP_SIZE_Y = 8;
        private static int THREAD_GROUP_SIZE_Z = 8;

        //|||||||||||||||||||||||||||||||||||||||||||| RADIANCE ||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||| RADIANCE ||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||| RADIANCE ||||||||||||||||||||||||||||||||||||||||||||

        public static void ProjectIntoUniformSH(ComputeShader shader, Cubemap cubemap, int orderCount, DeringFilter deringFilter, float deringFilterWindowSize, out Vector3[] output, bool gammaCorrection = false)
        {
            int coefficientCount = (orderCount + 1) * (orderCount + 1);
            output = new Vector3[coefficientCount];

            //------------------------- COMPUTE BUFFER CONSTRUCTION -------------------------
            ComputeBuffer outputCoefficentsBuffer = new ComputeBuffer(output.Length, Marshal.SizeOf(typeof(Vector3)));
            outputCoefficentsBuffer.SetData(output);

            //------------------------- COMPUTE SHADER -------------------------
            int ComputeShader_ProjectRadianceIntoUniformSH = shader.FindKernel("ComputeShader_ProjectRadianceIntoUniformSH");

            shader.SetBuffer(ComputeShader_ProjectRadianceIntoUniformSH, "OutputCoefficients", outputCoefficentsBuffer);
            //shader.SetTexture(ComputeShader_ProjectRadianceIntoUniformSH, "InputEquirectangular", );
            shader.SetTexture(ComputeShader_ProjectRadianceIntoUniformSH, "InputCubemap", cubemap);

            shader.SetVector("SourceCubemapResolution", new Vector4(cubemap.width, cubemap.height, 0, 0));
            shader.SetInt("SphericalHarmonicOrderCount", orderCount);

            SphericalHarmonicsUtility.SetComputeKeyword(shader, "_INPUTTYPE_CUBEMAP", true);
            SphericalHarmonicsUtility.SetComputeKeyword(shader, "_INPUTTYPE_EQUIRECTANGULAR", false);

            //shader.Dispatch(ComputeShader_ProjectRadianceIntoUniformSH, cubemap.width, cubemap.height, 1);
            shader.Dispatch(ComputeShader_ProjectRadianceIntoUniformSH, Mathf.CeilToInt(cubemap.width / THREAD_GROUP_SIZE_X), Mathf.CeilToInt(cubemap.height / THREAD_GROUP_SIZE_Y), 1);
            //shader.Dispatch(ComputeShader_ProjectRadianceIntoUniformSH, THREAD_GROUP_SIZE_X, THREAD_GROUP_SIZE_Y, 1);
            //shader.Dispatch(ComputeShader_ProjectRadianceIntoUniformSH, 1, 1, 1);

            outputCoefficentsBuffer.GetData(output);

            //------------------------- CLEANUP -------------------------
            outputCoefficentsBuffer.Release();
        }

        public static void ProjectIntoSampledSH(ComputeShader shader, Cubemap cubemap, int orderCount, DeringFilter deringFilter, float deringFilterWindowSize, int sampleCount, SamplingType samplingType, out Vector3[] output, bool gammaCorrection = false)
        {
            int coefficientCount = (orderCount + 1) * (orderCount + 1);
            output = new Vector3[coefficientCount];

            //------------------------- COMPUTE BUFFER CONSTRUCTION -------------------------
            ComputeBuffer outputCoefficentsBuffer = new ComputeBuffer(output.Length, Marshal.SizeOf(typeof(Vector3)));
            outputCoefficentsBuffer.SetData(output);

            //------------------------- COMPUTE SHADER -------------------------
            int ComputeShader_ProjectRadianceIntoSampledSH = shader.FindKernel("ComputeShader_ProjectRadianceIntoSampledSH");

            shader.SetBuffer(ComputeShader_ProjectRadianceIntoSampledSH, "OutputCoefficients", outputCoefficentsBuffer);
            //shader.SetTexture(ComputeShader_ProjectRadianceIntoSampledSH, "InputEquirectangular", );
            shader.SetTexture(ComputeShader_ProjectRadianceIntoSampledSH, "InputCubemap", cubemap);

            shader.SetVector("SourceCubemapResolution", new Vector4(cubemap.width, cubemap.height, 0, 0));
            shader.SetInt("SphericalHarmonicOrderCount", orderCount);
            shader.SetInt("SampleCount", sampleCount);

            SphericalHarmonicsUtility.SetComputeKeyword(shader, "_INPUTTYPE_CUBEMAP", true);
            SphericalHarmonicsUtility.SetComputeKeyword(shader, "_INPUTTYPE_EQUIRECTANGULAR", false);

            //shader.Dispatch(ComputeShader_ProjectRadianceIntoSampledSH, Mathf.CeilToInt(cubemap.width / THREAD_GROUP_SIZE_X), Mathf.CeilToInt(cubemap.height / THREAD_GROUP_SIZE_Y), 1);
            //shader.Dispatch(ComputeShader_ProjectRadianceIntoSampledSH, THREAD_GROUP_SIZE_X, THREAD_GROUP_SIZE_Y, 1);
            shader.Dispatch(ComputeShader_ProjectRadianceIntoSampledSH, 1, 1, 1);

            outputCoefficentsBuffer.GetData(output);

            //------------------------- CLEANUP -------------------------
            outputCoefficentsBuffer.Release();
        }
    }
}