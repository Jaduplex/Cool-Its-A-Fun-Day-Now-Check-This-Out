package visuals;

import backend.Conductor;
import states.PlayState;
import backend.ClientPrefs;
import flixel.animation.FlxAnimationController;
import adobeanimate.FlxAtlasSprite;
import flixel.util.FlxSort;
import flixel.util.FlxDestroyUtil;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import openfl.utils.Assets;
import haxe.Json;
import flixel.util.FlxColor;

using StringTools;

typedef CharacterFile =
{
  var aaAtlas:Bool;

  var animations:Array<AnimArray>;
  var image:String;
  var scale:Float;
  var sing_duration:Float;
  var healthicon:String;

  var position:Array<Float>;
  var camera_position:Array<Float>;

  var flip_x:Bool;
  var no_antialiasing:Bool;
  var healthbar_colors:Array<Int>;

  var artist:String;
  var animator:String;
  var whoDoneWhat:String;

  var _editor_isPlayer:Bool;
}

typedef AnimArray =
{
  var anim:String;
  var name:String;
  var fps:Int;
  var loop:Bool;
  var hasTransition:Bool;
  var indices:Array<Int>;
  var offsets:Array<Int>;
}

class Character extends PixelPerfectSprite
{
  /**
   * In case a character is missing, it will use this on its place
  **/
  public static final DEFAULT_CHARACTER:String = 'bf';

  public var animOffsets:Map<String, Array<Dynamic>>;
  public var debugMode:Bool = false;
  public var extraData:Map<String, Dynamic> = new Map<String, Dynamic>();

  public var isPlayer:Bool = false;
  public var curCharacter:String = DEFAULT_CHARACTER;

  public var hasTransitionsMap:Map<String, Bool> = new Map<String, Bool>();

  public var colorTween:FlxTween;

  public var canDance:Bool = true;
  public var canSing:Bool = true;

  public var holdTimer:Float = 0;
  public var animationNotes:Array<Dynamic> = [];
  public var singDuration:Float = 4; // Multiplier of how long a character holds the sing pose
  public var idleSuffix:String = '';
  public var danceIdle:Bool = false; // Character use "danceLeft" and "danceRight" instead of "idle"
  public var skipDance:Bool = false;
  public var danceEveryNumBeats:Int = 2;
  public var danced:Bool = false;

  public var healthIcon:String = 'face';
  public var healthColorArray:Array<Int> = [255, 0, 0];

  public var animationsArray:Array<AnimArray> = [];

  public var positionArray:Array<Float> = [0, 0];
  public var cameraPosition:Array<Float> = [0, 0];
  public var curFunnyPosition:Array<Float> = [0, 0];

  public var hasMissAnimations:Bool = false;
  public var vocalsFile:String = '';

  // Used on Character Editor
  public var imageFile:String = '';
  public var jsonScale:Float = 1;
  public var noAntialiasing:Bool = false;
  public var originalFlipX:Bool = false;
  public var _editor_isPlayer:Null<Bool> = null;

  public var artist:String = "Unknown";
  public var animator:String = "Unknown";
  public var whoDoneWhat:String = "Unknown";

  public var isAnimateAtlas:Bool = false;
  public var atlas:FlxAtlasSprite;

  public var settingCharacterUp:Bool = true;

  public var animPaused(get, set):Bool;

  public function new(x:Float, y:Float, ?character:String = 'bf', ?isPlayer:Bool = false, ?doPositioning = true)
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Creating Character: " + character + ', ' + x + ', ' + y);
    #end

    super(x, y);

    animation = new FlxAnimationController(this);

    animOffsets = new Map<String, Array<Dynamic>>();
    curCharacter = character;
    this.isPlayer = isPlayer;

    pixelPerfect = false;

    var characterPath:String = 'characters/$curCharacter.json';

    var path:String = Paths.getPath(characterPath, TEXT, null);
    #if MODS_ALLOWED
    if (!FileSystem.exists(path))
    #else
    if (!Assets.exists(path))
    #end
    {
      path = Paths.getPath('characters/' + DEFAULT_CHARACTER + '.json', TEXT); // If a character couldn't be found, change him to BF just to prevent a crash
      color = FlxColor.BLACK;
      alpha = 0.6;
    }

    try
    {
      #if MODS_ALLOWED
      loadCharacterFile(Json.parse(File.getContent(path)));
      #else
      loadCharacterFile(Json.parse(Assets.getText(path)));
      #end
    }
    catch (e:Dynamic)
    {
      #if DEVELOPERBUILD
      trace('Error loading character file of "$character": $e');
      #end
    }

