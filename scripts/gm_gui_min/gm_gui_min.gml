/*
	Game Maker GUI Library
*/

gml_pragma("global", "_gm_gui_init_()")
enum widget_types {
	label,
	slider,
	button,
	entry,
	list,
	check_box
}

function _gm_gui_init_() {
	global.gm_gui_default_font = fnt_gm_gui
	
	global.gm_gui_slider_selected = noone
	global.gm_gui_slider_action = false
	
	global.gm_gui_entry_selected = noone
	global.gm_gui_entry_action = false
}

/// Important function !
/// Must be called in the End step event
function gm_gui_update() {
	global.gm_gui_slider_action = false
	global.gm_gui_entry_action = false
}

function widget_base(x, y, width, height) {
	widget_x = x
	widget_y = y
	widget_width = width
	widget_height = height
	
	widget_width_prev = width
	widget_height_prev = height
	
	widget_outline_color = c_white
	widget_background_color = make_colour_rgb(4, 4, 32)
	widget_text_color = c_white
}

#region Label
function label_create_ext(x, y, width, height, text) {
	widget_base(x, y, width, height)
	
	widget_type = widget_types.label
	widget_text = text
	widget_text_prev = text
	widget_surf = -1
	widget_surf_refresh = false
}

function label_create(text) {
	label_create_ext(
		x,
		y,
		sprite_width,
		sprite_height,
		text
	)
}

function label_update() {
	widget_x = x
	widget_y = y
	
	if (
		widget_width != widget_width_prev ||
		widget_height != widget_height_prev
	) {
		if surface_exists(widget_surf) {
			surface_free(widget_surf)
		}
	}
	
	if (
		widget_text != widget_text_prev
	) {
		widget_surf_refresh = true
	}
	
	widget_width_prev = widget_width
	widget_height_prev = widget_height
	
	widget_text_prev = widget_text
}

function label_draw() {
	var color = draw_get_colour();
	
	if !surface_exists(widget_surf) {
		widget_surf = surface_create(
			widget_width,
			widget_height
		)
		widget_surf_refresh = true
	}
	if widget_surf_refresh {
		widget_surf_refresh = false
		
		surface_set_target(widget_surf)
		draw_clear_alpha(c_black, 0)
		
		var font = draw_get_font();
		var halign = draw_get_halign();
		var valign = draw_get_valign();
		
		draw_set_font(global.gm_gui_default_font)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		
		draw_set_colour(widget_text_color)
		draw_text(
			widget_width * 0.5,
			widget_height * 0.5,
			widget_text
		)
		
		draw_set_font(font)
		draw_set_halign(halign)
		draw_set_valign(valign)
		
		surface_reset_target()
	}
	
	draw_set_colour(widget_background_color)
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		false
	)
	
	draw_surface(
		widget_surf,
		widget_x,
		widget_y
	)
	
	draw_set_colour(widget_outline_color)
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		true
	)
	
	draw_set_colour(color)
}

function label_clean_up() {
	if surface_exists(widget_surf) {
		surface_free(widget_surf)
	}
}
#endregion

#region Slider
function slider_create_ext(x, y, width, height, value, slider_color, select_color, offset = 8) {
	widget_base(x, y, width, height)
	
	widget_type = widget_types.slider
	widget_value = value
	widget_selected = false
	widget_offset = offset
	widget_width_value = widget_width - offset * 2
	widget_slider_color = slider_color
	widget_background_select_color = select_color
}

function slider_create(value, slider_color, select_color, offset = 8) {
	slider_create_ext(
		x,
		y,
		sprite_width,
		sprite_height,
		value,
		slider_color,
		select_color,
		offset
	)
}

function to_range(value, _min, _max) {
	return lerp(_min, _max, value)
}
function from_range(value, _min, _max) {
	return (value - _min) / (_max - _min)
}

function slider_update() {
	widget_x = x
	widget_y = y
	widget_width_value = widget_width - widget_offset * 2
	
	if !global.gm_gui_slider_action {
		if mouse_check_button_pressed(mb_left) {
			if (
				mouse_x > widget_x &&
				mouse_y > widget_y &&
				mouse_x < widget_x + widget_width &&
				mouse_y < widget_y + widget_height
			) {
				global.gm_gui_slider_selected = id
				global.gm_gui_slider_action = true
				widget_selected = true
			}
		}
	}
	
	if mouse_check_button_released(mb_left) {
		if global.gm_gui_slider_selected == id {
			widget_selected = false
			global.gm_gui_slider_selected = noone
		}
	}
	
	if (
		widget_selected &&
		global.gm_gui_slider_selected == id
	) {
		widget_value = clamp(
			mouse_x - widget_x,
			0,
			widget_width
		) / widget_width
	}
}

