package openfl.display;

import flixel.util.FlxStringUtil;
import backend.ClientPrefs;
import util.MemoryUtil;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if flash
import openfl.Lib;
#end

/**
  The FPS class provides an easy-to-use monitor to display
  the current frame rate of an OpenFL project

  Class shadowed for The Destitution Mod.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
  /**
    The current frame rate, expressed using frames-per-second
  **/
  public var currentFPS(default, null):Int;

  /**
    The current memory usage.
  **/
  public var memoryMegas:Float = 0;

  @:noCompletion private var cacheCount:Int;
  @:noCompletion private var currentTime:Float;
  @:noCompletion private var times:Array<Float>;

  public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
  {
    super();

    this.x = x;
    this.y = y;

    currentFPS = 0;
    selectable = false;
    mouseEnabled = false;
    defaultTextFormat = new TextFormat(Paths.font("BAUHS93.ttf"), 20, color);
    autoSize = LEFT;
    multiline = true;
    text = "FPS: ";

    cacheCount = 0;
    currentTime = 0;
    times = [];

    #if flash
    addEventListener(Event.ENTER_FRAME, function(e) {
      var time = Lib.getTimer();
      __enterFrame(time - currentTime);
    });
    #end
  }

  var deltaTimeout:Float = 0.0;

  // Event Handlers
  @:noCompletion
  private #if !flash override #end function __enterFrame(deltaTime:Float):Void
  {
    if (deltaTimeout > 1000)
    {
      // there's no need to update this every frame and it only causes performance losses.
      deltaTimeout = 0.0;
      return;
    }

    currentTime += deltaTime;

    times.push(currentTime);

    while (times[0] < currentTime - 1000)
    {
      times.shift();
    }

    var currentCount = times.length;

    currentFPS = Math.round((currentCount + cacheCount) / 2);

    if (currentFPS > ClientPrefs.framerate)
    {
      currentFPS = ClientPrefs.framerate;
    }

    if (currentCount != cacheCount)
    {
      text = 'FPS: ${currentFPS}';

      text += '\nMemory: ${FlxStringUtil.formatBytes(MemoryUtil.getMemoryUsed())}';

      textColor = 0xFFFFFFFF;

      if (currentFPS <= 30)
      {
        textColor = 0xFFFF0000;
      }

      text += "\n";
    }

    cacheCount = currentCount;
    deltaTimeout += deltaTime;
  }
}