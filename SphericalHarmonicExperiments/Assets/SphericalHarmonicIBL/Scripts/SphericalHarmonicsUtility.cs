using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting.FullSerializer;
using UnityEngine;

namespace SphericalHarmonicIBL
{
    public static class SphericalHarmonicsUtility
    {
        public static Cubemap DownsampleCubemap(Cubemap source, int downsampleFactor)
        {
            Cubemap downsampledCubemap = new Cubemap(source.width >> downsampleFactor, source.format, false);

            Graphics.CopyTexture(source, (int)CubemapFace.PositiveX, downsampleFactor, downsampledCubemap, (int)CubemapFace.PositiveX, 0);
            Graphics.CopyTexture(source, (int)CubemapFace.NegativeX, downsampleFactor, downsampledCubemap, (int)CubemapFace.NegativeX, 0);
            Graphics.CopyTexture(source, (int)CubemapFace.PositiveY, downsampleFactor, downsampledCubemap, (int)CubemapFace.PositiveY, 0);
            Graphics.CopyTexture(source, (int)CubemapFace.NegativeY, downsampleFactor, downsampledCubemap, (int)CubemapFace.NegativeY, 0);
            Graphics.CopyTexture(source, (int)CubemapFace.PositiveZ, downsampleFactor, downsampledCubemap, (int)CubemapFace.PositiveZ, 0);
            Graphics.CopyTexture(source, (int)CubemapFace.NegativeZ, downsampleFactor, downsampledCubemap, (int)CubemapFace.NegativeZ, 0);

            return downsampledCubemap;
        }

        public static float DifferentialSolidAngle(int textureSize, float u, float v)
        {
            float inv = 1.0f / textureSize;
            float scaledU = 2.0f * (u + 0.5f * inv) - 1;
            float scaledV = 2.0f * (v + 0.5f * inv) - 1;
            float x0 = scaledU - inv;
            float y0 = scaledV - inv;
            float x1 = scaledU + inv;
            float y1 = scaledV + inv;

            float x0_y0 = Mathf.Atan2(x0 * y0, Mathf.Sqrt(x0 * x0 + y0 * y0 + 1));
            float x0_y1 = Mathf.Atan2(x0 * y1, Mathf.Sqrt(x0 * x0 + y1 * y1 + 1));
            float x1_y0 = Mathf.Atan2(x1 * y0, Mathf.Sqrt(x1 * x1 + y0 * y0 + 1));
            float x1_y1 = Mathf.Atan2(x1 * y1, Mathf.Sqrt(x1 * x1 + y1 * y1 + 1));

            return x0_y0 - x0_y1 - x1_y0 + x1_y1;
        }

        public static Vector3 DirectionFromCubemapTexel(int face, float u, float v)
        {
            switch (face)
            {
                case 0: //+X
                    return new Vector3(1.0f, v * -2.0f + 1.0f, u * -2.0f + 1.0f).normalized;
                case 1: //-X
                    return new Vector3(-1.0f, v * -2.0f + 1.0f, u * 2.0f - 1.0f).normalized;
                case 2: //+Y
                    return new Vector3(u * 2.0f - 1.0f, 1.0f, v * 2.0f - 1.0f).normalized;
                case 3: //-Y
                    return new Vector3(u * 2.0f - 1.0f, -1.0f, v * -2.0f + 1.0f).normalized;
                case 4: //+Z
                    return new Vector3(u * 2.0f - 1.0f, v * -2.0f + 1.0f, 1.0f).normalized;
                case 5: //-Z
                    return new Vector3(u * -2.0f + 1.0f, v * -2.0f + 1.0f, -1.0f).normalized;
                default:
                    return Vector3.zero;
            }
        }

        public static int FindFace(Vector3 direction)
        {
            int faceIndex = 0;
            float max = Mathf.Abs(direction.x);

            if (Mathf.Abs(direction.y) > max)
            {
                max = Mathf.Abs(direction.y);
                faceIndex = 2;
            }

            if (Mathf.Abs(direction.z) > max)
                faceIndex = 4;

            switch (faceIndex)
            {
                case 0:
                    if (direction.x < 0)
                        faceIndex = 1;
                    break;

                case 2:
                    if (direction.y < 0)
                        faceIndex = 3;
                    break;

                case 4:
                    if (direction.z < 0)
                        faceIndex = 5;
                    break;
            }

            return faceIndex;
        }

