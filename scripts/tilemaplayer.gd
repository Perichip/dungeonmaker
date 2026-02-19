extends TileMapLayer

@onready var map_area: Control = $".."

var selected_source_id : int = -1
var selected_atlas_coords : Vector2i
var is_painting := false
var is_erasing := false

const MAP_WIDTH := 33
const MAP_HEIGHT := 22

func set_selected_tile(source_id:int, atlas_coords:Vector2i):
	selected_source_id = source_id
	selected_atlas_coords = atlas_coords

func _input(event):

	if event is InputEventMouseButton:

		# Click izquierdo → pintar
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_painting = event.pressed
			if event.pressed:
				paint_at_mouse(event.position)

		# Click derecho → borrar
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_erasing = event.pressed
			if event.pressed:
				erase_at_mouse(event.position)

	if event is InputEventMouseMotion:
		if is_painting:
			paint_at_mouse(event.position)
		if is_erasing:
			erase_at_mouse(event.position)

func paint_at_mouse(global_pos: Vector2):

	if not map_area.get_global_rect().has_point(global_pos):
		return

	if selected_source_id == -1:
		return

	var cell = local_to_map(to_local(global_pos))

	if cell.x < 0 or cell.y < 0:
		return
	if cell.x >= MAP_WIDTH or cell.y >= MAP_HEIGHT:
		return

	set_cell(cell, selected_source_id, selected_atlas_coords)

func erase_at_mouse(global_pos: Vector2):

	if not map_area.get_global_rect().has_point(global_pos):
		return

	var cell = local_to_map(to_local(global_pos))

	if cell.x < 0 or cell.y < 0:
		return
	if cell.x >= MAP_WIDTH or cell.y >= MAP_HEIGHT:
		return

	erase_cell(cell)
