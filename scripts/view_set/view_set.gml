function view_set(width, height, app_scale, window_scale, window_set = true, fullscreen = false) {
	view_enabled = true
	view_visible[0] = true
	
	camera_set_view_size(
		view_camera[0],
		width,
		height
	)
	
	view_wport[0] = width * app_scale
	view_hport[0] = height * app_scale
	
	surface_resize(
		application_surface,
		view_wport[0],
		view_hport[0]
	)
	
	window_set_fullscreen(fullscreen)
	if !fullscreen {
		if window_set {
			window_set_size(
				width * window_scale,
				height * window_scale
			)
			
			window_set_position(
				(
					display_get_width() - width * window_scale
				) * 0.5,
				(
					display_get_height() - height * window_scale
				) * 0.5
			)
		}
	}
}