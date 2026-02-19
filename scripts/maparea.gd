extends Control

@onready var tilemap_layer: TileMapLayer = $TileMapLayer
@onready var grid_overlay: Node2D = $GridOverlay
@onready var hover_overlay: Node2D = $HoverOverlay

const MIN_ZOOM := 0.5
const MAX_ZOOM := 2.5
const ZOOM_STEP := 0.1
const PAN_BUTTON := MOUSE_BUTTON_MIDDLE
const TOUCH_ZOOM_SENSITIVITY := 0.005

var zoom_level := 1.0
var pan_offset := Vector2.ZERO
var is_panning := false
var active_touches: Dictionary = {}
var pinch_last_distance := 0.0
var touch_pan_last_center := Vector2.ZERO

func _ready() -> void:
	clip_contents = true
	_apply_view_transform()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		if mouse_button_event.button_index == PAN_BUTTON:
			is_panning = mouse_button_event.pressed
			return

		if not get_global_rect().has_point(mouse_button_event.position):
			return

		if mouse_button_event.pressed and (mouse_button_event.button_index == MOUSE_BUTTON_WHEEL_UP or mouse_button_event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			var old_zoom := zoom_level
			if mouse_button_event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_level = min(zoom_level + ZOOM_STEP, MAX_ZOOM)
			else:
				zoom_level = max(zoom_level - ZOOM_STEP, MIN_ZOOM)

			if is_equal_approx(old_zoom, zoom_level):
				return

			var mouse_local: Vector2 = mouse_button_event.position - get_global_position()
			var world_before_zoom := (mouse_local - pan_offset) / old_zoom
			pan_offset = mouse_local - world_before_zoom * zoom_level
			_apply_view_transform()

	if event is InputEventMouseMotion and is_panning:
		pan_offset += event.relative
		_apply_view_transform()

	if event is InputEventScreenTouch:
		_handle_screen_touch(event as InputEventScreenTouch)

	if event is InputEventScreenDrag:
		_handle_screen_drag(event as InputEventScreenDrag)


func _handle_screen_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		active_touches[event.index] = event.position
	else:
		active_touches.erase(event.index)

	if active_touches.size() >= 2:
		var points := active_touches.values()
		var first_point := points[0] as Vector2
		var second_point := points[1] as Vector2
		pinch_last_distance = first_point.distance_to(second_point)
		touch_pan_last_center = (first_point + second_point) * 0.5
	elif active_touches.size() == 1:
		touch_pan_last_center = active_touches.values()[0] as Vector2


func _handle_screen_drag(event: InputEventScreenDrag) -> void:
	active_touches[event.index] = event.position

	if active_touches.size() < 2:
		return

	var points := active_touches.values()
	var first_point := points[0] as Vector2
	var second_point := points[1] as Vector2
	var current_distance: float = first_point.distance_to(second_point)
	var current_center: Vector2 = (first_point + second_point) * 0.5

	if pinch_last_distance > 0.0:
		var zoom_delta := (current_distance - pinch_last_distance) * TOUCH_ZOOM_SENSITIVITY
		var old_zoom := zoom_level
		zoom_level = clamp(zoom_level + zoom_delta, MIN_ZOOM, MAX_ZOOM)

		if not is_equal_approx(old_zoom, zoom_level):
			var mouse_local: Vector2 = current_center - get_global_position()
			var world_before_zoom := (mouse_local - pan_offset) / old_zoom
			pan_offset = mouse_local - world_before_zoom * zoom_level

	pan_offset += current_center - touch_pan_last_center
	pinch_last_distance = current_distance
	touch_pan_last_center = current_center
	_apply_view_transform()

func is_multitouch_active() -> bool:
	return active_touches.size() >= 2


func _apply_view_transform() -> void:
	for node in [tilemap_layer, grid_overlay, hover_overlay]:
		node.scale = Vector2.ONE * zoom_level
		node.position = pan_offset
