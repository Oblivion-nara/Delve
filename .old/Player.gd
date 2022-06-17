extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


var score : int = 0
var speed : int = 18500
var jumpforce : int = 1000
var gravity : int = 3000
var vel : Vector2 = Vector2()

onready var sprite : Sprite = get_node("Sprite")

func _ready():
	pass
	
func _process(delta):
	pass
	
func _physics_process(delta):
	
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	var jump = Input.is_action_pressed("jump")
	vel.x = 0
	if left:
		vel.x += speed*delta
	if right:
		vel.x -= speed*delta
	
	vel = move_and_slide(vel,Vector2.UP)
	
	vel.y += gravity * delta
	if jump && is_on_floor():
		vel.y -= jumpforce
	
	if vel.x < 0:
		sprite.flip_h = true
	if vel.x > 0:
		sprite.flip_h = false

func collect_coin(value):
	score += value

func kill():
	get_tree().reload_current_scene()
