extends Powerup


func enable_powerup() -> void:
	super()
	LifeManager.add_life()


func disable_powerup() -> void:
	super()
