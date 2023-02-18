/// @description draw

draw_set_colour(c_white)

draw_rectangle(
	x,
	y,
	x + sprite_width,
	y + sprite_height,
	true
)

if surface_exists(obj_render_window.render_tile_surf) {
	draw_surface_stretched(
		obj_render_window.render_tile_surf,
		x + 2,
		y + 2,
		sprite_width - 4,
		sprite_height - 4
	)
}
/*
if texture != noone {
	if sprite_exists(texture.sprite) {
		var l = x + 2;
		var t = y + 2;
		var r = x + sprite_width - 2;
		var b = y + sprite_height - 2;
		
		draw_primitive_begin_texture(pr_trianglelist, texture.texture)
		
		draw_vertex_texture(l, t, texture.uvs[0], texture.uvs[1])
		draw_vertex_texture(r, t, texture.uvs[2], texture.uvs[1])
		draw_vertex_texture(r, b, texture.uvs[2], texture.uvs[3])
		
		draw_vertex_texture(l, t, texture.uvs[0], texture.uvs[1])
		draw_vertex_texture(l, b, texture.uvs[0], texture.uvs[3])
		draw_vertex_texture(r, b, texture.uvs[2], texture.uvs[3])
		
		draw_primitive_end()
	}
}
*/