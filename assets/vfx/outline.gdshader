shader_type canvas_item;

uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

const vec2[4] DIRECTIONS = {
	vec2(1.0, 0.0),
	vec2(0.0, 1.0),
	vec2(-1.0, 0.0),
	vec2(0.0, -1.0)
};

float gtz(float input) {
	return max(0, sign(input));
}

float check(sampler2D tex, vec2 from, vec2 size) {
	float result = 0.0;
	for (int i = 0; i < 4; i++) {
		result += texture(tex, from + DIRECTIONS[i] * size).a;
	}
	return gtz(result);
}

void fragment() {
	COLOR = vec4(1.0, 0.0, 0.0, 0.0);
	//COLOR = mix(COLOR, color, check(TEXTURE, UV, TEXTURE_PIXEL_SIZE) * (1.0 - gtz(COLOR.a)) );
}