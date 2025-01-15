using System.Collections;
using System.Collections.Generic;

using UnityEngine;
using UnityEditor;

using SphericalHarmonicIBL;

public class SphericalHarmonicLookupTableGenerator
{
    //NOTE 1: Lookup table can be stored as single channel
    //NOTE 2: As for wether it need sto be stored as a float, half, or 8 bit is still to be determined...
    //NOTE 3: Would like to experiment with the math/technique and see how this fairs with tetrahedral cubemap rendering (only 4 faces)
    //NOTE 4: Generate and experiment with 1 order SH lookup table (4 coefficents), and higher orders

    //double resolution lookup table
    //lookupTableRes = 1024x1024
    //input cubemap face = 128x128
    //1024 / 128 = 8 faces per cubemap

    //reset lookup table
    //lookupTableRes = 512x512
    //input cubemap face = 64x64
    //512 / 64 = 8 faces per cubemap

    //halved resolution lookup table
    //lookupTableRes = 256x256
    //input cubemap face = 32x32
    //256 / 32 = 8 faces per cubemap

    //quarter resolution lookup table
    //lookupTableRes = 128x128
    //input cubemap face = 16x16
    //128 / 16 = 8 faces per cubemap
    public static void GenerateSphericalHarmonicBasisLookupTable_Order2_512x512(string assetPath)
    {
        int lookupTableSquareResolution = 512;
        int inputCubemapSquareResolution = 64;

        Texture2D lookupTexture = new Texture2D(lookupTableSquareResolution, lookupTableSquareResolution, TextureFormat.RGBAFloat, false);
        lookupTexture.filterMode = FilterMode.Point;
        lookupTexture.wrapMode = TextureWrapMode.Clamp;

        int cubemapSquaresPerSlice = lookupTableSquareResolution / inputCubemapSquareResolution;
        int cubemapFaceIndex = -1;
        int sphericalHarmonicBasisIndex = -1;

        float invResolution = 1.0f / lookupTableSquareResolution; // Precompute inverse resolution

        for (int x = 0; x < lookupTableSquareResolution; x++)
        {
            for (int y = 0; y < lookupTableSquareResolution; y++)
            {
                Vector2Int uvInt = new Vector2Int(x, y);
                Vector2 uvNormalized = new Vector2((float)uvInt.x / (float)lookupTableSquareResolution, (float)uvInt.y / (float)lookupTableSquareResolution);

                uvNormalized = new Vector2(uvNormalized.x, 1 - uvNormalized.y);

                Vector2 uvSquare = new Vector2(uvNormalized.x * cubemapSquaresPerSlice, uvNormalized.y * cubemapSquaresPerSlice);
                Vector2Int uvSquareInt = new Vector2Int((int)uvSquare.x, (int)uvSquare.y);
                Vector2 uvSquareNormalized = new Vector2(Frac(uvNormalized.x * cubemapSquaresPerSlice), Frac(uvNormalized.y * cubemapSquaresPerSlice));

                int totalSquareIndex = uvSquareInt.x + (uvSquareInt.y * cubemapSquaresPerSlice);

                cubemapFaceIndex = totalSquareIndex / 9;
                sphericalHarmonicBasisIndex = (int)Mathf.Repeat(totalSquareIndex, 9);

                Color newColor = Color.black;

                Vector3 direction = CubemapUVToDirection(uvSquareNormalized, cubemapFaceIndex);

                if (cubemapFaceIndex >= 0 && cubemapFaceIndex < 6)
                {
                    double sphericalHarmonicBasis = GatherSphericalHarmonicBasis(sphericalHarmonicBasisIndex, direction);

                    float d_omega = SphericalHarmonicsUtility.DifferentialSolidAngle(inputCubemapSquareResolution, uvSquareNormalized.x, uvSquareNormalized.y);
                    d_omega *= inputCubemapSquareResolution * inputCubemapSquareResolution;

                    newColor = ColorRGBFromFloat((float)(sphericalHarmonicBasis * d_omega), 1.0f);
                }

                newColor.a = 1.0f;

                lookupTexture.SetPixel(x, y, newColor);
            }
        }

        lookupTexture.Apply();

        if (AssetDatabase.LoadAssetAtPath<Texture2D>(assetPath) != null)
            AssetDatabase.DeleteAsset(assetPath);

        AssetDatabase.CreateAsset(lookupTexture, assetPath);
    }

