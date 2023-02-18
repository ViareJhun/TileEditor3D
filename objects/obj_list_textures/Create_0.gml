/// @description init

list_create(
	function (me, index) {
		var name = me.widget_data[index];
		
		obj_slider_specular_tex.widget_value = texture_manager_get(
			name
		).specular
		
		return index
	}
)