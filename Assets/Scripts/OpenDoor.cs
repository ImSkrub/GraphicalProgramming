using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OpenDoor : MonoBehaviour
{
    public float openHeight = 3.5f; // Altura a la que se abrirá la puerta
    public float duration = 3f; // Tiempo que tarda en abrir/cerrar
    public bool isOpen = false;
    private Vector3 closedPosition;
    private Vector3 openPosition;
    private Coroutine currentCoroutine;

    // Start is called before the first frame update
    void Start()
    {
        closedPosition = transform.position;
        openPosition = new Vector3(closedPosition.x, closedPosition.y + openHeight, closedPosition.z);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player") && !isOpen)
        {
            if (Vector3.Distance(transform.position, openPosition) > 0.01f)
            {
                if (currentCoroutine != null) StopCoroutine(currentCoroutine);
                currentCoroutine = StartCoroutine(MoveDoor(openPosition));
            }
            isOpen = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player") && isOpen)
        {
            if (Vector3.Distance(transform.position, closedPosition) > 0.01f)
            {
                if (currentCoroutine != null) StopCoroutine(currentCoroutine);
                currentCoroutine = StartCoroutine(MoveDoor(closedPosition));
            }
            isOpen = false;
        }
    }

    IEnumerator MoveDoor(Vector3 targetPosition)
    {
        Vector3 startPos = transform.position;
        float elapsed = 0f;
        while (elapsed < duration)
        {
            transform.position = Vector3.Lerp(startPos, targetPosition, elapsed / duration);
            elapsed += Time.deltaTime;
            yield return null;
        }
        transform.position = targetPosition;
    }    
}
