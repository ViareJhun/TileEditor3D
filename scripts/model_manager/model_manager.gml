/*
	Model manager
*/

gml_pragma("global", "_mdl_man_init_()")

function _mdl_man_init_() {
	global.model_manager_container = ds_map_create()
}

function model_manager_clear() {
	var mdl = ds_map_find_first(global.model_manager_container);
	var count = ds_map_size(global.model_manager_container);
	
	repeat count {
		vertex_delete_buffer(
			global.model_manager_container[? mdl].vertex_buffer
		)
		
		mdl = ds_map_find_next(
			global.model_manager_container,
			mdl
		)
	}
	
	ds_map_destroy(global.model_manager_container)
	global.model_manager_container = ds_map_create()
}

function model_manager_get(key) {
	return global.model_manager_container[? key]
}

function model_manager_add(tex_path, key) {
	if ds_map_exists(
		global.model_manager_container,
		key
	) {
		return global.model_manager_container[? key]
	}
	
	var model = {
		struct: load_obj(tex_path),
		vertex_buffer: vertex_create_buffer(),
		vertex_buffer_aabb: vertex_create_buffer(),
		my_key: key
	};
	vertex_begin(model.vertex_buffer, global.tile_3d_format)
	t3d_vb_obj(model.vertex_buffer, model.struct)
	vertex_end(model.vertex_buffer)
	vertex_freeze(model.vertex_buffer)
	
	vertex_begin(model.vertex_buffer_aabb, global.tile_3d_format)
	t3d_vb_aabb(model.vertex_buffer_aabb, model.struct)
	vertex_end(model.vertex_buffer_aabb)
	vertex_freeze(model.vertex_buffer_aabb)
	
	global.model_manager_container[? key] = model
	return global.model_manager_container[? key]
}

function model_manager_add_data(data, key) {
	if ds_map_exists(
		global.model_manager_container,
		key
	) {
		return global.model_manager_container[? key]
	}
	
	var model = {
		struct: data,
		vertex_buffer: vertex_create_buffer(),
		vertex_buffer_aabb: vertex_create_buffer(),
		my_key: key
	};
	vertex_begin(model.vertex_buffer, global.tile_3d_format)
	t3d_vb_obj(model.vertex_buffer, model.struct)
	vertex_end(model.vertex_buffer)
	vertex_freeze(model.vertex_buffer)
	
	vertex_begin(model.vertex_buffer_aabb, global.tile_3d_format)
	t3d_vb_aabb(model.vertex_buffer_aabb, model.struct)
	vertex_end(model.vertex_buffer_aabb)
	vertex_freeze(model.vertex_buffer_aabb)
	
	global.model_manager_container[? key] = model
	return global.model_manager_container[? key]
}