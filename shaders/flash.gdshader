shader_type canvas_item;

uniform float hit_opacity = 0;
uniform vec4 flash_color:source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	vec3 blend = mix(tex_color.rgb, flash_color.rgb, hit_opacity);
	
	COLOR.rgb = blend;
	COLOR.a = tex_color.a;
}