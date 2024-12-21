package states;

import backend.PlayerSettings;
import backend.Controls;
import backend.ClientPrefs;
import flixel.FlxSubState;
import backend.Conductor;

class MusicBeatSubstate extends FlxSubState
{
  public function new()
  {
    super();
  }

  public var lastBeat:Float = 0;
  public var lastStep:Float = 0;

  public var curStep:Int = 0;
  public var curBeat:Int = 0;

  public var curDecStep:Float = 0;
  public var curDecBeat:Float = 0;
  public var controls(get, never):Controls;

  inline function get_controls():Controls
  {
    return PlayerSettings.player1.controls;
  }

  override function update(elapsed:Float)
  {
    var oldStep:Int = curStep;

    updateCurStep();
    updateBeat();

    if (oldStep != curStep && curStep > 0)
    {
      stepHit();
    }

    super.update(elapsed);
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

  public function stepHit():Void
  {
    if (curStep % 4 == 0)
    {
      beatHit();
    }
  }

  public function beatHit():Void {}
}