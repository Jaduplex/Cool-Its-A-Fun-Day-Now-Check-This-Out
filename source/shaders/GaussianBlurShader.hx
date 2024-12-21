package shaders;

import flixel.addons.display.FlxRuntimeShader;
import openfl.utils.Assets;

/**
 * Note... not actually gaussian!
 */
class GaussianBlurShader extends FlxRuntimeShader
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'GaussianBlurShader';

  public var amount:Float;

  public function new(amount:Float = 1.0)
  {
    super(Assets.getText(Paths.frag("gaussianBlur")));
    setAmount(amount);
  }

  public function setAmount(value:Float):Void
  {
    this.amount = value;
    this.setFloat("_amount", amount);
  }
}