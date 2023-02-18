/*
	Tile 3D
*/

gml_pragma("global", "_tile_3d_init_()")
enum camera_type {
	perspective,
	ortho
}

function _tile_3d_init_() {
	vertex_format_begin()
	vertex_format_add_position_3d()
	vertex_format_add_normal()
	vertex_format_add_color()
	vertex_format_add_texcoord()
	global.tile_3d_format = vertex_format_end()
	
	global.uni_tile_3d_ambient = shader_get_uniform(shd_tile_3d, "ambient")
	global.uni_tile_3d_sun_dir = shader_get_uniform(shd_tile_3d, "sun_dir")
	global.uni_tile_3d_specular_strength = shader_get_uniform(shd_tile_3d, "specular_strength")
	global.uni_tile_3d_specular_blur = shader_get_uniform(shd_tile_3d, "specular_blur")
	global.uni_tile_3d_camera_position = shader_get_uniform(shd_tile_3d, "camera_position")
	global.uni_aabb_3d_color = shader_get_uniform(shd_aabb_3d, "color")
	
	global.tile_3d_mat_view_storage = noone
	global.tile_3d_mat_proj_storage = noone
	
	global.tile_3d_floor = vertex_create_buffer()
	vertex_begin(global.tile_3d_floor, global.tile_3d_format)
	t3d_vb_floor(global.tile_3d_floor, 0, 0, 16, 16, 0, [0, 0, 1, 1])
	vertex_end(global.tile_3d_floor)
	vertex_freeze(global.tile_3d_floor)
	
	global.tile_3d_wall = vertex_create_buffer()
	vertex_begin(global.tile_3d_wall, global.tile_3d_format)
	t3d_vb_block(global.tile_3d_wall, 0, 0, 0, 16, 16, 16, [0, 0, 1, 1])
	vertex_end(global.tile_3d_wall)
	vertex_freeze(global.tile_3d_wall)
	
	global.tile_3d_wall_high = vertex_create_buffer()
	vertex_begin(global.tile_3d_wall_high, global.tile_3d_format)
	t3d_vb_block(global.tile_3d_wall_high, 0, 0, 0, 16, 16, 32, [0, 0, 1, 1])
	vertex_end(global.tile_3d_wall_high)
	vertex_freeze(global.tile_3d_wall_high)
	
	var s = 16;
	var step = 16;
	global.tile_3d_grid = vertex_create_buffer()
	vertex_begin(global.tile_3d_grid, global.tile_3d_format)
	for (var i = -s / 2; i <= s / 2; i ++) {
		var offset = i * step;
		var half = s * 0.5 * step;
		t3d_vertex(global.tile_3d_grid, offset, -half, -0.2, 0, 0, 1, 0, 0, c_white, 1)
		t3d_vertex(global.tile_3d_grid, offset, half, -0.2, 0, 0, 1, 0, 0, c_white, 1)
		
		t3d_vertex(global.tile_3d_grid, -half, offset, -0.2, 0, 0, 1, 0, 0, c_white, 1)
		t3d_vertex(global.tile_3d_grid, half, offset, -0.2, 0, 0, 1, 0, 0, c_white, 1)
	}
	vertex_end(global.tile_3d_grid)
	vertex_freeze(global.tile_3d_grid)
	
	global.tile_3d_axis = vertex_create_buffer()
	vertex_begin(global.tile_3d_axis, global.tile_3d_format)
	t3d_vertex(global.tile_3d_axis, 0, 0, 0, 0, 0, 1, 0, 0, c_lime, 1)
	t3d_vertex(global.tile_3d_axis, 1, 0, 0, 0, 0, 1, 0, 0, c_lime, 1)
	
	t3d_vertex(global.tile_3d_axis, 0, 0, 0, 0, 0, 1, 0, 0, c_red, 1)
	t3d_vertex(global.tile_3d_axis, 0, 1, 0, 0, 0, 1, 0, 0, c_red, 1)
	
	t3d_vertex(global.tile_3d_axis, 0, 0, 0, 0, 0, 1, 0, 0, c_blue, 1)
	t3d_vertex(global.tile_3d_axis, 0, 0, 1, 0, 0, 1, 0, 0, c_blue, 1)
	vertex_end(global.tile_3d_axis)
	vertex_freeze(global.tile_3d_axis)
}