    if (animOffsets.exists('singLEFTmiss') || animOffsets.exists('singDOWNmiss') || animOffsets.exists('singUPmiss') || animOffsets.exists('singRIGHTmiss'))
    {
      hasMissAnimations = true;
    }

    recalculateDanceIdle();
    dance();

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  public function loadCharacterFile(json:Dynamic)
  {
    isAnimateAtlas = false;

    if (json.aaAtlas)
    {
      isAnimateAtlas = true;

      var animLibrary:String = Paths.getLibrary('rhythm:' + json.image);
      var animPath:String = Paths.stripLibrary('rhythm:' + json.image);
      var assetPath:String = Paths.animateAtlas(animPath, animLibrary);

      try
      {
        atlas = new FlxAtlasSprite(0, 0, assetPath);
        atlas.showPivot = false;
      }
      catch (e:Dynamic)
      {
        throw 'Could not load atlas ${assetPath}: $e';
      }
    }

    scale.set(1, 1);
    updateHitbox();

    if (!isAnimateAtlas)
    {
      frames = Paths.getMultiAtlas(json.image.split(','));
    }

    imageFile = json.image;
    jsonScale = json.scale;

    if (json.scale != 1)
    {
      scale.set(jsonScale, jsonScale);
      updateHitbox();
    }

    positionArray = json.position;
    cameraPosition = json.camera_position;

    healthIcon = json.healthicon;
    singDuration = json.sing_duration;
    flipX = (json.flip_x != isPlayer);
    healthColorArray = (json.healthbar_colors != null && json.healthbar_colors.length > 2) ? json.healthbar_colors : [161, 161, 161];
    vocalsFile = json.vocals_file != null ? json.vocals_file : '';
    originalFlipX = (json.flip_x == true);
    _editor_isPlayer = json._editor_isPlayer;
    artist = json.artist;
    animator = json.animator;
    whoDoneWhat = json.whoDoneWhat;

    noAntialiasing = (json.no_antialiasing == true);
    antialiasing = ClientPrefs.globalAntialiasing ? !noAntialiasing : false;
    pixelPerfect = noAntialiasing;

    animationsArray = json.animations;

    if (animationsArray != null && animationsArray.length > 0)
    {
      for (anim in animationsArray)
      {
        var animAnim:String = '' + anim.anim;
        var animName:String = '' + anim.name;
        var animFps:Int = anim.fps;
        var animLoop:Bool = !!anim.loop;
        var hasTransition = anim.hasTransition;
        var animIndices:Array<Int> = anim.indices;

        hasTransitionsMap.set(animAnim, hasTransition);

        if (!isAnimateAtlas)
        {
          if (animIndices != null && animIndices.length > 0)
          {
            animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
          }
          else
          {
            animation.addByPrefix(animAnim, animName, animFps, animLoop);
          }
        }
        else
        {
          if (animIndices != null && animIndices.length > 0)
          {
            atlas.anim.addBySymbolIndices(animAnim, animName, animIndices, animFps, animLoop);
          }
          else
          {
            atlas.anim.addBySymbol(animAnim, animName, animFps, animLoop);
          }
        }

        if (anim.offsets != null && anim.offsets.length > 1)
        {
          addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
        }
        else
        {
          addOffset(anim.anim, 0, 0);
        }
      }
    }

    if (isAnimateAtlas)
    {
      copyAtlasValues();
    }
  }

