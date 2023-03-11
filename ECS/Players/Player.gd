extends "res://ECS/Players/Duck.gd"

@export var level = 1

func _input(event):
  if event is InputEventMouseButton:
    move_direction = (get_global_mouse_position() - position).normalized()
