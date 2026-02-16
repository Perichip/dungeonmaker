extends Node2D

@onready var tilemap: TileMapLayer = $"../TileMapLayer"
@onready var map_area: Control = $".."

const MAP_WIDTH := 65
const MAP_HEIGHT := 45

var hover_cell : Vector2i = Vector2i(-1, -1)
var cell_size : int

func _ready():
	cell_size = tilemap.tile_set.tile_size.x

func _process(_delta):

	var mouse_pos = get_viewport().get_mouse_position()

	if not map_area.get_global_rect().has_point(mouse_pos):
		if hover_cell != Vector2i(-1, -1):
			hover_cell = Vector2i(-1, -1)
			queue_redraw()
		return

	var local_pos = tilemap.to_local(mouse_pos)
	var cell = tilemap.local_to_map(local_pos)

	if cell.x < 0 or cell.y < 0 or cell.x >= MAP_WIDTH or cell.y >= MAP_HEIGHT:
		if hover_cell != Vector2i(-1, -1):
			hover_cell = Vector2i(-1, -1)
			queue_redraw()
		return

	if cell != hover_cell:
		hover_cell = cell
		queue_redraw()


func _draw():
	if hover_cell.x == -1:
		return

	var rect = Rect2(
		hover_cell * cell_size,
		Vector2(cell_size, cell_size)
	)

	draw_rect(rect, Color(1,1,1,0.15), true)
	draw_rect(rect, Color(1,1,1,0.8), false, 2.0)
