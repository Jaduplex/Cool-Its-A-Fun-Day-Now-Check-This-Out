package ui;

import util.RandomUtil;
import visuals.PixelPerfectSprite;
import backend.Conductor;
import states.PlayState;
import backend.ClientPrefs;
import shaders.ColorSwap;
#if DEVELOPERBUILD
import editors.ChartingState;
#end

typedef EventNote =
{
  strumTime:Float,
  event:String,
  value1:String,
  value2:String
}

class Note extends PixelPerfectSprite
{
  public var extraData:Map<String, Dynamic> = [];

  public var strumTime:Float = 0;
  public var mustPress:Bool = false;
  public var noteData:Int = 0;
  public var canBeHit:Bool = false;
  public var tooLate:Bool = false;
  public var wasGoodHit:Bool = false;
  public var ignoreNote:Bool = false;
  public var hitByOpponent:Bool = false;
  public var noteWasHit:Bool = false;
  public var prevNote:Note;
  public var nextNote:Note;

  public var spawned:Bool = false;

  public var tail:Array<Note> = [];
  public var parent:Note;
  public var blockHit:Bool = false;

  public var sustainLength:Float = 0;
  public var isSustainNote:Bool = false;
  public var noteType(default, set):String = null;

  public var eventName:String = '';
  public var eventLength:Int = 0;
  public var eventVal1:String = '';
  public var eventVal2:String = '';

  public var colorSwap:ColorSwap;
  public var inEditor:Bool = false;

  public var animSuffix:String = '';
  public var gfNote:Bool = false;
  public var earlyHitMult:Float = 0.5;
  public var lateHitMult:Float = 1;
  public var lowPriority:Bool = false;

  public static var swagWidth:Float = 160 * 0.7;

  public var colArray:Array<String> = ['purple', 'blue', 'green', 'red'];
  public var pixelInt:Array<Int> = [0, 1, 2, 3];

  public var noteSplashDisabled:Bool = false;
  public var noteSplashTexture:String = null;
  public var noteSplashHue:Float = 0;
  public var noteSplashSat:Float = 0;
  public var noteSplashBrt:Float = 0;

  public var offsetX:Float = 0;
  public var offsetY:Float = 0;
  public var offsetAngle:Float = 0;
  public var multAlpha:Float = 1;
  public var multSpeed(default, set):Float = 1;

  public var copyX:Bool = true;
  public var copyY:Bool = true;
  public var copyAngle:Bool = true;
  public var copyAlpha:Bool = true;

  public var hitHealth:Float = 0.023;
  public var missHealth:Float = 0.0475;
  public var rating:String = 'unknown';
  public var ratingMod:Float = 0;
  public var ratingDisabled:Bool = false;

  public var texture(default, set):String = null;

  public var noAnimation:Bool = false;
  public var noMissAnimation:Bool = false;
  public var hitCausesMiss:Bool = false;
  public var distance:Float = 2000;

  public var hitsoundDisabled:Bool = false;

  public var itemNote:Bool = false;

  public function set_multSpeed(value:Float):Float
  {
    resizeByRatio(value / multSpeed);
    multSpeed = value;
    return value;
  }

  public function resizeByRatio(ratio:Float)
  {
    if (isSustainNote && !animation.curAnim.name.endsWith('end'))
    {
      scale.y *= ratio;
      updateHitbox();
    }
  }

  public function set_texture(value:String):String
  {
    if (texture != value)
    {
      switch (noteType.toLowerCase())
      {
        case 'item note' | 'rulez note' | 'honk note' | 'something something wah wah idk':
          return texture;
      }

      reloadNote('', value);
      texture = value;
    }

    return value;
  }

  public function set_noteType(value:String):String
  {
    noteSplashTexture = PlayState.SONG.splashSkin;

    if (noteData > -1 && noteData < ClientPrefs.arrowHSV.length)
    {
      colorSwap.hue = ClientPrefs.arrowHSV[noteData][0] / 360;
      colorSwap.saturation = ClientPrefs.arrowHSV[noteData][1] / 100;
      colorSwap.brightness = ClientPrefs.arrowHSV[noteData][2] / 100;
    }

    if (noteData > -1 && noteType != value)
    {
      switch (value)
      {
        case 'Alt Animation':
          animSuffix = '-alt';
        case 'No Animation':
          noAnimation = true;
          noMissAnimation = true;
        case 'GF Sing':
          gfNote = true;
        case 'Item Note':
          angle = 0;
          lowPriority = true;
          ignoreNote = true;
          itemNote = true;

          colorSwap.hue = 0;
          colorSwap.brightness = 0;
          colorSwap.saturation = 0;

          var noteNum:Int = RandomUtil.randomVisuals.int(0, 10);
          animation.reset();
          loadGraphic(Paths.image('destitution/itemShit/$noteNum'));
          setGraphicSize(105, 105);
          switch (noteData)
          {
            case 0:
              angle = -90;
            case 1:
              angle = 180;
            case 2:
              angle = 0;
            case 3:
              angle = 90;
          }
          updateHitbox();
      }

      noteType = value;
    }

    noteSplashHue = colorSwap.hue;
    noteSplashSat = colorSwap.saturation;
    noteSplashBrt = colorSwap.brightness;

    return value;
  }

