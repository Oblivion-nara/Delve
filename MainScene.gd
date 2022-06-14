extends Node2D

var gridSize = 7
var tile = load("res://Tile.tscn")
var projectResolution=Vector2(ProjectSettings.get_setting("display/window/size/width"),ProjectSettings.get_setting("display/window/size/height"))

func _ready():
#	var newtile = tile.instance()
#	newtile.position = Vector2(64,64)
#	add_child(newtile)
#	newtile = tile.instance()
#	add_child(newtile)
	var inst = tile.instance()
	var tilewidth = inst.get_node("Sprite").texture.get_data().get_width()
	var tileheight = inst.get_node("Sprite").texture.get_data().get_height()
	var scalex = inst.get_node("Sprite").scale.x
	var scaley = inst.get_node("Sprite").scale.y
	var tileswide = (projectResolution.x-1) / (tilewidth *scalex)+1
	var tileshigh = (projectResolution.y-1) / (tileheight*scaley)+1
	inst.queue_free()
	for i in range(tileswide):
		for j in range(tileshigh):
			var newtile = tile.instance()
			newtile.position = Vector2((i+0.5)*tilewidth*scalex,(j+0.5)*tileheight*scaley)
			add_child(newtile)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

#func _process(delta):
#	if Input.is_action_pressed("ui_cancel"):
#		get_tree().quit()
