package shaders;

import openfl.utils.Assets;
import flixel.addons.display.FlxRuntimeShader;
import flixel.tweens.FlxTween;

class BlueFade extends FlxRuntimeShader
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'BlueFade';

  public var fadeAmt(default, set):Float;

  function set_fadeAmt(val:Float):Float
  {
    this.setFloat('fadeAmt', val);
    fadeAmt = val;

    return fadeAmt;
  }

  public function fade(startAmt:Float = 0, targetAmt:Float = 1, duration:Float, _options:TweenOptions):Void
  {
    fadeAmt = startAmt;
    FlxTween.tween(this, {fadeVal: targetAmt}, duration, _options);
  }

  public function new()
  {
    super(Assets.getText(Paths.frag('blueFade')));

    this.fadeAmt = 1;
  }
}