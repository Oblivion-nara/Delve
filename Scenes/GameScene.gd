extends Node2D

onready var tile = preload("res://Scenes/Tile.tscn")
onready var level2Transition = preload("res://Sprites/dirtTransition1.png")
onready var level3Transition = preload("res://Sprites/dirtTransition2.png")
onready var level2Dirt = preload("res://Sprites/dirt2.png")
onready var level3Dirt = preload("res://Sprites/dirt3.png")
onready var tiles = $Tiles
onready var turnCounter = $CanvasLayer/EndTurnButton/Turns
onready var matsUI = $CanvasLayer/Resources/Materials
onready var toolsUI = $CanvasLayer/Resources/Tools
onready var buildUI = $CanvasLayer/Abilities/Build
onready var tradeUI = $CanvasLayer/Abilities/Trade

var mapWidth = 15
var mapHeight = 10
var level2Depth = 3
var level3Depth = 6
var map
var turn = 1

var materials = 20
var tools = 20

var build = true
var trade = true

func _ready():
	generate_map()
	write_text()

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

func end_turn():
	build = true
	buildUI.text = "Build\nAvailable"
	trade = true
	tradeUI.text = "Trade\nAvailable"
	
	turn += 1
	turnCounter.text = "Turn: " + str(turn)
	for x in $Tiles.get_children():
		x.update()

func _input(event):
	if event.is_action_pressed("ui_select"):
		end_turn()

func write_text():
	var i = $Info
	while i.percent_visible < 1:
		i.percent_visible += 0.01
		yield(get_tree().create_timer(0.01), "timeout")
