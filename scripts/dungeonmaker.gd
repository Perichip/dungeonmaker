extends Control

@onready var tilemap = $HSplitContainer/MapArea/TileMapLayer
@onready var palette_container = $HSplitContainer/LeftArea/ScrollContainer/Palette

func _ready():
	generate_palette()

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
