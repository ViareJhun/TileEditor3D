varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 color;

void main()
{
    gl_FragColor = vec4(color, 1.0);
}
