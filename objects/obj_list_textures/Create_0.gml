/// @description init

list_create(
	function (me, index) {
		var name = me.widget_data[index];
		
		var tex = texture_manager_get(
			name
		);
		obj_slider_specular_tex.widget_value = tex.specular
		obj_slider_specular_tex.widget_value = from_range(
			tex.specular_blur,
			global.shininess_min,
			global.shininess_max
		)
		
		return index
	}
)