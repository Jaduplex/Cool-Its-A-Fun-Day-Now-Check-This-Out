package shaders;

import flixel.system.FlxAssets.FlxShader;

class MultiplyShader extends FlxShader
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'MultiplyShader';

  @:glFragmentSource('
		#pragma header
        uniform sampler2D funnyImage;
		uniform vec4 uBlendColor;

		vec4 blendMultiply(vec4 base, vec4 blend)
		{
			return base * blend;
		}

		vec4 blendMultiply(vec4 base, vec4 blend, float opacity)
		{
			return (blendMultiply(base, blend) * opacity + base * (1.0 - opacity));
		}

		void main()
		{
			vec4 base = flixel_texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = blendMultiply(base, uBlendColor, uBlendColor.a);
		}')
  public function new()
  {
    super();
  }
}