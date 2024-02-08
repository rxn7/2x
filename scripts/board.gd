class_name Board

const TILE_SCENE: PackedScene = preload("res://scenes/tile.tscn")

signal changed
var tiles: Array[Tile]

func _init() -> void:
	tiles.resize(16)

func restart() -> void:
	for t in tiles:
		if t != null:
			t.queue_free()

	tiles.fill(null)
	
	for i in 2:
		spawn_random_tile(false)

	changed.emit()

func remove_tile(idx: int) -> void:
	tiles[idx].queue_free()
	tiles[idx] = null

func slide(horizontal: bool, reverse: bool) -> SlideResult:
	var result: SlideResult = SlideResult.new()

	for row in generate_slide_rows(horizontal, reverse):
		result.moved = slide_row(row) or result.moved
		result.merged = merge_row(row) or result.merged
		result.moved = slide_row(row) or result.moved

	return result

func slide_row(row: PackedInt32Array) -> bool:
	var move_made: bool = false
	var last_empty_idx: int = -1
	var non_empty_tiles: Array[Tile] = []
	for i in 4:
		if tiles[row[i]] != null:
			non_empty_tiles.push_back(tiles[row[i]])
			tiles[row[i]] = null
			if last_empty_idx != -1:
				move_made = true
		elif last_empty_idx == -1:
			last_empty_idx = i

	for i in range(non_empty_tiles.size()):
		var tile: Tile = non_empty_tiles[i]
		tiles[row[i]] = tile
		tile.update_position(row[i])

	return move_made

func generate_slide_rows(horizontal: bool, reverse: bool) -> Array[PackedInt32Array]:
	var rows: Array[PackedInt32Array] = []
	rows.resize(4)
	for i in 4:
		var row: PackedInt32Array = []
		row.resize(4)

		if reverse:
			for j in range(3, -1, -1):
				row[3-j] = (Board.xy_to_index(j, i) if horizontal else Board.xy_to_index(i, j))
		else:
			for j in 4:
				row[j] = (Board.xy_to_index(j, i) if horizontal else Board.xy_to_index(i, j))

		rows[i] = row

	return rows

func merge_row(row: PackedInt32Array) -> bool:
	var move_made: bool = false
	for i in 3:
		var curr_tile: Tile = tiles[row[i]]
		var next_tile: Tile = tiles[row[i + 1]]

		if curr_tile == null or next_tile == null or curr_tile.value == 0 or curr_tile.value != next_tile.value:
			continue
			
		curr_tile.double()
		Game.instance.score += curr_tile.value
		remove_tile(row[i + 1])

		move_made = true

	return move_made

func spawn_random_tile(wait_for_move_animation: bool = true) -> void:
	var free_indices: PackedInt32Array = []
	# Find empty cells
	for idx in 16:
		if tiles[idx] == null:
			free_indices.push_back(idx)
			
	if free_indices.size() == 0:
		push_error("There are no empty cells!")
		return

	var index: int = free_indices[randi_range(0, free_indices.size() - 1)]
	# 90% change to spawn 2, 10% chance to spawn 4
	var value: int = 4 if randf() >= 0.9 else 2
	
	var tile: Tile = TILE_SCENE.instantiate()
	Game.instance.tile_container.add_child(tile)
	tiles[index] = tile

	tile.update_position(index)
	tile.pop_up(wait_for_move_animation)
	tile.value = value


func is_any_move_possible() -> bool:
	for x in range(4):
		for y in range(4):
			var curr_tile: Tile = tiles[Board.xy_to_index(x, y)]

			# Empty cell is available
			if curr_tile == null:
				return true

			# Check if horizontal move is possible
			if x < 3:
				var other_tile: Tile = tiles[Board.xy_to_index(x + 1, y)]
				if other_tile != null and curr_tile.value == other_tile.value:
					return true

			# Check if vertical move is possible
			if y < 3:
				var other_tile = tiles[Board.xy_to_index(x, y + 1)]
				if other_tile != null and curr_tile.value == other_tile.value:
					return true
			
	return false

static func xy_to_index(x: int, y: int) -> int:
	return y * 4 + x