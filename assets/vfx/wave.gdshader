shader_type canvas_item;

uniform float amplitude = 0.05;
uniform float frequency = 8.0;
uniform float speed = 8.0;

void fragment() {
	vec2 uv = UV;
	uv.y += sin(UV.x * frequency + TIME * speed) * amplitude;
	COLOR = texture(TEXTURE, uv);
}