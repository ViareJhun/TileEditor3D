/// @description init

global.string_digits_real = function(source) {
	if (string_length(source) == 0) {
		return 0
	}
	
	var before_dot = "";
	var after_dot = "";
	var is_after_dot = false;
	var count = string_length(source);
	
	for (var i = 1; i <= count; i ++) {
		var c = string_char_at(source, i);
		
		if (c == ".") {
			is_after_dot = true	
		} else {
			if (is_after_dot) {
				after_dot += string_digits(c)
			} else {
				before_dot += string_digits(c)
			}
		}
	}
	
	if (string_length(before_dot) == 0) {
		return 0
	}
	if (is_after_dot) {
		if (string_length(after_dot) == 0) {
			return 0
		}
		
		return (
			real(before_dot) +
			real(after_dot) / power(10, string_length(after_dot))
		)
	} else {
		return real(before_dot)
	}
}

function entry_position_update(trans) {
	with obj_entry_position {
		if (!widget_entry_selected) {
			widget_entry_text = string(
				variable_struct_get(
					trans,
					tag
				)
			)
		} else {
			var value = global.string_digits_real(widget_entry_text);
			
			variable_struct_set(
				trans,
				tag,
				value
			)
			
			with obj_editor slider_transform_update(trans)
		}
	}
}

function slider_transform_update(trans) {
	with obj_slider_transformations {
		switch tag {
			case "x":
				widget_value = from_range(
					trans.x, global.tile_x_min, global.tile_x_max
				)
			break
			case "y":
				widget_value = from_range(
					trans.y, global.tile_y_min, global.tile_y_max
				)
			break
			case "z":
				widget_value = from_range(
					trans.z, global.tile_z_min, global.tile_z_max
				)
			break
			
			case "x_scale":
				widget_value = from_range(
					trans.x_scale, global.tile_xs_min, global.tile_xs_max
				)
			break
			case "y_scale":
				widget_value = from_range(
					trans.y_scale, global.tile_ys_min, global.tile_ys_max
				)
			break
			case "z_scale":
				widget_value = from_range(
					trans.z_scale, global.tile_zs_min, global.tile_zs_max
				)
			break
			
			case "x_angle":
				widget_value = from_range(
					trans.x_angle, global.tile_xa_min, global.tile_xa_max
				)
			break
			case "y_angle":
				widget_value = from_range(
					trans.y_angle, global.tile_ya_min, global.tile_ya_max
				)
			break
			case "z_angle":
				widget_value = from_range(
					trans.z_angle, global.tile_za_min, global.tile_za_max
				)
			break
		}
	}
}

function object_set_position(name, x = noone, y = noone, z = noone) {
	if x != noone global.tile_object_transformations[$ name].x = x
	if y != noone global.tile_object_transformations[$ name].y = y
	if z != noone global.tile_object_transformations[$ name].z = z
	
	slider_transform_update(global.tile_object_transformations[$ name])
}

function object_set_rotation(name, xa = noone, ya = noone, za = noone) {
	if xa != noone global.tile_object_transformations[$ name].x_angle = xa
	if ya != noone global.tile_object_transformations[$ name].y_angle = ya
	if za != noone global.tile_object_transformations[$ name].z_angle = za
	
	slider_transform_update(global.tile_object_transformations[$ name])
}

function object_set_scale(name, xs = noone, ys = noone, zs = noone) {
	if xs != noone global.tile_object_transformations[$ name].x_scale = xs
	if ys != noone global.tile_object_transformations[$ name].y_scale = ys
	if zs != noone global.tile_object_transformations[$ name].z_scale = zs
	
	slider_transform_update(global.tile_object_transformations[$ name])
}