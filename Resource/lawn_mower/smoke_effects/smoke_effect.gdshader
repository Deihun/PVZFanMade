shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(1.0, 8.0) = 1.0;
uniform float alpha_thresh : hint_range(0.001, 0.5) = 0.01;

void fragment() {
    vec4 center = texture(TEXTURE, UV);
    float a_center = center.a;

    vec2 px = TEXTURE_PIXEL_SIZE * outline_width;

    float maxA = 0.0;
    maxA = max(maxA, texture(TEXTURE, UV + vec2(-px.x, 0.0)).a);
    maxA = max(maxA, texture(TEXTURE, UV + vec2( px.x, 0.0)).a);
    maxA = max(maxA, texture(TEXTURE, UV + vec2(0.0, -px.y)).a);
    maxA = max(maxA, texture(TEXTURE, UV + vec2(0.0,  px.y)).a);
    maxA = max(maxA, texture(TEXTURE, UV + vec2(-px.x, -px.y)).a);
    maxA = max(maxA, texture(TEXTURE, UV + vec2(-px.x,  px.y)).a);
    maxA = max(maxA, texture(TEXTURE, UV + vec2(px.x, -px.y)).a);
    maxA = max(maxA, texture(TEXTURE, UV + vec2(px.x,  px.y)).a);

    // Outer-only condition: center is transparent, but neighbor is opaque
    if (a_center > alpha_thresh) {
        COLOR = center; // normal sprite
    } else if (maxA > alpha_thresh) {
        COLOR = vec4(outline_color.rgb, outline_color.a); // solid outline
    } else {
        COLOR = vec4(0.0);
    }
}
