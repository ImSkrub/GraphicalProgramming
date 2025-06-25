
using UnityEngine;

public class Cameramaterial : MonoBehaviour
{
    public Material glitchMaterial;
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (glitchMaterial)
            Graphics.Blit(src, dest, glitchMaterial);
        else
            Graphics.Blit(src, dest);
    }
}
