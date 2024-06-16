extends Control

@onready var negotiate_screen = $NegotiateScreen

var negotiation_queue = []

func negotiate():
	negotiate_screen.visible = true
	negotiation_queue.pop()
