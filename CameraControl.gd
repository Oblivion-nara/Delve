extends Camera2D


onready var player = get_node("/root/MainScene/Player")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = player.position.x
