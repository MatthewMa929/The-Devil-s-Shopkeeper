extends Node2D

@onready var rng = RandomNumberGenerator.new()
@onready var scrap_map = $ScrapMap
@onready var obj_spr = $ObjectSprite
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
			reveal_object(mouse_vectori)

func reveal_object(vectori):
	for i in range(enemy_arr.size()):
		if enemy_arr[i].pos == vectori:
			set_sprite_to_tilemap_pos(enemy_arr[i])
	for j in range(item_arr.size()):
		if item_arr[j].pos == vectori:
			set_sprite_to_tilemap_pos(item_arr[j])

func create_vectori(vector):
	if vector.y < y_offset:
		return Vector2i(-1, -1)
	return Vector2i(vector.x/cell_size, (vector.y-y_offset)/cell_size)

func map_details():
	var scrambled_arr = []
	for y in range(tilemap.size_y):
		for x in range(tilemap.size_x):
			var pos = Vector2i(x+2, y)
			scrambled_arr.append(pos)
	scrambled_arr.shuffle()
	var ptr = create_enemies(scrambled_arr, 0)
	ptr += create_items(scrambled_arr, ptr)

func create_enemies(scrambled_arr, ptr):
	for i in range(ptr, tilemap.max_enemies):
		if tilemap.enemies.size() > 0:
			var type = rng.randi_range(0, tilemap.enemies.size()-1)
			var new_enemy = tilemap.enemies[type].duplicate()
			new_enemy.pos = scrambled_arr[i]
			enemy_arr.append(new_enemy)
			#set_sprite_to_tilemap_pos(new_enemy)
			ptr += 1
	return ptr

func create_items(scrambled_arr, ptr):
	var item_amt = rng.randi_range(tilemap.item_min, tilemap.item_max)
	for i in range(ptr, item_amt+ptr):
		if tilemap.items.size() > 0:
			var type = rng.randi_range(0, tilemap.items.size()-1)
			var new_item = tilemap.items[type].duplicate()
			new_item.pos = scrambled_arr[i]
			item_arr.append(new_item)
			#set_sprite_to_tilemap_pos(new_item)
			ptr += 1
	return ptr

func set_sprite_to_tilemap_pos(object):
	var spr = obj_spr.duplicate()
	spr.position = Vector2(object.pos.x*32, object.pos.y*32+10)
	spr.texture = object.texture
	add_child(spr)