        public static int GetTexelIndexFromDirection(Vector3 direction, int cubemapResolution)
        {
            float u = 0;
            float v = 0;

            switch (FindFace(direction))
            {
                case 0:
                    direction.z /= direction.x;
                    direction.y /= direction.x;
                    u = (direction.z - 1.0f) * -0.5f;
                    v = (direction.y - 1.0f) * -0.5f;
                    break;

                case 1:
                    direction.z /= -direction.x;
                    direction.y /= -direction.x;
                    u = (direction.z + 1.0f) * 0.5f;
                    v = (direction.y - 1.0f) * -0.5f;
                    break;

                case 2:
                    direction.x /= direction.y;
                    direction.z /= direction.y;
                    u = (direction.x + 1.0f) * 0.5f;
                    v = (direction.z + 1.0f) * 0.5f;
                    break;

                case 3:
                    direction.x /= -direction.y;
                    direction.z /= -direction.y;
                    u = (direction.x + 1.0f) * 0.5f;
                    v = (direction.z - 1.0f) * -0.5f;
                    break;

                case 4:
                    direction.x /= direction.z;
                    direction.y /= direction.z;
                    u = (direction.x + 1.0f) * 0.5f;
                    v = (direction.y - 1.0f) * -0.5f;
                    break;

                case 5:
                    direction.x /= -direction.z;
                    direction.y /= -direction.z;
                    u = (direction.x - 1.0f) * -0.5f;
                    v = (direction.y - 1.0f) * -0.5f;
                    break;
            }

            u = Mathf.Min(u, 0.999999f);
            v = Mathf.Min(v, 0.999999f);

            return (int)(v * cubemapResolution) * cubemapResolution + (int)(u * cubemapResolution);
        }

        public static void SetComputeKeyword(ComputeShader computeShader, string keyword, bool value)
        {
            if (value)
                computeShader.EnableKeyword(keyword);
            else
                computeShader.DisableKeyword(keyword);
        }

        public static void SetMaterialKeyword(Material material, string keyword, bool value)
        {
            if (value)
                material.EnableKeyword(keyword);
            else
                material.DisableKeyword(keyword);
        }

        public static Vector3[] CompressAndUncompressCoefficents(Vector3[] inputCoefficents, CoefficentPrecision coefficentPrecision)
        {
            Vector3[] outputCoefficents = new Vector3[inputCoefficents.Length];

            for (int i = 0; i < inputCoefficents.Length; i++)
            {
                float postCompressedX = CompressAndUncompressValue(inputCoefficents[i].x, coefficentPrecision);
                float postCompressedY = CompressAndUncompressValue(inputCoefficents[i].y, coefficentPrecision);
                float postCompressedZ = CompressAndUncompressValue(inputCoefficents[i].z, coefficentPrecision);

                outputCoefficents[i] = new Vector3(postCompressedX, postCompressedY, postCompressedZ);
            }

            return outputCoefficents;
        }

