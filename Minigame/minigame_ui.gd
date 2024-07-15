extends Control

@onready var row_container = $RowContainer
@onready var col_container = $ColContainer
@onready var row_text = $RowContainer/RowText
@onready var col_text = $ColContainer/ColText
@onready var enemy_label = $EnemyLabel
@onready var item_label = $ItemLabel
@onready var switch_mode = $SwitchMode


func change_text(label, new_text):
	label.text = "[center][color=black]" + str(new_text)