function slider_draw() {
	var color = draw_get_colour();
	
	draw_set_colour(widget_background_color)
	if widget_selected {
		draw_set_colour(widget_background_select_color)
	}
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		false
	)
	
	draw_set_colour(widget_slider_color)
	draw_rectangle(
		widget_x + widget_offset + 
		widget_value * widget_width_value - widget_offset,
		widget_y,
		widget_x + widget_offset + 
		widget_value * widget_width_value + widget_offset,
		widget_y + widget_height,
		false
	)
	
	draw_set_colour(widget_outline_color)
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		true
	)
	
	draw_set_colour(color)
}
#endregion

#region Button
function button_create_ext(x, y, width, height, text, press_color, func) {
	widget_base(x, y, width, height)
	
	widget_type = widget_types.button
	widget_background_press_color = press_color
	widget_pressed = false
	widget_surf = -1
	widget_surf_refresh = false
	widget_text = text
	widget_text_prev = text
	widget_function = func
}

function button_create(text, press_color, func) {
	button_create_ext(
		x,
		y,
		sprite_width,
		sprite_height,
		text,
		press_color,
		func
	)
}

function button_update() {
	widget_x = x
	widget_y = y
	
	var mouse_inside = (
		mouse_x > widget_x &&
		mouse_y > widget_y &&
		mouse_x < widget_x + widget_width &&
		mouse_y < widget_y + widget_height
	);
	if (
		mouse_check_button_pressed(mb_left) &&
		mouse_inside
	) {
		widget_pressed = true
	}
	if (
		mouse_check_button_released(mb_left)
	) {
		if (
			widget_pressed &&
			mouse_inside
		) {
			widget_function(id)
		}
		
		widget_pressed = false
	}
	
	if (
		widget_width != widget_width_prev ||
		widget_height != widget_height_prev
	) {
		if surface_exists(widget_surf) {
			surface_free(widget_surf)
		}
		
		widget_surf_refresh = true
	}
	
	if (
		widget_text != widget_text_prev
	) {
		widget_surf_refresh = true
	}
	
	widget_width_prev = widget_width
	widget_height_prev = widget_height
	
	widget_text_prev = widget_text
}

function button_draw() {
	var color = draw_get_colour();
	
	if !surface_exists(widget_surf) {
		widget_surf = surface_create(
			widget_width,
			widget_height
		)
		
		widget_surf_refresh = true
	}
	
	if widget_surf_refresh {
		widget_surf_refresh = false
		
		surface_set_target(widget_surf)
		draw_clear_alpha(c_black, 0)
		
		var font = draw_get_font();
		var halign = draw_get_halign();
		var valign = draw_get_valign();
		
		draw_set_font(global.gm_gui_default_font)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		
		draw_set_colour(widget_text_color)
		draw_text(
			widget_width * 0.5,
			widget_height * 0.5,
			widget_text
		)
		
		draw_set_font(font)
		draw_set_halign(halign)
		draw_set_valign(valign)
		
		surface_reset_target()
	}
	
	draw_set_colour(widget_background_color)
	if widget_pressed {
		draw_set_colour(widget_background_press_color)
	}
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		false
	)
	
	draw_surface(
		widget_surf,
		widget_x,
		widget_y
	)
	
	draw_set_colour(widget_outline_color)
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		true
	)
	
	draw_set_colour(color)
}

function button_clean_up() {
	if surface_exists(widget_surf) {
		surface_free(widget_surf)
	}
}
#endregion

#region Entry
function entry_create_ext(x, y, width, height, text, real_only) {
	widget_base(x, y, width, height)
	
	widget_type = widget_types.entry
	widget_background_color = make_colour_rgb(1, 1, 8)
	widget_background_select_color = make_colour_rgb(4, 4, 32)
	widget_entry_text = text
	widget_entry_selected = false
	widget_surf = -1
	widget_entry_real_only = real_only
}

function entry_create(text, real_only) {
	entry_create_ext(
		x,
		y,
		sprite_width,
		sprite_height,
		text,
		real_only
	)
}

