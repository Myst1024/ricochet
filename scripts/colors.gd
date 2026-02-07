extends Node
class_name Colors

enum ColorOptions { RED, GREEN, BLUE }

const RED := Color(1,0,0)
const GREEN := Color(0,1,0)
const BLUE := Color(0,0,1)

static func from_enum(choice: ColorOptions) -> Color:
	match choice:
		ColorOptions.RED: return RED
		ColorOptions.GREEN: return GREEN
		ColorOptions.BLUE: return BLUE
		_: return RED
