package shaders;

import openfl.utils.Assets;
import flixel.addons.display.FlxRuntimeShader;

class BloomShader extends FlxRuntimeShader // BLOOM SHADER BY BBPANZU
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'BloomShader';

  public var dim(default, set):Float;
  public var Directions(default, set):Float;
  public var Quality(default, set):Float;
  public var Size(default, set):Float;

  public function new()
  {
    super(Assets.getText(Paths.frag('bloom')));

    Size = 18.0;
    Quality = 8.0;
    dim = 2.0;
    Directions = 16.0;
  }

  public function update(flot:Float) {}

  function set_dim(value:Float):Float
  {
    this.setFloat('dim', value);
    this.dim = value;

    return this.dim;
  }

  function set_Directions(value:Float):Float
  {
    this.setFloat('Directions', value);
    this.Directions = value;

    return this.Directions;
  }

  function set_Quality(value:Float):Float
  {
    this.setFloat('Quality', value);
    this.Quality = value;

    return this.Quality;
  }

  function set_Size(value:Float):Float
  {
    this.setFloat('Size', value);
    this.Size = value;

    return this.Size;
  }
}