class_name Utils

const SCREENSHOT_PATH = "user://screenshots/"

enum OS_TYPES {UNKNOWN, WINDOWS, LINUX, MACOS, IOS, ANDROID, WEB}


static func take_screenshot(viewport: Viewport) -> void:
	seed(int(Time.get_unix_time_from_system()))
	var image := viewport.get_texture().get_image() as Image

	if not DirAccess.dir_exists_absolute(SCREENSHOT_PATH):
		DirAccess.make_dir_absolute(SCREENSHOT_PATH)

	var file_path: String = SCREENSHOT_PATH + "screenshot-%s" % randi() + ".png"
	while ResourceLoader.exists(file_path):
		file_path = SCREENSHOT_PATH + "screenshot-%s" % randi() + ".png"

	image.save_png(file_path)


static func set_fullscreen(fullscreen: bool = true) -> void:
	if get_current_os() == OS_TYPES.WEB: return

	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1280, 720))
		DisplayServer.window_set_position(
			get_middle_of_screen_position() - get_middle_of_window_position()
		)


static func get_middle_of_screen_position() -> Vector2i:
	return DisplayServer.screen_get_size(0) / 2


static func get_middle_of_window_position() -> Vector2i:
	return DisplayServer.window_get_size() / 2


static func get_current_os() -> OS_TYPES:
	match OS.get_name():
		"Windows", "UWP":
			return OS_TYPES.WINDOWS
		"macOS":
			return OS_TYPES.MACOS
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			return OS_TYPES.LINUX
		"Android":
			return OS_TYPES.ANDROID
		"iOS":
			return OS_TYPES.IOS
		"Web":
			return OS_TYPES.WEB

	return OS_TYPES.UNKNOWN
