shader_type canvas_item;

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
	// MOONLIGHT 15
	/*vec3(3.0/255.0, 2.0/255.0, 6.0/255.0),    // #030206
    vec3(7.0/255.0, 9.0/255.0, 24.0/255.0),   // #070918
    vec3(9.0/255.0, 15.0/255.0, 51.0/255.0),  // #090f33
    vec3(9.0/255.0, 30.0/255.0, 77.0/255.0),  // #091e4d
    vec3(8.0/255.0, 50.0/255.0, 83.0/255.0),  // #083253
    vec3(13.0/255.0, 47.0/255.0, 135.0/255.0),// #0d2f87
    vec3(10.0/255.0, 76.0/255.0, 160.0/255.0),// #0a4ca0
    vec3(38.0/255.0, 132.0/255.0, 206.0/255.0),// #2684ce
    vec3(54.0/255.0, 181.0/255.0, 245.0/255.0),// #36b5f5
    vec3(58.0/255.0, 255.0/255.0, 251.0/255.0),// #3afffb
    vec3(131.0/255.0, 193.0/255.0, 111.0/255.0),// #83c16f
    vec3(99.0/255.0, 164.0/255.0, 96.0/255.0), // #63a460
    vec3(61.0/255.0, 130.0/255.0, 78.0/255.0), // #3d824e
    vec3(46.0/255.0, 103.0/255.0, 73.0/255.0), // #2e6749
    vec3(31.0/255.0, 75.0/255.0, 67.0/255.0)   // #1f4b43
	*/
	// Leopold's dreams
	/*vec3(55.0/255.0, 33.0/255.0, 52.0/255.0),  // #372134
    vec3(71.0/255.0, 68.0/255.0, 118.0/255.0), // #474476
    vec3(72.0/255.0, 136.0/255.0, 183.0/255.0),// #4888b7
    vec3(109.0/255.0, 188.0/255.0, 185.0/255.0),// #6dbcb9
    vec3(140.0/255.0, 239.0/255.0, 182.0/255.0) // #8cefb6
	*/
	
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
	/*vec3(12.0/255.0, 230.0/255.0, 242.0/255.0),
	vec3(0.0/255.0, 152.0/255.0, 219.0/255.0),
	vec3(30.0/255.0, 87.0/255.0, 156.0/255.0),
	vec3(32.0/255.0, 53.0/255.0, 98.0/255.0),
	vec3(37.0/255.0, 36.0/255.0, 70.0/255.0),
	vec3(32.0/255.0, 21.0/255.0, 51.0/255.0)
	*/
	
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