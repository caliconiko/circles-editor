extends Node2D

onready var stroke = $Stroke
onready var fill = $Fill
onready var center = $Center
onready var area2d = $Area2D

var point_a = Vector2(-50, -50)
var point_b = Vector2(50, 50)

var path_type = Global.PathTypes.NORMAL

var circle_a:Node2D
var circle_b:Node2D

var selected = false

func _ready():
	set_points()
	set_textures()

func get_circles():
	return [circle_a, circle_b]

func set_circles(a:Node2D, b:Node2D):
	for c in get_circles():
		if c:
			c.paths.erase(self)
	circle_a=a
	circle_b=b
	for c in get_circles():
		c.paths.append(self)
	set_points(circle_a.position, circle_b.position)

func set_textures():
	center.set_texture(Global.path_assets[path_type])
	
func update_points():
	set_points(circle_a.position, circle_b.position)
	
func set_points(a:Vector2 = point_a, b:Vector2 = point_b):
	point_a = to_local(a)
	point_b = to_local(b)
	for l in  [stroke, fill]:
		l.points[0] = point_a
		l.points[1] = point_b
	
	center.position = (point_a+point_b)/2
	center.rotation = point_a.angle_to_point(point_b)
	
	Global.delete_children(area2d)
	# from https://shaggydev.com/2022/01/25/line2d-physics/
	var line_poly = Geometry.offset_polyline_2d([point_a, point_b], stroke.width / 2)
	
	# offset_polyline_2d can potentially return multiple polygons
	# so iterate through all polyons and create collision shapes from them
	for poly in line_poly:
		var col = CollisionPolygon2D.new()
		col.polygon = poly
		area2d.add_child(col)

func delete():
	for c in get_circles():
		c.paths.erase(self)
	modulate = Color.red
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
				Global.emit_signal("select_path", self)
				print("circles: "+str(get_circles()))
