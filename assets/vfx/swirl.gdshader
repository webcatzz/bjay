shader_type canvas_item;

uniform vec2 origin;
uniform int stripe_count = 16;
uniform float spin_speed = 0.125;
uniform float flow_speed = 2.0;

void fragment() {
	vec2 v = VERTEX - origin;
	float r = sqrt(pow(v.x, 2) + pow(v.y, 2));
	float theta = atan(v.y, v.x) + sin(r * 0.05 - flow_speed * TIME) * 0.25 + spin_speed * TIME;
	float value = floor(mod(theta / TAU * float(stripe_count), 2.0));
	COLOR = texture(TEXTURE, vec2(value));
}