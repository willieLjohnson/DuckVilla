extends KinematicBody2D

var speed = 10

func _ready():
	pass # Replace with function body.

func _input(event):
   # Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		var direction = (get_global_mouse_position() - position).normalized()
		if direction.x < 0:
			$Sprite.set_flip_h(true)
		else:
			$Sprite.set_flip_h(false)
		move_and_collide(direction * speed)
	
