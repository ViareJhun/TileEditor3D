/// @description init

button_create(
	"save tile",
	make_colour_rgb(16, 16, 128),
	function (me) {
		var file = get_save_filename(
			"3dtile file|*.tl3",
			global.tile_name
		);
		if file != "" {
			tile_save(file)
		}
	}
)