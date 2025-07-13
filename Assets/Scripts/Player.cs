using UnityEngine;

public class Player : MonoBehaviour
{
    private PlayerCamera1 playerCamera;
    private Rigidbody rb;

    [SerializeField] private float speed;


    void Awake()
    {
        GetComponents();
    }

    void FixedUpdate()
    {
        Movement();
    }


    private void GetComponents()
    {
        playerCamera = GetComponentInChildren<PlayerCamera1>();
        rb = GetComponent<Rigidbody>();
    }

    private void Movement()
    {
        Vector3 cameraForward = playerCamera.transform.forward;
        cameraForward.y = 0;
        cameraForward.Normalize();

        Vector3 right = playerCamera.transform.right;
        Vector3 movement = (cameraForward * Input.GetAxisRaw("Vertical") + right * Input.GetAxisRaw("Horizontal")).normalized * speed * Time.fixedDeltaTime;

        rb.velocity = new Vector3(movement.x, rb.velocity.y, movement.z);
    }
}
