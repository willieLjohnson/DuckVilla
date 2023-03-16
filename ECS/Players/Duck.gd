extends CharacterBody2D

@export var follow_player: bool = false
@export var speed: float = 5
var _speed: float

var move_direction: Vector2 = Vector2.ZERO
var _area_force: Vector2 = Vector2.ZERO
var player_dir: Vector2
var food_dir: Vector2
@onready var food_radar = $FoodRadar

func _ready():
  _speed = speed

func _physics_process(delta: float) -> void:
  var area_forces = $SoftCollision.get_push_vector_and_area()

  _find_food()

  if name != "Scout":
    if area_forces[1] == null:
      if follow_player and Global.player != null:
        player_dir = (Global.player.position - position).normalized()
        move_direction = lerp(player_dir, move_direction, 0.8)
    else:
      _area_force = lerp(_area_force, area_forces[0] * area_forces[2], 0.05)
      move_and_collide(_area_force)

  $Sprite2D.set_flip_h(move_direction.x < 0)
  move_and_collide(move_direction * speed)
  move_direction = lerp(move_direction, Vector2.ZERO, 0.1)


func _set_speed(new_speed):
  _speed = new_speed
  speed = new_speed

func _find_food():
  if food_radar == null: return
  if food_radar.food != null:
    follow_player = false
    food_dir = ($FoodRadar.food.position - position).normalized()
    food_dir = lerp(food_dir, food_dir, 0.8)
    move_and_collide(food_dir * speed)
    food_dir = lerp(food_dir, Vector2.ZERO, 0.1)
  else:
    follow_player = true

func _collect_food(food: Food):
  if food == null: return
  Global.vibrate()
  Global.food_pickup(food)
  if self.name != "Player": follow_player = true
  if food_radar: food_radar.food = null
  food.on_radar = false
  food.remove_self()


func _on_HitBox_area_entered(area: Area2D) -> void:
  var area_parent = area.get_parent()
  if area_parent is Food: _collect_food(area_parent as Food)

