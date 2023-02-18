/// @description init

button_create(
	"1 scale",
	make_colour_rgb(16, 16, 128),
	function (me) {
		if global.tile_object_container.widget_data_selected > -1 {
			var name = global.tile_object_container.widget_data[
				global.tile_object_container.widget_data_selected
			];
			with obj_editor {
				object_set_scale(name, 1, 1, 1)
			}
		}
	}
)