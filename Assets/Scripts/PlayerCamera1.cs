using UnityEngine;

public class PlayerCamera1 : MonoBehaviour
{
    private Player playerModel;

    private Vector3 cameraOffset;

    private float rotationX = 0f;

    [SerializeField] private float offSetY; // Posicion de la camara en eje y
    [SerializeField] private float sensitivity;


    void Awake()
    {
        GetComponents();
        InitializeCameraPosition();
    }

    void Update()
    {
        UpdateCameraFollow();
    }


    private void GetComponents()
    {
        playerModel = GetComponentInParent<Player>();
    }

    private void InitializeCameraPosition()
    {
        cameraOffset = new Vector3(0f, offSetY, -0.1f);
        transform.position = playerModel.transform.position + cameraOffset;
    }

    private void UpdateCameraFollow()
    {
        cameraOffset = new Vector3(0f, offSetY, 0.3f);

        float x, y;

        x = Input.GetAxis("Mouse X") * sensitivity * Time.deltaTime;
        y = Input.GetAxis("Mouse Y") * sensitivity * Time.deltaTime;

        rotationX -= y;
        rotationX = Mathf.Clamp(rotationX, -80f, 80f);

        transform.localRotation = Quaternion.Euler(rotationX, 0f, 0f);
        playerModel.transform.Rotate(Vector3.up * x);
    }
}
