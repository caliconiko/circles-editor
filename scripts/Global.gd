extends Node

enum CircleTypes {START, NORMAL, INCREMENT, DECREMENT, OUTPUT}
enum PathTypes {NORMAL, INPUT, PRIORITY, CONDITIONAL}

const IMAGES_BASE_PATH = "res://images/"
var circle_back_assets = {}
var circle_front_assets = {}
var path_assets = {}

onready var circle = preload("res://scenes/Circle.tscn")
onready var path = preload("res://scenes/Path.tscn")

signal select_circle(circle)
signal select_path(path)
signal select_circles(circles)
signal select_paths(paths)

enum SelectingModes {CLICK, RECTANGLE, BRUSH}
var selecting_mode = SelectingModes.CLICK

static func delete_children(node:Node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func load_assets():
	for circle_type in CircleTypes.keys():
		var lower_circle_type = circle_type.to_lower()
		var back_path = IMAGES_BASE_PATH+lower_circle_type+"-back.png"
		var front_path = IMAGES_BASE_PATH+lower_circle_type+"-front.png"
		
		var index = CircleTypes.get(circle_type)
		
		circle_back_assets[index] = load(back_path)
		circle_front_assets[index] = load(front_path)
		
		print(front_path)
		
	for path_type in PathTypes.keys():
		var lower_path_type = path_type.to_lower()
		var path_path = IMAGES_BASE_PATH+lower_path_type+"-path.png"
		var import_path = IMAGES_BASE_PATH+lower_path_type+"-path.png.import"
		
		var index = PathTypes.get(path_type)

		var file_exists = Directory.new().file_exists(path_path)
		var import_file_exists = Directory.new().file_exists(import_path)
		if file_exists or import_file_exists:
			path_assets[index] = load(path_path)
		else:
			path_assets[index] = null
			
		print(path_path)
			
	print(path_assets)
	print(circle_front_assets)
		
func _ready():
	load_assets()
