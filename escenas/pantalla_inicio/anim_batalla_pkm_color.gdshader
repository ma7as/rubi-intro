shader_type canvas_item;

// Color celeste por defecto (puedes cambiarlo desde el Inspector)
uniform vec4 target_color : source_color = vec4(1.0, 0.5, 1.0, 1.0);
// Progreso: 1.0 = Todo celeste, 0.0 = Colores originales
uniform float progress : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Mezcla el color original de la textura con el color celeste plano
    vec3 final_rgb = mix(tex_color.rgb, target_color.rgb, progress);
    
    // Asigna el color final manteniendo intacto el canal alfa (transparencia de los bordes)
    COLOR = vec4(final_rgb, tex_color.a);
}