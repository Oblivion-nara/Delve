extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


export var speed: int = 250
export var movedist : int = 384

onready var startX : int = position.x
onready var targetX : int = position.x + movedist

func move_to(current, to, step):
	var new = current
	if new < to:
		new += step
		if new > to:
			new = to
	else:
		new -= step
		if new < to:
			new = to
	return new

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = move_to(position.x,targetX,speed*delta)
	if position.x == targetX:
		if targetX == startX:
			targetX = startX+movedist
		else:
			targetX = startX


func _on_Enemy_body_entered(body):
	if body.name == "Player":
		body.kill()
