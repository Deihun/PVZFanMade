shader_type canvas_item;

uniform float chill_strength : hint_range(0.0, 1.0) = 0.0;
uniform float poison_strength : hint_range(0.0, 1.0) = 0.0;
uniform float burn_strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec3 color = mix(tex.rgb, vec3(0.114, 0.349, 0.439), chill_strength); //change it to even more blue

    // Tint green for poison
    color = mix(color, vec3(0.0, 1.0, 0.0), poison_strength);

    // Tint red/orange for burn
    color = mix(color, vec3(1.0, 0.3, 0.0), burn_strength);

    COLOR = vec4(color, tex.a);
}
