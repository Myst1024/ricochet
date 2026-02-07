extends Label

var score := 0

func _on_node_added(node: Node):
	# Auto-connect to ANY bullet that gets added to the tree
	if node.get_script() and node is Bullet:
		if node.has_signal("enemy_down"):
			node.enemy_down.connect(add_score)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_score(added_score: int) -> void:
	score += added_score * added_score
	text = 'Score: ' + str(score)
	
