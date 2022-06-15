extends Node2D

onready var tile = preload("res://Scenes/Tile.tscn")
onready var level2Transition = preload("res://Sprites/dirtTransition1.png")
onready var level3Transition = preload("res://Sprites/dirtTransition2.png")
onready var level2Dirt = preload("res://Sprites/dirt2.png")
onready var level3Dirt = preload("res://Sprites/dirt3.png")
onready var tiles = $Tiles

var mapWidth = 15
var mapHeight = 10
var map

var level2Depth = 3
var level3Depth = 6

func _ready():
	generate_map()

func generate_map():
	for r in mapHeight:
		for c in mapWidth:
			var t = tile.instance()
			t.position = Vector2(c, r) * 64 + Vector2(64,64)
			if r > level3Depth:
				t.set_texture(level3Dirt)
			elif r == level3Depth:
				t.set_texture(level3Transition)
			elif r > level2Depth:
				t.set_texture(level2Dirt)
			elif r == level2Depth:
				t.set_texture(level2Transition)
			tiles.add_child(t)
	map = tiles.get_children()
	
	for i in tiles.get_children():
		var x = mapWidth*0.5+0.5
		if i.position == Vector2(64*x,64):
			i.isRoom = true
			i.isStairs = true
			i.update()
