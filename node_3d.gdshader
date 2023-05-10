shader_type canvas_item;

uniform int levels : hint_range(1, 16);
uniform float threshold : hint_range(0.0, 1.0);
uniform int pixelate : hint_range(1, 10);
uniform sampler2D dither_texture : filter_nearest;
const vec3 palette[6] = {
	// Neon Space
	/*vec3(223.0/255.0, 7.0/255.0, 114.0/255.0),   // #df0772
    vec3(254.0/255.0, 84.0/255.0, 111.0/255.0),  // #fe546f
    vec3(255.0/255.0, 158.0/255.0, 125.0/255.0), // #ff9e7d
    vec3(255.0/255.0, 208.0/255.0, 128.0/255.0), // #ffd080
    vec3(255.0/255.0, 253.0/255.0, 255.0/255.0), // #fffdff
    vec3(11.0/255.0, 255.0/255.0, 230.0/255.0),  // #0bffe6
    vec3(1.0/255.0, 203.0/255.0, 207.0/255.0),   // #01cbcf
    vec3(1.0/255.0, 136.0/255.0, 165.0/255.0),   // #0188a5
    vec3(62.0/255.0, 50.0/255.0, 100.0/255.0),   // #3e3264
    vec3(53.0/255.0, 42.0/255.0, 85.0/255.0)     // #352a55
	*/
	
	// Eulblink
	vec3(12.0/255.0, 230.0/255.0, 242.0/255.0),
	vec3(0.0/255.0, 152.0/255.0, 219.0/255.0),
	vec3(30.0/255.0, 87.0/255.0, 156.0/255.0),
	vec3(32.0/255.0, 53.0/255.0, 98.0/255.0),
	vec3(37.0/255.0, 36.0/255.0, 70.0/255.0),
	vec3(32.0/255.0, 21.0/255.0, 51.0/255.0)
	
	//vec3(0.0, 0.63, 1.0), // cyan
    //vec3(0.0, 0.46, 1.0), // light blue
	//vec3(0.0, 0.35, 0.79), // middle blue
	//vec3(0.0, 0.16, 0.54), // dark blue
	//vec3(0.03, 0.05, 0.41), // dark blue pure
	//vec3(0.0, 0.58, 0.57), // light green
	//vec3(0.0, 0.37, 0.37), // middle green
	//vec3(0.0, 0.2, 0.2), // dark green
	//vec3(1.0, 1.0, 1.0), // white
	//vec3(0.0, 0.0, 0.0) //black
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

void fragment()
{
	// Pixelate the screen
	vec2 screen_size = vec2(textureSize(TEXTURE, 0)) / float(pixelate);
	vec2 screen_sample_uv = floor(UV * screen_size) / screen_size;

	// Map the dither texture onto the screen pixels with tiling and repeating
	vec2 dither_size = vec2(textureSize(dither_texture, 0));
	vec2 dither_uv = mod(UV * screen_size, dither_size) / dither_size;
	
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
	
	// Apply the dithered color
	COLOR.rgb = closest_col;
}