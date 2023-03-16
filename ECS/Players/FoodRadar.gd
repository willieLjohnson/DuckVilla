extends Area2D

var food: Food = null

func _process(delta):
  if food == null: return
  if food.spawned != true:
    food = null

func _on_area_entered(area):
  if area.is_in_group("food") and food == null:
    var as_food = area.get_parent() as Food
    if as_food == null: return
    if as_food.on_radar == true: return
    food = as_food
    food.on_radar = true
    return

func is_food_spotted():
  return food != null and food.on_radar and food.spawned == true
