extends Node

#Customer enters, looks at stock, decides to buy or leave, if buy, will stand at item with exclamation mark. Player needs to walk to them and negotiate price.
#Negotiation: If player does not give a suitable price within 2 tries, the buyer will leave. Even if the price is suitable, buyer may haggle anyways.

signal game_start

func _ready():
	emit_signal("game_start")

