using System.Collections;

using UnityEngine;

public class OpenDoor : MonoBehaviour
{
    public float openHeight; // Altura a la que se abrirá la puerta
    public float duration;   // Tiempo que tarda en abrir/cerrar

    private Vector3 closedPosition;
    private Vector3 openPosition;
    private Coroutine currentCoroutine;

    public bool isOpen = false;
    public bool isMoving = false; // Si la puerta se está moviendo

    private AudioSource doorSound;

    void Start()
    {
        doorSound = GetComponent<AudioSource>();
        closedPosition = transform.position;
        openPosition = new Vector3(closedPosition.x, closedPosition.y + openHeight, closedPosition.z);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player") && !isOpen && !isMoving)
        {
            currentCoroutine = StartCoroutine(MoveDoor(openPosition, true));
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player") && isOpen && !isMoving)
        {
            currentCoroutine = StartCoroutine(MoveDoor(closedPosition, false));
        }
    }

    IEnumerator MoveDoor(Vector3 targetPosition, bool opening)
    {
        isMoving = true;

        if (doorSound != null)
            doorSound.Play();

        Vector3 startPos = transform.position;
        float elapsed = 0f;

        while (elapsed < duration)
        {
            transform.position = Vector3.Lerp(startPos, targetPosition, elapsed / duration);
            elapsed += Time.deltaTime;
            yield return null;
        }

        transform.position = targetPosition;
        isOpen = opening;
        isMoving = false;
        currentCoroutine = null;
    }
}
