extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var speed := 600
@export var max_range := 1000.0
var distance_traveled  := 0.0
var last_object_hit: Object = null

func _physics_process(delta: float) -> void:
	if distance_traveled > max_range:
		queue_free()
		
		
	var direction = Vector2.RIGHT.rotated(rotation)
	var motion = direction * speed * delta
		
	if ray_cast_2d.is_colliding():
		print('bounce')
		
		## avoid double bounces
		last_object_hit = ray_cast_2d.get_collider()
		ray_cast_2d.add_exception(last_object_hit)
		
		var normal = ray_cast_2d.get_collision_normal()
		var new_direction = direction.bounce(normal)
		rotation = new_direction.angle()

	else:
		global_position += motion
		distance_traveled += motion.length()
	
