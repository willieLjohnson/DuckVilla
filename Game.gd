class_name Game extends Node2D

@onready var score = 0
@onready var duck_node = $Ducks
@onready var entity_manager = $EntityManager
@onready var timer = $Timer

func _ready():
  randomize()
  Global.game = self
  Global.entity_manager = entity_manager
  Global.player = $Ducks/Player
  timer.connect("timeout", Callable(self, "_spawn_food"))
  connect("update_score", Callable(self, "_update_score"))
  timer.start()
  _spawn_player(1)
  _spawn_duck()

func _spawn_duck(pos: Vector2 = Vector2.ZERO):
  if pos == Vector2.ZERO: pos = Global.player.position
  var new_duck = Global.GREENDUCK_SCENE.instantiate()
  new_duck.position = pos + Global.random_vec(-10, 10)
  new_duck.follow_player = true
  add_child(new_duck)

func _spawn_player(type = 0, pos = Vector2.ZERO):
  if pos == Vector2.ZERO: pos = Global.player.position
  var new_player
  if type == 0:
    new_player = Global.DEFENDER_SCENE.instantiate()
  else:
    new_player = Global.SCOUT_SCENE.instantiate()

  new_player.position = pos + Global.random_vec(10, 10)
  new_player.follow_player = false
  duck_node.add_child(new_player)

func _spawn_food():
  var randx = Global.rng.randf_range(0, Global.camera_rect.size.x)
  var randy = Global.rng.randf_range(0, Global.camera_rect.size.y)
  var crumbs = Global.entity_manager.spawn_from_pool("food", Vector2(randx, randy), 10)
  add_child(crumbs)

func score_updated():
  if Global.score % 12 == 0:
    _spawn_player(1)
  elif Global.score % 8 == 0:
    _spawn_player()
  elif Global.score % 4 == 0:
    _spawn_duck()

