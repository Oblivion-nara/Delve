extends Node2D

onready var roomObject = preload("res://Objects/Tile.tscn")

onready var world = $TileMap
onready var rooms = $Rooms
onready var exploreArrows = $ControlArrows
#onready var buildUI = $HUD/HBoxContainer/Abilities/Build
#onready var tradeUI = $HUD/HBoxContainer/Abilities/Trade
#onready var turnCounter = $HUD/HBoxContainer/Turns
#onready var tileSize = world.cell_size.x
onready var resourcesUI = $HUD/HBoxContainer/Resources
onready var materialsUI = resourcesUI.find_node("Materials")
onready var toolsUI = resourcesUI.find_node("Tools")
onready var output = resourcesUI.find_node("Output")

# click detection stuff
var pressedTile
var selectedTile
var selectedRoom

var heightLimit = 1
var rightLimit = 5
var leftLimit = -5
var depthLimit = 20

var rng = RandomNumberGenerator.new()

# I think we should add more resources at lower depths, otherwise there's no real need to go deeper
var turn = 0
var numberOfRooms = 0 # not sure why this would be useful but it's here
var materials = 20 setget mats_set, mats_get
var materialsLimit = 50
var tools = 20 setget tools_set, tools_get
var toolsLimit = 50
#var canExplore = true
#var canTrade = true


func _ready(): # begin by building the starting room
	rng.randomize()
	explore_tile(Vector2(0,0), null)
#	canExplore = true

func mats_set(new_value):
	materials = min(new_value,materialsLimit)
	materialsUI.text = ("Materials\n" + str(materials) + "/" + str(materialsLimit))

func mats_get():
	return materials

func tools_set(new_value):
	tools = min(new_value,toolsLimit)
	toolsUI.text = ("Tools\n" + str(tools) + "/" + str(toolsLimit))

func tools_get():
	return tools


func _unhandled_input(event):
	# This section makes it so that you have to press and release your mouse button on the same tile to select it
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true: # get click
			pressedTile = convert_to_room(get_global_mouse_position()) # get_global_m... is used because event.position gets messed up by a moving camera
			if pressedTile != selectedTile: # if you click off your selected tile
				remove_explore_arrows()
		elif event.button_index == BUTTON_LEFT and event.pressed == false: # or get release
			if convert_to_room(get_global_mouse_position()) == pressedTile: # compare released tile to clicked tile
				selectedTile = pressedTile
				pressedTile = null
				selectedRoom = get_room_object(selectedTile)
				if selectedRoom:
					place_explore_arrows(selectedRoom)
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("ui_select"):
		pass
#		end_turn()

func convert_to_room(worldCoords): # (Vector2 world coords) You could definitely use a simple formula for these instead of TileMap functions, but i don't want to
	var newCoords = world.world_to_map(worldCoords - world.global_position)
	return newCoords

func convert_to_world(roomCoords): # (Vector2 tile coords)
	var newCoords = world.map_to_world(roomCoords) + world.global_position + world.cell_size / 2
	return newCoords

func get_room_object(tileCoords):
	for n in rooms.get_children():
		if n.name == str(tileCoords):
			return n
	return null


func place_explore_arrows(room): # (room object) place the explore arrows around a selected room
	#if canExplore:
	exploreArrows.position = room.position
	exploreArrows.set_visibility(get_adjacent_tiles(selectedTile),selectedTile)

func remove_explore_arrows(): # make the explore arrows invisible again
	exploreArrows.set_visibility([null,null,null,null],null)


