namespace SphericalHarmonicIBL
{
    /// <summary>
    /// The precision of the final computed spherical harmonic coefficents.
    /// </summary>
    public enum CoefficentPrecision
    {
        /// <summary>
        /// (float32) Spherical Harmonic coefficents are stored with 32 bits of precision.
        /// </summary>
        Float32,

        /// <summary>
        /// (half16) Spherical Harmonic coefficents are stored with 16 bits of precision.
        /// </summary>
        Half16,

        /// <summary>
        /// (int16) Spherical Harmonic coefficents are stored with 16 bits of precision.
        /// <para>Value is compressed into a signed integer16 (-32768 to 32767).</para>
        /// <para>Then multiplied by 10000 to keep the first digit (So maximum first digit value is 3 to -3) and there are 4 maximum decimal places.</para>
        /// <para>RANGE: (-3.2768, 3.2767) </para>
        /// </summary>
        SignedInt16_Decimal4,

        /// <summary>
        /// (int16) Spherical Harmonic coefficents are stored with 16 bits of precision.
        /// <para>Value is compressed into a signed integer16 (-32768 to 32767).</para>
        /// <para>Then multiplied by 1000 to keep the first two digits (So maximum first digit value is 32 to -32) and there are 3 maximum decimal places.</para>
        /// <para>RANGE: (-32.768, 32.767) </para>
        /// </summary>
        SignedInt16_Decimal3,

        /// <summary>
        /// (int15) Spherical Harmonic coefficents are stored with 15 bits of precision.
        /// <para>Value is compressed into a signed integer15 (-16384 to 16383).</para>
        /// <para>Then multiplied by 1000 to keep the first two digits (So maximum first digits value is 16 to -16) and there are 3 maximum decimal places.</para>
        /// <para>RANGE: (-16.384, 16.383) </para>
        /// </summary>
        SignedInt15_Decimal3,

        /// <summary>
        /// (int14) Spherical Harmonic coefficents are stored with 14 bits of precision.
        /// <para>Value is compressed into a signed integer14 (-8192 to 8191).</para>
        /// <para>Then multiplied by 1000 to keep the first digit (So maximum first digit value is 8 to -8) and there are 3 maximum decimal places.</para>
        /// <para>RANGE: (-8.192, 8.191) </para>
        /// </summary>
        SignedInt14_Decimal3,

        /// <summary>
        /// (int14) Spherical Harmonic coefficents are stored with 14 bits of precision.
        /// <para>Value is compressed into a signed integer14 (-8192 to 8191).</para>
        /// <para>Then multiplied by 100 to keep the first two digits (So maximum first digit value is 81 to -81) and there are 2 maximum decimal places.</para>
        /// <para>RANGE: (-81.92, 81.91) </para>
        /// </summary>
        SignedInt14_Decimal2,

        /// <summary>
        /// (int13) Spherical Harmonic coefficents are stored with 13 bits of precision.
        /// <para>Value is compressed into a signed integer13 (-4096 to 4095).</para>
        /// <para>Then multiplied by 100 to keep the first two digits (So maximum first digit value is 40 to -40) and there are 2 maximum decimal places.</para>
        /// <para>RANGE: (-40.96, 40.95) </para>
        /// </summary>
        SignedInt13_Decimal2,

        /// <summary>
        /// (int12) Spherical Harmonic coefficents are stored with 12 bits of precision.
        /// <para>Value is compressed into a signed integer12 (-2048 to 2047).</para>
        /// <para>Then multiplied by 100 to keep the first two digits (So maximum first digit value is 20 to -20) and there are 2 maximum decimal places.</para>
        /// <para>RANGE: (-20.48, 20.47) </para>
        /// </summary>
        SignedInt12_Decimal2,

        /// <summary>
        /// (int11) Spherical Harmonic coefficents are stored with 11 bits of precision.
        /// <para>Value is compressed into a signed integer11 (-1024 to 1023).</para>
        /// <para>Then multiplied by 100 to keep the first two digits (So maximum first digit value is 10 to -10) and there are 2 maximum decimal places.</para>
        /// <para>RANGE: (-10.24, 10.23) </para>
        /// </summary>
        SignedInt11_Decimal2,

        /// <summary>
        /// (int10) Spherical Harmonic coefficents are stored with 10 bits of precision.
        /// <para>Value is compressed into a signed integer10 (-512 to 511).</para>
        /// <para>Then multiplied by 100 to keep the first digit (So maximum first digit value is 5 to -5) and there are 2 maximum decimal places.</para>
        /// <para>RANGE: (-5.12, 5.11) </para>
        /// </summary>
        SignedInt10_Decimal2,

        /// <summary>
        /// (int10) Spherical Harmonic coefficents are stored with 10 bits of precision.
        /// <para>Value is compressed into a signed integer10 (-512 to 511).</para>
        /// <para>Then multiplied by 10 to keep the first two digits (So maximum first digit value is 5 to -5) and there are 2 maximum decimal places.</para>
        /// <para>RANGE: (-51.2, 51.1) </para>
        /// </summary>
        SignedInt10_Decimal1,

        /// <summary>
        /// (int9) Spherical Harmonic coefficents are stored with 9 bits of precision.
        /// <para>Value is compressed into a signed integer9 (-256 to 255).</para>
        /// <para>Then multiplied by 100 to keep the first digit (So maximum first digit value is 2 to -2) and there are 2 maximum decimal places.</para>
        /// <para>RANGE: (-2.56, 2.55) </para>
        /// </summary>
        SignedInt9_Decimal2,

        /// <summary>
        /// (int9) Spherical Harmonic coefficents are stored with 9 bits of precision.
        /// <para>Value is compressed into a signed integer9 (-256 to 255).</para>
        /// <para>Then multiplied by 10 to keep the first two digits (So maximum first digit value is 25 to -25) and there are 1 maximum decimal places.</para>
        /// <para>RANGE: (-25.6, 25.5) </para>
        /// </summary>
        SignedInt9_Decimal1,

        /// <summary>
        /// (int8) Spherical Harmonic coefficents are stored with 8 bits of precision.
        /// <para>Value is compressed into a signed integer8 (-128 to 127).</para>
        /// <para>Then multiplied by 100 to keep the first two digits (So maximum first digit value is 1 to -1) and there are 2 maximum decimal places.</para>
        /// <para>RANGE: (-12.8, 12.7) </para>
        /// </summary>
        SignedInt8_Decimal2,

        /// <summary>
        /// (int8) Spherical Harmonic coefficents are stored with 8 bits of precision.
        /// <para>Value is compressed into a signed integer8 (-128 to 127).</para>
        /// <para>Then multiplied by 10 to keep the first two digits (So maximum first digit value is 12 to -12) and there are 1 maximum decimal places.</para>
        /// <para>RANGE: (-1.28, 1.27) </para>
        /// </summary>
        SignedInt8_Decimal1,

        UnsignedInt16_Decimal4,
        UnsignedInt16_Decimal3,
        UnsignedInt15_Decimal3,
        UnsignedInt14_Decimal3,
        UnsignedInt14_Decimal2,
        UnsignedInt13_Decimal2,
        UnsignedInt12_Decimal2,
        UnsignedInt11_Decimal2,
        UnsignedInt10_Decimal2,
        UnsignedInt10_Decimal1,
        UnsignedInt9_Decimal2,
        UnsignedInt9_Decimal1,
        UnsignedInt8_Decimal2,
        UnsignedInt8_Decimal1,
    }
}