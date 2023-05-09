shader_type spatial;

uniform float sway_frequency = 1.0;
uniform float sway_amplitude = 0.5;
uniform float sway_speed = 2.0;
uniform vec3 color = vec3(1.0, 1.0, 1.0);
uniform float emission_strength = 0.3;

void vertex() {
        float sway = sin((VERTEX.x * sway_frequency) + (TIME * sway_speed)) * sway_amplitude;
        VERTEX.z += sway;
}

void fragment() {
        // Add emission
        float emission_intensity = emission_strength * UV.y;
        EMISSION = vec3(emission_intensity, emission_intensity, emission_intensity);

        // Add vertical gradient from white to transparent
        ALBEDO = mix(vec3(1.0, 1.0, 1.0), color, UV.y);
        ALPHA = 1.0 - UV.y;
}
