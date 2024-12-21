package states;

import lime.math.Rectangle;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import util.CoolUtil;
import backend.ClientPrefs;
import ui.MarkHeadTransition;
import backend.PlayerSettings;
import backend.Controls;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxState;
import flixel.FlxCamera;
import backend.Conductor;

class MusicBeatState extends FlxUIState
{
  public var curSection:Int = 0;
  public var stepsToDo:Int = 0;

  public var curStep:Int = 0;
  public var curBeat:Int = 0;

  public var curDecStep:Float = 0;
  public var curDecBeat:Float = 0;
  public var controls(get, never):Controls;

  public static var camBeat:FlxCamera;

  inline function get_controls():Controls
  {
    return PlayerSettings.player1.controls;
  }

  override function create()
  {
    camBeat = FlxG.camera;

    var skip:Bool = FlxTransitionableState.skipNextTransOut;

    super.create();

    if (!skip)
    {
      openSubState(new MarkHeadTransition(0.7, true));
    }

    FlxTransitionableState.skipNextTransOut = false;
  }

  override function update(elapsed:Float)
  {
    var oldStep:Int = curStep;

    updateCurStep();
    updateBeat();

    if (oldStep != curStep)
    {
      if (curStep > 0)
      {
        stepHit();
      }

      if (PlayState.SONG != null)
      {
        if (oldStep < curStep)
        {
          updateSection();
        }
        else
        {
          rollbackSection();
        }
      }
    }

    if (FlxG.keys.anyJustPressed(TitleState.fullscreenKeys))
    {
      FlxG.fullscreen = !FlxG.fullscreen;
    }

    if (FlxG.save.data != null)
    {
      FlxG.save.data.fullscreen = FlxG.fullscreen;
    }

    super.update(elapsed);
  }

  public function updateSection():Void
  {
    if (stepsToDo < 1)
    {
      stepsToDo = Math.round(getBeatsOnSection() * 4);
    }

    while (curStep >= stepsToDo)
    {
      curSection++;

      var beats:Float = getBeatsOnSection();

      stepsToDo += Math.round(beats * 4);

      sectionHit();
    }
  }

  public function rollbackSection():Void
  {
    if (curStep < 0)
    {
      return;
    }

    var lastSection:Int = curSection;

    curSection = 0;
    stepsToDo = 0;

    for (i in 0...PlayState.SONG.notes.length)
    {
      if (PlayState.SONG.notes[i] != null)
      {
        stepsToDo += Math.round(getBeatsOnSection() * 4);

        if (stepsToDo > curStep)
        {
          break;
        }

        curSection++;
      }
    }

    if (curSection > lastSection)
    {
      sectionHit();
    }
  }

  public function updateBeat():Void
  {
    curBeat = Math.floor(curStep / 4);
    curDecBeat = curDecStep / 4;
  }

  public function updateCurStep():Void
  {
    var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

    var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
    curDecStep = lastChange.stepTime + shit;
    curStep = lastChange.stepTime + Math.floor(shit);
  }

  public static function switchState(nextState:FlxState, libraryToLoad:String = 'rhythm')
  {
    if (CoolUtil.hasInitializedWindow)
    {
      gameStateScreenshot();
    }

    Paths.setCurrentLevel(libraryToLoad);

    var curState:Dynamic = FlxG.state;
    var leState:MusicBeatState = curState;

    if (!FlxTransitionableState.skipNextTransIn)
    {
      leState.openSubState(new MarkHeadTransition(0.6, false));

      if (nextState == FlxG.state)
      {
        MarkHeadTransition.finishCallback = function() {
          FlxG.resetState();
        };
      }
      else
      {
        MarkHeadTransition.finishCallback = function() {
          FlxG.switchState(() -> nextState);
        };
      }

      return;
    }

    FlxTransitionableState.skipNextTransIn = false;

    FlxG.switchState(() -> nextState);
  }

  public static function resetState()
  {
    if (CoolUtil.hasInitializedWindow)
    {
      gameStateScreenshot();
    }
    FlxG.resetState();
  }

  public static function gameStateScreenshot()
  {
    #if DEVELOPERBUILD
    var perf = new Perf("MusicBeatState gameStateScreenshot()");
    #end

    var mouseVisi = FlxG.mouse.visible;

    #if !SHOWCASEVIDEO
    Main.fpsVar.visible = false;
    #end

    FlxG.mouse.visible = false;

    CoolUtil.lastStateScreenShot = new Bitmap(BitmapData.fromImage(FlxG.stage.window.readPixels(new Rectangle(0, 0, FlxG.stage.stageWidth,
      FlxG.stage.stageHeight))));

    #if !SHOWCASEVIDEO
    Main.fpsVar.visible = ClientPrefs.showFPS;
    #end
    FlxG.mouse.visible = mouseVisi;

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  public static function getState():MusicBeatState
  {
    var curState:Dynamic = FlxG.state;
    var leState:MusicBeatState = curState;

    return leState;
  }

  public function stepHit():Void
  {
    if (curStep % 4 == 0)
    {
      beatHit();
    }
  }

  public function beatHit():Void {}

  public function sectionHit():Void {}

  public function getBeatsOnSection()
  {
    var val:Null<Float> = 4;

    if (PlayState.SONG != null && PlayState.SONG.notes[curSection] != null)
    {
      val = PlayState.SONG.notes[curSection].sectionBeats;
    }

    return val == null ? 4 : val;
  }
}