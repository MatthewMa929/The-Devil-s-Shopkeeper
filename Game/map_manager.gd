extends Node2D

@onready var tilemap = $TileMap
@onready var cell_size = 32
@onready var offset = Vector2(-16, 0)
@onready var offset_i = Vector2i(-0.5, 0)
@onready var stand_floor_arr = []
@onready var stand_pos_arr = []

signal set_up_done(pos_arr)

func _ready():
	pass

func set_up_shop(): #Need to offset by 16 due to tilemap setup
	for i in range(11):
		for j in range(6):
			var coords = Vector2(i*cell_size, j*cell_size) + offset
			var coords_i = Vector2i(i, j) + offset_i
			if tilemap.get_cell_atlas_coords(0, coords_i) == Vector2i(1, 0):
				stand_pos_arr.append(coords)
				emit_signal("create_stand", coords)
				if is_floor(coords_i + Vector2i(1, 0)):
					stand_floor_arr.append(coords)
				if is_floor(coords_i + Vector2i(-1, 0)):
					stand_floor_arr.append(coords)
				if is_floor(coords_i + Vector2i(0, 1)):
					stand_floor_arr.append(coords)
				if is_floor(coords_i + Vector2i(0, -1)):
					stand_floor_arr.append(coords)
	emit_signal("set_up_done", stand_pos_arr)

func is_floor(coords_i):
	if tilemap.get_cell_atlas_coords(0, coords_i) == Vector2i(0, 0):
		return true
	return false
