shader_type canvas_item;
// thank you niwho (https://godotshaders.com/shader/a-simple-reflection-shader/)

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float offset = 0;
uniform float scale : hint_range(0.05, 1.0, 0.05) = 1.0;

varying float screen_baseY;

void vertex() {
	mat4 t = mat4(vec4(2.0, 0, 0, 0), vec4(0, 2.0, 0, 0), vec4(0, 0, 1.0, 0), vec4(-1.0, -1.0, 0, 1.0));
	screen_baseY = (inverse(t)*SCREEN_MATRIX*CANVAS_MATRIX *  (MODEL_MATRIX)*vec4(-1.0/TEXTURE_PIXEL_SIZE.x/2.0,  -1.0/TEXTURE_PIXEL_SIZE.y/2.0, 0, 1.0)).y;
}

void fragment() {
	vec2 uv =  SCREEN_UV;
	uv.y -= screen_baseY;
	uv.y *= scale;
	uv.y += screen_baseY;
	COLOR = texture(SCREEN_TEXTURE, vec2(uv.x, (screen_baseY*2.0- (uv.y-offset))));
}