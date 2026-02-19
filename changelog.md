----

 # Futuras Versiones irán aquí

---- 

## [0.1.0] – Zoom, guardado JSON y expansión de mapa

### Added
#### 🔍 Zoom + Pan en MapArea
- Implementado soporte completo de zoom y desplazamiento (pan) mediante nueva script `maparea.gd`.
- Zoom con rueda del ratón centrado en el cursor.
- Pan con botón central del ratón arrastrando.
- Aplicación sincronizada de `scale` y `position` a:
  - `TileMapLayer`
  - `GridOverlay`
  - `HoverOverlay`
- Alineación perfecta entre mapa, grid y resaltado.
- Activado `clip_contents` en `MapArea` para recortar correctamente al hacer pan/zoom.

---

#### 🗺 Expansión del área editable
- Ampliado el tamaño lógico del mapa de **33x22** a **100x100**.
- Ajustados los límites de escritura en el `TileMapLayer`.
- `GridOverlay` actualizado para:
  - Usar tamaño de celda dinámico desde el `TileSet`.
  - Dibujar cuadrícula completa de 100x100.
- `HoverOverlay` adaptado al nuevo tamaño al calcular celda resaltada.

---

#### 💾 Guardado y carga de mapa en JSON
- Conectados botones `Save` y `Load` en `_ready()`.
- Implementado guardado del mapa en JSON:
  - Serialización de todas las celdas pintadas.
  - Incluye:
    - `position`
    - `source_id`
    - `atlas_coords`
    - `alternative_tile`
- Implementada carga desde JSON:
  - Validaciones básicas de archivo y estructura.
  - Limpieza del mapa actual antes de restaurar.
  - Restauración completa de celdas.
- Añadida función auxiliar para validar estructura mínima de cada celda.

---

#### 📂 Selección de archivo mediante FileDialog
- Sustituido path fijo por `FileDialog`:
  - Guardar → diálogo de guardado.
  - Cargar → diálogo de apertura.
- Creada carpeta de trabajo:
user://maps

- Sugerencia automática de nombre por defecto (`mapa.json`).
- Refactor de lógica a funciones por ruta:
- `_save_map_to_path`
- `_load_map_from_path`
- Mantiene el mismo formato JSON de celdas.

---

### Fixed
#### 🧾 Correcciones de tipado (Godot 4.5 strict typing)
- Conversión explícita de `event` a `InputEventMouseButton` para acceso seguro a:
- `position`
- `pressed`
- `button_index`
- Tipado explícito de `mouse_local` como `Vector2`.
- Corrección de parseo JSON:
- Resultado guardado en `parsed_result: Variant`.
- Validación de tipo antes de convertir a `Dictionary`.
- Eliminadas inferencias implícitas de `Variant`.
- Sin cambios funcionales en carga, solo cumplimiento estricto de tipado.

---

### Architecture
- Separación clara entre:
- Interacción (zoom/pan)
- Render (TileMap + Overlays)
- Persistencia (JSON)
- Tamaño de mapa desacoplado de valores hardcodeados.
- Sistema preparado para futuras ampliaciones:
- Capas múltiples
- Exportación/importación extendida
- Herramientas adicionales de edición

---

### Result
Dungeon Maker ahora soporta:

- Navegación fluida (zoom + pan).
- Área de trabajo amplia (100x100).
- Guardado y carga de mapas en JSON.
- Selección de archivo por usuario.
- Cumplimiento completo de tipado estricto en Godot 4.5.

La base del editor queda consolidada para evolucionar hacia una herramienta más completa.

----

## [0.0.1] – Initial Prototype

### Added
#### 🗺 Sistema base de edición
- Implementado `TileMapLayer` compatible con Godot 4.5.
- Grid limitado configurable (actualmente 30x30).
- Generación automática de Tile Palette desde `TileSetAtlasSource`.
- Selección dinámica de tiles desde la paleta.
- Pintado de tiles con click izquierdo.
- Pintado continuo mediante arrastre.
- Borrado de tiles con click derecho (incluye arrastre).
- Overlay visual de grid independiente.
- Highlight dinámico de celda bajo el cursor.
- Restricción de interacción al área del mapa (`MapArea`).

---

### Architecture
- Separación modular de responsabilidades:
  - `TileMapLayer` → lógica de mapa y edición.
  - `GridOverlay` → renderizado de rejilla.
  - `HoverOverlay` → resaltado de celda.
  - `DungeonMaker` → coordinación de paleta.
- Eliminado uso de `TileMap` legacy → migrado a `TileMapLayer`.
- Sistema preparado para futura implementación de:
  - Zoom & Pan.
  - Undo stack.
  - Guardado / carga de mapa.
  - Soporte táctil (Android/Tablet).

---

### Current Scope
- Editor funcional en entorno PC.
- Base técnica sólida para expansión móvil.
