extends Node2D

#For 2D nodes, manages actions.

@onready var shop_inv = $ShopInventory
@onready var player = $Player
@onready var npc_manager = $NPCManager

signal move_digit(input)

func _ready():
	pass

func _process(delta):
	pass

