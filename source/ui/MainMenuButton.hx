package ui;

import backend.ClientPrefs;
import flixel.FlxSprite;

class MainMenuButton extends FlxSprite
{
  public var customAnimMode:Bool = false;
  public var customFinishCallback:Void->Void = null;

  public var isFlashing:Bool = false;
  public var flashTick:Float = 0;
  public final flashFramerate:Float = 20;
  public var flashTimer:Float = 0;
  public var flickerCallback:Void->Void = null;

  public function new(x:Float = 0, y:Float = 0, option:String = 'story_mode', daScale:Float = 1)
  {
    super(x, y);

    frames = Paths.getSparrowAtlas('mainmenu/menu_' + option);
    animation.addByPrefix('idle', option + " basic", 24);
    animation.addByPrefix('selected', option + " white", 24);
    animation.play('idle', true);

    antialiasing = ClientPrefs.globalAntialiasing;

    scale.set(daScale, daScale);
    updateHitbox();
  }

  public function playAnim(animName:String, ?customAnimFinishCallback:Void->Void)
  {
    if (animName != 'idle' && animName != 'selected')
    {
      customAnimMode = true;
    }

    customFinishCallback = customAnimFinishCallback;

    animation.play(animName);
    animation.onFinish.addOnce(onAnimComplete);
    centerOffsets();
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    if (isFlashing)
    {
      if (flashTimer <= 0)
      {
        if (flickerCallback != null)
        {
          flickerCallback();
          flickerCallback = null;
        }

        isFlashing = false;

        return;
      }

      flashTimer -= elapsed;

      flashTick += elapsed;

      if (flashTick >= 1 / flashFramerate)
      {
        flashTick %= 1 / flashFramerate;
        visible = !visible;
      }
    }
  }

  public function onAnimComplete(str:String):Void
  {
    if (customFinishCallback != null)
    {
      customFinishCallback();
    }
    customAnimMode = false;
    animation.onFinish.removeAll();
  }

  public function buttonFlicker(duration:Float, ?finishCallback:Void->Void)
  {
    flashTimer = duration;
    flashTick = 0;
    flickerCallback = finishCallback;
    isFlashing = true;
  }
}