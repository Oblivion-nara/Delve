extends Node2D

onready var tile = preload("res://Scenes/Tile.tscn")

onready var level2Transition = preload("res://Sprites/dirtTransition1.png")
onready var level3Transition = preload("res://Sprites/dirtTransition2.png")
onready var level2Dirt = preload("res://Sprites/dirt2.png")
onready var level3Dirt = preload("res://Sprites/dirt3.png")
onready var startingRoom = preload("res://Sprites/bigRoom.png")

onready var tiles = $Tiles
onready var turnCounter = $CanvasLayer/HBoxContainer/EndTurnButton/Turns
onready var matsUI = $CanvasLayer/HBoxContainer/Resources/Materials
onready var toolsUI = $CanvasLayer/HBoxContainer/Resources/Tools
onready var buildUI = $CanvasLayer/HBoxContainer/Abilities/Build
onready var tradeUI = $CanvasLayer/HBoxContainer/Abilities/Trade

var mapWidth = 16
var mapHeight = 10
var level2Depth = 2
var level3Depth = 5
var map
var turn = 1

var materials = 20
var tools = 20

var build = true
var trade = true

var tilesize = 64
onready var camera = get_node("Camera2D")

func _ready():
	generate_map()
	write_text()
	camera.set_scene(self)
	

func generate_map():
	for r in mapHeight:
		for c in mapWidth:
			var t = tile.instance()
			t.position = Vector2(c, r) * tilesize + Vector2(tilesize/2.0,128)
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
		if i.position == Vector2(tilesize*x,128):
			i.isRoom = true
			i.isStairs = true
			i.update()
			var s = Sprite.new()
			self.add_child(s)
			s.texture = startingRoom
			s.global_position = i.position + Vector2(0,-tilesize/2.0)

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
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("ui_select"):
		end_turn()

func write_text():
	var i = $Info
	while i.percent_visible < 1:
		i.percent_visible += 0.01
		yield(get_tree().create_timer(0.01), "timeout")
