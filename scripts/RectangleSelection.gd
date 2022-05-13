extends Node2D

onready var color_polygon = $ColorPolygon
onready var collision_polygon = $Area2D/CollisionPolygon2D
onready var area2d = $Area2D

var start_pos = Vector2.ZERO

func _ready():
	var transparent_aqua = Color.aqua
	transparent_aqua.a = 0.5
	color_polygon.color=transparent_aqua
	hide()
	
func _physics_process(delta):
	set_polygons()

func set_polygons():
	var mouse_pos = get_global_mouse_position()
	var polygon = [
		start_pos,
		Vector2(start_pos.x, mouse_pos.y),
		mouse_pos,
		Vector2(mouse_pos.x, start_pos.y)
	]
	collision_polygon.polygon = polygon
	color_polygon.polygon = polygon

func _input(event):
	if event is InputEventMouseButton:
		if Global.selecting_mode==Global.SelectingModes.RECTANGLE:
			if event.button_index==BUTTON_LEFT and event.pressed:
				start_pos=get_global_mouse_position()
				set_polygons()
				show()
			elif event.button_index==BUTTON_LEFT:
				hide()
				print(area2d.get_overlapping_areas())
