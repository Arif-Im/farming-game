using System;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;

public class PlayerController : MonoBehaviour
{
    [FormerlySerializedAs("_rb")] 
    [SerializeField] private Rigidbody2D playerRigidbody;
    [SerializeField] private float xMaxSpeed = 5.0f;
    [SerializeField] private float yMaxSpeed = 5.0f;
    
    private float _xSpeed;
    private float _ySpeed;
    
    private void Update()
    {
        playerRigidbody.linearVelocity = new Vector2(_xSpeed, _ySpeed);
    }

    public void OnMove(InputValue inputValue)
    {
        _xSpeed = inputValue.Get<Vector2>().x * xMaxSpeed;
        _ySpeed = inputValue.Get<Vector2>().y * yMaxSpeed;
    }
}
