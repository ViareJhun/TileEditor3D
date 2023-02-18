/// @description init

slider_create(
	0.5,
	c_white,
	make_colour_rgb(16, 16, 128)
)
widget_value = from_range(
	32,
	global.shininess_min,
	global.shininess_max
)