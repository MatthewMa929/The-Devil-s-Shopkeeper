extends Node2D

#For 2D nodes, manages actions.

@onready var shop_inv = $ShopInventory
@onready var player = $Player
@onready var npc_manager = $NPCManager

func _process(delta):
	pass

func set_up():
	shop_inv.create_stands()
