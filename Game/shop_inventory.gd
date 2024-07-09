extends Node2D

#Will duplicate shop stands to fill store, stored in array. Also holds the inventory of items in stock.

@export var item_arr:Array[Item] = []

@onready var inventory_slot = $InventorySlot
@onready var shop_stand = $ShopStand
@onready var resource_preloader = $ResourcePreloader
@onready var inv_size_x = 4
@onready var inv_size_y = 4
@onready var amt_stands = 6
@onready var inv_arr = []
@onready var visible_inv_arr = []
@onready var stand_arr = []
@onready var stand_pos_arr = []
@onready var rng = RandomNumberGenerator.new()

signal display_item(item)

var selected_stand = null
var shopping_list = []
var shopping_list_ptr = 0
var select_num = 0

func inputs(delta):
	if Input.is_action_just_pressed("Left"):
		change_selected(-1)
	if Input.is_action_just_pressed("Right"):
		change_selected(1)
	if Input.is_action_just_pressed("Up"):
		change_selected(-inv_size_y)
	if Input.is_action_just_pressed("Down"):
		change_selected(inv_size_y)
	if Input.is_action_just_pressed("Place") and selected_stand:
		place_item(select_num)
	if Input.is_action_just_pressed("Back"):
		close_inventory()

func create_inventory():
	for i in range(inv_size_y):
		var new_y = inventory_slot.position.y + i*15
		for j in range(inv_size_x):
			var new_x = inventory_slot.position.x + j*15
			var new_slot = inventory_slot.duplicate()
			new_slot.position = Vector2(new_x, new_y)
			new_slot.visible = true
			add_child(new_slot)
			inv_arr.append(new_slot)
			visible_inv_arr.append(new_slot.item.texture)
	for k in range(item_arr.size()):
		inv_arr[k].change_item(resource_preloader.get_resource(item_arr[k].name))
	print("inv created")

func create_stands():
	for i in range(stand_pos_arr.size()):
		var new_stand = shop_stand.duplicate()
		new_stand.position = stand_pos_arr[i]
		new_stand.visible = true
		add_child(new_stand)
		stand_arr.append(new_stand)
	Global.stand_arr = stand_arr
		#print(new_stand.position)
	#print(stand_pos_arr)
	#print(stand_arr)

func change_selected(num):
	inv_arr[select_num].is_selected = false
	if select_num + num >= 0 and select_num + num < inv_size_x * inv_size_y:
		select_num += num
	if num == 1 and select_num%4 == 0:
		select_num -= 1
	if num == -1 and (select_num-3)%4 == 0 and select_num != 0:
		select_num += 1
	inv_arr[select_num].is_selected = true

func place_item(inv_arr_ind):
	if selected_stand.item.name != "Empty":
		inv_arr[select_num].change_item(selected_stand.item)
		selected_stand.change_item(Global.empty)
	else:
		var new_item = inv_arr[inv_arr_ind].item
		selected_stand.change_item(new_item)
		inv_arr[inv_arr_ind].change_item(Global.empty)
	#inv_arr[inv_arr_ind].change_item(resource_preloader.get_resource("Empty"))

func find_empty_slot():
	for i in range(inv_arr.size()):
		if inv_arr[i].item.name == "Empty":
			return i

func close_inventory():
	Global.state = "MOVE"

func set_up():
	create_inventory()
	change_selected(0)
	create_stands()
	Global.empty = resource_preloader.get_resource("Empty")

func get_stand_items():
	var stand_item_arr = []
	for i in range(stand_arr.size()):
		if stand_arr[i].item.name != "Empty":
			stand_item_arr.append(stand_arr[i].item)
	return stand_item_arr

func get_item_resouce_arr(str_arr):
	var ret_arr = []
	for res_str in str_arr:
		if typeof(res_str) != TYPE_STRING:
			ret_arr.append(res_str)
		else:
			ret_arr.append(resource_preloader.get_resource(res_str))
	return ret_arr

func cmp_item_arrs(arr1, arr2):
	var same_lst = []
	var diff_lst = []
	for item1 in arr1:
		if item1 in arr2:
			same_lst.append(item1)
		else:
			diff_lst.append(item1)
	return [same_lst, diff_lst]

func random_item_lst(): #Probability: Stand items, Cost to reputation
	var lst = get_item_resouce_arr(resource_preloader.get_resource_list())
	var new_item_lst = []
	for i in range(4):
		var type = "Food" #CHANGE
		var rand = rng.randi_range(0, lst.size()-1)
		new_item_lst.append(lst[rand])
	print(new_item_lst, self)
	return new_item_lst

func create_shopping_list(customer_arr): #For random stand items, each customer takes a chance at buying it, wallet first, rarity 2nd
	var stand_items = get_stand_items()
	var highlighted = []
	for a in range(0, 3):
		highlighted.append(stand_arr[a].item)
	for i in range(customer_arr.size()):
		for j in range(stand_items.size()): #For each item in stand, 
			var prob = rng.randf_range(0, 1)
			if prob < calc_item_buy_chance(stand_items[j], customer_arr[i], highlighted):
				shopping_list.append(j)
				#print(stand_items[j])
				continue
	if shopping_list.size() > 0:
		emit_signal("display_item", stand_arr[shopping_list[0]].item)
	else:
		Global.state = "MOVE"

func calc_item_buy_chance(item, customer, highlighted):
	var start_chance = 1.0
	var mult = customer.npc_res.status*4
	var wallet = rng.randi_range(1 + mult, 4 + mult)*150
	var prob = start_chance
	if item.cost >= wallet*1.2:
		return 0
	for pref_item in customer.npc_res.preferred_items:
		if item == pref_item:
			prob += 0.2
			continue
	var div = item.rarity + 1
	return prob/div

func sort_by_rarity():
	pass

func _on_map_manager_set_up_done(pos_arr, floor_arr):
	stand_pos_arr = pos_arr

func _on_player_place_item(collided):
	Global.state = "INVENTORY"
	selected_stand = collided

func _on_npc_manager_request_items(customer_arr):
	create_shopping_list(customer_arr)

func _on_negotiate_screen_item_sold(item, cost):
	print("SOLD")
	if shopping_list.size() > shopping_list_ptr+1:
		shopping_list_ptr += 1
		emit_signal("display_item", stand_arr[shopping_list[shopping_list_ptr]].item)
	else:
		print("DONE")
