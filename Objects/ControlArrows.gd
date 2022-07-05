extends Node2D

onready var buildUp = $Explore/ArrowUp
onready var buildLeft = $Explore/ArrowLeft
onready var buildRight = $Explore/ArrowRight
onready var buildDown = $Explore/ArrowDown

onready var connectUp = $Connect/ArrowUp
onready var connectLeft = $Connect/ArrowLeft
onready var connectRight = $Connect/ArrowRight
onready var connectDown = $Connect/ArrowDown

onready var delete = $Delete

var selectedRoom
var selectedTile = Vector2.ZERO

func _ready():
	set_visibility([null,null,null,null],null)
	pass

func set_visibility(directions, selected): # (array of Vector2 tile coords, Vector2 selected tile coords)
	if selected != null:
		selectedRoom = get_parent().get_room_object(selected)
	else:
		selectedRoom = null
	var adjacentRooms = get_parent().get_adjacent_rooms(directions)
	
	if !directions[0]: # make the button invisible if you get sent null
		buildUp.visible = false
		connectUp.visible = false
	elif get_parent().is_in_world_limits(directions[0]): # otherwise, check if the recieved coords are in the world limits
		if !adjacentRooms[0]: # if there's no room, show the explore button
			buildUp.visible = true
		else: # otherwise, check if the selected room is already connected to the adjacent room
			if !adjacentRooms[0].connections.down:
				connectUp.visible = true
	
	if !directions[1]:
		buildLeft.visible = false
		connectLeft.visible = false
	elif get_parent().is_in_world_limits(directions[1]):
		if !adjacentRooms[1]:
			buildLeft.visible = true
		else:
			if !adjacentRooms[1].connections.right:
				connectLeft.visible = true
	
	if !directions[2]:
		buildRight.visible = false
		connectRight.visible = false
	elif get_parent().is_in_world_limits(directions[2]):
		if !adjacentRooms[2]:
			buildRight.visible = true
		else:
			if !adjacentRooms[2].connections.left:
				connectRight.visible = true
	
	if !directions[3]:
		buildDown.visible = false
		connectDown.visible = false
	elif get_parent().is_in_world_limits(directions[3]):
		if !adjacentRooms[3]:
			buildDown.visible = true
		else:
			if !adjacentRooms[3].connections.up:
				connectDown.visible = true
	
#	if selectedRoom:
#		delete.visible = true
#	else:
#		delete.visible = false
	selectedTile = selected

func _on_ExploreUp_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_parent().explore_tile(Vector2(selectedTile.x,selectedTile.y-1), selectedTile)
			get_parent().remove_explore_arrows()

func _on_ExploreLeft_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_parent().explore_tile(Vector2(selectedTile.x-1,selectedTile.y), selectedTile)
			get_parent().remove_explore_arrows()

func _on_ExploreRight_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_parent().explore_tile(Vector2(selectedTile.x+1,selectedTile.y), selectedTile)
			get_parent().remove_explore_arrows()

func _on_ExploreDown_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_parent().explore_tile(Vector2(selectedTile.x,selectedTile.y+1), selectedTile)
			get_parent().remove_explore_arrows()


func _on_ConnectUp_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_parent().build_connection(Vector2(selectedTile.x,selectedTile.y-1), selectedTile, "up")
			get_parent().remove_explore_arrows()


func _on_ConnectLeft_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_parent().build_connection(Vector2(selectedTile.x-1,selectedTile.y), selectedTile, "left")
			get_parent().remove_explore_arrows()


func _on_ConnectRight_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_parent().build_connection(Vector2(selectedTile.x+1,selectedTile.y), selectedTile, "right")
			get_parent().remove_explore_arrows()


func _on_ConnectDown_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_parent().build_connection(Vector2(selectedTile.x,selectedTile.y+1), selectedTile, "down")
			get_parent().remove_explore_arrows()