  override function update(elapsed:Float)
  {
    if (isAnimateAtlas && atlas == null)
    {
      return;
    }

    if (isAnimateAtlas && atlas != null)
    {
      atlas.update(elapsed);
    }

    if (debugMode || (!isAnimateAtlas && animation.curAnim == null) || (isAnimateAtlas && atlas.anim.curSymbol == null))
    {
      super.update(elapsed);

      return;
    }

    // ANIMATION TRANSITION HANDLING
    if (!debugMode)
    {
      if (animation.curAnim != null)
      {
        if (hasTransitionsMap.get(animation.curAnim.name))
        {
          if (animation.curAnim.finished)
          {
            if (animOffsets.exists('idle-alt') || animOffsets.exists('danceLeft-alt') || animOffsets.exists('danceRight-alt'))
            {
              if (PlayState.instance != null)
              {
                dance(PlayState.SONG.notes[PlayState.instance.curSection].altAnim);
              }
            }
            else if (PlayState.instance != null)
            {
              if (PlayState.instance.curSong.toLowerCase().startsWith('superseded'))
              {
                dance(false, PlayState.SONG.notes[PlayState.instance.curSection].mustHitSection);
              }
              else
              {
                dance();
              }
            }
            else
            {
              dance();
            }

            holdTimer = 0;

            if (!animation.curAnim.looped)
            {
              finishAnimation();
            }
          }
        }
      }
    }

    if (getAnimationName().startsWith('sing'))
    {
      holdTimer += elapsed;
    }
    else if (isPlayer)
    {
      holdTimer = 0;
    }

    if (!isPlayer
      && holdTimer >= Conductor.stepCrochet * (0.0011 #if FLX_PITCH / (FlxG.sound.music != null ? FlxG.sound.music.pitch : 1) #end) * singDuration)
    {
      if (animOffsets.exists('idle-alt') || animOffsets.exists('danceLeft-alt') || animOffsets.exists('danceRight-alt'))
      {
        dance(PlayState.SONG.notes[PlayState.instance.curSection].altAnim);
      }
      else if (PlayState.instance != null)
      {
        if (PlayState.instance.curSong.toLowerCase().startsWith('superseded'))
        {
          dance(false, PlayState.SONG.notes[PlayState.instance.curSection].mustHitSection);
        }
        else
        {
          dance();
        }
      }
      else
      {
        dance();
      }

      holdTimer = 0;
    }

    var name:String = getAnimationName();

    if (isAnimationFinished() && animOffsets.exists('$name-loop'))
    {
      playAnim('$name-loop');
    }

    super.update(elapsed);
  }

  inline public function isAnimationNull():Bool
  {
    if (isAnimateAtlas && atlas == null)
    {
      return true;
    }

    return !isAnimateAtlas ? (animation.curAnim == null) : (atlas.anim.curSymbol == null);
  }

  inline public function getAnimationName():String
  {
    if (isAnimateAtlas && atlas == null)
    {
      return '';
    }

    var name:String = '';
    @:privateAccess
    if (!isAnimationNull())
    {
      name = !isAnimateAtlas ? animation.curAnim.name : atlas.animation.curAnim.name;
    }

    return (name != null) ? name : '';
  }

  public function isAnimationFinished():Bool
  {
    if (isAnimateAtlas && atlas == null)
    {
      return false;
    }

    if (isAnimationNull())
    {
      return false;
    }

    return !isAnimateAtlas ? animation.curAnim.finished : atlas.anim.finished;
  }

  public function finishAnimation():Void
  {
    if (isAnimateAtlas && atlas == null)
    {
      return;
    }

    if (isAnimationNull())
    {
      return;
    }

    if (!isAnimateAtlas)
    {
      animation.curAnim.finish();
    }
    else
    {
      atlas.anim.curFrame = atlas.anim.length - 1;
    }
  }

  public function get_animPaused():Bool
  {
    if (isAnimateAtlas && atlas == null)
    {
      return false;
    }

    if (isAnimationNull())
    {
      return false;
    }

    return !isAnimateAtlas ? animation.curAnim.paused : atlas.anim.isPlaying;
  }

  public function set_animPaused(value:Bool):Bool
  {
    if (isAnimateAtlas && atlas == null)
    {
      return false;
    }

    if (isAnimationNull())
    {
      return value;
    }

    if (!isAnimateAtlas)
    {
      animation.curAnim.paused = value;
    }
    else
    {
      if (value)
      {
        atlas.anim.pause();
      }
      else
      {
        atlas.animation.resume();
      }
    }

    return value;
  }

  public function dance(alt:Bool = false, mustHitSection = false)
  {
    var altStr:String = "";

    if (alt)
    {
      altStr = "-alt";
    }

    if (mustHitSection && (animOffsets.exists('idle-mh') || animOffsets.exists('danceLeft-mh') || animOffsets.exists('danceRight-mh')))
    {
      altStr = '-mh';
    }

    if (!debugMode && !skipDance && canDance)
    {
      if (danceIdle)
      {
        danced = !danced;

        if (danced)
        {
          playAnim('danceRight' + idleSuffix + altStr, true);
        }
        else
        {
          playAnim('danceLeft' + idleSuffix + altStr, true);
        }
      }
      else if (animation.getByName('idle' + idleSuffix + altStr) != null)
      {
        if (animation.curAnim != null)
        {
          if (!animation.getByName('idle' + idleSuffix + altStr).looped || animation.curAnim.name != "idle" + idleSuffix + altStr)
          {
            playAnim('idle' + idleSuffix + altStr, true);
          }
        }
        else
        {
          playAnim('idle' + idleSuffix + altStr, true);
        }
      }
    }
  }

  public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
  {
    if (AnimName.toLowerCase().startsWith('sing') && !canSing)
    {
      return;
    }

    if (AnimName.startsWith("sing"))
    {
      if (AnimName.startsWith("singLEFT"))
      {
        if (curCharacter == "rulez")
        {
          curFunnyPosition = [-64, 0];
        }
        else
        {
          curFunnyPosition = [-8, 0];
        }
      }
      else if (AnimName.startsWith("singDOWN"))
      {
        if (curCharacter == "rulez")
        {
          curFunnyPosition = [0, 136];
        }
        else
        {
          curFunnyPosition = [0, 8];
        }
      }
      else if (AnimName.startsWith("singUP"))
      {
        if (curCharacter == "rulez")
        {
          curFunnyPosition = [0, -48];
        }
        else
        {
          curFunnyPosition = [0, -8];
        }
      }
      else if (AnimName.startsWith("singRIGHT"))
      {
        if (curCharacter == "rulez")
        {
          curFunnyPosition = [48, 0];
        }
        else
        {
          curFunnyPosition = [8, 0];
        }
      }
      else
      {
        curFunnyPosition = [0, 0];
      }
    }
    else
    {
      curFunnyPosition = [0, 0];
    }

    if (!isAnimateAtlas)
    {
      animation.play(AnimName, Force, Reversed, Frame);
    }
    else if (atlas != null)
    {
      atlas.playAnimation(AnimName, Force, false, false);
    }

    if (animOffsets.exists(AnimName))
    {
      var daOffset = animOffsets.get(AnimName);
      offset.set(daOffset[0], daOffset[1]);
    }

    if (curCharacter.startsWith('gf-') || curCharacter == 'gf')
    {
      if (AnimName == 'singLEFT')
      {
        danced = true;
      }
      else if (AnimName == 'singRIGHT')
      {
        danced = false;
      }

      if (AnimName == 'singUP' || AnimName == 'singDOWN')
      {
        danced = !danced;
      }
    }
  }

  public function sortAnims(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int
  {
    return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0], Obj2[0]);
  }

  public function recalculateDanceIdle()
  {
    var lastDanceIdle:Bool = danceIdle;

    danceIdle = (animOffsets.exists('danceLeft' + idleSuffix) && animOffsets.exists('danceRight' + idleSuffix));

    if (settingCharacterUp)
    {
      danceEveryNumBeats = (danceIdle ? 1 : 2);
    }
    else if (lastDanceIdle != danceIdle)
    {
      var calc:Float = danceEveryNumBeats;

      if (danceIdle)
      {
        calc /= 2;
      }
      else
      {
        calc *= 2;
      }

      danceEveryNumBeats = Math.round(Math.max(calc, 1));
    }

    settingCharacterUp = false;
  }

  public function addOffset(name:String, x:Float = 0, y:Float = 0)
  {
    animOffsets[name] = [x, y];
  }

  public function quickAnimAdd(name:String, anim:String)
  {
    if (isAnimateAtlas)
    {
      return;
    }

    animation.addByPrefix(name, anim, 24, false);
  }

  public override function draw()
  {
    if (isAnimateAtlas && atlas != null)
    {
      copyAtlasValues();
      atlas.draw();
      return;
    }

    super.draw();
  }

  public function copyAtlasValues()
  {
    @:privateAccess
    {
      if (atlas != null)
      {
        if (cameras != null)
        {
          atlas.cameras = cameras;
        }
        atlas.scrollFactor = scrollFactor;
        atlas.scale = scale;
        atlas.offset = offset;
        atlas.origin = origin;
        atlas.x = x;
        atlas.y = y;
        atlas.angle = angle;
        atlas.alpha = alpha;
        atlas.visible = visible;
        atlas.flipX = flipX;
        atlas.flipY = flipY;
        atlas.shader = shader;
        atlas.antialiasing = antialiasing;
        atlas.colorTransform = colorTransform;
        atlas.color = color;
      }
    }
  }

  public override function destroy()
  {
    destroyAtlas();
    super.destroy();
  }

  public function destroyAtlas()
  {
    if (atlas != null)
    {
      atlas = FlxDestroyUtil.destroy(atlas);
    }
  }
}