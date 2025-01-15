using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace SphericalHarmonicIBL
{
    public static class SphericalHarmonicsDering
    {
        /// <summary>
        /// Applies Hanning filter for given window size.
        /// </summary>
        /// <param name="inputCoefficents"></param>
        /// <param name="filteredCoefficents"></param>
        /// <param name="filterWindowSize"></param>
        public static void FilterHanning(Vector3[] inputCoefficents, out Vector3[] filteredCoefficents, float filterWindowSize)
        {
            filteredCoefficents = new Vector3[inputCoefficents.Length];

            float filterWindowSizeReciprocal = 1.0f / filterWindowSize;
            Vector2 Factors = new Vector2(
                0.5f * (1.0f + Mathf.Cos(Mathf.PI * filterWindowSizeReciprocal)), 
                0.5f * (1.0f + Mathf.Cos(2.0f * Mathf.PI * filterWindowSizeReciprocal))
                );

            if (filteredCoefficents.Length <= 0)
                return;

            filteredCoefficents[0] = inputCoefficents[0];

            if (filteredCoefficents.Length == 1)
                return;

            filteredCoefficents[1] = Factors.x * inputCoefficents[1];
            filteredCoefficents[2] = Factors.x * inputCoefficents[2];
            filteredCoefficents[3] = Factors.x * inputCoefficents[3];

            if (filteredCoefficents.Length <= 4)
                return;

            filteredCoefficents[4] = Factors.y * inputCoefficents[4];
            filteredCoefficents[5] = Factors.y * inputCoefficents[5];
            filteredCoefficents[6] = Factors.y * inputCoefficents[6];
            filteredCoefficents[7] = Factors.y * inputCoefficents[7];
            filteredCoefficents[8] = Factors.y * inputCoefficents[8];
        }

        /// <summary>
        /// Applies Lanczos filter for given window size.
        /// </summary>
        /// <param name="inputCoefficents"></param>
        /// <param name="filteredCoefficents"></param>
        /// <param name="filterWindowSize"></param>
        public static void FilterLanczos(Vector3[] inputCoefficents, out Vector3[] filteredCoefficents, float filterWindowSize)
        {
            filteredCoefficents = new Vector3[inputCoefficents.Length];

            float filterWindowSizeReciprocal = 1.0f / filterWindowSize;
            Vector2 Factors = new Vector2(
                Mathf.Sin(Mathf.PI * filterWindowSizeReciprocal) / (Mathf.PI * filterWindowSizeReciprocal), 
                Mathf.Sin(2.0f * Mathf.PI * filterWindowSizeReciprocal) / (2.0f * Mathf.PI * filterWindowSizeReciprocal)
                );

            if (filteredCoefficents.Length <= 0)
                return;

            filteredCoefficents[0] = inputCoefficents[0];

            if (filteredCoefficents.Length == 1)
                return;

            filteredCoefficents[1] = Factors.x * inputCoefficents[1];
            filteredCoefficents[2] = Factors.x * inputCoefficents[2];
            filteredCoefficents[3] = Factors.x * inputCoefficents[3];

            if (filteredCoefficents.Length <= 4)
                return;

            filteredCoefficents[4] = Factors.y * inputCoefficents[4];
            filteredCoefficents[5] = Factors.y * inputCoefficents[5];
            filteredCoefficents[6] = Factors.y * inputCoefficents[6];
            filteredCoefficents[7] = Factors.y * inputCoefficents[7];
            filteredCoefficents[8] = Factors.y * inputCoefficents[8];
        }

        /// <summary>
        /// Applies gaussian filter for given window size.
        /// </summary>
        /// <param name="inputCoefficents"></param>
        /// <param name="filteredCoefficents"></param>
        /// <param name="filterWindowSize"></param>
        public static void FilterGaussian(Vector3[] inputCoefficents, out Vector3[] filteredCoefficents, float filterWindowSize)
        {
            filteredCoefficents = new Vector3[inputCoefficents.Length];

            float filterWindowSizeReciprocal = 1.0f / filterWindowSize;
            Vector2 Factors = new Vector2(
                Mathf.Exp(-0.5f * (Mathf.PI * filterWindowSizeReciprocal) * (Mathf.PI * filterWindowSizeReciprocal)), 
                Mathf.Exp(-0.5f * (2.0f * Mathf.PI * filterWindowSizeReciprocal) * (2.0f * Mathf.PI * filterWindowSizeReciprocal))
                );

            if (filteredCoefficents.Length <= 0)
                return;

            filteredCoefficents[0] = inputCoefficents[0];

            if (filteredCoefficents.Length == 1)
                return;

            filteredCoefficents[1] = Factors.x * inputCoefficents[1];
            filteredCoefficents[2] = Factors.x * inputCoefficents[2];
            filteredCoefficents[3] = Factors.x * inputCoefficents[3];

            if (filteredCoefficents.Length <= 4)
                return;

            filteredCoefficents[4] = Factors.y * inputCoefficents[4];
            filteredCoefficents[5] = Factors.y * inputCoefficents[5];
            filteredCoefficents[6] = Factors.y * inputCoefficents[6];
            filteredCoefficents[7] = Factors.y * inputCoefficents[7];
            filteredCoefficents[8] = Factors.y * inputCoefficents[8];
        }
    }
}