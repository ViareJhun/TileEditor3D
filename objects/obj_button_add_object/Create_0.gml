/// @description init

button_create(
	"add",
	make_colour_rgb(16, 16, 128),
	function (me) {
		var obj_path = get_open_filename(
			"obj file|*.obj", ""
		);
		
		if obj_path != "" {
			var key = filename_name(obj_path);
			var name = key + "_" + 
			string(
				array_length(
					global.tile_object_container.widget_data
				) + 1
			);
			
			global.tile_object_models[$ name] = model_manager_add(
				obj_path,
				key
			)
			with global.tile_object_container {
				list_add_item(name)
			}
			global.tile_object_transformations[$ name] = {
				x: global.tile_object_x_start,
				y: global.tile_object_y_start,
				z: global.tile_object_z_start,
				x_angle: 0,
				y_angle: 0,
				z_angle: 0,
				x_scale: 1,
				y_scale: 1,
				z_scale: 1
			}
			global.tile_object_texture[$ name] = -1
			global.tile_object_visible[$ name] = true
			global.tile_object_solid[$ name] = true
		}
	}
)