function entry_update() {
	widget_x = x
	widget_y = y
	
	if mouse_check_button_released(mb_left) {
		if (
			mouse_x > widget_x &&
			mouse_y > widget_y &&
			mouse_x < widget_x + widget_width &&
			mouse_y < widget_y + widget_height &&
			!global.gm_gui_entry_action
		) {
			global.gm_gui_entry_selected = id
			global.gm_gui_entry_action = true
			widget_entry_selected = true
			keyboard_string = widget_entry_text
		} else {
			widget_entry_selected = false
			
			if widget_entry_real_only {
				widget_entry_text = string_digits(widget_entry_text)
			}
		}
	}
	
	if (
		widget_entry_selected &&
		global.gm_gui_entry_selected == id
	) {
		widget_entry_text = keyboard_string
	}
	
	if keyboard_check_pressed(vk_enter) {
		global.gm_gui_entry_selected = noone
		widget_entry_selected = false
		keyboard_string = ""
		
		if widget_entry_real_only {
			widget_entry_text = string_digits(widget_entry_text)
		}
	}
}

function entry_draw() {
	var color = draw_get_colour();
	
	if !surface_exists(widget_surf) {
		widget_surf = surface_create(
			widget_width,
			widget_height
		)
	}
	
	surface_set_target(widget_surf)
	draw_clear_alpha(c_black, 0)
	
	var font = draw_get_font();
	var halign = draw_get_halign();
	var valign = draw_get_valign();
	
	draw_set_font(global.gm_gui_default_font)
	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)
	draw_set_colour(widget_text_color)
	
	draw_text(
		2,
		widget_height * 0.5,
		widget_entry_text
	)
	
	draw_set_font(font)
	draw_set_halign(halign)
	draw_set_valign(valign)
	
	surface_reset_target()
	
	draw_set_colour(widget_background_color)
	if widget_entry_selected {
		draw_set_colour(widget_background_select_color)
	}
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		false
	)
	
	draw_surface(
		widget_surf,
		widget_x,
		widget_y
	)
	
	draw_set_colour(widget_outline_color)
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		true
	)
	
	draw_set_colour(color)
}

function entry_clean_up() {
	if surface_exists(widget_surf) {
		surface_free(widget_surf)
	}
}
#endregion

#region List
function list_create_ext(x, y, width, height, item_height, offset, press_func) {
	widget_base(x, y, width, height)
	
	widget_type = widget_types.list
	widget_scroll_offset = offset
	widget_scroll_height = 0
	widget_scroll_show = 0
	widget_scroll = 0
	widget_scroll_speed = 0.05
	widget_data = []
	widget_data_selected = -1
	widget_item_height = item_height
	widget_data_height = 0
	widget_surf = -1
	widget_item_color = make_colour_rgb(16, 16, 128)
	widget_press_func = press_func
}

function list_create(press_func = function(me,i){return i}, item_height = 24, offset = 16) {
	list_create_ext(
		x,
		y,
		sprite_width,
		sprite_height,
		item_height,
		offset,
		press_func
	)
}

function list_add_item(value) {
	array_push(
		widget_data,
		value
	)
}

function list_remove_item(index) {
	array_delete(
		widget_data,
		index,
		1
	)
	if widget_data_selected >= array_length(widget_data) {
		widget_data_selected = -1
	}
	if widget_data_selected < 0 {
		widget_data_selected = -1
	}
}

function list_update() {
	widget_x = x
	widget_y = y
	
	widget_scroll_height = widget_height - widget_scroll_offset * 2
	
	var mouse_inside = (
		mouse_x >= widget_x &&
		mouse_y >= widget_y &&
		mouse_x <= widget_x + widget_width - widget_scroll_offset &&
		mouse_y <= widget_y + widget_height
	);
	var mouse_inside_scroll = (
		mouse_x >= widget_x + widget_width - widget_scroll_offset &&
		mouse_y >= widget_y &&
		mouse_x <= widget_x + widget_width &&
		mouse_y <= widget_y + widget_height
	);
	
	if mouse_inside {
		if mouse_wheel_up() {
			widget_scroll -= widget_scroll_speed
		}
		if mouse_wheel_down() {
			widget_scroll += widget_scroll_speed
		}
	}
	if mouse_inside_scroll {
		if mouse_check_button(mb_left) {
			widget_scroll = clamp(
				mouse_y - widget_y,
				0,
				widget_height
			) / widget_height
		}
	}
	if mouse_check_button_pressed(mb_left) {
		if mouse_inside {
			var num = floor(
				(
					mouse_y - widget_y + max(
						0,
						widget_data_height - widget_height
					) * widget_scroll_show
				) / widget_item_height
			);
			if (
				num >= 0 &&
				num < array_length(widget_data)
			) {
				widget_data_selected = widget_press_func(id, num)
			}
		}
	}
	if widget_data_selected >= array_length(widget_data) {
		widget_data_selected = -1
	}
	if widget_data_selected < 0 {
		widget_data_selected = -1
	}
	
	widget_scroll = clamp(
		widget_scroll,
		0,
		1
	)
	widget_scroll_show = lerp(
		widget_scroll_show,
		widget_scroll,
		0.2
	)
	widget_data_height = array_length(
		widget_data
	) * widget_item_height
}

