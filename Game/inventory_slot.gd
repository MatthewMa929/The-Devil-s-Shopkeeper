extends Node2D

@export var item:Item

@onready var item_spr = $ItemSpr

func _process(delta):
	if item.name != "Empty":
		item_spr.texture = item.texture
		item_spr.scale = Vector2(0.5, 0.5)
	
