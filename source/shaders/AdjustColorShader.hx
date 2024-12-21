package shaders;

import flixel.addons.display.FlxRuntimeShader;
import openfl.utils.Assets;

class AdjustColorShader extends FlxRuntimeShader
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'AdjustColorShader';

  public var hue(default, set):Float;
  public var saturation(default, set):Float;
  public var brightness(default, set):Float;
  public var contrast(default, set):Float;

  public function new()
  {
    super(Assets.getText(Paths.frag('adjustColor')));
    hue = 0;
    saturation = 0;
    brightness = 0;
    contrast = 0;
  }

  function set_hue(value:Float):Float
  {
    this.setFloat('hue', value);
    this.hue = value;

    return this.hue;
  }

  function set_saturation(value:Float):Float
  {
    this.setFloat('saturation', value);
    this.saturation = value;

    return this.saturation;
  }

  function set_brightness(value:Float):Float
  {
    this.setFloat('brightness', value);
    this.brightness = value;

    return this.brightness;
  }

  function set_contrast(value:Float):Float
  {
    this.setFloat('contrast', value);
    this.contrast = value;

    return this.contrast;
  }
}