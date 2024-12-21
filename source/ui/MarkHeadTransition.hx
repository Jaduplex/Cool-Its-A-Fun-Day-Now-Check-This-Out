package ui;

import util.CoolUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import states.MusicBeatSubstate;

class MarkHeadTransition extends MusicBeatSubstate
{
  public static var finishCallback:Void->Void;
  public static var nextCamera:FlxCamera;

  public var isTransIn:Bool = false;
  public var transition:FlxSprite;

  public function new(duration:Float, isTransIn:Bool)
  {
    super();

    this.isTransIn = isTransIn;

    var zoom:Float = CoolUtil.boundTo(FlxG.camera.zoom, 0.05, 1);
    var width:Int = Std.int(FlxG.width / zoom);
    var height:Int = Std.int(FlxG.height / zoom);

    transition = new FlxSprite();
    transition.frames = Paths.getSparrowAtlas('screen_transition');
    transition.animation.addByPrefix('in', 'in', 24, false);
    transition.animation.addByPrefix('out', 'out', 24, false);
    transition.animation.play('out', true);
    transition.setGraphicSize(width, height);
    transition.updateHitbox();
    transition.screenCenter();
    add(transition);

    if (isTransIn)
    {
      transition.animation.play('in', true);
      transition.animation.onFinish.addOnce(function dude(duh:String)
      {
        transition.animation.onFinish.removeAll();
        transition.visible = false;
        close();
      });
    }
    else
    {
      transition.animation.play('out', true);
      transition.animation.onFinish.addOnce(function dude(duh:String)
      {
        transition.animation.onFinish.removeAll();
        if (finishCallback != null)
        {
          finishCallback();
        }
      });
    }

    if (nextCamera != null)
    {
      transition.cameras = [nextCamera];
    }

    nextCamera = null;
  }
}