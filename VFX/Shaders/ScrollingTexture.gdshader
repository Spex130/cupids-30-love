shader_type spatial;

uniform float textureScaleX = 1.0;
uniform float textureScaleY = 1.0;
uniform float scrollSpeed = 1.0;

uniform sampler2D maintexture : source_color, hint_default_black; // Sampler 2d of the matcap
uniform vec4 _Color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {
    // Apply initial UV scaling and offset
    vec2 scaled_uv = vec2(UV.x * textureScaleX, UV.y * textureScaleY);

    // **Apply scrolling based on TIME and scroll_speed**
    scaled_uv.x += scrollSpeed * TIME;

    // Assign the modified UV to be used in fragment shader
    UV = scaled_uv;
}

void fragment() {

	// Called for every pixel the material is visible on.
	float xScroll = UV.x + TIME * scrollSpeed;
	float yScroll = UV.y + TIME * scrollSpeed;
	vec2 offset_uv = UV - (TIME * scrollSpeed);
	vec4 texture_color = texture(maintexture, offset_uv);
	
	ALBEDO = texture_color.rgb;


}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
