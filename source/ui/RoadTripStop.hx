package ui;

import backend.ClientPrefs;
import visuals.PixelPerfectSprite;
import flixel.group.FlxSpriteGroup;

class RoadTripStop extends FlxSpriteGroup
{
  public var songName:String;

  public var stopG:PixelPerfectSprite;
  public var marker:RoadTripMarker;

  public var hovered(default, set):Bool = false;

  public var numLinked:Int;

  public function new(x:Float = 0, y:Float = 0, song:String, number:Int)
  {
    super(x, y);

    songName = song;
    numLinked = number;

    stopG = new PixelPerfectSprite(0, 145);

    stopG.frames = Paths.getSparrowAtlas('story/stop');

    stopG.animation.addByPrefix('idle', 'stop idle', 24, true);
    stopG.animation.addByPrefix('hovered', 'stop hovered', 24, true);

    stopG.animation.play('idle', true);

    stopG.antialiasing = ClientPrefs.globalAntialiasing;

    add(stopG);

    marker = new RoadTripMarker(0, 0, songName);

    add(marker);
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);
  }

  public function set_hovered(value:Bool):Bool
  {
    if (value)
    {
      if (stopG.animation.curAnim.name != 'hovered' && stopG.animation.curAnim.name != 'hovered')
      {
        stopG.animation.play('hovered', true);
        stopG.offset.set(-119, -131);
      }
    }
    else if (stopG.animation.curAnim.name != 'idle' && stopG.animation.curAnim.name != 'idle')
    {
      stopG.animation.play("idle", true);
      stopG.offset.set(0, 0);
    }

    marker.hovered = value;

    return value;
  }
}