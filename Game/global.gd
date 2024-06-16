extends Node

#States are MOVE, INVENTORY, BUY, SELL, NEGOTIATE
@onready var state_arr = ["MOVE", "INVENTORY", "BUY", "SELL", "NEGOTIATE"]
@onready var max_price = 100000
@onready var max_digits = 6
@onready var state = "MOVE"

var empty = null
var nullNPC = null
var stand_arr = []
var stand_pos_arr = []
var stand_floor_arr = []

func _process(delta):
	if Input.is_action_just_pressed("Change State"):
		for i in range(state_arr.size()-1):
			if state_arr[i] == state:
				state = state_arr[i+1]
				print(state)
				break;
