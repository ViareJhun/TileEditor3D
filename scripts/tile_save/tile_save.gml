function tile_save(fname) {
	var save_path = filename_path(fname);
	
	#region Textures prepare
	var textures_to_save = {};
	if global.tile_tex_main != noone {
		textures_to_save[$ global.tile_tex_main.my_key] = true
	}
	
	var count = array_length(global.tile_object_container.widget_data);
	for (var i = 0; i < count; i ++) {
		var name = global.tile_object_container.widget_data[i];
		var _tex = global.tile_object_texture[$ name];
		if _tex != -1 {
			var tex = texture_manager_get(
				global.tile_texture_container.widget_data[_tex]
			);
			
			if !variable_struct_exists(textures_to_save, tex.my_key) {
				textures_to_save[$ tex.my_key] = true
			}
		}
	}
	var _textures = variable_struct_get_names(textures_to_save);
	var textures = [];
	var tex_names_new = {};
	var tex_names_new_rev = {};
	for (var i = 0; i < array_length(_textures); i ++) {
		var name = global.tile_name + "_tex_" + string(i) + ".png";
		var is_main = false;
		var spec_strength = texture_manager_get(_textures[i]).specular;
		var spec_blur = texture_manager_get(_textures[i]).specular_blur;
		if _textures[i] == filename_name(global.tile_tex_path) {
			is_main = true
		}
		tex_names_new[$ _textures[i]] = name
		tex_names_new_rev[$ name] = _textures[i]
		array_push(textures, [name, is_main, spec_strength, spec_blur])
	}
	#endregion
	
	#region Models prepare
	var models_to_save = {};
	
	var count = array_length(global.tile_object_container.widget_data);
	for (var i = 0; i < count; i ++) {
		var name = global.tile_object_container.widget_data[i];
		var mdl = global.tile_object_models[$ name];
		
		if !variable_struct_exists(models_to_save, mdl.my_key) {
			models_to_save[$ mdl.my_key] = {
				aabb: mdl.struct.aabb,
				size: mdl.struct.size,
				data: mdl.struct.data
			}
		}
	}
	var models = variable_struct_get_names(models_to_save);
	#endregion
	
	#region Object prepare
	var objects = [];
	var count = array_length(global.tile_object_container.widget_data);
	for (var i = 0; i < count; i ++) {
		var name = global.tile_object_container.widget_data[i];
		var trans = global.tile_object_transformations[$ name];
		var model = global.tile_object_models[$ name];
		var _solid = global.tile_object_solid[$ name];
		var _visible = global.tile_object_visible[$ name];
		var tex_name = tex_names_new[$
			global.tile_texture_container.widget_data[
				global.tile_object_texture[$ name]
			]
		];
		
		array_push(
			objects,
			{
				name: name,
				solid: _solid,
				visible: _visible,
				texture_name: tex_name,
				model_name: model.my_key,
				transformations: trans
			}
		)
	}
	#endregion
	
	var save_data = {
		tile_name: global.tile_name,
		tile_solid: global.tile_solid,
		tile_wall_high: global.tile_wall_high,
		uv_map: global.tile_uv_tex,
		
		texture_count: array_length(textures),
		texture_names: textures,
		
		model_count: array_length(models),
		model_names: models,
		model_data: models_to_save,
		
		object_count: array_length(global.tile_object_container.widget_data),
		object_data: objects
	};
	
	#region Write
	var file = file_text_open_write(fname);
	file_text_write_string(
		file,
		json_stringify(
			save_data
		)
	)
	file_text_close(file)
	#endregion
	
	#region Textures write
	for (var i = 0; i < array_length(textures); i ++) {
		var name = textures[i][0];
		var key = tex_names_new_rev[$ name];
		
		sprite_save(
			texture_manager_get(key).sprite,
			0,
			save_path + name// + ".png"
		)
	}
	
	if surface_exists(obj_render_window.render_tile_surf) {
		surface_save(
			obj_render_window.render_tile_surf,
			save_path + global.tile_name + "_icon.png"
		)
	}
	#endregion
	
	show_message("tile saved")
}