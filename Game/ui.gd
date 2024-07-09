extends Control

@onready var negotiate_screen = $NegotiateScreen
@onready var coins_text = $Icons/CoinsText

var negotiation_queue = []

func negotiate():
	negotiate_screen.visible = true
	negotiation_queue.pop()


func _on_shop_inventory_item_sold(item, cost):
	coins_text -= cost
