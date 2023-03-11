extends Node2D

var text = "0" : set = set_text

func _ready() -> void:
  $Label.text = text

func _on_Timer_timeout() -> void:
  $AnimationPlayer.play("Disappear")
  $AnimationPlayer.speed_scale = 1.25

func set_text(new_text: String) -> void:
  text = new_text
  $Label.text = text
