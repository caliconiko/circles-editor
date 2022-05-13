extends Node2D

var circle_type = Global.CircleTypes.START
var paths = []

var selected = false

func _ready():
	set_textures()

func set_textures():
	$Back.set_texture(Global.circle_back_assets[circle_type])
	$Front.set_texture(Global.circle_front_assets[circle_type])

func delete():
	var paths_copy = paths.duplicate()
	for i in range(paths_copy.size()):
		paths_copy[i].delete()
	hide()
	queue_free()

func select():
	modulate = Color.aqua
	selected = true

func deselect():
	modulate = Color.white
	selected = false

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if Global.selecting_mode==Global.SelectingModes.CLICK:
			if event.button_index==BUTTON_LEFT and event.pressed:
				Global.emit_signal("select_circle", self)
				print("paths: "+str(paths))
