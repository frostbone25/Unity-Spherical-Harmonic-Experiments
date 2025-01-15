using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class SetChildMeshRenderersMaterials : MonoBehaviour
{
    public Material materialToApply;

    [ContextMenu("SetMeshRendererMaterials")]
    public void SetMeshRendererMaterials()
    {
        MeshRenderer[] meshRenderers = gameObject.GetComponentsInChildren<MeshRenderer>();
        SkinnedMeshRenderer[] skinnedMeshRenderer = gameObject.GetComponentsInChildren<SkinnedMeshRenderer>();

        for(int i = 0; i < meshRenderers.Length; i++)
        {
            meshRenderers[i].sharedMaterial = materialToApply;

            Material[] materials = new Material[meshRenderers[i].sharedMaterials.Length];

            for (int j = 0; j < materials.Length; j++)
            {
                materials[j] = materialToApply;
            }

            meshRenderers[i].sharedMaterials = materials;
        }

        for (int i = 0; i < skinnedMeshRenderer.Length; i++)
        {
            skinnedMeshRenderer[i].sharedMaterial = materialToApply;

            Material[] materials = new Material[skinnedMeshRenderer[i].sharedMaterials.Length];

            for (int j = 0; j < materials.Length; j++)
            {
                materials[j] = materialToApply;
            }

            skinnedMeshRenderer[i].sharedMaterials = materials;
        }
    }
}
