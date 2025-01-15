using System.Collections.Generic;
using UnityEngine;

namespace SphericalHarmonicIBL
{
    public static class SphericalHarmonicsCPU
    {
        public static Vector3[] ProjectIntoUniformSH(
            Cubemap cubemap, 
            int orderCount, 
            DeringFilter deringFilter, 
            float deringFilterWindowSize, 
            bool gammaCorrection = false)
        {
            int coefficientCount = (orderCount + 1) * (orderCount + 1);
            Vector3[] output = new Vector3[coefficientCount];
            Color[] cubemapFaceColors;
            int size = cubemap.width;

            //iterate through the 6 faces of the cubemap
            for (int face = 0; face < 6; ++face)
            {
                cubemapFaceColors = cubemap.GetPixels((CubemapFace)face);

                //iterate through all of the texels on the cubemap face
                for (int texel = 0; texel < size * size; texel++)
                {
                    float u = (texel % size) / (float)size;
                    float v = ((int)(texel / size)) / (float)size;

                    //get the direction vector
                    Vector3 dir = SphericalHarmonicsUtility.DirectionFromCubemapTexel(face, u, v);

                    //sample the color of the current cubemap texel
                    Color cubemapRadianceSample = cubemapFaceColors[texel];

                    //convert the radiance sample from linear to gamma space (produces best results)
                    if(gammaCorrection)
                    {
                        cubemapRadianceSample.r = Mathf.LinearToGammaSpace(cubemapRadianceSample.r);
                        cubemapRadianceSample.g = Mathf.LinearToGammaSpace(cubemapRadianceSample.g);
                        cubemapRadianceSample.b = Mathf.LinearToGammaSpace(cubemapRadianceSample.b);
                    }

                    //compute the differential solid angle
                    float d_omega = SphericalHarmonicsUtility.DifferentialSolidAngle(size, u, v);

                    //iterate through each specified order of SH
                    for (int l = 0; l <= orderCount; l++)
                    {
                        //iterate through each SH basis for the current SH order
                        for (int m = -l; m <= l; m++)
                        {
                            int index = l * (l + 1) + m;

                            //evaluate the spherical harmonic basis for the current order
                            float sh = SphericalHarmonicBasis.EvaluatePrecomputedBasisFunction(l, m, dir);

                            output[index].x += cubemapRadianceSample.r * d_omega * sh;
                            output[index].y += cubemapRadianceSample.g * d_omega * sh;
                            output[index].z += cubemapRadianceSample.b * d_omega * sh;
                        }
                    }
                }
            }

            return FilterCoefficents(output, deringFilter, deringFilterWindowSize);
        }

        public static Vector3[] ProjectIntoSampledSH(
            Cubemap cubemap, 
            int orderCount, 
            int sampleCount, 
            SamplingType samplingType, 
            DeringFilter deringFilter, 
            float deringFilterWindowSize, 
            bool gammaCorrection = false)
        {
            int coefficientCount = (orderCount + 1) * (orderCount + 1);
            Vector3[] output = new Vector3[coefficientCount];
            List<Color[]> faces = new List<Color[]>();

            //iterate through the 6 faces of the cubemap
            for (int f = 0; f < 6; ++f)
            {
                faces.Add(cubemap.GetPixels((CubemapFace)f, 0));
            }

            //iterate through each specified order of SH
            for (int l = 0; l <= orderCount; l++)
            {
                //iterate through each SH basis for the current SH order
                for (int m = -l; m <= l; m++)
                {
                    int shIndex = l * (l + 1) + m;

                    for (int s = 0; s < sampleCount; ++s)
                    {
                        Vector3 dir = Random.onUnitSphere; //SphericalHarmonicsSamplingType.RandomSphereSampling

                        if (samplingType == SamplingType.FibonacciSphereSampling)
                        {
                            float angleIncrement = 10.1664073846305f; //precomputed version of (Mathf.PI * 2 * ((1 + Mathf.Sqrt(5)) / 2))
                            float y = 1 - (s + 0.5f) / sampleCount * 2;
                            float radius = Mathf.Sqrt(1 - y * y);
                            float theta = s * angleIncrement;

                            float x = Mathf.Cos(theta) * radius;
                            float z = Mathf.Sin(theta) * radius;

                            dir = new Vector3(x, y, z);
                        }

                        int index = SphericalHarmonicsUtility.GetTexelIndexFromDirection(dir, cubemap.height);
                        int face = SphericalHarmonicsUtility.FindFace(dir);

                        //read the radiance texel
                        Color cubemapRadianceSample = faces[face][index];

                        //convert the radiance sample from linear to gamma space (produces best results)
                        if (gammaCorrection)
                        {
                            cubemapRadianceSample.r = Mathf.LinearToGammaSpace(cubemapRadianceSample.r);
                            cubemapRadianceSample.g = Mathf.LinearToGammaSpace(cubemapRadianceSample.g);
                            cubemapRadianceSample.b = Mathf.LinearToGammaSpace(cubemapRadianceSample.b);
                        }

                        //evaluate the spherical harmonic basis for the current order
                        float sh = SphericalHarmonicBasis.EvaluatePrecomputedBasisFunction(l, m, dir);

                        output[shIndex].x += cubemapRadianceSample.r * sh;
                        output[shIndex].y += cubemapRadianceSample.g * sh;
                        output[shIndex].z += cubemapRadianceSample.b * sh;
                    }

                    output[shIndex].x *= 4.0f * Mathf.PI / (float)sampleCount;
                    output[shIndex].y *= 4.0f * Mathf.PI / (float)sampleCount;
                    output[shIndex].z *= 4.0f * Mathf.PI / (float)sampleCount;
                }
            }

            return FilterCoefficents(output, deringFilter, deringFilterWindowSize);
        }

        //|||||||||||||||||||||||||||||||||||||||||||| DE-RINGING ||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||| DE-RINGING ||||||||||||||||||||||||||||||||||||||||||||
        //|||||||||||||||||||||||||||||||||||||||||||| DE-RINGING ||||||||||||||||||||||||||||||||||||||||||||

        public static Vector3[] FilterCoefficents(Vector3[] coefficents, DeringFilter deringFilter, float deringFilterWindowSize)
        {
            Vector3[] filteredCoefficents = coefficents;

            switch (deringFilter)
            {
                case DeringFilter.None:
                    break;
                case DeringFilter.Hanning:
                    SphericalHarmonicsDering.FilterHanning(coefficents, out filteredCoefficents, deringFilterWindowSize);
                    break;
                case DeringFilter.Lanczos:
                    SphericalHarmonicsDering.FilterLanczos(coefficents, out filteredCoefficents, deringFilterWindowSize);
                    break;
                case DeringFilter.Gaussian:
                    SphericalHarmonicsDering.FilterGaussian(coefficents, out filteredCoefficents, deringFilterWindowSize);
                    break;
            }

            return filteredCoefficents;
        }
    }
}