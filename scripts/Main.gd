extends Control

var selected_circles = []
var selected_paths = []

onready var rectangle_selection = $RectangleSelection
onready var save_file_dialog = $SaveFileDialog
onready var debug_file_dialog = $DebugFileDialog

var image

func _input(event):
	if event is InputEventKey:
		var just_pressed = event.is_pressed() and not event.is_echo()
		if just_pressed:
			var how_many_circles_selected = selected_circles.size()
			var how_many_paths_selected = selected_paths.size()
			if event.scancode == KEY_X:
				for c in selected_circles:
					c.delete()
				selected_circles.clear()
				for p in selected_paths:
					p.delete()
				selected_paths.clear()
				
			elif event.scancode == KEY_ENTER:
				image = get_viewport().get_texture().get_data()
				image.flip_y()
				print("Saving file")
				save_file_dialog.show_modal()
				
			elif event.scancode == KEY_QUOTELEFT:
				debug_file_dialog.popup()
			
			elif how_many_circles_selected < 1 and how_many_paths_selected < 1:
				for circle_type in Global.CircleTypes.keys():
					var circle_char = circle_type[0]
					if event.scancode == OS.find_scancode_from_string(circle_char):
						var circle = Global.circle.instance()
						circle.circle_type = Global.CircleTypes.get(circle_type)
						circle.position = get_global_mouse_position()
						add_child(circle)
			elif how_many_circles_selected == 2:
				for path_type in Global.PathTypes.keys():
					var path_char = path_type[0]
					if event.scancode == OS.find_scancode_from_string(path_char):
						var path = Global.path.instance()
						path.path_type = Global.PathTypes.get(path_type)
						add_child(path)
						path.set_circles(selected_circles[0], selected_circles[1])
						
						for c in selected_circles:
							c.deselect()
						selected_circles.clear()

func _on_select_circle(circle:Node2D):
	if selected_circles.has(circle):
		circle.deselect()
		selected_circles.erase(circle)
	else:
		circle.select()
		selected_circles.append(circle)
		
	print(selected_circles)

func _on_select_path(path:Node2D):
	if selected_paths.has(path):
		path.deselect()
		selected_paths.erase(path)
	else:
		path.select()
		selected_paths.append(path)
		
	print(selected_paths)

func _ready():
	Global.connect("select_circle", self, "_on_select_circle")
	Global.connect("select_path", self, "_on_select_path")


func _on_SaveFileDialog_file_selected(path):
	image.save_png(path)
