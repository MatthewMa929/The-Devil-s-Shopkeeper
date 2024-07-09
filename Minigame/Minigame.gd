extends Node2D

@onready var tilemap = $TileMap
@onready var y_offset = 10
@onready var cell_size = 32

func _ready():
	pass
	#create_stage()

func _process(delta):
	if Input.is_action_just_pressed("Left Click"):
		var mouse_vectori = create_vectori(get_global_mouse_position())
		if tilemap.get_cell_atlas_coords(0, mouse_vectori) == Vector2i(1, 0):
			tilemap.set_cell(0, mouse_vectori, 0, Vector2i(0, 0))

func create_vectori(vector):
	if vector.y < y_offset:
		return Vector2i(-1, -1)
	return Vector2i(vector.x/cell_size, (vector.y-y_offset)/cell_size)
