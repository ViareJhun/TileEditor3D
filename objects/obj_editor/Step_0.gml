/// @description update

global.tile_name = obj_entry_name.widget_entry_text
global.tile_solid = obj_check_box_solid.widget_value
obj_label_tex_path.widget_text = global.tile_tex_path
obj_main_texture_drawer.texture = global.tile_tex_main
global.tile_draw_interpolation = obj_check_box_interpolation.widget_value
global.tile_wall_high = obj_check_box_wall_high.widget_value
global.tile_object_selected = obj_list_objects.widget_data_selected

global.tile_uv_tex = obj_check_box_uv_map.widget_value

if global.tile_tex_main != noone {
	global.tile_tex_main.specular = obj_slider_specular.widget_value
}
if obj_list_textures.widget_data_selected != -1 {
	texture_manager_get(
		obj_list_textures.widget_data[
			obj_list_textures.widget_data_selected
		]
	).specular = obj_slider_specular_tex.widget_value
}

if global.tile_object_selected != -1 {
	var name = obj_list_objects.widget_data[
		global.tile_object_selected
	];
	var trans = global.tile_object_transformations[$ name];
	global.tile_object_visible[$ name] = obj_check_box_object_visible.widget_value
	global.tile_object_solid[$ name] = obj_check_box_object_solid.widget_value
	
	global.tile_object_texture[$ name] = (
		obj_list_textures.widget_data_selected
	)
	with obj_slider_transformations {
		if widget_selected {
			switch tag {
				case "x":
					trans.x = to_range(
						widget_value, global.tile_x_min, global.tile_x_max
					)
				break
				case "y":
					trans.y = to_range(
						widget_value, global.tile_y_min, global.tile_y_max
					)
				break
				case "z":
					trans.z = to_range(
						widget_value, global.tile_z_min, global.tile_z_max
					)
				break
				
				case "x_scale":
					trans.x_scale = to_range(
						widget_value, global.tile_xs_min, global.tile_xs_max
					)
				break
				case "y_scale":
					trans.y_scale = to_range(
						widget_value, global.tile_ys_min, global.tile_ys_max
					)
				break
				case "z_scale":
					trans.z_scale = to_range(
						widget_value, global.tile_zs_min, global.tile_zs_max
					)
				break
				
				case "x_angle":
					trans.x_angle = to_range(
						widget_value, global.tile_xa_min, global.tile_xa_max
					)
				break
				case "y_angle":
					trans.y_angle = to_range(
						widget_value, global.tile_ya_min, global.tile_ya_max
					)
				break
				case "z_angle":
					trans.z_angle = to_range(
						widget_value, global.tile_za_min, global.tile_za_max
					)
				break
			}
		}
	}
	
	entry_position_update(trans)
	entry_angle_update(trans)
	entry_scale_update(trans)
}