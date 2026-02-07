extends CharacterBody2D
class_name Enemy

var player: Player
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var speed := 20

@export var nav_update_interval: float = 0.5
var nav_update_timer := nav_update_interval

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	call_deferred("setup_navigation")
	
	modulate = [Colors.RED, Colors.GREEN, Colors.BLUE].pick_random()
	
func _process(delta: float) -> void:
	if not player:
		return
		
	target_player(delta)
	
	if navigation_agent_2d.is_navigation_finished():
		return
		
	var next_position = navigation_agent_2d.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
func target_player(delta: float):
	nav_update_timer += delta
	if nav_update_timer >= nav_update_interval:
		navigation_agent_2d.target_position = player.global_position
		nav_update_timer = 0
	
func setup_navigation():
	await get_tree().physics_frame
	if player:
		navigation_agent_2d.target_position = player.global_position
