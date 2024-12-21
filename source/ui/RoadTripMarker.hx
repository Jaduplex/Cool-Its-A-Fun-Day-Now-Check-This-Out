package ui;

import util.EaseUtil;
import flixel.tweens.FlxTween;
import backend.ClientPrefs;
import visuals.PixelPerfectSprite;
import flixel.group.FlxSpriteGroup;

class RoadTripMarker extends FlxSpriteGroup
{
  public var songName:String;

  public var marker:PixelPerfectSprite;

  public var songCover:PixelPerfectSprite;

  public var hovered(default, set):Bool = false;

  public var acceptable:Bool = false;

  public function new(x:Float = 0, y:Float = 0, song:String)
  {
    super(x, y);

    songName = song;

    marker = new PixelPerfectSprite();

    marker.frames = Paths.getSparrowAtlas('story/location');

    marker.animation.addByPrefix('idle', 'idle', 24, true);
    marker.animation.addByPrefix('reform', 'reform', 24, false);
    marker.animation.addByPrefix('transform', 'transform', 24, false);
    marker.animation.addByPrefix('transformed', 'box', 24, true);

    marker.animation.play('idle', true);

    marker.animation.onFinish.add(animationFinished);

    marker.antialiasing = ClientPrefs.globalAntialiasing;

    add(marker);

    songCover = new PixelPerfectSprite(0, -50);

    if (songName.toLowerCase() == 'eggshells')
    {
      if (Paths.image('song_covers/' + songName.toLowerCase() + ClientPrefs.lastEggshellsEnding, null, true) != null)
      {
        songCover.loadGraphic(Paths.image('song_covers/' + songName.toLowerCase() + ClientPrefs.lastEggshellsEnding));
      }
      else
      {
        songCover.loadGraphic(Paths.image('song_covers/placeholder'));
      }
    }
    else if (Paths.image('song_covers/' + songName.toLowerCase(), null, true) != null)
    {
      songCover.loadGraphic(Paths.image('song_covers/' + songName.toLowerCase()));
    }
    else
    {
      songCover.loadGraphic(Paths.image('song_covers/placeholder'));
    }

    songCover.setGraphicSize(90, 90);
    songCover.updateHitbox();

    songCover.antialiasing = false;

    add(songCover);

    songCover.alpha = 0;
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);
    // centerOrigin();
  }

  function bringOnTheDetails(value:Bool)
  {
    FlxTween.cancelTweensOf(songCover);

    if (value)
    {
      FlxTween.tween(songCover, {alpha: 1, y: -17}, 0.1, {ease: EaseUtil.stepped(4)});
    }
    else
    {
      FlxTween.tween(songCover, {alpha: 0, y: -50}, 0.05, {ease: EaseUtil.stepped(4)});
    }
  }

  public function set_hovered(value:Bool):Bool
  {
    if (value)
    {
      if (marker.animation.curAnim.name != 'transform' && marker.animation.curAnim.name != 'transformed')
      {
        marker.animation.play('transform', true);
        // marker.offset.set(-82, -71);
        // centerOrigin();
        acceptable = false;
      }
    }
    else if (marker.animation.curAnim.name != 'reform' && marker.animation.curAnim.name != 'idle')
    {
      marker.animation.play("reform", true);
      // marker.offset.set(-82, -71);
      // centerOrigin();
      bringOnTheDetails(false);
      acceptable = false;
    }

    return value;
  }

  public function animationFinished(name:String)
  {
    switch (name)
    {
      case 'transform':
        marker.animation.play('transformed', true);
        // marker.offset.set(-82, -71);
        // centerOrigin();
        bringOnTheDetails(true);
        acceptable = true;
      case 'reform':
        marker.animation.play('idle', true);
        // marker.offset.set(0, 0);
        acceptable = true;
    }
  }
}