package ui;

import flixel.math.FlxMath;
import util.CoolUtil;
import backend.ClientPrefs;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
  public var sprTracker:FlxSprite;
  public var isPlayer:Bool = false;
  public var char:String = '';

  public function new(char:String = 'bf', isPlayer:Bool = false)
  {
    super();
    this.isPlayer = isPlayer;
    changeIcon(char);
    scrollFactor.set();
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    if (sprTracker != null)
    {
      setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
    }
  }

  public var iconOffsets:Array<Float> = [0, 0];

  public function changeIcon(char:String)
  {
    if (this.char != char)
    {
      var name:String = 'icons/' + char;

      if (!Paths.fileExists('images/' + name + '.png', IMAGE, false, 'rhythm'))
      {
        name = 'icons/icon-' + char;
      }

      if (!Paths.fileExists('images/' + name + '.png', IMAGE, false, 'rhythm'))
      {
        name = 'icons/icon-face';
      }

      var file:Dynamic = Paths.image(name);

      loadGraphic(file);
      loadGraphic(file, true, Math.floor(width / 2), Math.floor(height));
      iconOffsets[0] = (width - 150) / 2;
      iconOffsets[1] = (width - 150) / 2;
      updateHitbox();

      animation.add(char, [0, 1], 0, false, isPlayer);
      animation.play(char, true);

      setFrameWithHealth(50, 1);

      this.char = char;

      antialiasing = ClientPrefs.globalAntialiasing;
    }
  }

  public function iconLerp(e:Float, cZoomingDec:Float, pbR:Float)
  {
    var mult:Float = FlxMath.lerp(1, scale.x, CoolUtil.boundTo(1 - (e * 13 * cZoomingDec * pbR), 0, 1));
    var multDos:Float = FlxMath.lerp(1, scale.y, CoolUtil.boundTo(1 - (e * 13 * cZoomingDec * pbR), 0, 1));
    scale.set(mult, multDos);
    updateHitbox();
  }

  public function setFrameWithHealth(healthes:Float, player:Int)
  {
    if (player == 2)
    {
      if (healthes > 80)
      {
        animation.curAnim.curFrame = 1;
      }
      else
      {
        animation.curAnim.curFrame = 0;
      }
    }
    else
    {
      if (healthes < 20)
      {
        animation.curAnim.curFrame = 1;
      }
      else
      {
        animation.curAnim.curFrame = 0;
      }
    }
  }

  override function updateHitbox()
  {
    super.updateHitbox();
    offset.x = iconOffsets[0];
    offset.y = iconOffsets[1];
  }

  public function getCharacter():String
  {
    return char;
  }
}