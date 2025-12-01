using System;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    [SerializeField] Rigidbody2D _rb;
    
    private float _xSpeed;
    private float _ySpeed;
    
    private void Update()
    {
        _rb.linearVelocity = new Vector2(_xSpeed, _ySpeed);
    }

    public void OnMove(InputValue inputValue)
    {
        _xSpeed = inputValue.Get<Vector2>().x;
        _ySpeed = inputValue.Get<Vector2>().y;
    }
}
