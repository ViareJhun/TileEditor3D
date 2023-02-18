varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vPosition;

uniform float ambient;
uniform float specular_strength;
uniform float specular_blur;
uniform vec3 camera_position;
uniform vec3 sun_dir;

void main()
{
    vec4 main = texture2D(gm_BaseTexture, v_vTexcoord);
	vec3 normal = normalize(v_vNormal);
	
	vec3 view_direction = normalize(camera_position - v_vPosition);
	// vec3 reflect_direction = reflect(-normalize(sun_dir), normal);
	vec3 halfway_direction = normalize(view_direction + normalize(sun_dir));
	float specular = pow(
		max(
			dot(
				normal,
				halfway_direction
			), 0.0
		),
		specular_blur
	);
	
	main.rgb *= (
		ambient + max(
			0.0,
			dot(
				normal,
				normalize(sun_dir)
			)
		) + specular_strength * specular * 2.0
	);
	
	gl_FragColor = v_vColour * main;
	if (gl_FragColor.a < 0.9) {
		discard;
	}
}
