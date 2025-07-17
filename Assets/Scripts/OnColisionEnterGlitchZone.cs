using UnityEngine;

[ExecuteInEditMode]
public class OnColisionEnterGlitchZone : MonoBehaviour
{

    [Header("Valores de mezcla")]
    [SerializeField] float maxBlend = 0.8f;
    [SerializeField] float speed = 1.5f;   // unidades por segundo

    [Header("Audio")]
    [SerializeField] float maxVolume = 1f;
    [SerializeField] float volumeFadeSpeed = 1.5f;

    float target, current;
    float targetVolume, currentVolume;

    Material glitchMat;
    AudioSource audioSource;

    void Reset() { GetComponent<Collider>().isTrigger = true; }
    void Start()
    {
        var cam = Camera.main;
        if (cam != null)
        {
            var matScript = cam.GetComponent<Cameramaterial>();
            if (matScript != null)
                glitchMat = matScript.glitchMaterial;
        }

        audioSource = GetComponent<AudioSource>();
        audioSource.loop = true; 
        audioSource.playOnAwake = false;
        audioSource.volume = 0f;
    }
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            target = maxBlend;
            targetVolume = maxVolume;
            if (!audioSource.isPlaying)
                audioSource.Play();
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            target = 0f;
            targetVolume = 0f;
        }
    }

    void Update()
    {
        if (!glitchMat) return;

        current = Mathf.MoveTowards(current, target, speed * Time.deltaTime);
        glitchMat.SetFloat("_ScreenBlend", current);

        currentVolume = Mathf.MoveTowards(currentVolume, targetVolume, volumeFadeSpeed * Time.deltaTime);
        audioSource.volume = currentVolume;

        if (currentVolume <= 0.001f && targetVolume == 0f && audioSource.isPlaying)
        {
            audioSource.Stop();
        }
    }
}