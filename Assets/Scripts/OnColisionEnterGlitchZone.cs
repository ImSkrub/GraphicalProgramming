using UnityEngine;

[ExecuteInEditMode]
public class OnColisionEnterGlitchZone : MonoBehaviour
{

    [Header("Valores de mezcla")]
    [SerializeField] float maxBlend = 0.8f;
    [SerializeField] float speed = 1.5f;   // unidades por segundo

    float target, current;
    Material glitchMat;

    void Reset() { GetComponent<Collider>().isTrigger = true; }
    void Start()
    {
        // Buscar el material que usa la cámara
        var cam = Camera.main;
        if (cam != null)
        {
            var matScript = cam.GetComponent<Cameramaterial>();
            if (matScript != null)
                glitchMat = matScript.glitchMaterial;
        }
    }
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
            target = maxBlend;
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
            target = 0f;
    }

    void Update()
    {
        if (!glitchMat) return;

        current = Mathf.MoveTowards(current, target, speed * Time.deltaTime);
        glitchMat.SetFloat("_ScreenBlend", current);
    }
}