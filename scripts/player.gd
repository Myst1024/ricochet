extends CharacterBody2D
class_name Player
@export var bullet_scene: PackedScene
@export var speed := 200

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()

	look_at(mouse_pos)
	if Input.is_action_just_pressed("fire"):
		shoot()
		
	var direction = Vector2.ZERO
	if Input.is_action_pressed("up"):
		direction += Vector2.UP
	if Input.is_action_pressed("down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("right"):
		direction += Vector2.RIGHT
		
	velocity = direction * speed
	move_and_slide()

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.rotation = global_rotation
	bullet.global_position = global_position
	get_tree().root.add_child(bullet)
	print('bang')
	
