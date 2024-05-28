@tool
extends Node2D

@export var flying_area_width: float = 500.0:
	set(new_width):
		flying_area_width = new_width
		update_shape()

var flying_area_collision

func _ready():
	flying_area_collision = get_node("Flying_area").get_child(0)
	var new_shape = RectangleShape2D.new()
	new_shape.extents = flying_area_collision.shape.extents
	flying_area_collision.shape = new_shape
	update_shape()


func update_shape():
	if not flying_area_collision:
		return
	
	var shape = flying_area_collision.shape
	
	if shape is RectangleShape2D:
		shape.extents = Vector2(flying_area_width / 2, 30.0)
		print("Bluebird new flying area size: ", shape.extents)