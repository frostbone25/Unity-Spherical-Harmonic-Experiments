using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.UIElements;

public class UnitySH : MonoBehaviour
{
    private MeshRenderer renderer;

    [ContextMenu("Print Unity Coefficents")]
    public void PrintUnitySH()
    {
        renderer = GetComponent<MeshRenderer>();

        //these don't work...
        //Vector4 unity_SHAr = renderer.sharedMaterial.GetVector("unity_SHAr");
        //Vector4 unity_SHAg = renderer.sharedMaterial.GetVector("unity_SHAg");
        //Vector4 unity_SHAb = renderer.sharedMaterial.GetVector("unity_SHAb");
        //Vector4 unity_SHBr = renderer.sharedMaterial.GetVector("unity_SHBr");
        //Vector4 unity_SHBg = renderer.sharedMaterial.GetVector("unity_SHBg");
        //Vector4 unity_SHBb = renderer.sharedMaterial.GetVector("unity_SHBb");
        //Vector4 unity_SHC = renderer.sharedMaterial.GetVector("unity_SHC");

        SphericalHarmonicsL2 sh;
        LightProbes.GetInterpolatedProbe(Vector3.zero, null, out sh);

        //REF - https://github.com/keijiro/LightProbeUtility/blob/master/Assets/LightProbeUtility.cs
        //Constant + Linear
        Vector4 unity_SHAr = new Vector4(sh[0, 3], sh[0, 1], sh[0, 2], sh[0, 0] - sh[0, 6]);
        Vector4 unity_SHAg = new Vector4(sh[1, 3], sh[1, 1], sh[1, 2], sh[1, 0] - sh[1, 6]);
        Vector4 unity_SHAb = new Vector4(sh[2, 3], sh[2, 1], sh[2, 2], sh[2, 0] - sh[2, 6]);

        // Quadratic polynomials
        Vector4 unity_SHBr = new Vector4(sh[0, 4], sh[0, 6], sh[0, 5] * 3, sh[0, 7]);
        Vector4 unity_SHBg = new Vector4(sh[1, 4], sh[1, 6], sh[1, 5] * 3, sh[1, 7]);
        Vector4 unity_SHBb = new Vector4(sh[2, 4], sh[2, 6], sh[2, 5] * 3, sh[2, 7]);

        // Final quadratic polynomial
        Vector4 unity_SHC = new Vector4(sh[0, 8], sh[2, 8], sh[1, 8], 1);

        string log = "=== Unity SH (SHADER) ===";
        log += "\n";

        log += string.Format("unity_SHAr: ({0}, {1}, {2}, {3})", unity_SHAr.x, unity_SHAr.y, unity_SHAr.z, unity_SHAr.w);
        log += "\n";

        log += string.Format("unity_SHAg: ({0}, {1}, {2}, {3})", unity_SHAg.x, unity_SHAg.y, unity_SHAg.z, unity_SHAg.w);
        log += "\n";

        log += string.Format("unity_SHAb: ({0}, {1}, {2}, {3})", unity_SHAb.x, unity_SHAb.y, unity_SHAb.z, unity_SHAb.w);
        log += "\n";

        log += string.Format("unity_SHBr: ({0}, {1}, {2}, {3})", unity_SHBr.x, unity_SHBr.y, unity_SHBr.z, unity_SHBr.w);
        log += "\n";

        log += string.Format("unity_SHBg: ({0}, {1}, {2}, {3})", unity_SHBg.x, unity_SHBg.y, unity_SHBg.z, unity_SHBg.w);
        log += "\n";

        log += string.Format("unity_SHBb: ({0}, {1}, {2}, {3})", unity_SHBb.x, unity_SHBb.y, unity_SHBb.z, unity_SHBb.w);
        log += "\n";

        log += string.Format("unity_SHC: ({0}, {1}, {2}, {3})", unity_SHC.x, unity_SHC.y, unity_SHC.z, unity_SHC.w);
        log += "\n";

        log += "\n";
        log += "=== Unity SH (RAW) ===";
        log += "\n";

        log += string.Format("Coefficents 0: ({0}, {1}, {2}) \n", sh[0, 0], sh[1, 0], sh[2, 0]);
        log += string.Format("Coefficents 1: ({0}, {1}, {2}) \n", sh[0, 1], sh[1, 1], sh[2, 1]);
        log += string.Format("Coefficents 2: ({0}, {1}, {2}) \n", sh[0, 2], sh[1, 2], sh[2, 2]);
        log += string.Format("Coefficents 3: ({0}, {1}, {2}) \n", sh[0, 3], sh[1, 3], sh[2, 3]);
        log += string.Format("Coefficents 4: ({0}, {1}, {2}) \n", sh[0, 4], sh[1, 4], sh[2, 4]);
        log += string.Format("Coefficents 5: ({0}, {1}, {2}) \n", sh[0, 5], sh[1, 5], sh[2, 5]);
        log += string.Format("Coefficents 6: ({0}, {1}, {2}) \n", sh[0, 6], sh[1, 6], sh[2, 6]);
        log += string.Format("Coefficents 7: ({0}, {1}, {2}) \n", sh[0, 7], sh[1, 7], sh[2, 7]);
        log += string.Format("Coefficents 8: ({0}, {1}, {2}) \n", sh[0, 8], sh[1, 8], sh[2, 8]);

        Debug.Log(log);
    }
}
