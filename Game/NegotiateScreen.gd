extends Control

@onready var inc_icon = $IncIcon
@onready var dec_icon = $DecIcon
@onready var price_box = $PriceBox
@onready var price_digit = $PriceDigit
@onready var price_percentage = $PricePercentage
@onready var displayed_item = $DisplayedItem 
@onready var price_box_arr = [price_box]
@onready var price_digit_arr = [price_digit]
@onready var digit_ptr = 0

var gap = 32
var sell_queue = []
var negotiated_price = 0
var focused_item = null

signal item_sold(item, cost)

func _ready():
	for i in range(Global.max_digits):
		duplicate_button(i)

func _process(delta):
	if Global.state == "NEGOTIATE":
		if Input.is_action_just_pressed("Left"):
			inc_icon.position.x -= gap
			dec_icon.position.x -= gap
			digit_ptr += 1
		if Input.is_action_just_pressed("Right"):
			inc_icon.position.x += gap
			dec_icon.position.x += gap
			digit_ptr -= 1
		if Input.is_action_just_pressed("Up"):
			increase_digit(digit_ptr)
		if Input.is_action_just_pressed("Down"):
			decrease_digit(digit_ptr)
		if Input.is_action_just_pressed("Continue"):
			negotiation(focused_item)
			change_price("0000000")

func duplicate_button(num):
	var new_price_box = price_box.duplicate(true)
	var new_price_digit = price_digit.duplicate(true)
	var prev_price_digit = price_digit_arr[num]
	var prev_price_box = price_box_arr[num]
	new_price_digit.position = Vector2(prev_price_digit.position.x - gap, prev_price_digit.position.y)
	new_price_box.position = Vector2(prev_price_box.position.x - gap, prev_price_box.position.y)
	price_digit_arr.append(new_price_digit)
	price_box_arr.append(new_price_box)
	add_child(new_price_digit)
	add_child(new_price_box)

func change_digit_text(new_digit_text, ptr=digit_ptr):
	price_digit_arr[ptr].text = "[center][color=black]" + str(new_digit_text)
	negotiated_price = calc_negotiated_price()

func increase_digit(curr_digit):
	if curr_digit > Global.max_digits:
		return false
	if int(price_digit_arr[curr_digit].text) == 9:
		if increase_digit(curr_digit + 1):
			change_digit_text(0, curr_digit)
			return true
		else:
			return false
	change_digit_text(int(price_digit_arr[curr_digit].text) + 1, curr_digit)
	return true

func decrease_digit(curr_digit):
	if curr_digit > Global.max_digits:
		return false
	if int(price_digit_arr[curr_digit].text) == 0:
		if decrease_digit(curr_digit + 1):
			change_digit_text(9, curr_digit)
			return true
		else:
			return false
	change_digit_text(int(price_digit_arr[curr_digit].text) - 1, curr_digit)
	return true

func change_price(value):
	var op = 0
	for i in range(Global.max_digits, -1, -1):
		change_digit_text(value[i], op)
		op += 1

func calc_negotiated_price():
	var op = 0
	var price = 0
	for i in range(0, price_digit_arr.size(), 1):
		price += int(price_digit_arr[i].text)*(10**i)
		op += 1
	return price

func display_item(item):
	displayed_item.texture = item.texture
	focused_item = item
	#DISPLAY OFFERED PRICE

func negotiation(item): #STATE ALRDY SET TO NEGOTIATE, BASE IS YOU OFFER PRICE, NEXT GUY OFFERS PRICE
	display_item(item)
	if Input.is_action_just_pressed("Continue") && item.cost < negotiated_price:
		emit_signal("item_sold", item, negotiated_price)

func _on_shop_inventory_display_item(item):
	sell_queue.append(item)
	display_item(item)