  public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?inEditor:Bool = false)
  {
    super();

    if (prevNote == null)
    {
      prevNote = this;
    }

    this.prevNote = prevNote;
    isSustainNote = sustainNote;
    this.inEditor = inEditor;

    x += (ClientPrefs.middleScroll ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X) + 50;
    y -= 2000;

    this.strumTime = strumTime;

    if (!inEditor)
    {
      this.strumTime += ClientPrefs.noteOffset;
    }

    this.noteData = noteData;

    if (noteData > -1)
    {
      texture = '';
      colorSwap = new ColorSwap();
      shader = colorSwap.shader;

      x += swagWidth * (noteData);

      if (!isSustainNote && noteData > -1 && noteData < 4 && !itemNote)
      {
        var animToPlay:String = '';
        animToPlay = colArray[noteData % 4];
        animation.play(animToPlay + 'Scroll');
      }
    }

    if (prevNote != null)
    {
      prevNote.nextNote = this;
    }

    if (isSustainNote && prevNote != null)
    {
      alpha = 0.5;
      multAlpha = 0.5;

      hitsoundDisabled = true;

      if (ClientPrefs.downScroll)
      {
        flipY = true;
      }

      offsetX += width / 2;
      copyAngle = false;

      animation.play(colArray[noteData % 4] + 'holdend');

      updateHitbox();

      offsetX -= width / 2;

      if (prevNote.isSustainNote)
      {
        prevNote.animation.play(colArray[prevNote.noteData % 4] + 'hold');

        prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.05;

        if (PlayState.instance != null)
        {
          prevNote.scale.y *= PlayState.instance.songSpeed;
        }

        prevNote.updateHitbox();
      }
    }
    else if (!isSustainNote)
    {
      earlyHitMult = 1;
    }

    x += offsetX;
  }

  public var lastNoteOffsetXForPixelAutoAdjusting:Float = 0;
  public var lastNoteScaleToo:Float = 1;
  public var originalHeightForCalcs:Float = 6;

  public function reloadNote(?prefix:String = '', ?texture:String = '', ?suffix:String = '')
  {
    if (prefix == null)
    {
      prefix = '';
    }

    if (texture == null)
    {
      texture = '';
    }

    if (suffix == null)
    {
      suffix = '';
    }

    var skin:String = texture;

    if (texture.length < 1)
    {
      skin = PlayState.SONG.arrowSkin;

      if (skin == null || skin.length < 1)
      {
        skin = 'ui/notes';
      }
    }

    var animName:String = null;

    if (animation.curAnim != null)
    {
      animName = animation.curAnim.name;
    }

    var arraySkin:Array<String> = skin.split('/');
    arraySkin[arraySkin.length - 1] = prefix + arraySkin[arraySkin.length - 1] + suffix;

    var lastScaleY:Float = scale.y;
    var blahblah:String = arraySkin.join('/');

    frames = Paths.getSparrowAtlas(blahblah);
    loadNoteAnims();

    if (isSustainNote)
    {
      scale.y = lastScaleY;
    }

    updateHitbox();

    if (animName != null)
    {
      animation.play(animName, true);
    }

    #if DEVELOPERBUILD
    if (inEditor)
    {
      setGraphicSize(ChartingState.GRID_SIZE, ChartingState.GRID_SIZE);
      updateHitbox();
    }
    #end
  }

  public function loadNoteAnims()
  {
    if (itemNote)
    {
      updateHitbox();
      return;
    }

    animation.addByPrefix(colArray[noteData] + 'Scroll', colArray[noteData] + '0', 24);

    if (isSustainNote)
    {
      animation.addByPrefix(colArray[noteData] + 'holdend', colArray[noteData] + ' hold end', 24);
      animation.addByPrefix('purpleholdend', 'pruple end hold', 24);
      animation.addByPrefix(colArray[noteData] + 'hold', colArray[noteData] + ' hold piece', 24);
    }

    updateHitbox();
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    if (mustPress)
    {
      if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * lateHitMult)
        && strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * earlyHitMult))
      {
        canBeHit = true;
      }
      else
      {
        canBeHit = false;
      }

      if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
      {
        tooLate = true;
      }
    }
    else
    {
      canBeHit = false;

      if (strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * earlyHitMult))
      {
        if ((isSustainNote && prevNote.wasGoodHit) || strumTime <= Conductor.songPosition)
        {
          wasGoodHit = true;
        }
      }
    }

    if (tooLate && !inEditor)
    {
      if (alpha > 0.3)
      {
        alpha = 0.3;
      }
    }
  }
}