extends Node2D

#Will duplicate shop stands to fill store, stored in array. Also holds the inventory of items in stock.

@export var items:Array[Item] = []

@onready var inventory_slot = $InventorySlot
@onready var inv_size_x = 4
@onready var inv_size_y = 4
@onready var inv_arr = [inventory_slot]

func _ready():
	for i in range(inv_size_x):
		var new_x = inventory_slot.position.x + i*15
		for j in range(inv_size_y):
			var new_y = inventory_slot.position.y - j*15
			var new_slot = inventory_slot.duplicate(true)
			inv_arr.append(new_slot)
			new_slot.position = Vector2(new_x, new_y)
			add_child(new_slot)
