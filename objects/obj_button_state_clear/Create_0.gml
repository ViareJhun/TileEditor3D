/// @description init

button_create(
	"clear all",
	make_colour_rgb(16, 16, 128),
	function (me) {
		state_reset()
	}
)