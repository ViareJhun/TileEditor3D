/// @description init

button_create(
	"load tile",
	make_colour_rgb(16, 16, 128),
	function (me) {
		var file = get_open_filename(
			"3dtile file|*.tl3",
			""
		);
		if file != "" {
			global.is_load = true
			global.load_file = file
			state_reset(true)
		}
	}
)