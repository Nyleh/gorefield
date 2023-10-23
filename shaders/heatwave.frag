#pragma header

uniform float time;
uniform float strength;
uniform float speed;
uniform sampler2D noise;

void main() {
	vec2 p_m = openfl_TextureCoordv.xy;
    vec2 p_d = p_m;

    p_d.y = 1.0-p_d.y;
    p_d.t += (time * 0.1) * speed;

    p_d = mod(p_d, 1.0);
    vec4 dst_map_val = texture2D(noise, p_d);
    
    vec2 dst_offset = dst_map_val.xy;
    dst_offset -= vec2(.5,.5);
    dst_offset *= 2.;
    dst_offset *= (0.01 * strength);
	
    //reduce effect towards Y top
    dst_offset *= (1. - p_m.t);
    
    vec2 dist_tex_coord = p_m.st + dst_offset;
    gl_FragColor = flixel_texture2D(bitmap, dist_tex_coord); 
}