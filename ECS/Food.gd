extends Node2D

@export var score_value: int = 1
@export var player_variable_modify: String
@export var player_variable_set: float
var velocity: Vector2 = Vector2.ZERO

var life_timer
var spawned: bool = false
var value_multiplier: float = 1

signal food_pickup

var push_vector = Vector2.ZERO

func on_object_spawned() -> void:
  life_timer = Timer.new()
  life_timer.wait_time = 10
  life_timer.autostart = true
  life_timer.connect("timeout", Callable(self,"_on_LifeTimer_timeout"))
  self.add_child(life_timer)
  $AnimationPlayer.play("Animate")
  spawned = true

func _physics_process(delta: float) -> void:
  if not spawned: return
  velocity += -$Magnet.get_push_vector()
  velocity = lerp(velocity, Vector2.ZERO, 0.1)
  global_position = lerp(global_position, global_position + velocity * 5, 0.3)
  $AnimationPlayer.speed_scale = life_timer.wait_time / (0.1 + life_timer.time_left)

func _on_HitBox_area_entered(area: Area2D) -> void:
  if not spawned: return
  if area.is_in_group("player"):
    Global.vibrate()
    ## Global.play_sound("res://assets/sounds/essence-collect.wav", -10)
    ## var player_variable = area.get_parent().get(player_variable_modify)
    ## area.get_parent().set(player_variable_modify, player_variable + (player_variable_set * value_multiplier))
    Global.score += score_value * value_multiplier
    var popup_label = Global.instance_popup_label(area.global_position, str(Global.score), area.modulate, 20)
    emit_signal("update_score")
    call_deferred("remove_self")


func _on_LifeTimer_timeout() -> void:
  if not spawned: return
  call_deferred("remove_self")

func remove_self():
  if not spawned: return
  life_timer.queue_free()
  get_parent().remove_child(self)
  Global.object_pooler.deactivate_obj(self)
  spawned = false
