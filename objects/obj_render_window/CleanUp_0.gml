/// @description clean up

if surface_exists(render_tile_surf) {
	surface_free(render_tile_surf)
}
if surface_exists(render_surface) {
	surface_free(render_surface)
}