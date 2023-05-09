shader_type canvas_item;

uniform float power : hint_range(0.0, 2.0) = 1.0;

void fragment() {
    vec2 aspect = vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0);
    vec2 uv = SCREEN_UV * 2.0 - 1.0;
    vec2 xy = uv * aspect;
    float d = length(xy);

    if (d < 1.0) {
        float z = 1.0 - d * power;
        xy = xy / z;
        uv = xy / aspect * 0.5 + 0.5;
        COLOR = texture(TEXTURE, uv);
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    }
}