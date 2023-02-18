/// @description init

button_create(
	"add",
	make_colour_rgb(16, 16, 128),
	function (me) {
		var tex_path = get_open_filename(
			"png file|*.png", ""
		);
		
		if tex_path != "" {
			var key = filename_name(tex_path);
			texture_manager_add(
				tex_path,
				key
			)
			
			with global.tile_texture_container {
				list_add_item(key)
			}
		}
	}
)