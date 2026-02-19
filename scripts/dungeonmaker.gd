extends Control

@onready var tilemap = $HSplitContainer/MapArea/TileMapLayer
@onready var palette_container = $HSplitContainer/LeftArea/ScrollContainer/Palette
@onready var button_save: Button = $HSplitContainer/LeftArea/ButtonSave
@onready var button_load: Button = $HSplitContainer/LeftArea/ButtonLoad

const MAPS_DIR := "user://maps"
const DEFAULT_FILENAME := "mapa.json"

var save_dialog: FileDialog
var load_dialog: FileDialog

func _ready():
	generate_palette()
	_ensure_maps_dir()
	_setup_file_dialogs()
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)


func _ensure_maps_dir() -> void:
	var maps_dir_abs := ProjectSettings.globalize_path(MAPS_DIR)
	var err := DirAccess.make_dir_recursive_absolute(maps_dir_abs)
	if err != OK and err != ERR_ALREADY_EXISTS:
		push_warning("No se pudo crear el directorio de mapas: %s" % MAPS_DIR)

func _setup_file_dialogs() -> void:
	save_dialog = FileDialog.new()
	save_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_dialog.access = FileDialog.ACCESS_USERDATA
	save_dialog.use_native_dialog = true
	save_dialog.title = "Guardar mapa"
	save_dialog.add_filter("*.json", "Archivo JSON")
	save_dialog.file_selected.connect(_on_save_file_selected)
	add_child(save_dialog)

	load_dialog = FileDialog.new()
	load_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	load_dialog.access = FileDialog.ACCESS_USERDATA
	load_dialog.use_native_dialog = true
	load_dialog.title = "Cargar mapa"
	load_dialog.add_filter("*.json", "Archivo JSON")
	load_dialog.file_selected.connect(_on_load_file_selected)
	add_child(load_dialog)

func generate_palette():
	var tileset = tilemap.tile_set

	for source_id in range(tileset.get_source_count()):
		var source = tileset.get_source(source_id)

		if source is TileSetAtlasSource:

			var atlas_size = source.get_atlas_grid_size()

			for x in range(atlas_size.x):
				for y in range(atlas_size.y):

					var coords = Vector2i(x, y)

					if source.has_tile(coords):
						create_tile_button(source_id, coords)


func create_tile_button(source_id:int, atlas_coords:Vector2i):
	var btn = TextureButton.new()

	var source = tilemap.tile_set.get_source(source_id)
	var texture = source.texture
	var region = source.get_tile_texture_region(atlas_coords)

	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = texture
	atlas_texture.region = region

	btn.texture_normal = atlas_texture
	btn.custom_minimum_size = region.size

	btn.pressed.connect(func():
		tilemap.set_selected_tile(source_id, atlas_coords)
	)

	palette_container.add_child(btn)


func _on_save_pressed() -> void:
	save_dialog.current_dir = MAPS_DIR
	save_dialog.current_file = DEFAULT_FILENAME
	save_dialog.popup_centered_ratio()


func _on_load_pressed() -> void:
	load_dialog.current_dir = MAPS_DIR
	load_dialog.current_file = ""
	load_dialog.popup_centered_ratio()


func _on_save_file_selected(path: String) -> void:
	_save_map_to_path(path)


func _on_load_file_selected(path: String) -> void:
	_load_map_from_path(path)


func _save_map_to_path(path: String) -> void:
	var map_data := {
		"version": 1,
		"cells": []
	}

	for cell in tilemap.get_used_cells():
		map_data.cells.append({
			"x": cell.x,
			"y": cell.y,
			"source_id": tilemap.get_cell_source_id(cell),
			"atlas_x": tilemap.get_cell_atlas_coords(cell).x,
			"atlas_y": tilemap.get_cell_atlas_coords(cell).y,
			"alternative_tile": tilemap.get_cell_alternative_tile(cell)
		})

	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("No se pudo guardar el mapa en: %s" % path)
		return

	file.store_string(JSON.stringify(map_data, "\t"))
	print("Mapa guardado en: %s" % path)


func _load_map_from_path(path: String) -> void:
	if not FileAccess.file_exists(path):
		push_warning("No existe archivo de mapa para cargar: %s" % path)
		return

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("No se pudo abrir el archivo de mapa: %s" % path)
		return

	var parsed_result: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed_result) != TYPE_DICTIONARY:
		push_error("El archivo de mapa no tiene un formato válido.")
		return

	var parsed: Dictionary = parsed_result

	if not parsed.has("cells") or typeof(parsed.cells) != TYPE_ARRAY:
		push_error("El archivo de mapa no contiene celdas válidas.")
		return

	tilemap.clear()

	for cell_data in parsed.cells:
		if typeof(cell_data) != TYPE_DICTIONARY:
			continue
		if not _has_required_cell_fields(cell_data):
			continue

		var coords := Vector2i(int(cell_data.x), int(cell_data.y))
		var source_id := int(cell_data.source_id)
		var atlas_coords := Vector2i(int(cell_data.atlas_x), int(cell_data.atlas_y))
		var alternative_tile := int(cell_data.get("alternative_tile", 0))

		tilemap.set_cell(coords, source_id, atlas_coords, alternative_tile)

	print("Mapa cargado desde: %s" % path)


func _has_required_cell_fields(cell_data: Dictionary) -> bool:
	return cell_data.has("x") and cell_data.has("y") and cell_data.has("source_id") and cell_data.has("atlas_x") and cell_data.has("atlas_y")
