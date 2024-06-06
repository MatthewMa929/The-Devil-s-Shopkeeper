extends StaticBody2D

#Holds an item, player should be able to place item here

@onready var item_spr = $ItemSpr

@export var item:Item

func _process(delta):
	if Global.state == "INVENTORY":
		pass

func change_item(new_item):
	item = new_item
	item_spr.texture = item.texture
