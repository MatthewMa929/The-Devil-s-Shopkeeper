extends CharacterBody2D

@export var npc_res:Customer
@onready var sprite = $Sprite
@onready var rng = RandomNumberGenerator.new()

var assigned_stand = null

enum {
	ENTER,
	WANDER,
	STOP
}

var state = ENTER

#signal request_items(customer)

func _physics_process(delta):
	sprite.texture = npc_res.texture
	if state == ENTER:
		assigned_stand = get_random_stand()
		#emit_signal("request_items", npc_res)
		state = STOP
	if state == WANDER:
		pass
	if state == STOP:
		pass

func get_random_stand():
	var stand_amt = Global.stand_arr.size()
	var stand_num = rng.randi_range(0, stand_amt-1)
	return Global.stand_arr[stand_num]
