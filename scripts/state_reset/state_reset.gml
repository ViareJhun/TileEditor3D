function state_reset(restart = true) {
	texture_manager_clear()
	model_manager_clear()
	if restart room_restart()
}