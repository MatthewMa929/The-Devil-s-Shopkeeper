extends Node2D

#Manages the NPCs

@export var customer_arr:Array[Customer] = []

@onready var resource_preloader = $ResourcePreloader
@onready var npc = $NPC
var max_customer_amt = 0
var customer_amt = 0
var spawn_pos = Vector2(144, 32) #-32
var walkable_arr = []
var stand_pos_arr = []

func set_up():
	Global.nullNPC = resource_preloader.get_resource("NullNPC")
	spawn_npc(resource_preloader.get_resource("Devil"))

func spawn_npc(npc_res):
	var new_npc = npc.duplicate()
	new_npc.npc_res = npc_res
	new_npc.position = spawn_pos
	customer_arr.append(new_npc)
	add_child(new_npc)

func _on_map_manager_set_up_done(pos_arr, floor_arr):
	print(pos_arr)
	print(floor_arr)
