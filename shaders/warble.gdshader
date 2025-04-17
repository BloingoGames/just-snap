shader_type canvas_item;

uniform float time : hint_range(0.0, 100.0);
uniform float strength : hint_range(0.0, 0.2) = 0.05;
uniform float frequency : hint_range(0.0, 50.0) = 10.0;
uniform float speed : hint_range(0.0, 10.0) = 1.0;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = UV;

    // Warp the UVs using a sine wave
    uv.y += sin(uv.x * frequency + time * speed) * strength;
    uv.x += cos(uv.y * frequency + time * speed) * strength;

    COLOR = texture(TEXTURE, uv);
}