function list_draw() {
	var color = draw_get_colour();
	
	if !surface_exists(widget_surf) {
		widget_surf = surface_create(
			widget_width,
			widget_height
		)
	}
	
	surface_set_target(widget_surf)
	draw_clear_alpha(c_black, 0)
	
	var font = draw_get_font();
	var halign = draw_get_halign();
	var valign = draw_get_valign();
	
	draw_set_font(global.gm_gui_default_font)
	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)
	draw_set_colour(widget_text_color)
	
	var count = array_length(widget_data);
	var y_offset = max(
		0,
		widget_data_height - widget_height
	) * widget_scroll_show;
	for (var i = 0; i < count; i ++) {
		if widget_data_selected == i {
			draw_set_colour(widget_item_color)
			draw_rectangle(
				0,
				-y_offset + i * widget_item_height,
				widget_width - widget_scroll_offset - 2,
				-y_offset + i * widget_item_height +
				widget_item_height,
				false
			)
			draw_set_colour(widget_text_color)
			draw_rectangle(
				0,
				-y_offset + i * widget_item_height,
				widget_width - widget_scroll_offset - 2,
				-y_offset + i * widget_item_height +
				widget_item_height,
				true
			)
		}
		
		draw_text(
			2,
			-y_offset + i * widget_item_height +
			widget_item_height * 0.5,
			widget_data[i]
		)
	}
	
	draw_set_font(font)
	draw_set_halign(halign)
	draw_set_valign(valign)
	
	surface_reset_target()
	
	draw_set_colour(widget_background_color)
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		false
	)
	
	draw_surface(
		widget_surf,
		widget_x,
		widget_y
	)
	
	draw_set_colour(widget_background_color)
	draw_rectangle(
		widget_x + widget_width - widget_scroll_offset,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		false
	)
	
	draw_set_colour(widget_outline_color)
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		true
	)
	
	draw_rectangle(
		widget_x + widget_width - widget_scroll_offset,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		true
	)
	draw_rectangle(
		widget_x + widget_width - widget_scroll_offset,
		widget_y + widget_scroll_show * widget_scroll_height,
		widget_x + widget_width,
		widget_y + widget_scroll_show * widget_scroll_height +
		widget_scroll_offset * 2,
		false
	)
	
	draw_set_colour(color)
}

function list_clean_up() {
	if surface_exists(widget_surf) {
		surface_free(widget_surf)
	}
}
#endregion

#region Check box
function check_box_create_ext(x, y, width, height, on, offset) {
	widget_base(x, y, width, height)
	
	widget_type = widget_types.check_box
	widget_value = on
	widget_offset = offset
	widget_selected = false
	widget_background_select_color = make_colour_rgb(16, 16, 128)
}

function check_box_create(on, offset = 4) {
	check_box_create_ext(
		x,
		y,
		sprite_width,
		sprite_height,
		on,
		offset
	)
}

function check_box_update() {
	widget_x = x
	widget_y = y
	
	var mouse_inside = (
		mouse_x >= widget_x &&
		mouse_y >= widget_y &&
		mouse_x <= widget_x + widget_width &&
		mouse_y <= widget_y + widget_height
	);
	
	if mouse_inside {
		widget_selected = true
		
		if mouse_check_button_pressed(mb_left) {
			widget_value = !widget_value
		}
	} else {
		widget_selected = false
	}
}

function check_box_draw() {
	var color = draw_get_colour();
	
	draw_set_colour(widget_background_color)
	if widget_selected {
		draw_set_colour(widget_background_select_color)
	}
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		false
	)
	
	draw_set_colour(widget_outline_color)
	if widget_value {
		draw_rectangle(
			widget_x + widget_offset,
			widget_y + widget_offset,
			widget_x + widget_width - widget_offset,
			widget_y + widget_height - widget_offset,
			false
		)
	}
	
	draw_rectangle(
		widget_x,
		widget_y,
		widget_x + widget_width,
		widget_y + widget_height,
		true
	)
	
	draw_set_colour(color)
}
#endregion