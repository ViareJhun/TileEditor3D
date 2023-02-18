/// @description init

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