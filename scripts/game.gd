class_name Game
extends Node

const TILE_SCENE: PackedScene = preload("res://scenes/tile.tscn")
static var instance: Game

@onready var grid_container: GridContainer = $Background/GridContainer
@onready var tile_container: Node = $Tiles
@onready var score_label: Label = $Score
var tiles: Array[Tile]
var score: int = 0: set=update_score_label

func _enter_tree() -> void:
	instance = self
	tiles.resize(16)

func _ready() -> void:
	call_deferred("restart")

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.is_echo() or !event.is_pressed():
			return
			
		if event.keycode == KEY_R:
			restart()
		elif event.is_action_pressed("slide_up"):
			slide_up()
		elif event.is_action_pressed("slide_down"):
			slide_down()
		elif event.is_action_pressed("slide_left"):
			slide_left()
		elif event.is_action_pressed("slide_right"):
			slide_right()

func xy_to_index(x: int, y: int) -> int:
	return y * 4 + x
		
func restart() -> void:
	score = 0
	for t in tiles:
		if t != null:
			t.queue_free()

	tiles.fill(null)
	
	for i in 2:
		spawn_random_tile(false)

func move_tile(old_idx: int, new_idx: int) -> void:
	var tile: Tile = tiles[old_idx]
	assert(tile != null)

	tiles[new_idx] = tile
	tiles[old_idx] = null

	tile.update_position(new_idx)

func remove_tile(idx: int) -> void:
	tiles[idx].queue_free()
	tiles[idx] = null

func generate_slide_rows(horizontal: bool, reverse: bool) -> Array[PackedInt32Array]:
	var rows: Array[PackedInt32Array] = []
	rows.resize(4)
	for i in 4:
		var row: PackedInt32Array = []
		row.resize(4)

		if reverse:
			for j in range(3, -1, -1):
				row[3-j] = (xy_to_index(j, i) if horizontal else xy_to_index(i, j))
		else:
			for j in 4:
				row[j] = (xy_to_index(j, i) if horizontal else xy_to_index(i, j))

		rows[i] = row

	return rows

func slide(horizontal: bool, reverse: bool) -> void:
	var move_made: bool = false
	for row in generate_slide_rows(horizontal, reverse):
		move_made = slide_row(row) or move_made
		move_made = merge_row(row) or move_made
		move_made = slide_row(row) or move_made

	if move_made:
		spawn_random_tile()

func slide_up() -> void: slide(false, false)
func slide_down() -> void: slide(false, true)
func slide_left() -> void: slide(true, false)
func slide_right() -> void: slide(true, true)

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

func merge_row(row: PackedInt32Array) -> bool:
	var move_made: bool = false
	for i in 3:
		var curr_tile: Tile = tiles[row[i]]
		var next_tile: Tile = tiles[row[i + 1]]
		if curr_tile != null and next_tile != null and curr_tile.value == next_tile.value:
			curr_tile.double()
			score += curr_tile.value
			remove_tile(row[i + 1])

			move_made = true

	return move_made

func spawn_random_tile(wait_for_move_animation: bool = true) -> void:
	var free_indices: PackedInt32Array = []
	for idx in 16:
		if tiles[idx] == null:
			free_indices.push_back(idx)
			
	if free_indices.size() == 0:
		push_error("There are no empty cells!")
		return

	var index: int = free_indices[randi_range(0, free_indices.size() - 1)]
	var value: int = randi_range(1, 2) * 2
	
	var tile: Tile = TILE_SCENE.instantiate()
	tiles[index] = tile

	tile.call_deferred("update_position", index)
	tile.call_deferred("pop_up", wait_for_move_animation)
	tile.call_deferred("_set_value", value)

	tile_container.add_child(tile)

func update_score_label(_score: int) -> void:
	score = _score
	score_label.text = "Score: " + str(score)