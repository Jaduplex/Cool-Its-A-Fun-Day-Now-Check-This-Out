package shaders;

import openfl.utils.Assets;
import flixel.addons.display.FlxRuntimeShader;

/**
 * Create a little dotting effect.
 */
class InverseDotsShader extends FlxRuntimeShader
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'InverseDotsShader';

  public var amount(default, set):Float;

  public function new(theAmount:Float = 2)
  {
    super(Assets.getText(Paths.frag("inverseDots")));
    this.amount = theAmount;
  }

  function set_amount(value:Float):Float
  {
    this.setFloat('_amount', value);
    this.amount = value;

    return this.amount;
  }

  public function update(flot:Float) {}
}