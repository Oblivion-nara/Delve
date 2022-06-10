extends Area2D


export var value:int = 10
onready var rotation_speed : float = log(min(20,value/5)+2)*180

func _process(delta):
	rotation_degrees += rotation_speed * delta
	print(rotation_speed/180)

func _on_Coin_body_entered(body):
	if body.name == "Player":
		body.collect_coin(value)
		queue_free()
