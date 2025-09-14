shader_type canvas_item;

uniform sampler2D gradient_tex;
uniform float mix_strength : hint_range(0.0, 1.0) = 0.0; // 0 = invisible, 1 = full gradient

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);      // original sprite
    vec4 grad_color = texture(gradient_tex, UV); // gradient texture

    // Multiply gradient alpha by the base texture alpha → shape match
    float shaped_alpha = grad_color.a * base_color.a;

    // Blend gradient color and base color, but clip to base shape
    vec4 blended = mix(base_color, grad_color, mix_strength);

    // Final color with shaped alpha
    COLOR = vec4(blended.rgb, shaped_alpha);
}
