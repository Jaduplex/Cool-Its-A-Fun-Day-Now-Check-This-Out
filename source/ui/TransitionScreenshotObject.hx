package ui;

import util.EaseUtil;
import flixel.tweens.FlxTween;
import flixel.graphics.FlxGraphic;
import util.CoolUtil;
import visuals.PixelPerfectSprite;

class TransitionScreenshotObject extends PixelPerfectSprite
{
  public function new()
  {
    super();

    if (CoolUtil.lastStateScreenShot == null)
    {
      visible = false;
      return;
    }

    loadGraphic(FlxGraphic.fromBitmapData(CoolUtil.lastStateScreenShot.bitmapData));
    setGraphicSize(1280, 720);
    updateHitbox();
    screenCenter();
  }

  public function fadeout()
  {
    FlxTween.tween(this, {alpha: 0}, 0.25,
      {
        startDelay: 0.05,
        ease: EaseUtil.stepped(4),
        onComplete: function transThingDiesIrl(stupidScr:FlxTween)
        {
          this.visible = false;
          this.destroy();
        }
      });
  }
}