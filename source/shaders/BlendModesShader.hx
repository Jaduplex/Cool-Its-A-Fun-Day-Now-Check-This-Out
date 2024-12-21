package shaders;

import flixel.addons.display.FlxRuntimeShader;
import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;

class BlendModesShader extends FlxRuntimeShader
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'BlendModesShader';

  public var camera:ShaderInput<BitmapData>;
  public var cameraData:BitmapData;

  public function new()
  {
    super(Assets.getText(Paths.frag('blendModes')));
  }

  public function setCamera(cameraData:BitmapData):Void
  {
    this.cameraData = cameraData;

    this.setBitmapData('camera', this.cameraData);
  }
}