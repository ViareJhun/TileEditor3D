/*
	Texture manager
*/

gml_pragma("global", "_tex_man_init_()")

function _tex_man_init_() {
	global.texture_manager_container = ds_map_create()
}

function texture_manager_clear() {
	var tex = ds_map_find_first(global.texture_manager_container);
	var count = ds_map_size(global.texture_manager_container);
	
	repeat count {
		sprite_delete(
			global.texture_manager_container[? tex].sprite
		)
		
		tex = ds_map_find_next(
			global.texture_manager_container,
			tex
		)
	}
	
	ds_map_destroy(global.texture_manager_container)
	global.texture_manager_container = ds_map_create()
}

function texture_manager_get(key) {
	return global.texture_manager_container[? key]
}

function texture_manager_add(tex_path, key) {
	if ds_map_exists(
		global.texture_manager_container,
		key
	) {
		return global.texture_manager_container[? key]
	}
	
	var new_texture = {
		texture: noone,
		sprite: noone,
		uvs: noone,
		my_key: key,
		specular: 1,
		specular_blur: 32
	};
	
	new_texture.sprite = sprite_add(
		tex_path,
		1,
		false,
		false,
		0,
		0
	)
	new_texture.texture = sprite_get_texture(
		new_texture.sprite,
		0
	)
	new_texture.uvs = sprite_get_uvs(
		new_texture.sprite,
		0
	)
	
	global.texture_manager_container[? key] = new_texture
	return global.texture_manager_container[? key]
}