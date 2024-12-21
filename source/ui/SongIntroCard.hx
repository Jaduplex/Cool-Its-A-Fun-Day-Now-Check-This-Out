package ui;

import util.EaseUtil;
import visuals.PixelPerfectSprite;
import states.PlayState;
import backend.ClientPrefs;
import flixel.util.FlxColor;
import backend.Conductor;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

class SongIntroCard extends FlxSpriteGroup
{
  public var _charObj:PixelPerfectSprite;
  public var _cardObj:PixelPerfectSprite;
  public var _cardObjBelly:PixelPerfectSprite;
  public var _textObj:FlxText;
  public var _credObj:FlxText;
  public var _timer:Float;
  public var _ending:Bool = false;

  public static final _sizeMultipFromSixForty:Float = 1.25;

  public override function new(x:Float, y:Float, cardName:String, songDisplayName:String, composer:String, color:FlxColor)
  {
    super(x, y);

    _timer = ((Conductor.crochet / 250) * 2) + (0.1 / PlayState.instance.playbackRate);

    _charObj = new PixelPerfectSprite().loadGraphic(Paths.image('ui/songCards/' + cardName, null, true));
    if (Paths.image('ui/songCards/' + cardName, null, true) == null)
    {
      _charObj.loadGraphic(Paths.image('ui/songCards/placeholder'));
    }
    _charObj.setGraphicSize(800);
    _charObj.updateHitbox();
    _charObj.antialiasing = ClientPrefs.globalAntialiasing;
    add(_charObj);

    _cardObj = new PixelPerfectSprite().loadGraphic(Paths.image('ui/introCard'));
    _cardObj.scale.set(_sizeMultipFromSixForty, _sizeMultipFromSixForty);
    _cardObj.updateHitbox();
    _cardObj.color = color;
    add(_cardObj);

    _cardObjBelly = new PixelPerfectSprite().loadGraphic(Paths.image('ui/introCardBelly'));
    _cardObjBelly.scale.set(_sizeMultipFromSixForty, _sizeMultipFromSixForty);
    _cardObjBelly.updateHitbox();
    add(_cardObjBelly);

    _textObj = new FlxText(131.875, 273.75, 537.5, songDisplayName, Std.int(36 * _sizeMultipFromSixForty));
    _textObj.setFormat(Paths.font("BAUHS93.ttf"), 50, color, FlxTextAlign.CENTER, NONE);
    _textObj.antialiasing = ClientPrefs.globalAntialiasing;
    _textObj.bold = true;
    add(_textObj);

    _credObj = new FlxText(131.875, 327.5, 537.5, "Composed by " + composer, 15);
    _credObj.setFormat(Paths.font("BAUHS93.ttf"), 20, FlxColor.BLACK, FlxTextAlign.CENTER, NONE);
    _credObj.antialiasing = ClientPrefs.globalAntialiasing;
    add(_credObj);
  }

  public override function update(elapsed:Float)
  {
    super.update(elapsed);

    if (!_ending)
    {
      _timer -= 1 * elapsed;

      if (_timer <= 0)
      {
        startEnding();
      }
    }
  }

  public function startEnding():Void
  {
    _ending = true;

    FlxTween.tween(this, {alpha: 0, y: this.y + 128}, Conductor.crochet / 1000,
      {
        ease: EaseUtil.stepped(4),
        onComplete: function the(tw:FlxTween)
        {
          _credObj.destroy();
          _textObj.destroy();
          _charObj.destroy();
          _cardObjBelly.destroy();
          _cardObj.destroy();
          this.destroy();
        }
      });
  }
}