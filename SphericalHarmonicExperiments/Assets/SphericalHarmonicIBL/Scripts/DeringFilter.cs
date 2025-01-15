namespace SphericalHarmonicIBL
{
    /// <summary>
    /// The type of filter used to mitigate spherical harmonic "ringing" artifacts in high contrast scenarios.
    /// </summary>
    public enum DeringFilter
    {
        /// <summary>
        /// No filter is used to mitigate potential spherical harmonic "ringing" artifacts.
        /// </summary>
        None,
        Hanning,
        Lanczos,
        Gaussian
    }
}