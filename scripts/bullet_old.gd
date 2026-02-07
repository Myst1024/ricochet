extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var polygon_2d: Polygon2D = $Polygon2D

@export var speed := 600
@export var max_range := 1000.0
var distance_traveled  := 0.0
var last_object_hit: Object = null
var current_particles: GPUParticles2D

func _ready() -> void:
	current_particles = gpu_particles_2d
	if current_particles.process_material:
		current_particles.process_material = current_particles.process_material.duplicate()

func _physics_process(delta: float) -> void:
	if distance_traveled > max_range:
		queue_free()
		
		
	var direction = Vector2.RIGHT.rotated(rotation)
	var motion = direction * speed * delta

	if ray_cast_2d.is_colliding():
		var collider = ray_cast_2d.get_collider()
		print('bounce')
		
		var normal = ray_cast_2d.get_collision_normal()
		var new_direction = direction.bounce(normal)
		rotation = new_direction.angle()

		var new_color = combine_colors(polygon_2d.modulate, collider.color)
		polygon_2d.modulate = new_color
		
		
		# new particle colors
		current_particles.emitting = false
		var new_particles = current_particles.duplicate()
		add_child(new_particles)
		current_particles.process_material = new_particles.process_material.duplicate()
		new_particles.process_material.color = new_color
		new_particles.emitting = true
		
		
		#gpu_particles_2d.process_material = gpu_particles_2d.process_material.duplicate()
		#gpu_particles_2d.process_material.color = new_color
		
	else:
		global_position += motion
		distance_traveled += motion.length()
	
func combine_colors(old_color: Color, new_color: Color):
	if old_color == Color(1.0, 1.0, 1.0, 1.0):
		return Color.from_hsv(new_color.h, 1, 1)
	
	var h1 = old_color.h
	var h2 = new_color.h
	
	# If the distance between hues is > 0.5, the "shortest path" 
	# goes through Red. We want the "long path" to get Green.
	if abs(h1 - h2) > 0.5:
		if h1 > h2: h2 += 1.0
		else: h1 += 1.0
		
	var mixed_hue = fmod((h1 + h2) / 2.0, 1.0)
	return Color.from_hsv(mixed_hue, 1.0, 1.0)
