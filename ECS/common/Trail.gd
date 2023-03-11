extends Line2D

@export var targetPath: NodePath
@export var trailLength = 1
@export var maxFrames = 15
@export var wave_enabled = false
@export var waveStrenth = 20
@export var target_width_multiplier = 100
@export var target_trailLength_multiplier = 50
@export var match_target_color: bool = false

@onready var default_width = width
@onready var default_trailLength = trailLength

var target
var point
var speed = 0
var frameCount = 0

func _ready() -> void:
  target = get_node(targetPath)
  default_width = width
  default_trailLength = trailLength
  if match_target_color:
    default_color = target.modulate
    gradient = Gradient.new()
    gradient.colors[0] = Color(default_color.r, default_color.g, default_color.b, 0)
    gradient.colors[1] = Color(default_color.r, default_color.g, default_color.b, default_color.a)

func _physics_process(delta: float) -> void:
  if target.is_queued_for_deletion(): return
  global_position = Vector2.ZERO
  rotation = 0

  if target != null:
    width = default_width + (target_width_multiplier * target.scale.y)
    trailLength = default_trailLength + (target_trailLength_multiplier * target.scale.x)
    point = target.global_position
    add_point(point)

  if wave_enabled: wave(delta)

  while get_point_count() > trailLength:
    remove_point(0)

  if match_target_color:
    default_color = target.modulate
    gradient = Gradient.new()
    gradient.colors[0] = Color(default_color.r, default_color.g, default_color.b, 0)
    gradient.colors[1] = Color(default_color.r, default_color.g, default_color.b, default_color.a)

func wave(delta: float) -> void:
  frameCount %= maxFrames
  for i in range(points.size()):
    if i > 0 and i < trailLength / 4:
      speed = randf_range(-waveStrenth, waveStrenth)
    elif i > trailLength / 4 + 1 and i < trailLength / 2:
      speed = randf_range(-waveStrenth * 2, waveStrenth * 2)
    elif i > trailLength / 2 + 1 and i < trailLength * 0.75:
      speed = randf_range(-waveStrenth * 3, waveStrenth * 3)

    var target_velocity = target.velocity.normalized()
    var wave_vec_normal = Vector2(abs(target_velocity.x), abs(target_velocity.y)).normalized()
    var wave_speed = ((wave_vec_normal.y + wave_vec_normal.x)) * speed
    var new_point_position = Vector2(get_point_position(i).x + (wave_speed * delta), get_point_position(i).y + (wave_speed * delta))

    set_point_position(i, new_point_position)