func explore_tile(newPos, oldPos): # (Vector2 tile coords, Vector2 tile coords) explore the tile at new tileMap coordinates and connect it to old tileMap coordinates
	print ("Exploring tile at " + str(newPos) + " from tile " + str(oldPos))
	var newRoom = roomObject.instance()
	newRoom.global_position = convert_to_world(newPos)
	rooms.add_child(newRoom)
	newRoom.name = str(newPos)
	newRoom.gridPosition = newPos
	
	var discover = 0 # Decide what you find when exploring a new tile
	if newPos.y<2:
		discover = rng.randi_range(0,2)
	else:
		discover = rng.randi_range(0,4)
	if discover == 1:
		#You find materials
		var n = rng.randi_range(1,13)
		print ("found " + str(n) + " materials")
		self.materials += n
	elif discover == 2:
		#You find tools
		var n = rng.randi_range(1,13)
		print ("found " + str(n) + " tools")
		self.tools += n
	elif discover == 3:
		#Environmental encounter
		print ("found environmental encounter")
		pass
	elif discover == 4:
		#Combat encounter
		print ("found combat encounter")
		pass
	
	if oldPos != null:
		var oldRoom = get_room_object(oldPos)
		if newPos.y > oldPos.y:
			newRoom.stairs.visible = true
			newRoom.connections.up = true
			oldRoom.connections.down = true
		elif newPos.y < oldPos.y:
			oldRoom.stairs.visible = true
			newRoom.connections.down = true
			oldRoom.connections.up = true
		elif newPos.x < oldPos.x:
			newRoom.doorRight.visible = true
			oldRoom.doorLeft.visible = true
			newRoom.connections.right = true
			oldRoom.connections.left = true
		elif newPos.x > oldPos.x:
			newRoom.doorLeft.visible = true
			oldRoom.doorRight.visible = true
			newRoom.connections.left = true
			oldRoom.connections.right = true
		numberOfRooms += 1
#	end_turn()
#	canExplore = false
#	buildUI.text = "Build\nUnavailable"

func remove_room(pos): # (Vector2 tile coords) delete room and remove connections from adjacent rooms
	pass

func build_connection(newPos, OldPos, direction): # create a doorway between two already existing rooms
	var newRoom = get_room_object(Vector2(newPos))
	var oldRoom = get_room_object(Vector2(OldPos))
	
	if direction == "up":
		oldRoom.connections.up = true
		newRoom.connections.down = true
		oldRoom.stairs.visible = true
	elif direction == "left":
		oldRoom.connections.left = true
		newRoom.connections.right = true
		oldRoom.doorLeft.visible = true
		newRoom.doorRight.visible = true
	elif direction == "right":
		oldRoom.connections.right = true
		newRoom.connections.left = true
		oldRoom.doorRight.visible = true
		newRoom.doorLeft.visible = true
	elif direction == "down":
		oldRoom.connections.down = true
		newRoom.connections.up = true
		newRoom.stairs.visible = true
#	canExplore = false
#	buildUI.text = "Build\nUnavailable"

func remove_connection(room1, room2): # (Vector2 tile coords) delete connection between two adjacent rooms
	pass


func is_in_world_limits(pos): # (Vector2 tile coords) check whether some tile coords are within set world limits
	if pos.y >= heightLimit and pos.x >= leftLimit and pos.x <= rightLimit and pos.y <= depthLimit:
		return true
	else:
		return false


func get_adjacent_tiles(tile): # (Vector2 tile coords) get the tiles adjacent to the selected tileMap coordinates
	var adjacents = [null, null, null, null]
	adjacents[0] = Vector2(tile.x,tile.y-1)
	adjacents[1] = Vector2(tile.x-1,tile.y)
	adjacents[2] = Vector2(tile.x+1,tile.y)
	adjacents[3] = Vector2(tile.x,tile.y+1)
	return adjacents # [Vector2, Vector2, Vector2, Vector2]

func get_adjacent_rooms(tiles): # (array of Vector2 tile coords) check if there are rooms in the tiles adjacent to the selected tileMap coordinates
	var adjacents = [null, null, null, null]
	if rooms:
		for n in rooms.get_children():
			if str(tiles[0]) == str(n.name):
				adjacents[0] = n
			elif str(tiles[1]) == str(n.name):
				adjacents[1] = n
			elif str(tiles[2]) == str(n.name):
				adjacents[2] = n
			elif str(tiles[3]) == str(n.name):
				adjacents[3] = n
	return adjacents # [object, object, object, object]


#func end_turn():
#	remove_explore_arrows()
##	canExplore = true
#	buildUI.text = "Build\nAvailable"
#	turn += 1
#	turnCounter.text = "Turn: " + str(turn)
