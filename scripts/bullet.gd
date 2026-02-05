extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D

@export var speed := 400.0
@export var beam_length := 80.0
@export var max_range := 2000.0

var distance_traveled := 0.0
var head_pos := Vector2.ZERO
var tail_pos := Vector2.ZERO
var is_shrinking := false
var has_spawned_next := false

func _ready():
	line.clear_points()
	# Point 0 is the Tail, Point 1 is the Head
	line.add_point(Vector2.ZERO) 
	line.add_point(Vector2.ZERO)

func _physics_process(delta: float) -> void:
	var move_amt = speed * delta
	
	if not is_shrinking:
		# 1. Update Raycast to look from current head position
		ray_cast_2d.position = head_pos
		# We use Vector2.RIGHT because the Node2D's rotation handles the direction
		ray_cast_2d.target_position = Vector2.RIGHT * (move_amt + 5)
		ray_cast_2d.force_raycast_update()
		
		var collider = ray_cast_2d.get_collider()
		
		if collider is ColoredObstacle:
			# 1. Get the global point where the ray hit
			var global_hit_point = ray_cast_2d.get_collision_point()
			
			# 2. Convert that global point to a point relative to the Bullet node
			var local_hit_point = to_local(global_hit_point)
			
			# 3. Use the local point to snap the head to the wall
			head_pos = local_hit_point
			
			is_shrinking = true
			
			var colliding_color: Color = collider.color
			
			spawn_bounce(global_hit_point, ray_cast_2d.get_collision_normal(), colliding_color)
		else:
			head_pos += Vector2.RIGHT * move_amt
			distance_traveled += move_amt

	# 2. Tail Movement Logic
	if is_shrinking:
		tail_pos += Vector2.RIGHT * move_amt
	elif head_pos.length() > beam_length:
		# Tail only moves once the head has grown the beam out
		tail_pos += Vector2.RIGHT * move_amt

	# 3. Update the Line2D (Local coordinates)
	line.set_point_position(0, tail_pos)
	line.set_point_position(1, head_pos)

	# 4. Cleanup
	if is_shrinking and tail_pos.distance_to(head_pos) < 15.0:
		queue_free()
	if distance_traveled > max_range:
		queue_free()

func spawn_bounce(collision_global_pos, normal, new_color: Color):
	if has_spawned_next: return
	has_spawned_next = true
	
	var next_beam = load(self.scene_file_path).instantiate()
	# IMPORTANT: Add to root so it's independent
	get_tree().root.add_child(next_beam)
	
	if modulate == Color(1.0, 1.0, 1.0, 1.0):
		next_beam.modulate = Color.from_hsv(new_color.h, 1, 1)
	else:
		next_beam.modulate = combine_colors(modulate, new_color)
	
	# Set the new origin to the wall hit point
	next_beam.global_position = collision_global_pos
	
	# Calculate reflected angle
	var current_dir = Vector2.RIGHT.rotated(global_rotation)
	var reflect_dir = current_dir.bounce(normal)
	next_beam.global_rotation = reflect_dir.angle()
	
	# Pass on the lifetime distance
	next_beam.distance_traveled = distance_traveled

func combine_colors(old_color: Color, new_color: Color):
	var old_hue = old_color.h
	var new_hue = new_color.h
	
	var mixed_hue = lerp_angle(old_hue * TAU, new_hue * TAU, 0.5) / TAU
	return Color.from_hsv(mixed_hue, 1.0, 1.0)
