shader_type spatial;

uniform float sway_frequency = 1.0;
uniform float sway_amplitude = 0.1;
uniform float sway_speed = 2.0;
uniform sampler2D texture_sampler;

void vertex() {
        float sway = sin((VERTEX.x * sway_frequency) + (TIME * sway_speed)) * sway_amplitude;
        VERTEX.z += sway;
}

void fragment() {
    vec4 tex_color = texture(texture_sampler, UV);
    ALBEDO = tex_color.rgb;
	ALPHA = tex_color.a;
}