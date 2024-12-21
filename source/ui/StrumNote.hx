package ui;

import visuals.PixelPerfectSprite;
import flixel.FlxG;
import shaders.ColorSwap;
import backend.ClientPrefs;

class StrumNote extends PixelPerfectSprite
{
  public var colorSwap:ColorSwap;
  public var resetAnim:Float = 0;
  public var noteData:Int = 0;
  public var direction:Float = 90;
  public var downScroll:Bool = false;
  public var sustainReduce:Bool = true;

  public var player:Int;

  public var texture(default, set):String = null;

  public function set_texture(value:String):String
  {
    if (texture != value)
    {
      texture = value;
      reloadNote();
    }

    return value;
  }

  public function new(x:Float, y:Float, leData:Int, player:Int, skin:String = 'ui/notes')
  {
    colorSwap = new ColorSwap();
    shader = colorSwap.shader;

    noteData = leData;

    this.player = player;
    this.noteData = leData;

    super(x, y);

    texture = skin;

    scrollFactor.set();
  }

  public function reloadNote()
  {
    var lastAnim:String = null;

    if (animation.curAnim != null)
    {
      lastAnim = animation.curAnim.name;
    }

    frames = Paths.getSparrowAtlas(texture);

    animation.addByPrefix('green', 'arrowUP', 24);
    animation.addByPrefix('blue', 'arrowDOWN', 24);
    animation.addByPrefix('purple', 'arrowLEFT', 24);
    animation.addByPrefix('red', 'arrowRIGHT', 24);

    antialiasing = false;

    switch (Math.abs(noteData) % 4)
    {
      case 0:
        animation.addByPrefix('static', 'arrowLEFT', 24);
        animation.addByPrefix('pressed', 'left press', 24, false);
        animation.addByPrefix('confirm', 'left confirm', 24, false);
      case 1:
        animation.addByPrefix('static', 'arrowDOWN', 24);
        animation.addByPrefix('pressed', 'down press', 24, false);
        animation.addByPrefix('confirm', 'down confirm', 24, false);
      case 2:
        animation.addByPrefix('static', 'arrowUP', 24);
        animation.addByPrefix('pressed', 'up press', 24, false);
        animation.addByPrefix('confirm', 'up confirm', 24, false);
      case 3:
        animation.addByPrefix('static', 'arrowRIGHT', 24);
        animation.addByPrefix('pressed', 'right press', 24, false);
        animation.addByPrefix('confirm', 'right confirm', 24, false);
    }

    updateHitbox();

    if (lastAnim != null)
    {
      playAnim(lastAnim, true);
    }
  }

  public function postAddedToGroup()
  {
    playAnim('static', true);

    x += Note.swagWidth * noteData;
    x += 50;
    x += ((FlxG.width / 2) * player);

    ID = noteData;
  }

  override function update(elapsed:Float)
  {
    if (resetAnim > 0)
    {
      resetAnim -= elapsed;

      if (resetAnim <= 0)
      {
        playAnim('static', true);
        resetAnim = 0;
      }
    }

    if (animation.curAnim.name == 'confirm')
    {
      centerOrigin();
    }

    super.update(elapsed);
  }

  public function playAnim(anim:String, ?force:Bool = false)
  {
    animation.play(anim, force);

    centerOffsets();
    centerOrigin();

    if (animation.curAnim == null || animation.curAnim.name == 'static')
    {
      colorSwap.hue = 0;
      colorSwap.saturation = 0;
      colorSwap.brightness = 0;
    }
    else
    {
      if (noteData > -1 && noteData < ClientPrefs.arrowHSV.length)
      {
        colorSwap.hue = ClientPrefs.arrowHSV[noteData][0] / 360;
        colorSwap.saturation = ClientPrefs.arrowHSV[noteData][1] / 100;
        colorSwap.brightness = ClientPrefs.arrowHSV[noteData][2] / 100;
      }

      if (animation.curAnim.name == 'confirm')
      {
        centerOrigin();
      }
    }
  }
}