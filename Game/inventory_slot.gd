extends Node2D

@export var item:Item

@onready var item_spr = $ItemSpr
@onready var select_spr = $Selected

var is_selected = false

func _process(delta):
	if is_selected:
		select_spr.visible = true
	else:
		select_spr.visible = false
	if item.name != "Empty":
		item_spr.texture = item.texture
		item_spr.scale = Vector2(0.5, 0.5)
	if Global.state == "INVENTORY":
		visible = true
	else:
		visible = false
