function load_obj(fname) {
	var file = file_text_open_read(fname);
	
	var mmx = [0, 0];
	var mmy = [0, 0];
	var mmz = [0, 0];
	
	var vx = [];
	var vy = [];
	var vz = [];
	
	var nx = [];
	var ny = [];
	var nz = [];
	
	var u = [];
	var v = [];
	
	while !file_text_eof(file) {
		var line = file_text_readln(file);
		
		var data = _split(line, " ");
		
		if array_length(data) > 0 {
			switch data[0] {
				case "v":
					array_push(vx, real(data[1]))
					array_push(vy, real(data[2]))
					array_push(vz, real(data[3]))
					
					if real(data[1]) < mmx[0] mmx[0] = real(data[1])
					if real(data[1]) > mmx[1] mmx[1] = real(data[1])
					
					if real(data[2]) < mmz[0] mmz[0] = real(data[2])
					if real(data[2]) > mmz[1] mmz[1] = real(data[2])
					
					if real(data[3]) < mmy[0] mmy[0] = real(data[3])
					if real(data[3]) > mmy[1] mmy[1] = real(data[3])
				break
				
				case "vn":
					array_push(nx, real(data[1]))
					array_push(ny, real(data[2]))
					array_push(nz, real(data[3]))
				break
				
				case "vt":
					array_push(u, real(data[1]))
					array_push(v, real(data[2]))
				break
			}
		}
	}
	
	file_text_close(file)
	
	// Load faces
	file = file_text_open_read(fname)
	var triangles = [];
	
	while !file_text_eof(file) {
		var line = file_text_readln(file);
		
		var data = _split(line, " ");
		
		if array_length(data) > 0 {
			switch data[0] {
				case "f":
					var count = array_length(data) - 1;
					var vs = [];
					
					for (var i = 0; i < count; i ++) {
						var terms = _split(data[i + 1] + "/", "/");
						
						var vi = int64(terms[0]) - 1;
						var ti = int64(terms[1]) - 1;
						var ni = int64(terms[2]) - 1;
						
						var xx = vx[vi];
						var yy = vy[vi];
						var zz = vz[vi];
						
						var xn = nx[ni];
						var yn = ny[ni];
						var zn = nz[ni];
						
						var uu = u[ti];
						var vv = v[ti];
						
						// Fix
						var t = yy;
						yy = zz
						zz = t
						var t = yn;
						yn = zn
						zn = t
						
						vs[i] = [
							[xx, yy, zz],
							[xn, yn, zn],
							[uu, 1 - vv]
						]
					}
					
					for (var i = 0; i < count - 2; i ++) {
						var a = 0;
						var b = i + 1;
						var c = i + 2;
						
						array_push(
							triangles,
							[
								vs[a], vs[b], vs[c]
							]
						)
					}
				break
			}
		}
	}
	
	file_text_close(file)
	
	var _w = mmx[1] - mmx[0];
	var _d = mmy[1] - mmy[0];
	var _h = mmz[1] - mmz[0];
	
	// Create mesh
	return {
		raw_data: {
			vx: vx,
			vy: vy,
			vz: vz,
			nx: nx,
			ny: ny,
			nz: nz,
			u: u,
			v: v
		},
		data: triangles,
		size: [_w, _d, _h],
		aabb: {
			x_min: mmx[0],
			x_max: mmx[1],
			y_min: mmy[0],
			y_max: mmy[1],
			z_min: mmz[0],
			z_max: mmz[1]
		}
	}
}

function _split(str, char) {
	var word = "";
	var words = [];
	var count = string_length(str);
	
	for (var i = 1; i <= count; i ++) {
		var e = string_char_at(str, i);
		
		if (e == char) || (i == count) {
			if string_length(word) > 0 {
				array_push(words, word)
				word = ""
			}
		} else {
			word += e
		}
	}
	
	return words
}