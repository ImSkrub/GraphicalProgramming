using UnityEngine;
public class Player : MonoBehaviour
{
    private PlayerCamera1 playerCamera;
    private Rigidbody rb;

    [SerializeField] private float speed;
    [SerializeField] AudioSource footstepsAudio;


    void Awake()
    {
        GetComponents();
    }

    void FixedUpdate()
    {
        Movement();
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            Application.Quit();
        }
    }


    private void GetComponents()
    {
        playerCamera = GetComponentInChildren<PlayerCamera1>();
        rb = GetComponent<Rigidbody>();
        footstepsAudio = GetComponent<AudioSource>();
    }

    private void Movement()
    {
        Vector3 cameraForward = playerCamera.transform.forward;
        cameraForward.y = 0;
        cameraForward.Normalize();

        Vector3 right = playerCamera.transform.right;
        Vector3 input = new Vector3(Input.GetAxisRaw("Horizontal"), 0, Input.GetAxisRaw("Vertical"));
        Vector3 movement = (cameraForward * input.z + right * input.x).normalized * speed * Time.fixedDeltaTime;

        rb.velocity = new Vector3(movement.x, rb.velocity.y, movement.z);

        // Efecto de sonido de pisadas
        if (input.magnitude > 0.1f)
        {
            if (!footstepsAudio.isPlaying)
            {
                footstepsAudio.Play();
            }
        }
        else
        {
            if (footstepsAudio.isPlaying)
            {
                footstepsAudio.Stop();
            }
        }
    }
}
