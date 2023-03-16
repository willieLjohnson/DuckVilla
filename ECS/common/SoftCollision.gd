class_name SoftCollider extends Area2D

@export var force: float = 1

func get_collisions():
  var areas = get_overlapping_areas()
  return [areas.size() > 0, areas]

func _get_soft_colliders(group: String = "none"):
  var areas = []
  for area in get_overlapping_areas():
    if area is SoftCollider:
      if group == "none" or area.is_in_group(group):
        areas.append(area)
  return [areas.size() > 0, areas]

func _get_first_collider(group: String = "none"):
  for area in get_overlapping_areas():
    if area is SoftCollider:
      if group == "none" or area.is_in_group(group):
        return area
  return null


func get_push_vector_and_area():
  var collisions = _get_soft_colliders()
  if collisions[0] != true: return [Vector2.ZERO, null, 1]

  var push_vector = Vector2.ZERO
  var area = null
  for collision in collisions:
    if collisions[0]:
      area = collisions[1][0]
      push_vector = area.global_position.direction_to(global_position)
      push_vector = push_vector.normalized()

  return [push_vector, area, (area as SoftCollider).force]
