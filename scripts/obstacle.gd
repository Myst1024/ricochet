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

var colors = {
	red = Color(0.933, 0.192, 0.275, 1.0), 
	green = Color(0.314, 0.702, 0.255, 1.0), 
	blue = Color(0.027, 0.0, 0.8, 1.0), 
	yellow = Color(1.0, 0.976, 0.443, 1.0)
}

@export var color: Color = colors.red




func _ready() -> void:
	draw_shape()


func draw_shape():
	if not is_inside_tree():
		return
		
	modulate = color

	var polygonPoints := PackedVector2Array()
	for i in range(sides):
		var point = Vector2.from_angle(TAU * i/sides) * radius
		polygonPoints.push_back(point.snapped(Vector2(.001,.001)))
	$CollisionPolygon2D.polygon = polygonPoints
	$Polygon2D.polygon = polygonPoints
