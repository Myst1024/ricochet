extends StaticBody2D
class_name ColoredObstacle
class_name ColoredObstacle
var colors = {
	red = Color(0.933, 0.192, 0.275, 1.0), 
	green = Color(0.314, 0.702, 0.255, 1.0), 
	blue = Color(0.153, 0.145, 0.451, 1.0), 
	yellow = Color(1.0, 0.976, 0.443, 1.0),
}

@export var color: Color

func _ready():
	modulate = colors.values().pick_random()
	color = modulate
	
