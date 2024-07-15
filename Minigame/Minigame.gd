extends Node2D

@onready var rng = RandomNumberGenerator.new()
@onready var scrap_map = $ScrapMap
@onready var obj_spr = $ObjectSprite
@onready var ui = $MinigameUI
@onready var enemy_placeholder = $EnemyPlaceholder
@onready var tilemap = scrap_map
@onready var y_offset = 10
@onready var cell_size = 32

var total_luck = 0
var enemy_arr = []
var item_arr = []

var row_arr = []
var col_arr = []
var reveal_arr = []
var placeholder_arr = []

func _ready():
	map_details()
	create_stage()
	update_ui()

func _process(delta):
	var mouse_vectori = create_vectori(get_global_mouse_position())
	if Input.is_action_just_pressed("Left Click"):
		if tilemap.get_cell_atlas_coords(0, mouse_vectori) == Vector2i(1, 0):
			var adj_arr = check_adj(mouse_vectori)
			reveal_arr.append([mouse_vectori, adj_arr[0], adj_arr[1]])
			tilemap.set_cell(0, mouse_vectori, 0, Vector2i(0, 0))
			remove_placeholder(mouse_vectori)
			reveal_object(mouse_vectori)
	if Input.is_action_just_pressed("Right Click"):
		if tilemap.get_cell_atlas_coords(0, mouse_vectori) == Vector2i(1, 0) and !remove_placeholder(mouse_vectori):
			var new_placeholder = enemy_placeholder.duplicate()
			new_placeholder.position = create_vector(mouse_vectori)
			add_child(new_placeholder)
			placeholder_arr.append(new_placeholder)

func create_stage():
	create_columns()
	create_rows()

func create_columns():
	var pos = ui.col_text.position + ui.col_container.position
	col_arr = [ui.col_text]
	for i in range(tilemap.size_x-1):
		var new_col_text = ui.col_text.duplicate()
		pos.x += 32
		new_col_text.position = pos
		add_child(new_col_text)
		col_arr.append(new_col_text)

func create_rows():
	var pos = ui.row_text.position + ui.row_container.position
	row_arr = [ui.row_text]
	for i in range(tilemap.size_x-1):
		var new_row_text = ui.row_text.duplicate()
		pos.y += 32
		new_row_text.position = pos
		add_child(new_row_text)
		row_arr.append(new_row_text)

func check_adj(vectori):
	var adj_arr = [Vector2i(vectori[0]-1, vectori[1]), Vector2i(vectori[0]+1, vectori[1]), Vector2i(vectori[0], vectori[1]-1), Vector2i(vectori[0], vectori[1]+1)]
	var adj_enemy_arr = [] #INDEXES
	var adj_item_arr = []
	for a in range(adj_arr.size()):
		var enemy = find_enemy(adj_arr[a])
		var item = find_item(adj_arr[a])
		if enemy:
			adj_enemy_arr.append(enemy)
		if item:
			adj_item_arr.append(item)
		ui.item_label.text = str(adj_item_arr.size())
	return [adj_enemy_arr, adj_item_arr]

func update_ui():
	for i in range(tilemap.size_x):
		var col_amt = 0
		for a in range(enemy_arr.size()):
			if i+2 == enemy_arr[a].pos[0]:
				col_amt += 1
		#for c in range(item_arr.size()):
			#if i+2 == item_arr[c].pos[0]:
				#col_amt += 1
		ui.change_text(col_arr[i], col_amt)
	for j in range(tilemap.size_y):
		var row_amt = 0
		for b in range(enemy_arr.size()):
			if j == enemy_arr[b].pos[1]:
				row_amt += 1
		#for d in range(item_arr.size()):
			#if j == item_arr[d].pos[1]:
				#row_amt += 1
		ui.change_text(row_arr[j], row_amt)

func find_enemy(vectori):
	for i in range(enemy_arr.size()):
		if enemy_arr[i].pos == vectori:
			return i

func find_item(vectori):
	for i in range(item_arr.size()):
		if item_arr[i].pos == vectori:
			return i

func reveal_object(vectori):
	for i in range(enemy_arr.size()):
		if enemy_arr[i].pos == vectori:
			set_sprite_to_tilemap_pos(enemy_arr[i])
	for j in range(item_arr.size()):
		if item_arr[j].pos == vectori:
			set_sprite_to_tilemap_pos(item_arr[j])

func remove_placeholder(vectori):
	for i in range(placeholder_arr.size()):
		if create_vectori(placeholder_arr[i].position) == vectori:
			placeholder_arr[i].queue_free()
			placeholder_arr.remove_at(i)
			return true
	return false

func create_vectori(vector):
	if vector.y < y_offset:
		return Vector2i(-1, -1)
	return Vector2i(vector.x/cell_size, (vector.y-y_offset)/cell_size)

func create_vector(vectori):
	return Vector2(vectori.x*cell_size, (vectori.y*cell_size)+y_offset)

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
			ptr += 1
	return ptr

func set_sprite_to_tilemap_pos(object):
	var spr = obj_spr.duplicate()
	spr.position = Vector2(object.pos.x*32, object.pos.y*32+10)
	spr.texture = object.texture
	add_child(spr)

