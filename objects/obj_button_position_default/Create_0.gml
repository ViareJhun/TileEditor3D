/// @description init

button_create(
	"x",
	make_colour_rgb(16, 16, 128),
	function (me) {
		if global.tile_object_container.widget_data_selected > -1 {
			var name = global.tile_object_container.widget_data[
				global.tile_object_container.widget_data_selected
			];
			
			variable_struct_set(
				global.tile_object_transformations[$ name],
				tag,
				variable_global_get(
					global.tag_var_name[$ tag]
				)
			)
			
			var trans = global.tile_object_transformations[$ name];
			with obj_editor slider_transform_update(trans)
		}
	}
)

tag = "x"