extends "res://ECS/Players/Duck.gd"

@export var level = 1

func _input(event):
  if event is InputEventMouseButton:
    if name == "Scout" and food_radar != null:
      if food_radar.is_food_spotted(): return
    move_direction = (get_global_mouse_position() - position).normalized()


func _on_hit_box_area_entered(area):
  var area_parent = area.get_parent()
  if area_parent is Food: _collect_food(area_parent as Food)

