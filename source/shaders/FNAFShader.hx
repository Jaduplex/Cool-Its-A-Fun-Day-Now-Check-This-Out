package shaders;

import flixel.addons.display.FlxRuntimeShader;
import openfl.utils.Assets;

class FNAFShader extends FlxRuntimeShader
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'FNAFShader';

  public var depth(default, set):Float;

  public function new(theDepth:Float = 5)
  {
    super(Assets.getText(Paths.frag('fnaf')));
    this.depth = theDepth;
  }

  function set_depth(value:Float):Float
  {
    this.setFloat('uDepth', value);
    this.depth = value;

    return this.depth;
  }

  public function update(elapsed:Float) {}
}