🗺️ DungeonMaker
📦 v0.0.1 — Initial Prototype
✨ Added

Sistema base de TileMapLayer compatible con Godot 4.5.

Grid limitado configurable (actualmente 30x30).

Generación automática de Tile Palette desde TileSetAtlasSource.

Selección dinámica de tiles desde la paleta.

Pintado de tiles con click izquierdo.

Pintado continuo mediante arrastre.

Borrado de tiles con click derecho (incluye arrastre).

Overlay visual de grid independiente.

Highlight dinámico de celda bajo el cursor.

Restricción de interacción al área del mapa (MapArea).

🏗 Architecture

Separación modular de responsabilidades:

TileMapLayer: lógica de mapa y edición.

GridOverlay: renderizado de rejilla.

HoverOverlay: resaltado de celda.

DungeonMaker: coordinación de paleta.

Eliminado uso de TileMap legacy → migrado a TileMapLayer.

Sistema preparado para futura implementación de:

Zoom & Pan

Undo stack

Guardado / carga de mapa

Soporte táctil (Android/Tablet)

🎯 Current Scope

Editor funcional en entorno PC.

Base técnica sólida para expansión móvil.