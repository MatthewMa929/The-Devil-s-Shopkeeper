extends Node2D

@onready var rng = RandomNumberGenerator.new()
@onready var scrap_map = $ScrapMap
@onready var tilemap = scrap_map
@onready var y_offset = 10
@onready var cell_size = 32

var total_luck = 0
var enemy_arr = []
var item_arr = []

func _ready():
	map_details()
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

func map_details():
	var scrambled_arr = []
	for y in range(tilemap.size_y):
		for x in range(tilemap.size_x):
			var pos = Vector2i(x, y)
			scrambled_arr.append(pos)
	scrambled_arr.shuffle()
	create_enemies(scrambled_arr)

func create_enemies(scrambled_arr):
	for i in range(tilemap.max_enemies):
		if tilemap.enemies.size() > 0:
			var type = rng.randi_range(0, tilemap.enemies.size()-1)
			var new_enemy = tilemap.enemies[type].duplicate()
			new_enemy.pos = scrambled_arr[i]
			enemy_arr.append(new_enemy)

func set_to_tilemap_pos(object):
	pass
