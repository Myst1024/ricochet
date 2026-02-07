@tool
extends StaticBody2D
class_name Obstacle

@export var sides := 3:
	set(value):
		sides = value
		draw_shape()
		
@export var radius := 50:
	set(value):
		radius = value
		draw_shape()
		

@export var color: Colors.ColorOptions = Colors.ColorOptions.BLUE

func _ready():
	modulate = Colors.from_enum(color)
	draw_shape()

func draw_shape():
	if not is_inside_tree():
		return
	
	var polygonPoints := PackedVector2Array()
	for i in range(sides):
		var point = Vector2.from_angle(TAU * i/sides) * radius
		polygonPoints.push_back(point.snapped(Vector2(.001,.001)))
	$CollisionPolygon2D.polygon = polygonPoints
	$Polygon2D.polygon = polygonPoints
