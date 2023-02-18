function array_get_index(array, value) {
	var count = array_length(array);
	for (var i = 0; i < count; i ++) {
		if value == array[i] {
			return i
		}
	}
	
	return -1
}