extends Node2D

#Will duplicate shop stands to fill store, stored in array. Also holds the inventory of items in stock.

@export var items:Array[Item] = []

@onready var inventory_slot = $InventorySlot
@onready var shop_stand = $ShopStand
@onready var inv_size_x = 4
@onready var inv_size_y = 4
@onready var inv_arr = []

var select_num = 0

func _ready():
	create_inventory()
	change_selected(0)

func _process(delta):
	if Global.state == "INVENTORY":
		if Input.is_action_just_pressed("Left"):
			change_selected(-inv_size_x)
		if Input.is_action_just_pressed("Right"):
			change_selected(inv_size_x)
		if Input.is_action_just_pressed("Up"):
			change_selected(1)
		if Input.is_action_just_pressed("Down"):
			change_selected(-1)
		
		if Input.is_action_just_pressed("Continue"):
			place_item()

func change_selected(num):
	inv_arr[select_num].is_selected = false
	if select_num + num >= 0 and select_num + num < inv_size_x * inv_size_y:
		select_num += num
	if num == 1 and select_num%4 == 0:
		select_num -= 1
	if num == -1 and (select_num-3)%4 == 0 and select_num != 0:
		select_num += 1
	inv_arr[select_num].is_selected = true
	print(select_num)

func place_item():
	pass

func create_inventory():
	for i in range(inv_size_x):
		var new_x = inventory_slot.position.x + i*15
		for j in range(inv_size_y):
			var new_y = inventory_slot.position.y - j*15
			var new_slot = inventory_slot.duplicate()
			new_slot.position = Vector2(new_x, new_y)
			new_slot.visible = true
			add_child(new_slot)
			inv_arr.append(new_slot)
