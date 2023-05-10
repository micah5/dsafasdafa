shader_type canvas_item;

uniform float power : hint_range(0.0, 2.0) = 1.0;
uniform int levels : hint_range(1, 16);
uniform float threshold : hint_range(0.0, 1.0);
uniform int pixelate : hint_range(1, 10);
uniform sampler2D dither_texture : filter_nearest;
const vec3 palette[24] = {
	vec3(249.0/255.0, 250.0/255.0, 232.0/255.0),// #f9fae8
    vec3(243.0/255.0, 226.0/255.0, 174.0/255.0),// #f3e2ae
    vec3(237.0/255.0, 187.0/255.0, 52.0/255.0),// #edbb34
    vec3(182.0/255.0, 94.0/255.0, 40.0/255.0),// #b65e28
    vec3(124.0/255.0, 50.0/255.0, 38.0/255.0),// #7c3226
    vec3(91.0/255.0, 33.0/255.0, 55.0/255.0),// #5b2137
    vec3(6.0/255.0, 18.0/255.0, 39.0/255.0),// #061227
    vec3(250.0/255.0, 178.0/255.0, 82.0/255.0),// #fab252
    vec3(237.0/255.0, 107.0/255.0, 57.0/255.0),// #ed6b39
    vec3(213.0/255.0, 41.0/255.0, 65.0/255.0),// #d52941
    vec3(150.0/255.0, 22.0/255.0, 80.0/255.0),// #961650
    vec3(95.0/255.0, 14.0/255.0, 75.0/255.0),// #5f0e4b
    vec3(47.0/255.0, 10.0/255.0, 53.0/255.0),// #2f0a35
    vec3(242.0/255.0, 255.0/255.0, 184.0/255.0),// #f2ffb8
    vec3(185.0/255.0, 247.0/255.0, 121.0/255.0),// #b9f779
    vec3(118.0/255.0, 226.0/255.0, 79.0/255.0),// #76e24f
    vec3(26.0/255.0, 179.0/255.0, 73.0/255.0),// #1ab349
    vec3(35.0/255.0, 139.0/255.0, 119.0/255.0),// #238b77
    vec3(21.0/255.0, 75.0/255.0, 92.0/255.0),// #154b5c
    vec3(143.0/255.0, 229.0/255.0, 234.0/255.0),// #8fe5ea
	vec3(107.0/255.0, 195.0/255.0, 226.0/255.0),// #6bc3e2
    vec3(68.0/255.0, 138.0/255.0, 213.0/255.0),// #448ad5
    vec3(33.0/255.0, 64.0/255.0, 163.0/255.0),// #2140a3
    vec3(38.0/255.0, 22.0/255.0, 126.0/255.0)// #26167e
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
    for (int i = 1; i < palette.length(); i++) {
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