function t3d_vertex(vb, x, y, z, nx, ny, nz, u, v, color, alpha) {
	vertex_position_3d(vb, x, y, z)
	vertex_normal(vb, nx, ny, nz)
	vertex_color(vb, color, alpha)
	vertex_texcoord(vb, u, v)
}
function t3d_vertex2(x, y, z, nx, ny, nz, u, v, color, alpha, vb) {
	vertex_position_3d(vb, x, y, z)
	vertex_normal(vb, nx, ny, nz)
	vertex_color(vb, color, alpha)
	vertex_texcoord(vb, u, v)
}

function t3d_vb_obj(vb, obj_struct) {
	var count = array_length(obj_struct.data);
	
	for (var i = 0; i < count; i ++) {
		var data = obj_struct.data[i];
		
		for (var j = 0; j < 3; j ++) {
			var position = data[j][0];
			var normal = data[j][1];
			var uv = data[j][2];
			
			t3d_vertex(
				vb,
				position[0], position[1], position[2],
				normal[0], normal[1], normal[2],
				uv[0], uv[1],
				c_white,
				1
			)
		}
	}
}

function t3d_vb_aabb(vb, obj_struct) {
	var aabb = obj_struct.aabb;
	
	t3d_vertex(vb, aabb.x_min, aabb.y_min, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_max, aabb.y_min, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	
	t3d_vertex(vb, aabb.x_min, aabb.y_min, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_min, aabb.y_max, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	
	t3d_vertex(vb, aabb.x_min, aabb.y_min, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_min, aabb.y_min, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
	
	
	t3d_vertex(vb, aabb.x_min, aabb.y_min, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_max, aabb.y_min, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
	
	t3d_vertex(vb, aabb.x_min, aabb.y_min, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_min, aabb.y_max, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
	
	
	t3d_vertex(vb, aabb.x_max, aabb.y_max, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_min, aabb.y_max, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
	
	t3d_vertex(vb, aabb.x_max, aabb.y_max, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_max, aabb.y_min, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
	
	t3d_vertex(vb, aabb.x_max, aabb.y_max, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_max, aabb.y_max, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	
	
	t3d_vertex(vb, aabb.x_max, aabb.y_max, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_min, aabb.y_max, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	
	t3d_vertex(vb, aabb.x_max, aabb.y_max, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_max, aabb.y_min, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	
	
	t3d_vertex(vb, aabb.x_max, aabb.y_min, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_max, aabb.y_min, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
	
	t3d_vertex(vb, aabb.x_min, aabb.y_max, aabb.z_min, 0, 0, 1, 0, 0, c_white, 1)
	t3d_vertex(vb, aabb.x_min, aabb.y_max, aabb.z_max, 0, 0, 1, 0, 0, c_white, 1)
}

function t3d_vb_floor(vb, sx, sy, fx, fy, z, uvs) {
	t3d_vertex(
		vb,
		sx, sy,
		z,
		0, 0, 1,
		uvs[0],
		uvs[1],
		c_white,
		1
	)
	t3d_vertex(
		vb,
		fx, sy,
		z,
		0, 0, 1,
		uvs[2],
		uvs[1],
		c_white,
		1
	)
	t3d_vertex(
		vb,
		fx, fy,
		z,
		0, 0, 1,
		uvs[2],
		uvs[3],
		c_white,
		1
	)
	
	t3d_vertex(
		vb,
		sx, sy,
		z,
		0, 0, 1,
		uvs[0],
		uvs[1],
		c_white,
		1
	)
	t3d_vertex(
		vb,
		fx, fy,
		z,
		0, 0, 1,
		uvs[2],
		uvs[3],
		c_white,
		1
	)
	t3d_vertex(
		vb,
		sx, fy,
		z,
		0, 0, 1,
		uvs[0],
		uvs[3],
		c_white,
		1
	)
}

function t3d_vb_block(vb, x1, y1, z1, x2, y2, z2, uvs) {
	var l = uvs[0];
	var t = uvs[1];
	var r = uvs[2];
	var b = uvs[3];
	
	// top
	t3d_vertex2(x1, y1, z2, 0, 0, 1, l, t, c_white, 1, vb)
	t3d_vertex2(x2, y2, z2, 0, 0, 1, r, b, c_white, 1, vb)
	t3d_vertex2(x2, y1, z2, 0, 0, 1, r, t, c_white, 1, vb)
	
	t3d_vertex2(x2, y2, z2, 0, 0, 1, r, b, c_white, 1, vb)
	t3d_vertex2(x1, y1, z2, 0, 0, 1, l, t, c_white, 1, vb)
	t3d_vertex2(x1, y2, z2, 0, 0, 1, l, b, c_white, 1, vb)
	
	// bottom
	t3d_vertex2(x1, y1, z1, 0, 0, -1, l, t, c_white, 1, vb)
	t3d_vertex2(x2, y2, z1, 0, 0, -1, r, b, c_white, 1, vb)
	t3d_vertex2(x2, y1, z1, 0, 0, -1, r, t, c_white, 1, vb)
	
	t3d_vertex2(x2, y2, z1, 0, 0, -1, r, b, c_white, 1, vb)
	t3d_vertex2(x1, y1, z1, 0, 0, -1, l, t, c_white, 1, vb)
	t3d_vertex2(x1, y2, z1, 0, 0, -1, l, b, c_white, 1, vb)
	
	// north
	t3d_vertex2(x1, y1, z2, 0, -1, 0, l, t, c_white, 1, vb)
	t3d_vertex2(x2, y1, z1, 0, -1, 0, r, b, c_white, 1, vb)
	t3d_vertex2(x2, y1, z2, 0, -1, 0, r, t, c_white, 1, vb)
	
	t3d_vertex2(x2, y1, z1, 0, -1, 0, r, b, c_white, 1, vb)
	t3d_vertex2(x1, y1, z2, 0, -1, 0, l, t, c_white, 1, vb)
	t3d_vertex2(x1, y1, z1, 0, -1, 0, l, b, c_white, 1, vb)
	
	// west
	t3d_vertex2(x1, y2, z2, -1, 0, 0, l, t, c_white, 1, vb)
	t3d_vertex2(x1, y1, z1, -1, 0, 0, r, b, c_white, 1, vb)
	t3d_vertex2(x1, y1, z2, -1, 0, 0, r, t, c_white, 1, vb)
	
	t3d_vertex2(x1, y1, z1, -1, 0, 0, r, b, c_white, 1, vb)
	t3d_vertex2(x1, y2, z2, -1, 0, 0, l, t, c_white, 1, vb)
	t3d_vertex2(x1, y2, z1, -1, 0, 0, l, b, c_white, 1, vb)
	
	// south
	t3d_vertex2(x2, y2, z2, 0, 1, 0, l, t, c_white, 1, vb)
	t3d_vertex2(x1, y2, z1, 0, 1, 0, r, b, c_white, 1, vb)
	t3d_vertex2(x1, y2, z2, 0, 1, 0, r, t, c_white, 1, vb)
	
	t3d_vertex2(x1, y2, z1, 0, 1, 0, r, b, c_white, 1, vb)
	t3d_vertex2(x2, y2, z2, 0, 1, 0, l, t, c_white, 1, vb)
	t3d_vertex2(x2, y2, z1, 0, 1, 0, l, b, c_white, 1, vb)
	
	// east
	t3d_vertex2(x2, y1, z2, 1, 0, 0, l, t, c_white, 1, vb)
	t3d_vertex2(x2, y2, z1, 1, 0, 0, r, b, c_white, 1, vb)
	t3d_vertex2(x2, y2, z2, 1, 0, 0, r, t, c_white, 1, vb)
	
	t3d_vertex2(x2, y2, z1, 1, 0, 0, r, b, c_white, 1, vb)
	t3d_vertex2(x2, y1, z2, 1, 0, 0, l, t, c_white, 1, vb)
	t3d_vertex2(x2, y1, z1, 1, 0, 0, l, b, c_white, 1, vb)
}

function t3d_camera(x, y, z, view_speed, fov, aspect, znear, zfar) {
	return {
		x: x,
		y: y,
		z: z,
		view_x: 1,
		view_y: 0,
		view_z: 0,
		up_x: 0,
		up_y: 0,
		up_z: 1,
		theta: 0,
		phi: 90,
		theta_to: 0,
		phi_to: 0,
		view_speed: view_speed,
		fov: fov,
		aspect: aspect,
		znear: znear,
		zfar: zfar,
		type: camera_type.perspective,
		
		mat_view: noone,
		mat_proj: noone
	}
}

function t3d_camera_ortho(x, y, z, view_speed, owidth, oheight, znear, zfar) {
	return {
		x: x,
		y: y,
		z: z,
		view_x: 1,
		view_y: 0,
		view_z: 0,
		up_x: 0,
		up_y: 0,
		up_z: 1,
		theta: 0,
		phi: 90,
		theta_to: 0,
		phi_to: 0,
		view_speed: view_speed,
		ortho_width: owidth,
		ortho_height: oheight,
		znear: znear,
		zfar: zfar,
		type: camera_type.ortho,
		
		mat_view: noone,
		mat_proj: noone
	}
}

function t3d_camera_view(camera, azimut, zenit) {
	camera.theta_to = azimut
	camera.phi_to = zenit
}

function t3d_camera_calc(camera) {
	camera.theta_to = camera.theta_to mod 360
	camera.phi_to = clamp(camera.phi_to, 1, 179)
	
	camera.theta += angle_difference(
		camera.theta_to,
		camera.theta
	) * camera.view_speed
	camera.phi = lerp(
		camera.phi,
		camera.phi_to,
		camera.view_speed
	)
	
	camera.view_x = dsin(camera.phi) * dcos(camera.theta)
	camera.view_y = dsin(camera.phi) * dsin(camera.theta)
	camera.view_z = dcos(camera.phi)
	
	camera.mat_view = matrix_build_lookat(
		camera.x,
		camera.y,
		camera.z,
		camera.x + camera.view_x,
		camera.y + camera.view_y,
		camera.z + camera.view_z,
		camera.up_x,
		camera.up_y,
		camera.up_z
	)
	if camera.type == camera_type.perspective {
		camera.mat_proj = matrix_build_projection_perspective_fov(
			camera.fov,
			camera.aspect,
			camera.znear,
			camera.zfar
		)
	} else {
		camera.mat_proj = matrix_build_projection_ortho(
			camera.ortho_width,
			camera.ortho_height,
			camera.znear,
			camera.zfar
		)
	}
}

function t3d_camera_calc_view(camera, x, y, z) {
	camera.view_x = x
	camera.view_y = y
	camera.view_z = z
	
	camera.mat_view = matrix_build_lookat(
		camera.x,
		camera.y,
		camera.z,
		camera.x + camera.view_x,
		camera.y + camera.view_y,
		camera.z + camera.view_z,
		camera.up_x,
		camera.up_y,
		camera.up_z
	)
	if camera.type == camera_type.perspective {
		camera.mat_proj = matrix_build_projection_perspective_fov(
			camera.fov,
			camera.aspect,
			camera.znear,
			camera.zfar
		)
	} else {
		camera.mat_proj = matrix_build_projection_ortho(
			camera.ortho_width,
			camera.ortho_height,
			camera.znear,
			camera.zfar
		)
	}
}

function t3d_draw_begin(camera) {
	global.tile_3d_mat_view_storage = matrix_get(matrix_view)
	global.tile_3d_mat_proj_storage = matrix_get(matrix_projection)
	gpu_push_state()
	
	matrix_set(
		matrix_view,
		camera.mat_view
	)
	matrix_set(
		matrix_projection,
		camera.mat_proj
	)
	
	gpu_set_ztestenable(true)
	gpu_set_zwriteenable(true)
}

function t3d_draw_end() {
	gpu_pop_state()
	
	matrix_set(
		matrix_view,
		global.tile_3d_mat_view_storage
	)
	matrix_set(
		matrix_projection,
		global.tile_3d_mat_proj_storage
	)
}