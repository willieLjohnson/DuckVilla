extends CharacterBody2D

@export var follow_player: bool = false
@export var speed: float = 5
var _speed: float

var move_direction: Vector2 = Vector2.ZERO
var _area_force: Vector2 = Vector2.ZERO
var player_dir: Vector2

func _ready():
  _speed = speed

func _physics_process(delta: float) -> void:
  var area_forces = $SoftCollision.get_push_vector_and_area()
  if area_forces[1] == null:
    if follow_player and Global.player != null:
      player_dir = (Global.player.position - position).normalized()
      move_direction = lerp(player_dir, move_direction, 0.8)
  else:
    _area_force = lerp(_area_force, area_forces[0] * area_forces[2], 0.05)
    move_and_collide(_area_force)
    print(area_forces[2])
  $Sprite2D.set_flip_h(move_direction.x < 0)

  move_and_collide(move_direction * speed)
  move_direction = lerp(move_direction, Vector2.ZERO, 0.1)
  area_forces = lerp(_area_force, Vector2.ZERO, 0.8)

func _set_speed(new_speed):
  _speed = new_speed
  speed = new_speed
