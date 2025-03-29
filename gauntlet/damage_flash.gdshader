shader_type spatial;
render_mode blend_add;

const float speed = 20.0;

void fragment() {
	ALBEDO = vec3(abs(sin(TIME * speed)) - UV.x);
}