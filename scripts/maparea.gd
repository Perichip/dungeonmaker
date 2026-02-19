extends Control

@onready var tilemap_layer: TileMapLayer = $TileMapLayer
@onready var grid_overlay: Node2D = $GridOverlay
@onready var hover_overlay: Node2D = $HoverOverlay

const MIN_ZOOM := 0.5
const MAX_ZOOM := 2.5
const ZOOM_STEP := 0.1
const PAN_BUTTON := MOUSE_BUTTON_MIDDLE

var zoom_level := 1.0
var pan_offset := Vector2.ZERO
var is_panning := false

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

func _apply_view_transform() -> void:
	for node in [tilemap_layer, grid_overlay, hover_overlay]:
		node.scale = Vector2.ONE * zoom_level
		node.position = pan_offset
