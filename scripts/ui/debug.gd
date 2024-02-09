extends Control

const FONT_SIZE: int = 16
const REDRAW_INTERVAL: float = 0.5
const ALTERNATING_COLORS: Array[Color] = [Color.HOT_PINK, Color.PINK]

var text_y: float = 0
var text_x: float = 0
var alternate_idx: int = 0
@export var game: Game

func _ready() -> void:
	if !OS.has_feature("debug"):
		visible = false
		queue_free()
		return
	
	var redraw_timer = Timer.new()
	redraw_timer.autostart = true
	redraw_timer.one_shot = false
	redraw_timer.wait_time = REDRAW_INTERVAL
	redraw_timer.timeout.connect(queue_redraw)
	add_child(redraw_timer)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed() and !event.is_echo() and event.keycode == KEY_QUOTELEFT:
		visible = !visible

func _draw() -> void:
	alternate_idx = 0
	text_y = FONT_SIZE
	text_x = 0

	draw_grid()

	text_y = get_viewport().get_visible_rect().size.y
	text_x = 0

	draw_debug_string("GPU: %s" % RenderingServer.get_video_adapter_name())
	draw_debug_string("CPU: %s" % OS.get_processor_name())

	draw_debug_string("OBJECTS: %d (NODES: %d)" % [Performance.get_monitor(Performance.OBJECT_COUNT), Performance.get_monitor(Performance.OBJECT_NODE_COUNT)])
	draw_debug_string("AUDIO POOL: %d (%d PLAYING)" % [SoundManager.pool_size, SoundManager.playing_count])
	draw_debug_string("STAT MEM: %s (MAX: %s)" % [String.humanize_size(Performance.get_monitor(Performance.MEMORY_STATIC)), String.humanize_size(Performance.get_monitor(Performance.MEMORY_STATIC_MAX))])
	draw_debug_string("RENDER BUF: %s" % String.humanize_size(Performance.get_monitor(Performance.RENDER_BUFFER_MEM_USED)))
	draw_debug_string("MSG BUF: %s" % String.humanize_size(Performance.get_monitor(Performance.MEMORY_MESSAGE_BUFFER_MAX)))
	draw_debug_string("VRAM: %s" % String.humanize_size(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)))
	draw_debug_string("FPS: %d" % Performance.get_monitor(Performance.TIME_FPS))

	draw_string(ThemeDB.fallback_font, Vector2(text_x, text_y), "Version: %s" % ProjectSettings.get_setting("application/config/version"), HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE, Color.WHITE_SMOKE)

func draw_grid() -> void:
	for y: int in 4:
		for x: int in 4:
			var tile: Tile = game.board.tiles[Board.xy_to_index(x, y)] 
			var text: String

			text = "[0000]" if tile == null else "[%04d]" % tile.value
			draw_string(ThemeDB.fallback_font, Vector2(x * 60, text_y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE, tile.get_color() if tile != null else Color.WHITE)

		text_y += FONT_SIZE

func draw_debug_string(text: String, color: Color = get_alternating_color()) -> void:
	draw_string(ThemeDB.fallback_font, Vector2(text_x, text_y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE, color)
	text_y -= FONT_SIZE

func get_alternating_color() -> Color:
	alternate_idx += 1
	return ALTERNATING_COLORS[(alternate_idx - 1) % ALTERNATING_COLORS.size()]
