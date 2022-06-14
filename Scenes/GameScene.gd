extends Node2D

onready var tile = preload("res://Scenes/Tile.tscn")
onready var tiles = $Tiles

var mapWidth = 15
var mapHeight = 10
var map

func _ready():
	generate_map()

func generate_map():
	for r in mapHeight:
		for c in mapWidth:
			var t = tile.instance()
			t.position = Vector2(c, r) * 64 + Vector2(64,64)
			tiles.add_child(t)
	map = tiles.get_children()
	
	for i in tiles.get_children():
		var x = mapWidth*0.5+0.5
		if i.position == Vector2(64*x,64):
			i.isRoom = true
			i.isStairs = true
			i.update()
