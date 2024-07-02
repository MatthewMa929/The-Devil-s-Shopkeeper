extends Resource

class_name Customer

@export var name:String
@export var texture:Texture
@export var preferred_items:Array[Item]
@export_enum("Villager", "Middle", "Noble") var status:int
