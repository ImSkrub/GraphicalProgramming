using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OpenDoor : MonoBehaviour
{
    public float openHeight; // Altura a la que se abrirá la puerta
    public float duration; // Tiempo que tarda en abrir/cerrar
    private Vector3 closedPosition;
    private Vector3 openPosition;
    private Coroutine currentCoroutine;
    public bool isOpen = false; // Estado de la puerta
    public bool isMoving = false; // Si la puerta se está moviendo
    //private bool playerInTrigger = false; // Si el jugador está dentro del trigger

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
            //if (currentCoroutine != null) StopCoroutine(currentCoroutine);
            //isOpen = true; // Cambiamos el estado inmediatamente
            currentCoroutine = StartCoroutine(MoveDoor(openPosition, true));
            //isMoving = false;
        }            
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player") && isOpen)
        {
            //if (currentCoroutine != null) StopCoroutine(currentCoroutine);
            //isOpen = false; // Cambiamos el estado inmediatamente
            currentCoroutine = StartCoroutine(MoveDoor(closedPosition, false));
        }            
    }

    IEnumerator MoveDoor(Vector3 targetPosition, bool opening)
    {
        isMoving = true;
        Vector3 startPos = transform.position;
        float elapsed = 0f;
        
        while (elapsed < duration)
        {
            transform.position = Vector3.Lerp(startPos, targetPosition, elapsed / duration);
            elapsed += Time.deltaTime;
            yield return null;
        }
        
        transform.position = targetPosition;
        isOpen = !isOpen;
        isMoving = false;
        currentCoroutine = null;
    }    
}
