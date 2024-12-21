package shaders;

import flixel.addons.display.FlxRuntimeShader;
import openfl.utils.Assets;
import flixel.math.FlxPoint;

class MosaicEffect extends FlxRuntimeShader
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'MosaicEffect';

  public var blockSize:FlxPoint = FlxPoint.get(1.0, 1.0);

  public function new()
  {
    super(Assets.getText(Paths.frag('mosaic')));
    setBlockSize(1.0, 1.0);
  }

  public function setBlockSize(w:Float, h:Float)
  {
    blockSize.set(w, h);
    setFloatArray("uBlocksize", [w, h]);
  }
}