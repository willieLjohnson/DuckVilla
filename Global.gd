extends Node

const POPUP_LABEL_SCENE = preload("res://ECS/PopupLabel.tscn")
const DEFENDER_SCENE = preload("res://ECS/Players/DefenderDuck.tscn")
const GREENDUCK_SCENE = preload("res://ECS/Players/GreenDuck.tscn")
const SCOUT_SCENE = preload("res://ECS/Players/ScoutDuck.tscn")
const WORKER_SCENE = preload("res://ECS/Players/WorkerDuck.tscn")

const save_file_path = "user://savegame.save"

var player: CharacterBody2D
var camera: Camera2D
var game: Game
var is_ios: bool
var is_android: bool
var is_mobile: bool

var haptics

var is_player_dead: bool = false
var score: int = 0
var high_score: int = 0

var entity_manager: Node2D
@onready var camera_rect: Rect2 : get = get_camera_rect
@onready var rng = RandomNumberGenerator.new()

func instance_node(node, location, parent):
  var node_instance = node.instantiate()
  if location != null: node_instance.global_position = location
  if parent != null: parent.add_child(node_instance)
  return node_instance

func instance_popup_label(position, text, modulate = Color.WHITE, scale = 1, z_index = 5, parent = game):
  var label = instance_node(POPUP_LABEL_SCENE, null, parent)
  label.text = text
  label.modulate = modulate
  label.scale = Vector2(scale, scale)
  label.z_index = z_index
  label.position = position
  return label

func get_camera_rect():
  if game != null:
    if camera == null:
      camera = game.get_node("Camera2D")
    update_OS_status()
    return camera.get_viewport().get_visible_rect()

func food_pickup(food: Food):
  score += food.value
  instance_popup_label(food.global_position, str(score), food.modulate, 15)
  game.score_updated()

func random_vec(min, max):
  return Vector2(rng.randf_range(min,max), rng.randf_range(min,max))

func get_camera_size():
  return get_camera_rect().size

func play_sound(sound, volume = 0, pitch = 1):
  if game != null:
    var audioStreamPlayer = AudioStreamPlayer.new()
    game.add_child(audioStreamPlayer)
    audioStreamPlayer.stream = load(sound)
    audioStreamPlayer.volume_db = volume
    audioStreamPlayer.pitch_scale = pitch
    audioStreamPlayer.play()

func play_sound_on(parent, sound, volume = 0):
  var audioStreamPlayer = AudioStreamPlayer.new()
  parent.add_child(audioStreamPlayer)
  audioStreamPlayer.stream = load(sound)
  audioStreamPlayer.volume_db = volume
  audioStreamPlayer.play()

func save():
  var save_dict = {
    "high_score": high_score
  }
  return save_dict

func save_game():
  var save_file = FileAccess.open(save_file_path, FileAccess.READ_WRITE)
  save_file.store_line(JSON.new().stringify(save()))
  save_file.close()

func load_game():
  var save_file = FileAccess.open(save_file_path, FileAccess.READ)
  if not save_file.file_exists(save_file_path):
    print("NO SAVE FILE")
    return

  var test_json_conv = JSON.new()
  test_json_conv.parse(save_file.get_line())
  var current_line = test_json_conv.get_data()

  high_score = current_line["high_score"]
  save_file.close()

func random_key(dict):
   var keys = dict.keys()
   return keys[randi() % keys.size()]

func update_OS_status():
  is_ios = OS.get_name() == "iOS"
  is_android = OS.get_name() == "Android"
  is_mobile = is_ios or is_android

func vibrate(strength=0):
  if Engine.has_singleton("Haptic") and is_ios and haptics == null:
    haptics = Engine.get_singleton("Haptic")

  match strength:
    0:
      if is_ios:
        haptics.selection()
      elif is_android:
        Input.vibrate_handheld(3)
    1:
      if is_ios:
        haptics.impact(0)
      elif is_android:
        Input.vibrate_handheld(5)
    2:
      if is_ios:
        haptics.impact(1)
      elif is_android:
        Input.vibrate_handheld(10)
    3:
      if is_ios:
        haptics.impact(2)
      elif is_android:
        Input.vibrate_handheld(20)
    4:
      if is_ios:
        haptics.impact(3)
      elif is_android:
        Input.vibrate_handheld(30)
    5:
      if is_mobile:
        Input.vibrate_handheld(400)
