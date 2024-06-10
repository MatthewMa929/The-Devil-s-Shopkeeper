extends Node

#States are MOVE, INVENTORY, BUY, SELL, NEGOTIATE
@onready var max_price = 100000
@onready var max_digits = 6
@onready var state = "MOVE"

var empty = null
var nullNPC = null
var stand_arr = []
var stand_pos_arr = []
var stand_floor_arr = []

