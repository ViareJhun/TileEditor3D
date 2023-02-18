/// @description init

button_create(
	"to center",
	make_colour_rgb(16, 16, 128),
	function (me) {
		if global.tile_object_container.widget_data_selected > -1 {
			var name = global.tile_object_container.widget_data[
				global.tile_object_container.widget_data_selected
			];
			with obj_editor {
				object_set_position(
					name,
					global.tile_object_x_start,
					global.tile_object_y_start,
					global.tile_object_z_start
				)
			}
		}
	}
)