    public static void GenerateAndApplySphericalHarmonicBasisLookupTable_Order2_512x512(string assetPath, Cubemap cubemap, out Vector3[] radianceCoefficents)
    {
        int lookupTableSquareResolution = 512;
        int inputCubemapSquareResolution = 64;

        Texture2D lookupTexture = new Texture2D(lookupTableSquareResolution, lookupTableSquareResolution, TextureFormat.RGBAFloat, true);
        lookupTexture.filterMode = FilterMode.Point;
        lookupTexture.wrapMode = TextureWrapMode.Clamp;

        int cubemapSquaresPerSlice = lookupTableSquareResolution / inputCubemapSquareResolution;
        int cubemapFaceIndex = -1;
        int sphericalHarmonicBasisIndex = -1;

        float invResolution = 1.0f / lookupTableSquareResolution; // Precompute inverse resolution

        for (int x = 0; x < lookupTableSquareResolution; x++)
        {
            for(int y = 0; y < lookupTableSquareResolution; y++)
            {
                Vector2Int uvInt = new Vector2Int(x, y);
                Vector2 uvNormalized = new Vector2((float)uvInt.x / (float)lookupTableSquareResolution, (float)uvInt.y / (float)lookupTableSquareResolution);

                uvNormalized = new Vector2(uvNormalized.x, 1 - uvNormalized.y);

                Vector2 uvSquare = new Vector2(uvNormalized.x * cubemapSquaresPerSlice, uvNormalized.y * cubemapSquaresPerSlice);
                Vector2Int uvSquareInt = new Vector2Int((int)uvSquare.x, (int)uvSquare.y);
                Vector2 uvSquareNormalized = new Vector2(Frac(uvNormalized.x * cubemapSquaresPerSlice), Frac(uvNormalized.y * cubemapSquaresPerSlice));

                Vector2Int uvSquareCubemapInt = new Vector2Int((int)(uvSquareNormalized.x * cubemap.width), (int)(uvSquareNormalized.y * cubemap.height));

                int totalSquareIndex = uvSquareInt.x + (uvSquareInt.y * cubemapSquaresPerSlice);

                cubemapFaceIndex = totalSquareIndex / 9;
                sphericalHarmonicBasisIndex = (int)Mathf.Repeat(totalSquareIndex, 9);

                Color newColor = Color.black;

                Vector3 direction = CubemapUVToDirection(uvSquareNormalized, cubemapFaceIndex);

                if (cubemapFaceIndex >= 0 && cubemapFaceIndex < 6)
                {
                    double sphericalHarmonicBasis = GatherSphericalHarmonicBasis(sphericalHarmonicBasisIndex, direction);

                    Color cubemapColor = cubemap.GetPixel((CubemapFace)cubemapFaceIndex, uvSquareCubemapInt.x, uvSquareCubemapInt.y, 0);
                    //cubemapColor.r = Mathf.LinearToGammaSpace(cubemapColor.r);
                    //cubemapColor.g = Mathf.LinearToGammaSpace(cubemapColor.g);
                    //cubemapColor.b = Mathf.LinearToGammaSpace(cubemapColor.b);

                    float d_omega = SphericalHarmonicsUtility.DifferentialSolidAngle(cubemap.width, uvSquareNormalized.x, uvSquareNormalized.y);
                    d_omega *= cubemap.width * cubemap.width;

                    newColor = cubemapColor * ColorRGBFromFloat((float)(sphericalHarmonicBasis * d_omega), 1.0f);
                }

                newColor.a = 1.0f;

                lookupTexture.SetPixel(x, y, newColor);
            }
        }

        lookupTexture.Apply(true);





        int mipLevelCubemapFaceIndex = -1;
        int mipLevelSphericalHarmonicBasisIndex = -1;

        Vector3 sphericalHarmonicBasis0 = Vector3.zero;
        Vector3 sphericalHarmonicBasis1 = Vector3.zero;
        Vector3 sphericalHarmonicBasis2 = Vector3.zero;
        Vector3 sphericalHarmonicBasis3 = Vector3.zero;
        Vector3 sphericalHarmonicBasis4 = Vector3.zero;
        Vector3 sphericalHarmonicBasis5 = Vector3.zero;
        Vector3 sphericalHarmonicBasis6 = Vector3.zero;
        Vector3 sphericalHarmonicBasis7 = Vector3.zero;
        Vector3 sphericalHarmonicBasis8 = Vector3.zero;

        /*
        Texture2D mipLevelExport = new Texture2D(8, 8, TextureFormat.RGBAFloat, false);
        mipLevelExport.filterMode = FilterMode.Point;
        mipLevelExport.wrapMode = TextureWrapMode.Clamp;

        for (int x = 0; x < 8; x++)
        {
            for(int y = 0; y < 8; y++)
            {
                Color mipColor = lookupTexture.GetPixel(x, y, 6);
                Vector3 mipColorVector = Vector3FromColorRGB(mipColor);

                int totalSquareIndex = x + (y * 8);

                mipLevelCubemapFaceIndex = totalSquareIndex / 9;
                mipLevelSphericalHarmonicBasisIndex = (int)Mathf.Repeat(totalSquareIndex, 9);

                if(mipLevelCubemapFaceIndex >= 0 && mipLevelCubemapFaceIndex < 6)
                {
                    if (mipLevelSphericalHarmonicBasisIndex == 0)
                        sphericalHarmonicBasis0 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 1)
                        sphericalHarmonicBasis1 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 2)
                        sphericalHarmonicBasis2 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 3)
                        sphericalHarmonicBasis3 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 4)
                        sphericalHarmonicBasis4 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 5)
                        sphericalHarmonicBasis5 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 6)
                        sphericalHarmonicBasis6 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 7)
                        sphericalHarmonicBasis7 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 8)
                        sphericalHarmonicBasis8 += mipColorVector;
                }

                mipLevelExport.SetPixel(x, y, mipColor);
            }
        }

        mipLevelExport.Apply();

        if (AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/SphericalHarmonicsMipLevelExport.asset") != null)
            AssetDatabase.DeleteAsset("Assets/SphericalHarmonicsMipLevelExport.asset");

        AssetDatabase.CreateAsset(mipLevelExport, "Assets/SphericalHarmonicsMipLevelExport.asset");
        */

        for (int x = 0; x < lookupTexture.width; x++)
        {
            for (int y = 0; y < lookupTexture.height; y++)
            {
                Vector2Int uvInt = new Vector2Int(x, y);
                Vector2 uvNormalized = new Vector2((float)uvInt.x / (float)lookupTableSquareResolution, (float)uvInt.y / (float)lookupTableSquareResolution);

                uvNormalized = new Vector2(uvNormalized.x, 1 - uvNormalized.y);

                Vector2 uvSquare = new Vector2(uvNormalized.x * cubemapSquaresPerSlice, uvNormalized.y * cubemapSquaresPerSlice);
                Vector2Int uvSquareInt = new Vector2Int((int)uvSquare.x, (int)uvSquare.y);

                int totalSquareIndex = uvSquareInt.x + (uvSquareInt.y * cubemapSquaresPerSlice);

                mipLevelCubemapFaceIndex = totalSquareIndex / 9;
                mipLevelSphericalHarmonicBasisIndex = (int)Mathf.Repeat(totalSquareIndex, 9);

                Color color = lookupTexture.GetPixel(x, y, 0);
                Vector3 mipColorVector = Vector3FromColorRGB(color);

                if (mipLevelCubemapFaceIndex >= 0 && mipLevelCubemapFaceIndex < 6)
                {
                    if (mipLevelSphericalHarmonicBasisIndex == 0)
                        sphericalHarmonicBasis0 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 1)
                        sphericalHarmonicBasis1 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 2)
                        sphericalHarmonicBasis2 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 3)
                        sphericalHarmonicBasis3 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 4)
                        sphericalHarmonicBasis4 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 5)
                        sphericalHarmonicBasis5 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 6)
                        sphericalHarmonicBasis6 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 7)
                        sphericalHarmonicBasis7 += mipColorVector;
                    else if (mipLevelSphericalHarmonicBasisIndex == 8)
                        sphericalHarmonicBasis8 += mipColorVector;
                }
            }
        }

        /*
        radianceCoefficents = new Vector3[9]
        {
            sphericalHarmonicBasis0,
            sphericalHarmonicBasis1,
            sphericalHarmonicBasis2,
            sphericalHarmonicBasis3,
            sphericalHarmonicBasis4,
            sphericalHarmonicBasis5,
            sphericalHarmonicBasis6,
            sphericalHarmonicBasis7,
            sphericalHarmonicBasis8
        };
        */

        //float term = 1.0f / 64.0f;
        float term = 1.0f / 512;
        //term *= 0.01f;
        //term *= 1.0f / Mathf.PI * 4;

        ///*
        radianceCoefficents = new Vector3[9]
        {
            sphericalHarmonicBasis0 * term,
            sphericalHarmonicBasis1 * term,
            sphericalHarmonicBasis2 * term,
            sphericalHarmonicBasis3 * term,
            sphericalHarmonicBasis4 * term,
            sphericalHarmonicBasis5 * term,
            sphericalHarmonicBasis6 * term,
            sphericalHarmonicBasis7 * term,
            sphericalHarmonicBasis8 * term
        };
        //*/

        if (AssetDatabase.LoadAssetAtPath<Texture2D>(assetPath) != null)
            AssetDatabase.DeleteAsset(assetPath);

        AssetDatabase.CreateAsset(lookupTexture, assetPath);
    }

    private static double GatherSphericalHarmonicBasis(int index, Vector3 direction)
    {
        switch(index)
        {
            //============= ORDER 0 =============
            case 0:
                return SphericalHarmonicBasis.EvaluateBasisFunctionDouble(0, 0, direction);

            //============= ORDER 1 =============
            case 1:
                return SphericalHarmonicBasis.EvaluateBasisFunctionDouble(1, -1, direction);
            case 2:
                return SphericalHarmonicBasis.EvaluateBasisFunctionDouble(1, 0, direction);
            case 3:
                return SphericalHarmonicBasis.EvaluateBasisFunctionDouble(1, 1, direction);

            //============= ORDER 2 =============
            case 4:
                return SphericalHarmonicBasis.EvaluateBasisFunctionDouble(2, -2, direction);
            case 5:
                return SphericalHarmonicBasis.EvaluateBasisFunctionDouble(2, -1, direction);
            case 6:
                return SphericalHarmonicBasis.EvaluateBasisFunctionDouble(2, 0, direction);
            case 7:
                return SphericalHarmonicBasis.EvaluateBasisFunctionDouble(2, 1, direction);
            case 8:
                return SphericalHarmonicBasis.EvaluateBasisFunctionDouble(2, 2, direction);

            default:
                return 0.0f;
        }
    }

    private static Vector3 Vector3FromColorRGB(Color color)
    {
        return new Vector3(color.r, color.g, color.b);
    }

    private static Color ColorRGBFromFloat(float value, float alpha)
    {
        return new Color(value, value, value, alpha);
    }

    private static Color ColorFromVector3(Vector3 vector3, float alpha)
    {
        return new Color(vector3.x, vector3.y, vector3.z, alpha);
    }

    private static Vector3 CubemapUVToDirection(Vector2 uv, int faceIndex)
    {
        // Map UV coordinates from [0, 1] to [-1, 1]
        Vector2 uvSigned = uv * 2.0f - Vector2.one;

        switch(faceIndex)
        {
            case 0: // +X (Right)
                return new Vector3(1.0f, -uvSigned.y, -uvSigned.x).normalized;
            case 1: // -X (Left)
                return new Vector3(-1.0f, -uvSigned.y, uvSigned.x).normalized;
            case 2: // +Y (Top)
                return new Vector3(uvSigned.x, 1.0f, uvSigned.y).normalized;
            case 3: // -Y (Bottom)
                return new Vector3(uvSigned.x, -1.0f, -uvSigned.y).normalized;
            case 4: // +Z (Front)
                return new Vector3(uvSigned.x, -uvSigned.y, 1.0f).normalized;
            case 5: // -Z (Back)
                return new Vector3(-uvSigned.x, -uvSigned.y, -1.0f).normalized;
            default:
                return Vector3.zero;
        }
    }

    public static float Frac(float value)
    {
        return value - Mathf.Floor(value);
    }

    private static float Saturate(float value)
    {
        return Mathf.Clamp01(value);
    }

    // Assumes that (0 <= x <= Pi).
    private static float SinFromCos(float cosX)
    {
        return Mathf.Sqrt(Saturate(1 - cosX * cosX));
    }

    // Transforms the unit vector from the spherical to the Cartesian (right-handed, Z up) coordinate.
    private static Vector3 SphericalToCartesian(float cosPhi, float sinPhi, float cosTheta)
    {
        float sinTheta = SinFromCos(cosTheta);

        return new Vector3(cosPhi * sinTheta, sinPhi * sinTheta, cosTheta);
    }

    private static Vector3 SphericalToCartesian(float phi, float cosTheta)
    {
        float sinPhi = Mathf.Sin(phi);
        float cosPhi = Mathf.Cos(phi);

        return SphericalToCartesian(cosPhi, sinPhi, cosTheta);
    }

    //https://github.com/needle-mirror/com.unity.render-pipelines.core/blob/master/ShaderLibrary/Sampling/Sampling.hlsl
    // Converts Cartesian coordinates given in the right-handed coordinate system
    // with Z pointing upwards (OpenGL style) to the coordinates in the left-handed
    // coordinate system with Y pointing up and Z facing forward (DirectX style).
    private static Vector3 TransformGLtoDX(Vector3 v)
    {
        return new Vector3(v.x, v.z, v.y); //v.xzy
    }

    // Performs conversion from equiareal map coordinates to Cartesian (DirectX cubemap) ones.
    private static Vector3 ConvertEquiarealToCubemap(float u, float v)
    {
        float phi = (Mathf.PI * 2.0f) - (Mathf.PI * 2.0f) * u;
        float cosTheta = 1.0f - 2.0f * v;

        return TransformGLtoDX(SphericalToCartesian(phi, cosTheta));
    }

    // Convert a texel position into normalized position [-1..1]x[-1..1]
    private static Vector2 CubemapTexelToNVC(Vector2Int unPositionTXS, uint cubemapSize)
    {
        return 2.0f * new Vector2(unPositionTXS.x, unPositionTXS.y) / Mathf.Max(cubemapSize - 1, 1) - Vector2.one;
    }

    // Map cubemap face to world vector basis
    public static readonly Vector3[][] CUBEMAP_FACE_BASIS_MAPPING = new Vector3[][]
    {
        // XPOS face
        new Vector3[]
        {
            new Vector3(0.0f, 0.0f, -1.0f),
            new Vector3(0.0f, -1.0f, 0.0f),
            new Vector3(1.0f, 0.0f, 0.0f)
        },
        // XNEG face
        new Vector3[]
        {
            new Vector3(0.0f, 0.0f, 1.0f),
            new Vector3(0.0f, -1.0f, 0.0f),
            new Vector3(-1.0f, 0.0f, 0.0f)
        },
        // YPOS face
        new Vector3[]
        {
            new Vector3(1.0f, 0.0f, 0.0f),
            new Vector3(0.0f, 0.0f, 1.0f),
            new Vector3(0.0f, 1.0f, 0.0f)
        },
        // YNEG face
        new Vector3[]
        {
            new Vector3(1.0f, 0.0f, 0.0f),
            new Vector3(0.0f, 0.0f, -1.0f),
            new Vector3(0.0f, -1.0f, 0.0f)
        },
        // ZPOS face
        new Vector3[]
        {
            new Vector3(1.0f, 0.0f, 0.0f),
            new Vector3(0.0f, -1.0f, 0.0f),
            new Vector3(0.0f, 0.0f, 1.0f)
        },
        // ZNEG face
        new Vector3[]
        {
            new Vector3(-1.0f, 0.0f, 0.0f),
            new Vector3(0.0f, -1.0f, 0.0f),
            new Vector3(0.0f, 0.0f, -1.0f)
        }
    };

    // Convert a normalized cubemap face position into a direction
    private static Vector3 CubemapTexelToDirection(Vector2 positionNVC, uint faceId)
    {
        Vector3 dir = CUBEMAP_FACE_BASIS_MAPPING[faceId][0] * positionNVC.x
                   + CUBEMAP_FACE_BASIS_MAPPING[faceId][1] * positionNVC.y
                   + CUBEMAP_FACE_BASIS_MAPPING[faceId][2];

        return dir.normalized;
    }
}
