namespace SphericalHarmonicIBL
{
    /// <summary>
    /// The type of sampling for the source environment map for generating Spherical Harmonic Coefficents.
    /// </summary>
    public enum SamplingType
    {
        /// <summary>
        /// Sample every texel of the environment map.
        /// <para>Most accurate, but depending on the resolution of the environment map it can also be the slowest.</para>
        /// </summary>
        EveryCubemapTexel,

        /// <summary>
        /// Sample every texel of a downsampled environment map.
        /// <para>Not as accurate, depends on how large the downsampling factor is.</para>
        /// </summary>
        DownsampledCubemapTexel,

        /// <summary>
        /// Sample the environment map in an even/grid like way.
        /// <para>Accuracy depends on how many samples are taken. Lower samples are faster, but won't catch any small bright points from the environment map.</para>
        /// </summary>
        FibonacciSphereSampling,

        /// <summary>
        /// Sample the environment map randomly. (NOTE: Results vary each time samples are taken due to the random nature)
        /// <para>Accuracy depends on how many samples are taken. Lower samples are faster, but won't catch any small bright points from the environment map.</para>
        /// </summary>
        RandomSphereSampling
    }
}