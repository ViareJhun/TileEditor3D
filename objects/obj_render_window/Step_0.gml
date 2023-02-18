/// @description update

render_width = sprite_width - render_offset * 2
render_height = sprite_height - render_offset * 2

var mouse_inside = (
	mouse_x > x &&
	mouse_y > y &&
	mouse_x < x + sprite_width &&
	mouse_y < y + sprite_height
);

render_cam.aspect = render_width / render_height

if mouse_inside {
	if mouse_wheel_up() {
		render_len_to *= 0.7
	}
	if mouse_wheel_down() {
		render_len_to *= 1.3
	}
	
	if mouse_check_button_pressed(mb_left) {
		render_x_view = mouse_x - x
		render_y_view = mouse_y - y
		render_view_update = true
	}
	if mouse_check_button(mb_left) {
		if render_view_update {
			var _x = mouse_x - x;
			var _y = mouse_y - y;
			
			render_cam.theta_to += (
				_x - render_x_view
			) * render_sens
			render_cam.phi_to += (
				_y - render_y_view
			) * render_sens
			
			window_mouse_set(
				x + render_x_view,
				y + render_y_view
			)
		}
	}
	if mouse_check_button_released(mb_left) {
		render_view_update = false
	}
	
	if mouse_check_button_pressed(mb_right) {
		render_z_temp = render_z_to
		render_zy_temp = y - mouse_y
		render_z_update = true
	}
	if mouse_check_button(mb_right) {
		if render_z_update {
			render_z_to = render_z_temp + (
				render_zy_temp - (y - mouse_y)
			) * 0.1
		}
	}
	if mouse_check_button_released(mb_right) {
		render_z_update = false
	}
	if mouse_check_button_pressed(mb_middle) {
		render_z_to = 0
	}
} else {
	render_view_update = false
	render_z_update = false
}

render_len_to = clamp(
	render_len_to,
	render_len_min,
	render_len_max
)
render_len = lerp(
	render_len,
	render_len_to,
	0.1
)
render_z = lerp(
	render_z,
	render_z_to,
	0.1
)

t3d_camera_calc(render_cam)

render_cam.x = 8 - render_cam.view_x * render_len
render_cam.y = 8 - render_cam.view_y * render_len
render_cam.z = render_z - render_cam.view_z * render_len