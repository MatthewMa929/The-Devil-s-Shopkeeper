extends Resource

class_name Item

@export var name:String
@export var texture:Texture
@export var type:Array[String] = ["NULL"]
@export_enum("NULL", "Common", "Rare", "Epic")  var rarity:int
@export var cost:int = 10
