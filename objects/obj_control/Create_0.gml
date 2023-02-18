/// @description init

global.tile_name = ""
global.tile_solid = false
global.tile_tex_path = ""
global.tile_tex_main = noone
global.tile_wall_high = false
global.tile_draw_interpolation = true
global.tile_draw_sun_dir = [0.55, 0.77, 0.44]
global.tile_draw_ambient = 0.5
global.tile_object_container = obj_list_objects
global.tile_object_transformations = {}
global.tile_object_models = {}
global.tile_object_texture = {}
global.tile_object_selected = -1
global.tile_object_visible = {}
global.tile_object_solid = {}
global.tile_texture_container = obj_list_textures
global.tile_uv_tex = false

global.tile_x_min = -6
global.tile_y_min = -6
global.tile_z_min = -6
global.tile_x_max = 22
global.tile_y_max = 22
global.tile_z_max = 22

global.tile_xs_min = 0.2
global.tile_ys_min = 0.2
global.tile_zs_min = 0.2
global.tile_xs_max = 3.0
global.tile_ys_max = 3.0
global.tile_zs_max = 3.0

global.tile_xa_min = -180
global.tile_xa_max = 180
global.tile_ya_min = -180
global.tile_ya_max = 180
global.tile_za_min = -180
global.tile_za_max = 180

global.tile_object_x_start = 8
global.tile_object_y_start = 8
global.tile_object_z_start = 0

global.tag_var_name = {}
global.tag_var_name[$ "x"] = "tile_object_x_start"
global.tag_var_name[$ "y"] = "tile_object_y_start"
global.tag_var_name[$ "z"] = "tile_object_z_start"

if (!variable_global_exists("vb_cube_16")) {
	global.vb_cube_16 = vertex_create_buffer()
	global.mesh_cube_16 = load_obj("cube16.obj")
	vertex_begin(global.vb_cube_16, global.tile_3d_format)
	t3d_vb_obj(global.vb_cube_16, global.mesh_cube_16)
	vertex_end(global.vb_cube_16)
	vertex_freeze(global.vb_cube_16)
	
	global.vb_cube_1632 = vertex_create_buffer()
	global.mesh_cube_1632 = load_obj("cube1632.obj")
	vertex_begin(global.vb_cube_1632, global.tile_3d_format)
	t3d_vb_obj(global.vb_cube_1632, global.mesh_cube_1632)
	vertex_end(global.vb_cube_1632)
	vertex_freeze(global.vb_cube_1632)
}