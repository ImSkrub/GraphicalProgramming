using UnityEngine;

public class PlayerCamera : MonoBehaviour
{
    public GameObject player;

    [SerializeField] private float cameraHeight;

    // Simulacion de Update
    void Update()
    {
        FollowPlayerPosition();
    }

    private void FollowPlayerPosition()
    {
        transform.position = new Vector3(player.transform.position.x, cameraHeight, player.transform.position.z);
    }
}
