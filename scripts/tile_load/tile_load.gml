function tile_load(fname) {
	var load_path = filename_path(fname);
	
	#region JSON load
	var file = file_text_open_read(fname);
	var text = "";
	while !file_text_eof(file) {
		text += file_text_readln(file);
	}
	file_text_close(file)
	
	var load_data = json_parse(text);
	#endregion
	
	global.tile_name = load_data.tile_name
	obj_entry_name.widget_entry_text = global.tile_name
	global.tile_solid = load_data.tile_solid
	obj_check_box_solid.widget_value = global.tile_solid
	global.tile_wall_high = load_data.tile_wall_high
	obj_check_box_wall_high.widget_value = global.tile_wall_high
	global.tile_uv_tex = false
	if (variable_struct_exists(load_data, "uv_map")) {
		global.tile_uv_tex = load_data.uv_map
	}
	obj_check_box_uv_map.widget_value = global.tile_uv_tex
	
	for (var i = 0; i < load_data.texture_count; i ++) {
		var name = load_data.texture_names[i][0];
		var is_main = load_data.texture_names[i][1];
		
		var spec_value = 1;
		var spec_blur = 32;
		if (array_length(load_data.texture_names[i]) > 2) {
			spec_value = load_data.texture_names[i][2]
		}
		if (array_length(load_data.texture_names[i]) > 3) {
			spec_blur = load_data.texture_names[i][3]
		}
		
		var tex_path = load_path + name;// + ".png";
		var temp = texture_manager_add(
			tex_path,
			name
		);
		temp.specular = spec_value
		temp.specular_blur = spec_blur
		obj_slider_specular.widget_value = spec_value
		
		if is_main {
			global.tile_tex_path = tex_path
			global.tile_tex_main = texture_manager_get(
				name
			)
		} else {
			with obj_list_textures {
				list_add_item(name)
			}
		}
	}
	
	for (var i = 0; i < load_data.model_count; i ++) {
		var name = load_data.model_names[i];
		var model = load_data.model_data[$ name];
		model_manager_add_data(
			model,
			name
		)
	}
	
	for (var i = 0; i < load_data.object_count; i ++) {
		var object = load_data.object_data[i];
		var name = object.name;
		
		global.tile_object_solid[$ name] = object.solid
		global.tile_object_visible[$ name] = object.visible
		global.tile_object_transformations[$ name] = object.transformations
		global.tile_object_models[$ name] = model_manager_get(
			object.model_name
		)
		global.tile_object_texture[$ name] = array_get_index(
			obj_list_textures.widget_data, object.texture_name
		)
		
		with obj_list_objects {
			list_add_item(name)
		}
	}
	
	show_message("tile loaded")
}