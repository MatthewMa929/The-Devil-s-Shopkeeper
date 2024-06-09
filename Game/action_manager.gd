extends Node2D

#For 2D nodes, manages actions.

@onready var shop_inventory = $ShopInventory
@onready var player = $Player
@onready var npc_manager = $NPCManager

func _physics_process(delta):
	if Global.state == "INVENTORY":
		shop_inventory.inputs(delta)
	if Global.state == "MOVE":
		player.inputs(delta)

func set_up():
	shop_inventory.set_up()
	npc_manager.set_up()
