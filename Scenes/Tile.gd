extends Node2D

var isRoom = false
var isDoorLeft = false
var isDoorRight = false
var isStairs = false
var currentLevel = 1

onready var game = get_parent().get_parent()

onready var arrowLeft = $Arrows/ArrowLeft
onready var arrowRight = $Arrows/ArrowRight
onready var arrowDown = $Arrows/ArrowDown
onready var control = $Control

onready var room = $Room
onready var doorLeft = $Doors/DoorLeft
onready var doorRight = $Doors/DoorRight
onready var stairs = $Stairs

func _ready():
	update()

func update():
	arrowLeft.visible = false
	arrowRight.visible = false
	arrowDown.visible = false
	
	if isRoom:
		room.visible = true
		control.visible = true
	else:
		room.visible = false
		control.visible = false

	if isDoorLeft:
		doorLeft.visible = true
	else:
		doorLeft.visible = false

	if isDoorRight:
		doorRight.visible = true
	else:
		doorRight.visible = false

	if isStairs:
		stairs.visible = true
	else:
		stairs.visible = false

func show_arrows():
	var adjacent = get_adjacent()
	if adjacent[1] != null and !adjacent[1].isDoorRight:
		arrowLeft.visible = true
		doorLeft.visible = false
	else:
		arrowLeft.visible = false
	
	if adjacent[2] != null and !adjacent[2].isDoorLeft:
		arrowRight.visible = true
		doorRight.visible = false
	else:
		arrowRight.visible = false
	
	if adjacent[3] != null and !adjacent[3].isStairs:
		arrowDown.visible = true
	else:
		arrowDown.visible = false

func get_adjacent(): # get the tiles adjacted to this tile
	var adjacent = []
	var offsets = [
		(Vector2.UP) * 64, #0
		(Vector2.LEFT) * 64,  #1
		(Vector2.RIGHT) * 64, #2
		(Vector2.DOWN) * 64   #3
	]
	for offset in offsets:
		var found = false
		for tile in game.map:
			if is_instance_valid(tile):
				if tile.position == position + offset:
					adjacent.append(tile)
					found = true
		if !found:
			adjacent.append(null)
	return adjacent

func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click") and isRoom and get_parent().get_parent().build:
			show_arrows()

func _on_ControlLeft_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click") and isRoom:
			var adjacent = get_adjacent()
			if adjacent[1] != null:
				adjacent[1].isRoom = true
				adjacent[1].isDoorRight = true
				isDoorLeft = true
				adjacent[1].update()
				build()
			update()

func _on_ControlRight_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click") and isRoom:
			var adjacent = get_adjacent()
			if adjacent[2] != null:
				adjacent[2].isRoom = true
				adjacent[2].isDoorLeft = true
				isDoorRight = true
				adjacent[2].update()
				build()
			update()

func _on_ControlDown_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click") and isRoom:
			var adjacent = get_adjacent()
			if adjacent[3] != null:
				adjacent[3].isRoom = true
				adjacent[3].isStairs = true
				adjacent[3].update()
				
				build()
			update()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click") and isRoom:
			var x = get_global_mouse_position().x
			var y = get_global_mouse_position().y
			if (x < position.x-32 or x > position.x+31) or (y < position.y-32 or y > position.y+31):
				yield(get_tree().create_timer(0.01), "timeout")
				update()

func set_texture(t):
	$Dirt.texture = t

func build():
	get_parent().get_parent().build = false
	get_parent().get_parent().buildUI.text = "Build\nUnavailable"
