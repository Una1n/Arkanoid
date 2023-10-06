extends Powerup


func enable_powerup() -> void:
	super()
	var gate = get_tree().get_first_node_in_group("Gate") as Gate
	if gate:
		gate.open()

func disable_powerup() -> void:
	super()
