shader_type spatial;

render_mode unshaded;

uniform float sway_frequency = 1.0;
uniform float sway_amplitude = 0.01;
uniform float sway_speed = 2.0;
uniform vec3 color: source_color = vec3(1.0, 1.0, 1.0);

void vertex() {
        float sway = sin((VERTEX.x * sway_frequency) + (TIME * sway_speed)) * sway_amplitude;
        VERTEX.x += sway;
		VERTEX.z += sway;
}

void fragment() {
        ALBEDO = color;
}
