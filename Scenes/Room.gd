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
var tile = Vector2.ZERO

func _ready():
	pass 
