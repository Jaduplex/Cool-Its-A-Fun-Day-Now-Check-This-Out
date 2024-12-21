package;

import states.InitState;
import backend.ClientPrefs;
import util.CoolUtil;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import openfl.display.StageAlign;
import lime.app.Application;
#if desktop
import backend.Discord.DiscordClient;
#end
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class Main extends Sprite
{
  var game =
    {
      width: 1280, // WINDOW width
      height: 720, // WINDOW height
      initialState: InitState, // initial game state
      zoom: -1.0, // game state bounds
      framerate: 240, // default framerate
      skipSplash: true, // if the default flixel splash screen should be skipped
      startFullscreen: false // if the game should start at fullscreen mode
    };

  public static var fpsVar:FPS;

  // You can pretty much ignore everything from here on - your code should go in your states.

  public static function main():Void
  {
    Lib.current.addChild(new Main());
  }

  public function new()
  {
    super();

    if (stage != null)
    {
      init();
    }
    else
    {
      addEventListener(Event.ADDED_TO_STAGE, init);
    }
  }

  private function init(?E:Event):Void
  {
    if (hasEventListener(Event.ADDED_TO_STAGE))
    {
      removeEventListener(Event.ADDED_TO_STAGE, init);
    }

    setupGame();
  }

  private function setupGame():Void
  {
    var stageWidth:Int = Lib.current.stage.stageWidth;
    var stageHeight:Int = Lib.current.stage.stageHeight;

    if (game.zoom == -1.0)
    {
      var ratioX:Float = stageWidth / game.width;
      var ratioY:Float = stageHeight / game.height;
      game.zoom = Math.min(ratioX, ratioY);
      game.width = Math.ceil(stageWidth / game.zoom);
      game.height = Math.ceil(stageHeight / game.zoom);
    }

    ClientPrefs.loadDefaultKeys();

    addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate, game.skipSplash,
      game.startFullscreen));

    Lib.current.stage.align = StageAlign.TOP_LEFT;
    Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

    #if !SHOWCASEVIDEO
    fpsVar = new FPS(10, 3, 0xFFFFFF);
    fpsVar.visible = false;
    addChild(fpsVar);

    if (fpsVar != null)
    {
      fpsVar.visible = ClientPrefs.showFPS;
    }
    #end

    #if CRASH_HANDLER
    Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
    #end

    FlxG.signals.gameResized.add(onResizeGame);
  }

  function onResizeGame(w:Int, h:Int)
  {
    fixShaderSize(this);

    if (FlxG.game != null)
    {
      fixShaderSize(FlxG.game);
    }

    if (FlxG.cameras == null)
    {
      return;
    }

    for (cam in FlxG.cameras.list)
    {
      if (cam != null && (cam.filters != null || cam.filters != []))
      {
        fixShaderSize(cam.flashSprite);
      }
    }
  }

  function fixShaderSize(sprite:Sprite)
  {
    @:privateAccess
    {
      if (sprite != null)
      {
        sprite.__cacheBitmap = null;
        sprite.__cacheBitmapData = null;
        sprite.__cacheBitmapData2 = null;
        sprite.__cacheBitmapData3 = null;
        sprite.__cacheBitmapColorTransform = null;
      }
    }
  }

  // Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
  // very cool person for real they don't get enough credit for their work
  #if CRASH_HANDLER
  function onCrash(e:UncaughtErrorEvent):Void
  {
    var errMsg:String = "";
    var path:String;
    var callStack:Array<StackItem> = CallStack.exceptionStack(true);
    var dateNow:String = Date.now().toString();

    dateNow = dateNow.replace(" ", "_");
    dateNow = dateNow.replace(":", "'");

    path = "./logs/" + "TheDestitutionMod_" + dateNow + ".txt";

    for (stackItem in callStack)
    {
      switch (stackItem)
      {
        case FilePos(s, file, line, column):
          errMsg += file + " (line " + line + ")\n";
        default:
          Sys.println(stackItem);
      }
    }

    errMsg += "\nUncaught Error: "
      + e.error
      +
      "\nPlease report this error on the GameJolt page if you are able to replicate it!\n\n> Crash Handler written by: sqirra-rng\n> Modified for The Destitution Mod by: Cynda";

    if (!FileSystem.exists("./logs/"))
    {
      FileSystem.createDirectory("./logs/");
    }

    File.saveContent(path, errMsg + "\n" + CoolUtil.markAscii + "\n");

    Sys.println(errMsg);
    Sys.println("Crash dump saved in " + Path.normalize(path));

    Application.current.window.alert("\nUnfortunately, The Destitution Mod has stopped.\n\nMore Details:\n" + errMsg, "The Destitution Mod Crash Handler");
    DiscordClient.shutdown();
    Application.current.window.close();
    Sys.exit(1);
  }
  #end
}