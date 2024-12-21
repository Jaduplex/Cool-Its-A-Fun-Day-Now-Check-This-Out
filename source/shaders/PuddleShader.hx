package shaders;

import flixel.addons.display.FlxRuntimeShader;
import openfl.Assets;

class PuddleShader extends FlxRuntimeShader
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'PuddleShader';

  public function new()
  {
    super(Assets.getText(Paths.frag('puddle')));
  }
}