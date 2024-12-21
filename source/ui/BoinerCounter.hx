package ui;

import util.CoolUtil;
import flixel.math.FlxMath;
import backend.ClientPrefs;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import visuals.PixelPerfectSprite;
import flixel.group.FlxSpriteGroup;

class BoinerCounter extends FlxSpriteGroup
{
  public var capsule:PixelPerfectSprite;
  public var text:FlxText;

  public var lerpBoiners:Float = 0;

  public override function new(x:Float, y:Float)
  {
    super(x, y);

    capsule = new PixelPerfectSprite().loadGraphic(Paths.image('gamble/counter'));
    capsule.updateHitbox();
    capsule.antialiasing = false;
    add(capsule);

    text = new FlxText(142, 36, 238, '0', 48);
    text.setFormat(Paths.font("BAUHS93.ttf"), 48, FlxColor.BLACK, CENTER, OUTLINE_FAST, FlxColor.WHITE);
    text.borderSize = 1.5;
    text.antialiasing = false;
    add(text);
  }

  public override function update(elapsed:Float)
  {
    if (lerpBoiners != ClientPrefs.boiners)
    {
      lerpBoiners = FlxMath.lerp(lerpBoiners, ClientPrefs.boiners, CoolUtil.boundTo(elapsed * 12, 0, 1));
    }

    if ((lerpBoiners >= (ClientPrefs.boiners - 5)) || (lerpBoiners <= (ClientPrefs.boiners + 5)))
    {
      lerpBoiners = ClientPrefs.boiners;
    }

    text.text = Std.string(Math.floor(lerpBoiners));

    super.update(elapsed);
  }
}