        public static float CompressAndUncompressValue(float input, CoefficentPrecision precision)
        {
            ushort compressedUShort = 0;
            short compressedShort = 0;
            byte compressedByte = 0;
            sbyte compressedSByte = 0;

            switch (precision)
            {
                case CoefficentPrecision.Half16:
                    compressedUShort = Mathf.FloatToHalf(input); //COMPRESS
                    return Mathf.HalfToFloat(compressedUShort); //UNCOMPRESS
                case CoefficentPrecision.SignedInt16_Decimal4:
                    compressedShort = (short)Mathf.Clamp((short)(input * 10000.0f), -32768, 32767); //COMPRESS
                    return compressedShort / 10000.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt16_Decimal3:
                    compressedShort = (short)Mathf.Clamp((short)(input * 1000.0f), -32768, 32767); //COMPRESS
                    return compressedShort / 1000.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt15_Decimal3:
                    compressedShort = (short)Mathf.Clamp((short)(input * 1000.0f), -16384, 16383); //COMPRESS
                    return compressedShort / 1000.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt14_Decimal3:
                    compressedShort = (short)Mathf.Clamp((short)(input * 1000.0f), -8192, 8191); //COMPRESS
                    return compressedShort / 1000.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt14_Decimal2:
                    compressedShort = (short)Mathf.Clamp((short)(input * 100.0f), -8192, 8191); //COMPRESS
                    return compressedShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt13_Decimal2:
                    compressedShort = (short)Mathf.Clamp((short)(input * 100.0f), -4096, 4095); //COMPRESS
                    return compressedShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt12_Decimal2:
                    compressedShort = (short)Mathf.Clamp((short)(input * 100.0f), -2048, 2047); //COMPRESS
                    return compressedShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt11_Decimal2:
                    compressedShort = (short)Mathf.Clamp((short)(input * 100.0f), -1024, 1023); //COMPRESS
                    return compressedShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt10_Decimal2:
                    compressedShort = (short)Mathf.Clamp((short)(input * 100.0f), -512, 511); //COMPRESS
                    return compressedShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt10_Decimal1:
                    compressedShort = (short)Mathf.Clamp((short)(input * 10.0f), -512, 511); //COMPRESS
                    return compressedShort / 10.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt9_Decimal2:
                    compressedShort = (short)Mathf.Clamp((short)(input * 100.0f), -256, 255); //COMPRESS
                    return compressedShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt9_Decimal1:
                    compressedShort = (short)Mathf.Clamp((short)(input * 10.0f), -256, 255); //COMPRESS
                    return compressedShort / 10.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt8_Decimal2:
                    compressedSByte = (sbyte)Mathf.Clamp((sbyte)(input * 100.0f), -128, 127); //COMPRESS
                    return compressedSByte / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.SignedInt8_Decimal1:
                    compressedSByte = (sbyte)Mathf.Clamp((sbyte)(input * 10.0f), -128, 127); //COMPRESS
                    return compressedSByte / 10.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt16_Decimal4:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 10000.0f), 0, 65535); //COMPRESS
                    return compressedUShort / 10000.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt16_Decimal3:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 1000.0f), 0, 65535); //COMPRESS
                    return compressedUShort / 1000.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt15_Decimal3:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 1000.0f), 0, 32767); //COMPRESS
                    return compressedUShort / 1000.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt14_Decimal3:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 1000.0f), 0, 16383); //COMPRESS
                    return compressedUShort / 1000.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt14_Decimal2:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 100.0f), 0, 16383); //COMPRESS
                    return compressedUShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt13_Decimal2:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 100.0f), 0, 8191); //COMPRESS
                    return compressedUShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt12_Decimal2:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 100.0f), 0, 4095); //COMPRESS
                    return compressedUShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt11_Decimal2:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 100.0f), 0, 2047); //COMPRESS
                    return compressedUShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt10_Decimal2:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 100.0f), 0, 1023); //COMPRESS
                    return compressedUShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt10_Decimal1:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 10.0f), 0, 1023); //COMPRESS
                    return compressedUShort / 10.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt9_Decimal2:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 100.0f), 0, 511); //COMPRESS
                    return compressedUShort / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt9_Decimal1:
                    compressedUShort = (ushort)Mathf.Clamp((ushort)(input * 10.0f), 0, 511); //COMPRESS
                    return compressedUShort / 10.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt8_Decimal2:
                    compressedByte = (byte)Mathf.Clamp((byte)(input * 100.0f), 0, 255); //COMPRESS
                    return compressedByte / 100.0f; //UNCOMPRESS
                case CoefficentPrecision.UnsignedInt8_Decimal1:
                    compressedByte = (byte)Mathf.Clamp((byte)(input * 10.0f), 0, 255); //COMPRESS
                    return compressedByte / 10.0f; //UNCOMPRESS
                default:
                    return input;
            }
        }
    }
}