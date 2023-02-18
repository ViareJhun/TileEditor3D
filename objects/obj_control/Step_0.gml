/// @description update

if (
	win_width != window_get_width() ||
	win_height != window_get_height()
) {
	view_set(
		max(32, window_get_width()),
		max(32, window_get_height()),
		1,
		1,
		false,
		false
	)
}

win_width = window_get_width()
win_height = window_get_height()