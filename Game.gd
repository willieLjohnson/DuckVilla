extends Node2D

@onready var score = 0
@onready var duck_node = $Ducks
@onready var object_pooler = $ObjectPooler
@onready var timer = $Timer

func _ready():
  randomize()
  Global.node_creation_parent = self
  Global.object_pooler = object_pooler
  Global.player = $Ducks/Player
  timer.connect("timeout", Callable(self, "_spawn_food"))
  connect("update_score", Callable(self, "_update_score"))
  timer.start()
  for i in 10:
    _spawn_duck(Vector2(2 * i, 2 * i))

func _spawn_duck(position: Vector2 = Vector2.ZERO):
  if position == Vector2.ZERO: position = Global.player.position
  var new_duck = Global.GREENDUCK_SCENE.instantiate()
  new_duck.position = position
  new_duck.follow_player = true
  add_child(new_duck)

func _spawn_player():
  if position == Vector2.ZERO: position = Global.player.position
  var new_player = Global.DEFENDER_SCENE.instantiate()
  new_player.position = position + Vector2(100, 100)
  new_player.follow_player = false

  duck_node.add_child(new_player)

func _spawn_food():
  var randx = Global.rng.randf_range(0, Global.camera_rect.size.x)
  var randy = Global.rng.randf_range(0, Global.camera_rect.size.y)
  var crumbs = Global.object_pooler.spawn_from_pool("food", Vector2(randx, randy), 10)
  add_child(crumbs)

func _update_score():
  if Global.score % 10 == 0:
    _spawn_duck()
  elif Global.score % 20 == 0:
    _spawn_player()
