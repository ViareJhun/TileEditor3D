/// @description init

button_create(
	"remove",
	make_colour_rgb(16, 16, 128),
	function (me) {
		if global.tile_object_container.widget_data_selected > -1 {
			with global.tile_object_container {
				list_remove_item(
					widget_data_selected
				)
			}
		}
	}
)