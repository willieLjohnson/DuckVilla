extends Node2D

@onready var default_colors: Dictionary
@export var randomness = 0.02

func _ready():
  for node in get_children():
    if node is Polygon2D:
      var color = (node as Polygon2D).color
      default_colors[node.name] = color
      node.color = Color(color.r + Global.rng.randf_range(-randomness, randomness), color.g + Global.rng.randf_range(-randomness, randomness), color.b + Global.rng.randf_range(-randomness, randomness))
