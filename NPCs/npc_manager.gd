extends Node2D

#Manages the NPCs

@export var customer_arr:Array = []

@onready var resource_preloader = $ResourcePreloader
var npc = preload("res://NPCs/npc.tscn")
var max_customer_amt = 5
var customer_amt = 0
var spawn_pos = Vector2(144, 32) #-32
var walkable_arr = []
var stand_pos_arr = []

signal request_items(customer_arr)

func _process(delta):
	if Global.state == "SELL" && customer_arr.size() < max_customer_amt:
		fill_customer_arr() #CHANGE

func set_up():
	Global.nullNPC = resource_preloader.get_resource("NullNPC")

func fill_customer_arr():
	spawn_npc(resource_preloader.get_resource("Devil"))
	if customer_arr.size() >= max_customer_amt:
		emit_signal("request_items", customer_arr)

func spawn_npc(npc_res):
	var new_npc = npc.instantiate()
	new_npc.npc_res = npc_res
	new_npc.position = spawn_pos
	customer_arr.append(new_npc)
	print(new_npc)
	add_child(new_npc)

func _on_map_manager_set_up_done(pos_arr, floor_arr):
	pass
	#print(pos_arr)
	#print(floor_arr)
