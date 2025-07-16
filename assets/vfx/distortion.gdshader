shader_type canvas_item;

uniform float distortion : hint_range(0.0, 32.0, 1.0) = 4.0;
uniform float wave_frequency : hint_range(0.0, 32.0, 1.0) = 4.0;
uniform float wave_amplitude : hint_range(0.0, 32.0, 1.0) = 1.0;
uniform float wave_speed : hint_range(0.0, 32.0, 1.0) = 1.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
	float dist = (texture(TEXTURE, UV).r * 2.0 - 1.0) * distortion;
	float wave = sin(UV.y * PI * wave_frequency + TIME * wave_speed) * wave_amplitude;
	float uv_mod = round(dist + wave) * SCREEN_PIXEL_SIZE.x;
	COLOR = texture(screen_texture, SCREEN_UV + vec2(uv_mod, 0.0));
}