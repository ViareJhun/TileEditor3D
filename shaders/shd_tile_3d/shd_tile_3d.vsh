attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vPosition;

void main()
{
    vec4 osp = vec4(in_Position, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * osp;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
	v_vNormal = (
		gm_Matrices[MATRIX_WORLD] *
		vec4(in_Normal, 0.0)
	).xyz;
	v_vPosition = (
		gm_Matrices[MATRIX_WORLD] * osp
	).xyz;
}
