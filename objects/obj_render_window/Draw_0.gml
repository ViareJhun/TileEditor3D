/// @description draw

#region 3D render
if !surface_exists(render_surface) {
	render_surface = surface_create(
		render_width,
		render_height
	)
}
surface_set_target(render_surface)
draw_clear_alpha(c_black, 0)
draw_set_colour(c_white)
render_3d(render_cam)
draw_set_colour(c_white)
draw_set_font(fnt_gm_gui)
draw_text(
	4,
	4,
	"theta = " + string(render_cam.theta_to)
)
draw_text(
	4,
	4 + 16,
	"phi = " + string(render_cam.phi_to)
)
surface_reset_target()

if !surface_exists(render_tile_surf) {
	render_tile_surf = surface_create(
		render_tile_size, render_tile_size
	)
}
surface_set_target(render_tile_surf)
draw_clear_alpha(c_black, 0)
draw_set_colour(c_white)
render_tile_cam.x = 6.99
render_tile_cam.y = 7.99
render_tile_cam.theta_to = 0
render_tile_cam.phi_to = 180
t3d_camera_calc(render_tile_cam)

render_3d(render_tile_cam, false)

surface_reset_target()
#endregion

draw_set_colour(c_white)
draw_rectangle(
	x,
	y,
	x + sprite_width,
	y + sprite_height,
	true
)

draw_surface(
	render_surface,
	x + render_offset,
	y + render_offset
)