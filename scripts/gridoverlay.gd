extends Node2D

const MAP_WIDTH := 100
const MAP_HEIGHT := 100
@onready var tilemap: TileMapLayer = $"../TileMapLayer"

func _draw() -> void:
	if tilemap.tile_set == null:
		return
		
	var cell_size := float(tilemap.tile_set.tile_size.x)
	var width_px := MAP_WIDTH * cell_size
	var height_px := MAP_HEIGHT * cell_size
	var color := Color(1, 1, 1, 0.15)

	for x in range(MAP_WIDTH + 1):
		var xpos := x * cell_size
		draw_line(Vector2(xpos, 0), Vector2(xpos, height_px), color, 1.0)

	for y in range(MAP_HEIGHT + 1):
		var ypos := y * cell_size
		draw_line(Vector2(0, ypos), Vector2(width_px, ypos), color, 1.0)
