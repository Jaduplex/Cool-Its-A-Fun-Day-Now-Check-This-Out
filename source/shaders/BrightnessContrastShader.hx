package shaders;

import flixel.system.FlxAssets.FlxShader;

class BrightnessContrastShader extends FlxShader
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'BrightnessContrastShader';

  @:glFragmentSource('
        #pragma header

        uniform float brightness;
        uniform float contrast;
        void main() {
            vec2 uv = openfl_TextureCoordv.xy;
            
            gl_FragColor = flixel_texture2D(bitmap, uv);
            gl_FragColor.rgb = ((gl_FragColor.rgb - 0.5) * max(contrast, 0.)) + 0.5;
            gl_FragColor.rgb *= max(brightness, 0.);
        }
    ')
  public function new(bright:Float, cont:Float)
  {
    super();
    brightness.value = [bright];
    contrast.value = [cont];
  }

  public function update(flot:Float) {}
}