shader_type canvas_item;

uniform float power : hint_range(0.0, 2.0) = 1.0;
uniform int levels : hint_range(1, 16);
uniform float threshold : hint_range(0.0, 1.0);
uniform int pixelate : hint_range(1, 10);
uniform sampler2D dither_texture : filter_nearest;
const vec3 palette[10] = {
    vec3(0.0, 0.46, 1.0),
	vec3(0.0, 0.35, 0.79),
	vec3(0.0, 0.16, 0.54),
	vec3(0.03, 0.05, 0.41),
	vec3(0.0, 0.63, 1.0),
	vec3(0.84, 1.0, 0.94),
	vec3(0.43, 0.2, 0.5),
	vec3(1.0, 1.0, 1.0),
	vec3(0.0, 0.6, 0.57),
	vec3(0.0, 0.0, 0.0)
};

float dither(float raw, float dither, int depth) {
    float div = 1.0 / float(depth);
    float val = 0.0;
    
    for (int i = 0; i < depth; i++) {
        if (raw <= div * (float(i + 1))) {
            if ((raw * float(depth)) - float(i) <= dither * 0.999) {
                val = div * float(i);
            } else {
                val = div * float(i + 1);
            }
            break;
        }
    }
    if (raw >= 1.0) {
        val = 1.0;
    }
    return val;
}

vec3 closest_color(vec3 color) {
    float min_distance = distance(color, palette[0]);
    vec3 closest_color = palette[0];
    for (int i = 1; i < 16; i++) {
        float current_distance = distance(color, palette[i]);
        if (current_distance < min_distance) {
            min_distance = current_distance;
            closest_color = palette[i];
        }
    }
    return closest_color;
}

void fragment() {
    vec2 aspect = vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0);
    vec2 uv = SCREEN_UV * 2.0 - 1.0;
    vec2 xy = uv * aspect;
    float d = length(xy);

    vec4 color;
    
    if (d < 1.0) {
        float z = 1.0 - d * power;
        xy = xy / z;
        uv = xy / aspect * 0.5 + 0.5;
        
        // Pixelate the screen
        vec2 screen_size = vec2(textureSize(TEXTURE, 0)) / float(pixelate);
        vec2 screen_sample_uv = floor(uv * screen_size) / screen_size;

        // Map the dither texture onto the screen pixels with tiling and repeating
        vec2 dither_size = vec2(textureSize(dither_texture, 0));
        vec2 dither_uv = mod(uv * screen_size, dither_size) / dither_size;

        // Sample the screen pixel
        vec3 screen_col = texture(TEXTURE, screen_sample_uv).rgb;

        // Sample the corresponding dither pixel luminance
        float dither_luminance = texture(dither_texture, dither_uv).r;

        // Dither each channel (r, g, and b) to the number of color quantizations via dither value
        vec3 quantized_col;
        for (int i = 0; i < 3; i++) {
            float raw_channel = screen_col[i];
            float dither_amount = threshold * dither_luminance;
            float quantized_channel = dither(raw_channel, dither_amount, levels);
            quantized_col[i] = quantized_channel;
        }

        // Find the closest color in the palette to the dithered color
        vec3 closest_col = closest_color(quantized_col);

         // Assign the dithered color to the color variable
        color = vec4(closest_col, 1.0);
    } else {
        color = vec4(0.0, 0.0, 0.0, 1.0);
    }

    COLOR = color;
}
