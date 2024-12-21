#pragma header

uniform float uDepth;

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (openfl_TextureCoordv * openfl_TextureSize) / openfl_TextureSize.xy;

    float dx = distance(openfl_TextureCoordv.x, 0.5);
    float dy = distance(openfl_TextureCoordv.y, 0.5);
    
    float offset = (dx * 0.2) * dy;
    
    float dir = 0.0;
	
    if (openfl_TextureCoordv.y <= 0.5)
    {
        dir = 1.0;
    }
    else
    {
        dir = -1.0;
    }
    
    vec2 coords = vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y + dx * (offset * uDepth * dir));
    
    gl_FragColor = flixel_texture2D(bitmap, coords);
}