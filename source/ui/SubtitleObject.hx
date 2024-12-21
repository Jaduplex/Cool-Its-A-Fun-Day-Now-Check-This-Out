package ui;

import util.EaseUtil;
import backend.ClientPrefs;
import flixel.util.FlxColor;
import backend.Conductor;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

class SubtitleObject extends FlxSpriteGroup
{
  public var _textObj:FlxText;
  public var _timer:Float;
  public var _style:SubtitleTypes;
  public var _ending:Bool = false;

  public var _fontSize:Int = 16;
  public var _color:FlxColor = FlxColor.WHITE;
  public var _secondColor:FlxColor = FlxColor.BLACK;
  public var _borderType:FlxTextBorderStyle = FlxTextBorderStyle.OUTLINE_FAST;
  public var _fontChoice:String = Paths.font("BAUHS93.ttf");
  public var _borderSize:Float = 2;
  public var _doAa:Bool = true;

  public override function new(x:Float, y:Float, text:String, durationInSecs:Float, type:SubtitleTypes)
  {
    super(x, y);

    _timer = durationInSecs;
    _style = type;

    loadTypeData(type);

    _textObj = new FlxText(0, 0, 640, text, _fontSize);
    _textObj.setFormat(_fontChoice, _fontSize, _color, CENTER, _borderType, _secondColor);
    _textObj.borderSize = _borderSize;
    if (_doAa)
    {
      _textObj.antialiasing = ClientPrefs.globalAntialiasing;
    }
    else
    {
      _textObj.antialiasing = false;
    }
    add(_textObj);
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

    var scaleTarget:Float = 0.75;
    if (_style == SubtitleTypes.SCIENCEY)
    {
      scaleTarget = 1;
    }

    FlxTween.tween(_textObj, {alpha: 0, 'scale.x': scaleTarget, 'scale.y': scaleTarget}, Conductor.crochet / 1500,
      {
        ease: EaseUtil.stepped(4),
        onComplete: function the(tw:FlxTween)
        {
          _textObj.destroy();
          this.destroy();
        }
      });
  }

  public function loadTypeData(type:SubtitleTypes):Void
  {
    switch (type)
    {
      case NORMAL:
        _fontSize = 36;
        _color = FlxColor.WHITE;
        _secondColor = FlxColor.BLACK;
        _borderType = FlxTextBorderStyle.OUTLINE_FAST;
        _fontChoice = Paths.font("BAUHS93.ttf");
        _borderSize = 1.5;
        _doAa = true;
      case INVERTED:
        _fontSize = 36;
        _color = FlxColor.BLACK;
        _secondColor = FlxColor.WHITE;
        _borderType = FlxTextBorderStyle.OUTLINE_FAST;
        _fontChoice = Paths.font("BAUHS93.ttf");
        _borderSize = 1.5;
        _doAa = true;
      case SCIENCEY:
        _fontSize = 48;
        _color = FlxColor.fromRGB(30, 173, 25);
        _secondColor = FlxColor.fromRGB(6, 59, 5);
        _borderType = FlxTextBorderStyle.SHADOW;
        _fontChoice = Paths.font("Calculator.ttf");
        _borderSize = 2;
        _doAa = false;
    }
  }
}

enum SubtitleTypes
{
  NORMAL;
  INVERTED;
  SCIENCEY;
}