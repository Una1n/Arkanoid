class_name UserPreferences extends Resource

const USER_PREFERENCES_FILE = "user://user_preferences.tres"

@export_range(0, 1, 0.01) var master_audio_level: float = 1
@export_range(0, 1, 0.01) var music_audio_level: float = 1
@export_range(0, 1, 0.01) var sfx_audio_level: float = 1


func save() -> void:
	ResourceSaver.save(self, USER_PREFERENCES_FILE)


static func load_or_create() -> UserPreferences:
	var preferences: UserPreferences
	if ResourceLoader.exists(USER_PREFERENCES_FILE):
		preferences = load(USER_PREFERENCES_FILE) as UserPreferences
	else:
		preferences = UserPreferences.new()

	return preferences
