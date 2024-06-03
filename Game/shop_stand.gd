extends Node2D

#Holds an item, player should be able to place item here

@onready var item_spr = $ItemSpr

@export var item:Item

func _process(delta):
	item_spr.texture = item.texture
