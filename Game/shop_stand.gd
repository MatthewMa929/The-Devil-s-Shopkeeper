extends StaticBody2D

#Holds an item, player should be able to place item here

@onready var item_spr = $ItemSpr

@export var item:Item

func change_item(new_item):
	item = new_item
	item_spr.texture = item.texture
