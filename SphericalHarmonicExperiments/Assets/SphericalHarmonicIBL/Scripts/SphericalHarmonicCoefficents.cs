using SphericalHarmonicIBL;
using UnityEngine;

namespace SphericalHarmonicIBL
{
    public class SphericalHarmonicCoefficents : ScriptableObject
    {
        public CoefficentPrecision storedCoefficentPrecision;
        public Vector3[] coefficents;

        public void DebugPrintMinimumMaximums()
        {
            float mimimum = float.MaxValue;
            float maximum = float.MinValue;

            for (int i = 0; i < coefficents.Length; i++)
            {
                mimimum = Mathf.Min(mimimum, coefficents[i].x);
                mimimum = Mathf.Min(mimimum, coefficents[i].y);
                mimimum = Mathf.Min(mimimum, coefficents[i].z);

                maximum = Mathf.Max(maximum, coefficents[i].x);
                maximum = Mathf.Max(maximum, coefficents[i].y);
                maximum = Mathf.Max(maximum, coefficents[i].z);
            }

            Debug.Log(string.Format("[SphericalHarmonicCoefficents] Minimum Value: {0} | Maximum Value: | {1}", mimimum, maximum));
        }
    }
}