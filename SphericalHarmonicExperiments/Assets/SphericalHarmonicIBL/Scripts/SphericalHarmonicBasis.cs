using UnityEngine;

namespace SphericalHarmonicIBL
{
    public static class SphericalHarmonicBasis
    {
        /// <summary>
        /// Evaluate the spherical harmonic basis function given l, m, and a direction vector up to 6 orders.
        /// <para>NOTE: This is much faster since terms are precomputed, results are identical to the non-precomputed version.</para>
        /// </summary>
        /// <param name="l"></param>
        /// <param name="m"></param>
        /// <param name="dir"></param>
        /// <returns></returns>
        public static float EvaluatePrecomputedBasisFunction(int l, int m, Vector3 dir)
        {
            //---------------------------------- ORDER 0 ----------------------------------
            if (l == 0 && m == 0)
                return 0.282094791773878f;
            //---------------------------------- ORDER 1 ----------------------------------
            if (l == 1)
            {
                switch(m)
                {
                    case -1: return 0.48860251190292f * dir.y;
                    case 0: return 0.48860251190292f * dir.z;
                    case 1: return 0.48860251190292f * dir.x;
                }
            }
            //---------------------------------- ORDER 2 ----------------------------------
            if (l == 2)
            {
                switch(m)
                {
                    case -2: return 1.09254843059208f * dir.x * dir.y;
                    case -1: return 1.09254843059208f * dir.y * dir.z;
                    case 0: return 0.31539156525252f * (3 * dir.z * dir.z - 1);
                    case 1: return 1.09254843059208f * dir.x * dir.z;
                    case 2: return 0.54627421529604f * (dir.x * dir.x - dir.y * dir.y);
                }
            }
            //---------------------------------- ORDER 3 ----------------------------------
            if (l == 3)
            {
                switch(m)
                {
                    case -3: return 0.590043589926643f * dir.y * (3 * dir.x * dir.x - dir.y * dir.y);
                    case -2: return 2.89061144264055f * dir.x * dir.y * dir.z;
                    case -1: return 0.457045799464466f * dir.y * (4 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y);
                    case 0: return 0.373176332590115f * (dir.z * (2 * dir.z * dir.z - 3 * dir.x * dir.x - 3 * dir.y * dir.y));
                    case 1: return 0.457045799464466f * dir.x * (4 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y);
                    case 2: return 1.44530572132028f * dir.z * (dir.x * dir.x - dir.y * dir.y);
                    case 3: return 0.590043589926643f * dir.x * (dir.x * dir.x - 3 * dir.y * dir.y);
                }
            }
            //---------------------------------- ORDER 4 ----------------------------------
            if (l == 4)
            {
                float dirDot = Vector3.Dot(dir, dir);

                switch(m)
                {
                    case -4: return 2.5033429417967f * (dir.z * dir.x * (dir.z * dir.z - dir.x * dir.x));
                    case -3: return -1.74465993438048f * (3.0f * dir.z * dir.z - dir.x * dir.x) * dir.x * dir.y;
                    case -2: return 0.94617469575756f * (dir.z * dir.x * (7.0f * dir.y * dir.y - dirDot));
                    case -1: return -0.598413420602149f * (dir.y * dir.x * (7.0f * dir.y * dir.y - 3.0f * dirDot));
                    case 0: return 0.105785546915204f * (35.0f * (dir.y * dir.y) * (dir.y * dir.y) - 30.0f * (dir.y * dir.y) + 3.0f);
                    case 1: return -0.598413420602149f * (dir.y * dir.z * (7.0f * dir.y * dir.y - 3.0f * dirDot));
                    case 2: return 0.47308734787878f * ((dir.z * dir.z - dir.x * dir.x) * (7.0f * dir.y * dir.y - dirDot));
                    case 3: return -1.74465993438048f * dir.z * dir.y * (dir.z * dir.z - 3.0f * dir.x * dir.x);
                    case 4: return 0.625835735449176f * ((dir.z * dir.z) * ((dir.z * dir.z) - 3.0f * (dir.x * dir.x)) - (dir.x * dir.x) * (3.0f * (dir.z * dir.z) - (dir.x * dir.x)));
                }
            }
            //---------------------------------- ORDER 5 ----------------------------------
            if (l == 5)
            {
                float phi = Mathf.Atan2(dir.y, dir.x);
                float sinTheta = Mathf.Sqrt(1.0f - dir.z * dir.z);

                switch(m)
                {
                    case -5: return 0.464132203440858f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * Mathf.Sin(-5f * phi);
                    case -4: return 1.46771489830575f * (sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * Mathf.Cos(-4f * phi);
                    case -3: return 0.34594371914684f * (sinTheta * sinTheta * sinTheta) * (9f * dir.z * dir.z - 1f) * Mathf.Sin(-3f * phi);
                    case -2: return 1.6947711832609f * (sinTheta * sinTheta) * (3f * dir.z * dir.z * dir.z - dir.z) * Mathf.Cos(-2f * phi);
                    case -1: return 0.320281648576215f * sinTheta * (21f * dir.z * dir.z * dir.z * dir.z - 14f * dir.z * dir.z + 1f) * Mathf.Sin(-1f * phi);
                    case 0: return 0.116950322453424f * (63f * dir.z * dir.z * dir.z * dir.z * dir.z - 70f * dir.z * dir.z * dir.z + 15f * dir.z);
                    case 1: return -0.320281648576215f * sinTheta * (21f * dir.z * dir.z * dir.z * dir.z - 14f * dir.z * dir.z + 1f) * Mathf.Cos(phi);
                    case 2: return 1.6947711832609f * (sinTheta * sinTheta) * (3f * dir.z * dir.z * dir.z - dir.z) * Mathf.Sin(2f * phi);
                    case 3: return -0.34594371914684f * (sinTheta * sinTheta * sinTheta) * (9f * dir.z * dir.z - 1f) * Mathf.Cos(3f * phi);
                    case 4: return 1.46771489830575f * (sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * Mathf.Sin(4f * phi);
                    case 5: return -0.464132203440858f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * Mathf.Cos(5f * phi);
                }
            }
            //---------------------------------- ORDER 6 ----------------------------------
            if (l == 6)
            {
                float phi = Mathf.Atan2(dir.y, dir.x);
                float sinTheta = Mathf.Sqrt(1.0f - dir.z * dir.z);

                switch(m)
                {
                    case -6: return 0.483084113580066f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * Mathf.Sin(-6f * phi);
                    case -5: return 1.6734524581001f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * Mathf.Cos(-5f * phi);
                    case -4: return 0.356781262853998f * (sinTheta * sinTheta * sinTheta * sinTheta) * (11f * dir.z * dir.z - 1f) * Mathf.Sin(-4f * phi);
                    case -3: return 0.651390485867716f * (sinTheta * sinTheta * sinTheta) * (11f * dir.z * dir.z * dir.z - 3f * dir.z) * Mathf.Cos(-3f * phi);
                    case -2: return 0.325695242933858f * (sinTheta * sinTheta) * (33f * dir.z * dir.z * dir.z * dir.z - 18f * dir.z * dir.z + 1f) * Mathf.Sin(-2f * phi);
                    case -1: return 0.411975516301141f * sinTheta * (33f * dir.z * dir.z * dir.z * dir.z * dir.z - 30f * dir.z * dir.z * dir.z + 5f * dir.z) * Mathf.Cos(-1f * phi);
                    case 0: return 0.0635692022676284f * (231f * dir.z * dir.z * dir.z * dir.z * dir.z * dir.z - 315f * dir.z * dir.z * dir.z * dir.z + 105f * dir.z * dir.z - 5f);
                    case 1: return -0.411975516301141f * sinTheta * (33f * dir.z * dir.z * dir.z * dir.z * dir.z - 30f * dir.z * dir.z * dir.z + 5f * dir.z) * Mathf.Sin(phi);
                    case 2: return 0.325695242933858f * (sinTheta * sinTheta) * (33f * dir.z * dir.z * dir.z * dir.z - 18f * dir.z * dir.z + 1f) * Mathf.Cos(2f * phi);
                    case 3: return -0.651390485867716f * (sinTheta * sinTheta * sinTheta) * (11f * dir.z * dir.z * dir.z - 3f * dir.z) * Mathf.Sin(3f * phi);
                    case 4: return 0.356781262853998f * (sinTheta * sinTheta * sinTheta * sinTheta) * (11f * dir.z * dir.z - 1f) * Mathf.Cos(4f * phi);
                    case 5: return -1.6734524581001f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * Mathf.Sin(5f * phi);
                    case 6: return 0.483084113580066f * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * Mathf.Cos(6f * phi);
                }
            }

            //anything past 6 orders is not supported.
            return 0f;
        }

        /// <summary>
        /// Evaluate the spherical harmonic basis function given l, m, and a direction vector up to 6 orders.
        /// <para>NOTE: This is much slower since there are no precomputed terms.</para>
        /// </summary>
        /// <param name="l"></param>
        /// <param name="m"></param>
        /// <param name="dir"></param>
        /// <returns></returns>
        public static float EvaluateBasisFunction(int l, int m, Vector3 dir)
        {
            //---------------------------------- ORDER 0 ----------------------------------
            if (l == 0 && m == 0)
                return 0.5f * Mathf.Sqrt(1 / Mathf.PI);
            //---------------------------------- ORDER 1 ----------------------------------
            if (l == 1)
            {
                switch(m)
                {
                    case -1: return Mathf.Sqrt(3 / (4 * Mathf.PI)) * dir.y;
                    case 0: return Mathf.Sqrt(3 / (4 * Mathf.PI)) * dir.z;
                    case 1: return Mathf.Sqrt(3 / (4 * Mathf.PI)) * dir.x;
                }
            }
            //---------------------------------- ORDER 2 ----------------------------------
            if (l == 2)
            {
                switch(m)
                {
                    case -2: return 0.5f * Mathf.Sqrt(15 / Mathf.PI) * dir.x * dir.y;
                    case -1: return 0.5f * Mathf.Sqrt(15 / Mathf.PI) * dir.y * dir.z;
                    case 0: return 0.25f * Mathf.Sqrt(5 / Mathf.PI) * (3 * dir.z * dir.z - 1);
                    case 1: return 0.5f * Mathf.Sqrt(15 / Mathf.PI) * dir.x * dir.z;
                    case 2: return 0.25f * Mathf.Sqrt(15 / Mathf.PI) * (dir.x * dir.x - dir.y * dir.y);
                }
            }
            //---------------------------------- ORDER 3 ----------------------------------
            if (l == 3)
            {
                switch(m)
                {
                    case -3: return (0.25f * Mathf.Sqrt(7.0f) * 1.0f / Mathf.Sqrt(Mathf.PI)) * (Mathf.Sqrt(5) / Mathf.Sqrt(2)) * dir.y * (3 * dir.x * dir.x - dir.y * dir.y);
                    case -2: return (0.25f * Mathf.Sqrt(7.0f) * 1.0f / Mathf.Sqrt(Mathf.PI)) * 2.0f * Mathf.Sqrt(15) * dir.x * dir.y * dir.z;
                    case -1: return (0.25f * Mathf.Sqrt(7.0f) * 1.0f / Mathf.Sqrt(Mathf.PI)) * (Mathf.Sqrt(3) / Mathf.Sqrt(2)) * dir.y * (4 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y);
                    case 0: return (0.25f * Mathf.Sqrt(7.0f) * 1.0f / Mathf.Sqrt(Mathf.PI)) * (dir.z * (2 * dir.z * dir.z - 3 * dir.x * dir.x - 3 * dir.y * dir.y));
                    case 1: return (0.25f * Mathf.Sqrt(7.0f) * 1.0f / Mathf.Sqrt(Mathf.PI)) * (Mathf.Sqrt(3) / Mathf.Sqrt(2)) * dir.x * (4 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y);
                    case 2: return (0.25f * Mathf.Sqrt(7.0f) * 1.0f / Mathf.Sqrt(Mathf.PI)) * Mathf.Sqrt(15) * dir.z * (dir.x * dir.x - dir.y * dir.y);
                    case 3: return (0.25f * Mathf.Sqrt(7.0f) * 1.0f / Mathf.Sqrt(Mathf.PI)) * (Mathf.Sqrt(5) / Mathf.Sqrt(2)) * dir.x * (dir.x * dir.x - 3 * dir.y * dir.y);
                }
            }
            //---------------------------------- ORDER 4 ----------------------------------
            if (l == 4)
            {
                switch(m)
                {
                    case -4: return Mathf.Sqrt(35.0f / Mathf.PI) * 3.0f / 4.0f * (dir.z * dir.x * (dir.z * dir.z - dir.x * dir.x));
                    case -3: return -Mathf.Sqrt(35.0f / 2.0f / Mathf.PI) * 3.0f / 4.0f * (3.0f * dir.z * dir.z - dir.x * dir.x) * dir.x * dir.y;
                    case -2: return Mathf.Sqrt(5.0f / Mathf.PI) * 3.0f / 4.0f * (dir.z * dir.x * (7.0f * dir.y * dir.y - Vector3.Dot(dir, dir)));
                    case -1: return -Mathf.Sqrt(5.0f / 2.0f / Mathf.PI) * 3.0f / 4.0f * (dir.y * dir.x * (7.0f * dir.y * dir.y - 3.0f * Vector3.Dot(dir, dir)));
                    case 0: return Mathf.Sqrt(1 / Mathf.PI) * 3.0f / 16.0f * (35.0f * (dir.y * dir.y) * (dir.y * dir.y) - 30.0f * (dir.y * dir.y) + 3.0f);
                    case 1: return -Mathf.Sqrt(5.0f / 2.0f / Mathf.PI) * 3.0f / 4.0f * (dir.y * dir.z * (7.0f * dir.y * dir.y - 3.0f * Vector3.Dot(dir, dir)));
                    case 2: return Mathf.Sqrt(5.0f / Mathf.PI) * 3.0f / 8.0f * ((dir.z * dir.z - dir.x * dir.x) * (7.0f * dir.y * dir.y - Vector3.Dot(dir, dir)));
                    case 3: return -Mathf.Sqrt(35.0f / 2.0f / Mathf.PI) * 3.0f / 4.0f * dir.z * dir.y * (dir.z * dir.z - 3.0f * dir.x * dir.x);
                    case 4: return Mathf.Sqrt(35.0f / Mathf.PI) * 3.0f / 16.0f * ((dir.z * dir.z) * ((dir.z * dir.z) - 3.0f * (dir.x * dir.x)) - (dir.x * dir.x) * (3.0f * (dir.z * dir.z) - (dir.x * dir.x)));
                }
            }
            //---------------------------------- ORDER 5 ----------------------------------
            if (l == 5)
            {
                float phi = Mathf.Atan2(dir.y, dir.x);
                float sinTheta = Mathf.Sqrt(1.0f - dir.z * dir.z);

                switch(m)
                {
                    case -5: return (3f / 32f) * Mathf.Sqrt(77f / Mathf.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * Mathf.Sin(-5f * phi);
                    case -4: return (3f / 16f) * Mathf.Sqrt(385f / (2f * Mathf.PI)) * (sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * Mathf.Cos(-4f * phi);
                    case -3: return (1f / 32f) * Mathf.Sqrt(385f / Mathf.PI) * (sinTheta * sinTheta * sinTheta) * (9f * dir.z * dir.z - 1f) * Mathf.Sin(-3f * phi);
                    case -2: return (1f / 8f) * Mathf.Sqrt(1155f / (2f * Mathf.PI)) * (sinTheta * sinTheta) * (3f * dir.z * dir.z * dir.z - dir.z) * Mathf.Cos(-2f * phi);
                    case -1: return (1f / 16f) * Mathf.Sqrt(165f / (2f * Mathf.PI)) * sinTheta * (21f * dir.z * dir.z * dir.z * dir.z - 14f * dir.z * dir.z + 1f) * Mathf.Sin(-1f * phi);
                    case 0: return (1f / 16f) * Mathf.Sqrt(11f / Mathf.PI) * (63f * dir.z * dir.z * dir.z * dir.z * dir.z - 70f * dir.z * dir.z * dir.z + 15f * dir.z);
                    case 1: return -(1f / 16f) * Mathf.Sqrt(165f / (2f * Mathf.PI)) * sinTheta * (21f * dir.z * dir.z * dir.z * dir.z - 14f * dir.z * dir.z + 1f) * Mathf.Cos(phi);
                    case 2: return (1f / 8f) * Mathf.Sqrt(1155f / (2f * Mathf.PI)) * (sinTheta * sinTheta) * (3f * dir.z * dir.z * dir.z - dir.z) * Mathf.Sin(2f * phi);
                    case 3: return -(1f / 32f) * Mathf.Sqrt(385f / Mathf.PI) * (sinTheta * sinTheta * sinTheta) * (9f * dir.z * dir.z - 1f) * Mathf.Cos(3f * phi);
                    case 4: return (3f / 16f) * Mathf.Sqrt(385f / (2f * Mathf.PI)) * (sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * Mathf.Sin(4f * phi);
                    case 5: return -(3f / 32f) * Mathf.Sqrt(77f / Mathf.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * Mathf.Cos(5f * phi);
                }
            }
            //---------------------------------- ORDER 6 ----------------------------------
            if (l == 6)
            {
                float phi = Mathf.Atan2(dir.y, dir.x);
                float sinTheta = Mathf.Sqrt(1.0f - dir.z * dir.z);

                switch(m)
                {
                    case -6: return (1f / 64f) * Mathf.Sqrt(3003f / Mathf.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * Mathf.Sin(-6f * phi);
                    case -5: return (3f / 32f) * Mathf.Sqrt(1001f / Mathf.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * Mathf.Cos(-5f * phi);
                    case -4: return (3f / 32f) * Mathf.Sqrt(91f / (2f * Mathf.PI)) * (sinTheta * sinTheta * sinTheta * sinTheta) * (11f * dir.z * dir.z - 1f) * Mathf.Sin(-4f * phi);
                    case -3: return (1f / 32f) * Mathf.Sqrt(1365f / Mathf.PI) * (sinTheta * sinTheta * sinTheta) * (11f * dir.z * dir.z * dir.z - 3f * dir.z) * Mathf.Cos(-3f * phi);
                    case -2: return (1f / 64f) * Mathf.Sqrt(1365f / Mathf.PI) * (sinTheta * sinTheta) * (33f * dir.z * dir.z * dir.z * dir.z - 18f * dir.z * dir.z + 1f) * Mathf.Sin(-2f * phi);
                    case -1: return (1f / 16f) * Mathf.Sqrt(273f / (2f * Mathf.PI)) * sinTheta * (33f * dir.z * dir.z * dir.z * dir.z * dir.z - 30f * dir.z * dir.z * dir.z + 5f * dir.z) * Mathf.Cos(-1f * phi);
                    case 0: return (1f / 32f) * Mathf.Sqrt(13f / Mathf.PI) * (231f * dir.z * dir.z * dir.z * dir.z * dir.z * dir.z - 315f * dir.z * dir.z * dir.z * dir.z + 105f * dir.z * dir.z - 5f);
                    case 1: return -(1f / 16f) * Mathf.Sqrt(273f / (2f * Mathf.PI)) * sinTheta * (33f * dir.z * dir.z * dir.z * dir.z * dir.z - 30f * dir.z * dir.z * dir.z + 5f * dir.z) * Mathf.Sin(phi);
                    case 2: return (1f / 64f) * Mathf.Sqrt(1365f / Mathf.PI) * (sinTheta * sinTheta) * (33f * dir.z * dir.z * dir.z * dir.z - 18f * dir.z * dir.z + 1f) * Mathf.Cos(2f * phi);
                    case 3: return -(1f / 32f) * Mathf.Sqrt(1365f / Mathf.PI) * (sinTheta * sinTheta * sinTheta) * (11f * dir.z * dir.z * dir.z - 3f * dir.z) * Mathf.Sin(3f * phi);
                    case 4: return (3f / 32f) * Mathf.Sqrt(91f / (2f * Mathf.PI)) * (sinTheta * sinTheta * sinTheta * sinTheta) * (11f * dir.z * dir.z - 1f) * Mathf.Cos(4f * phi);
                    case 5: return -(3f / 32f) * Mathf.Sqrt(1001f / Mathf.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * Mathf.Sin(5f * phi);
                    case 6: return (1f / 64f) * Mathf.Sqrt(3003f / Mathf.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * Mathf.Cos(6f * phi);
                }
            }

            //anything past 6 orders is not supported.
            return 0f;
        }







































        /// <summary>
        /// Evaluate the spherical harmonic basis function given l, m, and a direction vector up to 6 orders.
        /// <para>NOTE: This is much faster since terms are precomputed, results are identical to the non-precomputed version.</para>
        /// </summary>
        /// <param name="l"></param>
        /// <param name="m"></param>
        /// <param name="dir"></param>
        /// <returns></returns>
        public static double EvaluatePrecomputedBasisFunctionDouble(int l, int m, Vector3 dir)
        {
            //---------------------------------- ORDER 0 ----------------------------------
            if (l == 0 && m == 0)
                return 0.282094791773878;
            //---------------------------------- ORDER 1 ----------------------------------
            if (l == 1)
            {
                switch (m)
                {
                    case -1: return 0.48860251190292 * dir.y;
                    case 0: return 0.48860251190292 * dir.z;
                    case 1: return 0.48860251190292 * dir.x;
                }
            }
            //---------------------------------- ORDER 2 ----------------------------------
            if (l == 2)
            {
                switch (m)
                {
                    case -2: return 1.09254843059208 * dir.x * dir.y;
                    case -1: return 1.09254843059208 * dir.y * dir.z;
                    case 0: return 0.31539156525252 * (3 * dir.z * dir.z - 1);
                    case 1: return 1.09254843059208 * dir.x * dir.z;
                    case 2: return 0.54627421529604 * (dir.x * dir.x - dir.y * dir.y);
                }
            }
            //---------------------------------- ORDER 3 ----------------------------------
            if (l == 3)
            {
                switch (m)
                {
                    case -3: return 0.590043589926643 * dir.y * (3 * dir.x * dir.x - dir.y * dir.y);
                    case -2: return 2.89061144264055 * dir.x * dir.y * dir.z;
                    case -1: return 0.457045799464466 * dir.y * (4 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y);
                    case 0: return 0.373176332590115 * (dir.z * (2 * dir.z * dir.z - 3 * dir.x * dir.x - 3 * dir.y * dir.y));
                    case 1: return 0.457045799464466 * dir.x * (4 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y);
                    case 2: return 1.44530572132028 * dir.z * (dir.x * dir.x - dir.y * dir.y);
                    case 3: return 0.590043589926643 * dir.x * (dir.x * dir.x - 3 * dir.y * dir.y);
                }
            }
            //---------------------------------- ORDER 4 ----------------------------------
            if (l == 4)
            {
                float dirDot = Vector3.Dot(dir, dir);

                switch (m)
                {
                    case -4: return 2.5033429417967 * (dir.z * dir.x * (dir.z * dir.z - dir.x * dir.x));
                    case -3: return -1.74465993438048 * (3.0 * dir.z * dir.z - dir.x * dir.x) * dir.x * dir.y;
                    case -2: return 0.94617469575756 * (dir.z * dir.x * (7.0 * dir.y * dir.y - dirDot));
                    case -1: return -0.598413420602149 * (dir.y * dir.x * (7.0 * dir.y * dir.y - 3.0 * dirDot));
                    case 0: return 0.105785546915204 * (35.0 * (dir.y * dir.y) * (dir.y * dir.y) - 30.0 * (dir.y * dir.y) + 3.0);
                    case 1: return -0.598413420602149 * (dir.y * dir.z * (7.0 * dir.y * dir.y - 3.0 * dirDot));
                    case 2: return 0.47308734787878 * ((dir.z * dir.z - dir.x * dir.x) * (7.0 * dir.y * dir.y - dirDot));
                    case 3: return -1.74465993438048 * dir.z * dir.y * (dir.z * dir.z - 3.0 * dir.x * dir.x);
                    case 4: return 0.625835735449176 * ((dir.z * dir.z) * ((dir.z * dir.z) - 3.0 * (dir.x * dir.x)) - (dir.x * dir.x) * (3.0 * (dir.z * dir.z) - (dir.x * dir.x)));
                }
            }
            //---------------------------------- ORDER 5 ----------------------------------
            if (l == 5)
            {
                double phi = System.Math.Atan2(dir.y, dir.x);
                double sinTheta = System.Math.Sqrt(1.0 - dir.z * dir.z);

                switch (m)
                {
                    case -5: return 0.464132203440858 * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * System.Math.Sin(-5 * phi);
                    case -4: return 1.46771489830575 * (sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * System.Math.Cos(-4 * phi);
                    case -3: return 0.34594371914684 * (sinTheta * sinTheta * sinTheta) * (9 * dir.z * dir.z - 1) * System.Math.Sin(-3 * phi);
                    case -2: return 1.6947711832609 * (sinTheta * sinTheta) * (3 * dir.z * dir.z * dir.z - dir.z) * System.Math.Cos(-2 * phi);
                    case -1: return 0.320281648576215 * sinTheta * (21 * dir.z * dir.z * dir.z * dir.z - 14 * dir.z * dir.z + 1) * System.Math.Sin(-1 * phi);
                    case 0: return 0.116950322453424 * (63 * dir.z * dir.z * dir.z * dir.z * dir.z - 70 * dir.z * dir.z * dir.z + 15 * dir.z);
                    case 1: return -0.320281648576215 * sinTheta * (21 * dir.z * dir.z * dir.z * dir.z - 14 * dir.z * dir.z + 1) * System.Math.Cos(phi);
                    case 2: return 1.6947711832609 * (sinTheta * sinTheta) * (3 * dir.z * dir.z * dir.z - dir.z) * System.Math.Sin(2 * phi);
                    case 3: return -0.34594371914684 * (sinTheta * sinTheta * sinTheta) * (9 * dir.z * dir.z - 1) * System.Math.Cos(3 * phi);
                    case 4: return 1.46771489830575 * (sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * System.Math.Sin(4 * phi);
                    case 5: return -0.464132203440858 * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * System.Math.Cos(5 * phi);
                }
            }
            //---------------------------------- ORDER 6 ----------------------------------
            if (l == 6)
            {
                double phi = System.Math.Atan2(dir.y, dir.x);
                double sinTheta = System.Math.Sqrt(1.0 - dir.z * dir.z);

                switch (m)
                {
                    case -6: return 0.483084113580066 * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * System.Math.Sin(-6 * phi);
                    case -5: return 1.6734524581001 * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * System.Math.Cos(-5 * phi);
                    case -4: return 0.356781262853998 * (sinTheta * sinTheta * sinTheta * sinTheta) * (11 * dir.z * dir.z - 1) * System.Math.Sin(-4 * phi);
                    case -3: return 0.651390485867716 * (sinTheta * sinTheta * sinTheta) * (11 * dir.z * dir.z * dir.z - 3 * dir.z) * System.Math.Cos(-3 * phi);
                    case -2: return 0.325695242933858 * (sinTheta * sinTheta) * (33 * dir.z * dir.z * dir.z * dir.z - 18 * dir.z * dir.z + 1) * System.Math.Sin(-2 * phi);
                    case -1: return 0.411975516301141 * sinTheta * (33 * dir.z * dir.z * dir.z * dir.z * dir.z - 30 * dir.z * dir.z * dir.z + 5 * dir.z) * System.Math.Cos(-1 * phi);
                    case 0: return 0.0635692022676284 * (231 * dir.z * dir.z * dir.z * dir.z * dir.z * dir.z - 315 * dir.z * dir.z * dir.z * dir.z + 105 * dir.z * dir.z - 5);
                    case 1: return -0.411975516301141 * sinTheta * (33 * dir.z * dir.z * dir.z * dir.z * dir.z - 30 * dir.z * dir.z * dir.z + 5 * dir.z) * System.Math.Sin(phi);
                    case 2: return 0.325695242933858 * (sinTheta * sinTheta) * (33 * dir.z * dir.z * dir.z * dir.z - 18 * dir.z * dir.z + 1) * System.Math.Cos(2 * phi);
                    case 3: return -0.651390485867716 * (sinTheta * sinTheta * sinTheta) * (11 * dir.z * dir.z * dir.z - 3 * dir.z) * System.Math.Sin(3 * phi);
                    case 4: return 0.356781262853998 * (sinTheta * sinTheta * sinTheta * sinTheta) * (11 * dir.z * dir.z - 1) * System.Math.Cos(4 * phi);
                    case 5: return -1.6734524581001 * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * System.Math.Sin(5 * phi);
                    case 6: return 0.483084113580066 * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * System.Math.Cos(6 * phi);
                }
            }

            //anything past 6 orders is not supported.
            return 0;
        }

        /// <summary>
        /// Evaluate the spherical harmonic basis function given l, m, and a direction vector up to 6 orders.
        /// <para>NOTE: This is much slower since there are no precomputed terms.</para>
        /// </summary>
        /// <param name="l"></param>
        /// <param name="m"></param>
        /// <param name="dir"></param>
        /// <returns></returns>
        public static double EvaluateBasisFunctionDouble(int l, int m, Vector3 dir)
        {
            //---------------------------------- ORDER 0 ----------------------------------
            if (l == 0 && m == 0)
                return 0.5 * System.Math.Sqrt(1 / System.Math.PI);
            //---------------------------------- ORDER 1 ----------------------------------
            if (l == 1)
            {
                switch (m)
                {
                    case -1: return System.Math.Sqrt(3 / (4 * System.Math.PI)) * dir.y;
                    case 0: return System.Math.Sqrt(3 / (4 * System.Math.PI)) * dir.z;
                    case 1: return System.Math.Sqrt(3 / (4 * System.Math.PI)) * dir.x;
                }
            }
            //---------------------------------- ORDER 2 ----------------------------------
            if (l == 2)
            {
                switch (m)
                {
                    case -2: return 0.5 * System.Math.Sqrt(15 / System.Math.PI) * dir.x * dir.y;
                    case -1: return 0.5 * System.Math.Sqrt(15 / System.Math.PI) * dir.y * dir.z;
                    case 0: return 0.25 * System.Math.Sqrt(5 / System.Math.PI) * (3 * dir.z * dir.z - 1);
                    case 1: return 0.5 * System.Math.Sqrt(15 / System.Math.PI) * dir.x * dir.z;
                    case 2: return 0.25 * System.Math.Sqrt(15 / System.Math.PI) * (dir.x * dir.x - dir.y * dir.y);
                }
            }
            //---------------------------------- ORDER 3 ----------------------------------
            if (l == 3)
            {
                switch (m)
                {
                    case -3: return (0.25 * System.Math.Sqrt(7.0) * 1.0 / System.Math.Sqrt(System.Math.PI)) * (System.Math.Sqrt(5) / System.Math.Sqrt(2)) * dir.y * (3 * dir.x * dir.x - dir.y * dir.y);
                    case -2: return (0.25 * System.Math.Sqrt(7.0) * 1.0 / System.Math.Sqrt(System.Math.PI)) * 2.0 * System.Math.Sqrt(15) * dir.x * dir.y * dir.z;
                    case -1: return (0.25 * System.Math.Sqrt(7.0) * 1.0 / System.Math.Sqrt(System.Math.PI)) * (System.Math.Sqrt(3) / System.Math.Sqrt(2)) * dir.y * (4 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y);
                    case 0: return (0.25 * System.Math.Sqrt(7.0) * 1.0 / System.Math.Sqrt(System.Math.PI)) * (dir.z * (2 * dir.z * dir.z - 3 * dir.x * dir.x - 3 * dir.y * dir.y));
                    case 1: return (0.25 * System.Math.Sqrt(7.0) * 1.0 / System.Math.Sqrt(System.Math.PI)) * (System.Math.Sqrt(3) / System.Math.Sqrt(2)) * dir.x * (4 * dir.z * dir.z - dir.x * dir.x - dir.y * dir.y);
                    case 2: return (0.25 * System.Math.Sqrt(7.0) * 1.0 / System.Math.Sqrt(System.Math.PI)) * System.Math.Sqrt(15) * dir.z * (dir.x * dir.x - dir.y * dir.y);
                    case 3: return (0.25 * System.Math.Sqrt(7.0) * 1.0 / System.Math.Sqrt(System.Math.PI)) * (System.Math.Sqrt(5) / System.Math.Sqrt(2)) * dir.x * (dir.x * dir.x - 3 * dir.y * dir.y);
                }
            }
            //---------------------------------- ORDER 4 ----------------------------------
            if (l == 4)
            {
                switch (m)
                {
                    case -4: return System.Math.Sqrt(35.0 / System.Math.PI) * 3.0 / 4.0 * (dir.z * dir.x * (dir.z * dir.z - dir.x * dir.x));
                    case -3: return -System.Math.Sqrt(35.0 / 2.0 / System.Math.PI) * 3.0 / 4.0 * (3.0 * dir.z * dir.z - dir.x * dir.x) * dir.x * dir.y;
                    case -2: return System.Math.Sqrt(5.0 / System.Math.PI) * 3.0 / 4.0 * (dir.z * dir.x * (7.0 * dir.y * dir.y - Vector3.Dot(dir, dir)));
                    case -1: return -System.Math.Sqrt(5.0 / 2.0 / System.Math.PI) * 3.0 / 4.0 * (dir.y * dir.x * (7.0 * dir.y * dir.y - 3.0 * Vector3.Dot(dir, dir)));
                    case 0: return System.Math.Sqrt(1 / System.Math.PI) * 3.0 / 16.0 * (35.0 * (dir.y * dir.y) * (dir.y * dir.y) - 30.0 * (dir.y * dir.y) + 3.0);
                    case 1: return -System.Math.Sqrt(5.0 / 2.0 / System.Math.PI) * 3.0 / 4.0 * (dir.y * dir.z * (7.0 * dir.y * dir.y - 3.0 * Vector3.Dot(dir, dir)));
                    case 2: return System.Math.Sqrt(5.0 / System.Math.PI) * 3.0 / 8.0 * ((dir.z * dir.z - dir.x * dir.x) * (7.0 * dir.y * dir.y - Vector3.Dot(dir, dir)));
                    case 3: return -System.Math.Sqrt(35.0 / 2.0 / System.Math.PI) * 3.0 / 4.0 * dir.z * dir.y * (dir.z * dir.z - 3.0 * dir.x * dir.x);
                    case 4: return System.Math.Sqrt(35.0 / System.Math.PI) * 3.0 / 16.0 * ((dir.z * dir.z) * ((dir.z * dir.z) - 3.0 * (dir.x * dir.x)) - (dir.x * dir.x) * (3.0 * (dir.z * dir.z) - (dir.x * dir.x)));
                }
            }
            //---------------------------------- ORDER 5 ----------------------------------
            if (l == 5)
            {
                double phi = System.Math.Atan2(dir.y, dir.x);
                double sinTheta = System.Math.Sqrt(1.0 - dir.z * dir.z);

                switch (m)
                {
                    case -5: return (3 / 32) * System.Math.Sqrt(77 / System.Math.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * System.Math.Sin(-5 * phi);
                    case -4: return (3 / 16) * System.Math.Sqrt(385 / (2 * System.Math.PI)) * (sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * System.Math.Cos(-4 * phi);
                    case -3: return (1 / 32) * System.Math.Sqrt(385 / System.Math.PI) * (sinTheta * sinTheta * sinTheta) * (9 * dir.z * dir.z - 1) * System.Math.Sin(-3 * phi);
                    case -2: return (1 / 8) * System.Math.Sqrt(1155 / (2 * System.Math.PI)) * (sinTheta * sinTheta) * (3 * dir.z * dir.z * dir.z - dir.z) * System.Math.Cos(-2 * phi);
                    case -1: return (1 / 16) * System.Math.Sqrt(165 / (2 * System.Math.PI)) * sinTheta * (21 * dir.z * dir.z * dir.z * dir.z - 14 * dir.z * dir.z + 1) * System.Math.Sin(-1 * phi);
                    case 0: return (1 / 16) * System.Math.Sqrt(11 / System.Math.PI) * (63 * dir.z * dir.z * dir.z * dir.z * dir.z - 70 * dir.z * dir.z * dir.z + 15 * dir.z);
                    case 1: return -(1 / 16) * System.Math.Sqrt(165 / (2 * System.Math.PI)) * sinTheta * (21 * dir.z * dir.z * dir.z * dir.z - 14 * dir.z * dir.z + 1) * System.Math.Cos(phi);
                    case 2: return (1 / 8) * System.Math.Sqrt(1155 / (2 * System.Math.PI)) * (sinTheta * sinTheta) * (3 * dir.z * dir.z * dir.z - dir.z) * System.Math.Sin(2 * phi);
                    case 3: return -(1 / 32) * System.Math.Sqrt(385 / System.Math.PI) * (sinTheta * sinTheta * sinTheta) * (9 * dir.z * dir.z - 1) * System.Math.Cos(3 * phi);
                    case 4: return (3 / 16) * System.Math.Sqrt(385 / (2 * System.Math.PI)) * (sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * System.Math.Sin(4 * phi);
                    case 5: return -(3 / 32) * System.Math.Sqrt(77 / System.Math.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * System.Math.Cos(5 * phi);
                }
            }
            //---------------------------------- ORDER 6 ----------------------------------
            if (l == 6)
            {
                double phi = System.Math.Atan2(dir.y, dir.x);
                double sinTheta = System.Math.Sqrt(1.0f - dir.z * dir.z);

                switch (m)
                {
                    case -6: return (1 / 64) * System.Math.Sqrt(3003 / System.Math.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * System.Math.Sin(-6 * phi);
                    case -5: return (3 / 32) * System.Math.Sqrt(1001 / System.Math.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * System.Math.Cos(-5 * phi);
                    case -4: return (3 / 32) * System.Math.Sqrt(91 / (2 * System.Math.PI)) * (sinTheta * sinTheta * sinTheta * sinTheta) * (11 * dir.z * dir.z - 1) * System.Math.Sin(-4 * phi);
                    case -3: return (1 / 32) * System.Math.Sqrt(1365 / System.Math.PI) * (sinTheta * sinTheta * sinTheta) * (11 * dir.z * dir.z * dir.z - 3 * dir.z) * System.Math.Cos(-3 * phi);
                    case -2: return (1 / 64) * System.Math.Sqrt(1365 / System.Math.PI) * (sinTheta * sinTheta) * (33 * dir.z * dir.z * dir.z * dir.z - 18 * dir.z * dir.z + 1f) * System.Math.Sin(-2 * phi);
                    case -1: return (1 / 16) * System.Math.Sqrt(273 / (2 * System.Math.PI)) * sinTheta * (33 * dir.z * dir.z * dir.z * dir.z * dir.z - 30 * dir.z * dir.z * dir.z + 5 * dir.z) * System.Math.Cos(-1 * phi);
                    case 0: return (1 / 32) * System.Math.Sqrt(13 / System.Math.PI) * (231 * dir.z * dir.z * dir.z * dir.z * dir.z * dir.z - 315 * dir.z * dir.z * dir.z * dir.z + 105 * dir.z * dir.z - 5);
                    case 1: return -(1 / 16) * System.Math.Sqrt(273 / (2 * System.Math.PI)) * sinTheta * (33 * dir.z * dir.z * dir.z * dir.z * dir.z - 30 * dir.z * dir.z * dir.z + 5 * dir.z) * System.Math.Sin(phi);
                    case 2: return (1 / 64) * System.Math.Sqrt(1365 / System.Math.PI) * (sinTheta * sinTheta) * (33 * dir.z * dir.z * dir.z * dir.z - 18 * dir.z * dir.z + 1) * System.Math.Cos(2 * phi);
                    case 3: return -(1 / 32) * System.Math.Sqrt(1365 / System.Math.PI) * (sinTheta * sinTheta * sinTheta) * (11 * dir.z * dir.z * dir.z - 3 * dir.z) * System.Math.Sin(3 * phi);
                    case 4: return (3 / 32) * System.Math.Sqrt(91 / (2 * System.Math.PI)) * (sinTheta * sinTheta * sinTheta * sinTheta) * (11 * dir.z * dir.z - 1) * System.Math.Cos(4 * phi);
                    case 5: return -(3 / 32) * System.Math.Sqrt(1001 / System.Math.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * dir.z * System.Math.Sin(5 * phi);
                    case 6: return (1 / 64) * System.Math.Sqrt(3003 / System.Math.PI) * (sinTheta * sinTheta * sinTheta * sinTheta * sinTheta * sinTheta) * System.Math.Cos(6 * phi);
                }
            }

            //anything past 6 orders is not supported.
            return 0f;
        }
    }
}