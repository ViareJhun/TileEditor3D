/// @description init

list_create(
	function(me, index) {
		var name = me.widget_data[index];
		
		obj_list_textures.widget_data_selected = (
			global.tile_object_texture[$ name]
		)
		var trans = global.tile_object_transformations[$ name];
		with obj_editor slider_transform_update(trans)
		
		obj_check_box_object_visible.widget_value = global.tile_object_visible[$ name];
		obj_check_box_object_solid.widget_value = global.tile_object_solid[$ name];
		
		var tex = texture_manager_get(
			obj_list_textures.widget_data[
				global.tile_object_texture[$ name]
			]
		);
		obj_slider_specular_tex.widget_value = tex.specular
		obj_slider_shininess_tex.widget_value = from_range(
			tex.specular_blur,
			global.shininess_min,
			global.shininess_max
		)
		
		return index
	}
)