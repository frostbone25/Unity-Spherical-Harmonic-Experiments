using JetBrains.Annotations;
using Palmmedia.ReportGenerator.Core;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SampleTest : MonoBehaviour
{
    public enum SampleType
    {
        Uniform,
        UniformNoise
    }

    public SampleType sampleType;
    public bool drawRays;
    public float pointSize = 0.01f;
    public int samples = 64;

    private List<Vector3> sampleDirections = new List<Vector3>();

    [ContextMenu("Generate Samples")]
    public void GenerateSamples()
    {
        sampleDirections.Clear();

        if (sampleType == SampleType.Uniform)
        {
            //float goldenRatio = (1 + Mathf.Sqrt(5)) / 2;
            //float angleIncrement = Mathf.PI * 2 * goldenRatio;

            float angleIncrement = 10.1664073846305f; //precomputed

            for (int i = 1; i <= samples; i++)
            {
                float y = 1 - (i + 0.5f) / samples * 2;
                float radius = Mathf.Sqrt(1 - y * y);
                float theta = i * angleIncrement;

                float x = Mathf.Cos(theta) * radius;
                float z = Mathf.Sin(theta) * radius;

                Vector3 direction = new Vector3(x, y, z);
                sampleDirections.Add(direction);
            }
        }
        else if (sampleType == SampleType.UniformNoise)
        {
            for (int i = 1; i <= samples; i++)
            {
                Vector3 direction = Random.onUnitSphere;
                sampleDirections.Add(direction);
            }
        }
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(transform.position, 1.0f);

        Gizmos.color = Color.white;

        if(sampleType == SampleType.Uniform)
        {
            for (int i = 0; i < sampleDirections.Count; i++)
            {
                Gizmos.color = Color.white;

                if (drawRays)
                    Gizmos.DrawRay(transform.position, sampleDirections[i]);

                Gizmos.color = Color.green;
                Gizmos.DrawSphere(transform.position + sampleDirections[i], pointSize);
            }
        }
        else if(sampleType == SampleType.UniformNoise) 
        {
            for(int i = 0; i < sampleDirections.Count; i++)
            {
                Gizmos.color = Color.white;

                if (drawRays)
                    Gizmos.DrawRay(transform.position, sampleDirections[i]);

                Gizmos.color = Color.green;
                Gizmos.DrawSphere(transform.position + sampleDirections[i], pointSize);
            }
        }
    }
}
