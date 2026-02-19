extends Node2D

const MAP_WIDTH := 33
const MAP_HEIGHT := 22
const CELL_SIZE := 64  # ⚠️ Cambia según tu tileset
@onready var tilemap = $"../TileMapLayer"


func _draw():
	var width_px = MAP_WIDTH * CELL_SIZE
	var height_px = MAP_HEIGHT * CELL_SIZE

	var color = Color(1, 1, 1, 0.15)  # blanco muy transparente

	# Líneas verticales
	for x in range(MAP_WIDTH + 1):
		var xpos = x * CELL_SIZE
		draw_line(
			Vector2(xpos, 0),
			Vector2(xpos, height_px),
			color,
			1.0
		)

	# Líneas horizontales
	for y in range(MAP_HEIGHT + 1):
		var ypos = y * CELL_SIZE
		draw_line(
			Vector2(0, ypos),
			Vector2(width_px, ypos),
			color,
			1.0
		)
