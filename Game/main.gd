extends Node

#Customer enters, looks at stock, decides to buy or leave, if buy, will stand at item with exclamation mark. Player needs to walk to them and negotiate price.
#Negotiation: If player does not give a suitable price within 2 tries, the buyer will leave. Even if the price is suitable, buyer may haggle anyways.

#Hierarchy:
#ActionManager:
#Shop Inventory: Stand and Inventory, deals with item distribution

@onready var map_manager = $MapManager
@onready var action_manager = $ActionManager
@onready var ui = $UI
@onready var audio_manager = $AudioManager
@onready var background = $Background
@onready var minigame = preload("res://Minigame/minigame.tscn").instantiate()
@onready var current_scene = self

func _ready(): #THE ONLY READY
	map_manager.set_up_shop()
	action_manager.set_up()
	add_child(minigame)
	remove_child(get_node("MapManager"))
	remove_child(get_node("UI"))
	remove_child(get_node("Background"))
	remove_child(get_node("ActionManager"))
	

