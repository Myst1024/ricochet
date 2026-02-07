extends Node

@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@export var enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy():
	path_follow_2d.progress_ratio = randf()
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = path_follow_2d.global_position
	add_child(enemy)


func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
