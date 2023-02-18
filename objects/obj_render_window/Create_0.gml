/// @description init

render_surface = -1
render_offset = 4
render_width = sprite_width
render_height = sprite_height

render_cam = t3d_camera(
	0,
	0,
	0,
	0.4,
	60,
	render_width / render_height,
	0.1,
	1024
)
render_cam.phi_to = 150
render_cam.theta_to = 45

render_len_to = 8
render_len = render_len_to
render_len_min = 2
render_len_max = 128
render_x_view = 0
render_y_view = 0
render_z = 0
render_z_to = 0
render_z_temp = 0
render_z_update = false
render_zy_temp = 0
render_view_update = false
render_sens = 0.2

render_tile_size = 64
render_tile_surf = -1
render_tile_cam = t3d_camera_ortho(
	7, 7, 64,
	1,
	16,
	16,
	1,
	1024
)
render_tile_cam.up_x = dcos(-91)
render_tile_cam.up_y = -dsin(91)
render_tile_cam.up_z = 1

function render_3d(cam, aabb_draw = true) {
	t3d_draw_begin(cam)
	gpu_set_tex_filter(global.tile_draw_interpolation)
	
	vertex_submit(
		global.tile_3d_grid,
		pr_linelist,
		-1
	)
	
	shader_set(shd_tile_3d)
	shader_set_uniform_f(
		global.uni_tile_3d_ambient,
		global.tile_draw_ambient
	)
	shader_set_uniform_f_array(
		global.uni_tile_3d_sun_dir,
		global.tile_draw_sun_dir
	)
	shader_set_uniform_f(
		global.uni_tile_3d_specular_strength,
		1.0
	)
	shader_set_uniform_f_array(
		global.uni_tile_3d_camera_position,
		[cam.x, cam.y, cam.z]
	)
	
	if global.tile_tex_main != noone {
		shader_set_uniform_f(
			global.uni_tile_3d_specular_strength,
			global.tile_tex_main.specular
		)
		shader_set_uniform_f(
			global.uni_tile_3d_specular_blur,
			global.tile_tex_main.specular_blur
		)
		if global.tile_solid {
			var vb_wall = global.tile_3d_wall;
			if global.tile_wall_high {
				vb_wall = global.tile_3d_wall_high
				if global.tile_uv_tex {
					vb_wall = global.vb_cube_1632
				}
			} else {
				if global.tile_uv_tex {
					vb_wall = global.vb_cube_16
				}
			}
			
			vertex_submit(
				vb_wall,
				pr_trianglelist,
				global.tile_tex_main.texture
			)
		} else {
			vertex_submit(
				global.tile_3d_floor,
				pr_trianglelist,
				global.tile_tex_main.texture
			)
		}
	}
	
	// Render objects
	var count = array_length(
		global.tile_object_container.widget_data
	);
	for (var i = 0; i < count; i ++) {
		var name = global.tile_object_container.widget_data[i];
		
		if global.tile_object_visible[$ name] {
			var trans = global.tile_object_transformations[$ name];
			var model = global.tile_object_models[$ name];
			var tex_id = global.tile_object_texture[$ name];
			var tex = -1;
			var spec = 1;
			var blur = 32;
			if tex_id == -1 {
				if global.tile_tex_main != noone {
					tex = global.tile_tex_main.texture
					spec = global.tile_tex_main.specular
					blur = global.tile_tex_main.specular_blur
				}
			} else {
				var key = (
					global.tile_texture_container.widget_data[tex_id]
				);
				tex = texture_manager_get(key).texture
				spec = texture_manager_get(key).specular
				blur = texture_manager_get(key).specular_blur
			}
			
			shader_set_uniform_f(
				global.uni_tile_3d_specular_strength,
				spec
			)
			shader_set_uniform_f(
				global.uni_tile_3d_specular_blur,
				blur
			)
			
			matrix_set(
				matrix_world,
				matrix_build(
					trans.x,
					trans.y,
					trans.z,
					trans.x_angle,
					trans.y_angle,
					trans.z_angle,
					trans.x_scale,
					trans.y_scale,
					trans.z_scale
				)
			)
			vertex_submit(
				model.vertex_buffer,
				pr_trianglelist,
				tex
			)
			matrix_set(
				matrix_world,
				matrix_build_identity()
			)
		}
	}
	shader_reset()
	
	if aabb_draw {
		if obj_list_objects.widget_data_selected > -1 {
			var name = obj_list_objects.widget_data[
				obj_list_objects.widget_data_selected
			];
			var trans = global.tile_object_transformations[$ name];
			var model = global.tile_object_models[$ name];
		
			shader_set(shd_aabb_3d)
			shader_set_uniform_f_array(
				global.uni_aabb_3d_color,
				col2rgb(c_aqua)
			)
			matrix_set(
				matrix_world,
				matrix_build(
					trans.x,
					trans.y,
					trans.z,
					trans.x_angle,
					trans.y_angle,
					trans.z_angle,
					trans.x_scale,
					trans.y_scale,
					trans.z_scale
				)
			)
			vertex_submit(
				model.vertex_buffer_aabb,
				pr_linelist,
				-1
			)
		
			shader_set_uniform_f_array(
				global.uni_aabb_3d_color,
				col2rgb(c_red)
			)
			matrix_set(
				matrix_world,
				matrix_build(
					trans.x,
					trans.y,
					trans.z,
					0, 0, 0,
					trans.x_scale,
					trans.y_scale,
					trans.z_scale
				)
			)
			vertex_submit(
				model.vertex_buffer_aabb,
				pr_linelist,
				-1
			)
			shader_reset()
			
			matrix_set(
				matrix_world,
				matrix_build(
					trans.x,
					trans.y,
					trans.z,
					0, 0, 0,
					model.struct.size[0] * 1.0,
					model.struct.size[1] * 1.0,
					model.struct.size[2] * 1.0
				)
			)
			vertex_submit(
				global.tile_3d_axis,
				pr_linelist,
				-1
			)
			matrix_set(
				matrix_world,
				matrix_build_identity()
			)
		}
	}
	
	t3d_draw_end()
}