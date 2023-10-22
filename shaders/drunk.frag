#pragma header

uniform float time;

void main() // shader by lunar lol (i can only code basic shaders :(( )
{
    vec2 uv = openfl_TextureCoordv.xy;

    uv.x += sin(time + (uv.y*3)) * 0.02;
    uv.y += cos(time + (uv.x*3)) * 0.02;

    gl_FragColor = flixel_texture2D(bitmap, uv);
}