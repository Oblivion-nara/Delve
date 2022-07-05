extends Node2D

onready var stairs = $Stairs
onready var doorLeft = $Doors/DoorLeft
onready var doorRight = $Doors/DoorRight

var connections = {
	"up": false,
	"left": false,
	"right": false,
	"down": false
}
var gridPosition = Vector2.ZERO
#var tileState = null

func _ready():
	fade_in()

func fade_in():
	var fadeInTime = 0.5 # seconds
	var delay = 0.05
	while self.modulate[3] < 1:
		self.modulate[3] = min(self.modulate[3]+delay/fadeInTime,1)
		yield(get_tree().create_timer(delay), "timeout")
