/// @description room start

view_set(
	1280,
	600,
	1,
	1,
	true,
	false
)

win_width = window_get_width()
win_height = window_get_height()

if global.is_load {
	tile_load(global.load_file)
	global.is_load = false
}