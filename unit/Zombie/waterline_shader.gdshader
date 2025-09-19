shader_type canvas_item;

uniform float affected_float : hint_range(0.0, 1.1);
uniform float fade_height = 40.0;
uniform float line_thickness = 0.009;
uniform float time;

// Booleans for overrides
uniform bool white_override = false;
uniform bool darkblue_override = false;
uniform bool purple_override = false;

void fragment() {
    float fade_uv = fade_height / float(textureSize(TEXTURE, 0).y);
    float w = white_override ? 1.0 : 0.0;
    float d = darkblue_override ? 1.0 : 0.0;
    float p = purple_override ? 1.0 : 0.0;
    float cnt = w + d + p;
	
	if (affected_float < 1.0){
			

	    vec2 base_uv = UV;
	    base_uv.y -= (1.0 - affected_float); // downward shift
		vec4 tex_orig = texture(TEXTURE, base_uv);
	    vec3 base_rgb = tex_orig.rgb;
	    if (cnt > 0.0) {
	        vec3 whiteC    = vec3(1.0, 1.0, 1.0);
	        vec3 darkBlueC = vec3(0.0, 0.0, 0.5);
	        vec3 purpleC   = vec3(0.5, 0.0, 0.5);
	        vec3 overlay = (w * whiteC + d * darkBlueC + p * purpleC) / cnt;

	        // Blend instead of replace (like semi-transparent layer)
	        base_rgb = mix(base_rgb, overlay, 0.5);
	    }

	    // If affected_float == 1.0 -> disable water effect
	    if (affected_float >= 1.0) {
	        COLOR = vec4(base_rgb, tex_orig.a);
	    } else {
	        // Distorted UV for water effect (apply wave only inside fade)
	        vec2 distorted_uv = base_uv;

	        if (UV.y > affected_float && UV.y < affected_float + fade_uv) {
	            float wave_x = sin(UV.x * 30.0 + time * 5.0) * 0.01;
	            float wave_y = sin(UV.y * 40.0 + time * 3.0) * 0.01;
	            distorted_uv += vec2(wave_x, wave_y);
	        }

	        vec4 tex_dist = texture(TEXTURE, distorted_uv);

	        bool in_line = abs(UV.y - affected_float) < line_thickness;
	        bool in_fade = (UV.y > affected_float && UV.y < affected_float + fade_uv);

	        vec4 final_color;

	        if (in_line) {
	            final_color = vec4(vec3(1.0), tex_orig.a);
	        }
	        else if (in_fade) {
	            float fade_factor = 1.0 - (UV.y - affected_float) / fade_uv;
	            vec3 water_tint = vec3(0.3, 0.5, 1.0);

	            // Apply water fade using the *already tinted* base_rgb
	            vec3 tinted = mix(water_tint, base_rgb, fade_factor);
	            float alpha_fade = tex_dist.a * fade_factor;
	            final_color = vec4(tinted, alpha_fade);
	        }
	        else if (UV.y >= affected_float + fade_uv) {
	            discard;
	        }
	        else {
	            final_color = vec4(base_rgb, tex_orig.a);
	        }

	        COLOR = final_color;
	    }
	}else{
		vec2 base_uv = UV;
		vec4 tex_orig = texture(TEXTURE, base_uv);
		vec3 base_rgb = tex_orig.rgb;
			if (cnt > 0.0) {
	        vec3 whiteC    = vec3(1.0, 1.0, 1.0);
	        vec3 darkBlueC = vec3(0.0, 0.0, 0.5);
	        vec3 purpleC   = vec3(0.5, 0.0, 0.5);
	        vec3 overlay = (w * whiteC + d * darkBlueC + p * purpleC) / cnt;

	        base_rgb = mix(base_rgb , overlay, 0.5);
			COLOR = vec4(base_rgb, tex_orig.a);
	    }
	}
}
