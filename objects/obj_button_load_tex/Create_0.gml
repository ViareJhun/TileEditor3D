/// @description init

button_create(
	"load texture",
	make_colour_rgb(16, 16, 128),
	function (me) {
		var tex_path = get_open_filename(
			"png file|*.png", ""
		);
		
		if tex_path != "" {
			var key = filename_name(tex_path);
			
			global.tile_tex_path = tex_path
			global.tile_tex_main = texture_manager_add(
				tex_path,
				key
			)
		}
	}
)