extends Node2D

@onready var tilemap = $TileMap
@onready var player = $"../ActionManager/Player"
@onready var cell_size = 32
@onready var offset = Vector2(-16, 0)
@onready var offset_i = Vector2i(-16, 0)
@onready var stand_floor_arr = []
@onready var stand_pos_arr = []

signal set_up_done(pos_arr, floor_arr)

func _physics_process(delta):
	if Input.is_action_just_pressed("Continue") && Global.state == "BUY":
		print(tilemap.get_cell_atlas_coords(0, Vector2i(player.position.x/cell_size, player.position.y/cell_size)))
	if tilemap.get_cell_atlas_coords(0, Vector2i(player.position.x/cell_size, player.position.y/cell_size)) == Vector2i(1, 1) && Input.is_action_just_pressed("Continue") && Global.state == "BUY":
		Global.state = "SELL"
		print("SELL SPACE")

func set_up_shop(): #Need to offset by 16 due to tilemap setup
	for i in range(11):
		for j in range(6):
			var coords = Vector2(i*cell_size, j*cell_size) + offset
			var coords_i = Vector2i(i, j)
			if tilemap.get_cell_atlas_coords(0, coords_i) == Vector2i(1, 0):
				stand_pos_arr.append(coords)
				var coords_left = coords_i + Vector2i(-1, 0)
				var coords_right = coords_i + Vector2i(1, 0)
				var coords_up = coords_i + Vector2i(0, -1)
				var coords_down = coords_i + Vector2i(0, 1)
				var direc_arr = [coords, coords_left, coords_right, coords_up, coords_down]
				#print(direc_arr)
				if is_floor(coords_left):
					stand_floor_arr.append(coords_left*cell_size+offset_i)
				if is_floor(coords_right):
					stand_floor_arr.append(coords_right*cell_size+offset_i)
				if is_floor(coords_down):
					stand_floor_arr.append(coords_down*cell_size+offset_i)
				if is_floor(coords_up):
					stand_floor_arr.append(coords_up*cell_size+offset_i)
	emit_signal("set_up_done", stand_pos_arr, stand_floor_arr)
	Global.stand_floor_arr = stand_floor_arr
	Global.stand_pos_arr = stand_pos_arr

func is_floor(coords_i):
	if tilemap.get_cell_atlas_coords(0, coords_i) == Vector2i(0, 0):
		return true
	return false
