extends Node

const SCREENSHOT_PATH = "user://screenshots/"


func take_screenshot() -> void:
	seed(int(Time.get_unix_time_from_system()))
	var image := get_viewport().get_texture().get_image() as Image

	if not DirAccess.dir_exists_absolute(SCREENSHOT_PATH):
		DirAccess.make_dir_absolute(SCREENSHOT_PATH)

	var file_path: String = SCREENSHOT_PATH + "screenshot-%s" % randi() + ".png"
	while ResourceLoader.exists(file_path):
		file_path = SCREENSHOT_PATH + "screenshot-%s" % randi() + ".png"

	image.save_png(file_path)
