package options;

import ui.Alphabet;
import ui.TransitionScreenshotObject;
import util.EaseUtil;
#if desktop
import backend.Discord.DiscordClient;
#end
import flixel.addons.transition.FlxTransitionableState;
import util.CoolUtil;
import backend.Conductor;
import backend.ClientPrefs;
import ui.MarkHeadTransition;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.ui.FlxBar;
import states.MusicBeatState;

class NoteOffsetState extends MusicBeatState
{
  public var camHUD:FlxCamera;
  public var camGame:FlxCamera;
  public var camOther:FlxCamera;

  var coolText:FlxText;
  var rating:FlxSprite;
  var comboNums:FlxSpriteGroup;
  var dumbTexts:FlxTypedGroup<FlxText>;

  var barPercent:Float = 0;
  var delayMin:Int = 0;
  var delayMax:Int = 500;
  var timeBarBG:FlxSprite;
  var timeBar:FlxBar;
  var timeTxt:FlxText;
  var beatText:Alphabet;
  var beatTween:FlxTween;

  override public function create()
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Total NoteOffsetState create()");
    #end

    CoolUtil.newStateMemStuff();

    #if desktop
    DiscordClient.changePresence("Timing Offset Menu", null, null, '-menus');
    #end

    camGame = new FlxCamera();
    camHUD = new FlxCamera();
    camOther = new FlxCamera();
    camHUD.bgColor.alpha = 0;
    camOther.bgColor.alpha = 0;

    FlxG.cameras.reset(camGame);
    FlxG.cameras.add(camHUD, false);
    FlxG.cameras.add(camOther, false);

    FlxG.cameras.setDefaultDrawTarget(camGame, true);
    MarkHeadTransition.nextCamera = camOther;

    persistentUpdate = true;
    FlxG.sound.pause();

    var bg:FlxSprite = new FlxSprite().makeGraphic(2200, 2200, FlxColor.GRAY);
    bg.screenCenter();
    bg.scrollFactor.set();
    add(bg);

    beatText = new Alphabet(0, 0, 'Beat Hit!', true, true);
    beatText.x += 260;
    beatText.screenCenter();
    beatText.y = 320;
    beatText.alpha = 0;
    beatText.acceleration.y = 250;
    add(beatText);

    timeTxt = new FlxText(0, 600, FlxG.width, "", 32);
    timeTxt.setFormat(Paths.font("serife-converted.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    timeTxt.scrollFactor.set();
    timeTxt.borderSize = 2;
    timeTxt.cameras = [camHUD];

    barPercent = ClientPrefs.noteOffset;
    updateNoteDelay();

    timeBarBG = new FlxSprite(0, timeTxt.y + 8).loadGraphic(Paths.image('options/timingbar'));
    timeBarBG.setGraphicSize(Std.int(timeBarBG.width * 1.2));
    timeBarBG.updateHitbox();
    timeBarBG.cameras = [camHUD];
    timeBarBG.screenCenter(X);

    timeBar = new FlxBar(0, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this, 'barPercent', delayMin,
      delayMax);
    timeBar.scrollFactor.set();
    timeBar.screenCenter(X);
    timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
    timeBar.numDivisions = 392;
    timeBar.cameras = [camHUD];

    add(timeBarBG);
    add(timeBar);
    add(timeTxt);

    var transThing = new TransitionScreenshotObject();
    transThing.scrollFactor.set();
    add(transThing);
    transThing.fadeout();

    Conductor.changeBPM(128.0);
    FlxG.sound.playMusic(Paths.music('mus_neutral_drive'), 1, true);

    super.create();

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  var holdTime:Float = 0;

  override public function update(elapsed:Float)
  {
    var addNum:Int = 1;

    if (FlxG.keys.pressed.SHIFT)
    {
      addNum = 10;
    }

    if (FlxG.keys.justPressed.SPACE)
    {
      
    }

    if (controls.UI_LEFT_P)
    {
      barPercent = Math.max(delayMin, Math.min(ClientPrefs.noteOffset - 1, delayMax));
      updateNoteDelay();
    }
    else if (controls.UI_RIGHT_P)
    {
      barPercent = Math.max(delayMin, Math.min(ClientPrefs.noteOffset + 1, delayMax));
      updateNoteDelay();
    }

    var mult:Int = 1;
    if (controls.UI_LEFT || controls.UI_RIGHT)
    {
      holdTime += elapsed;
      if (controls.UI_LEFT)
      {
        mult = -1;
      }
    }

    if (controls.UI_LEFT_R || controls.UI_RIGHT_R) holdTime = 0;

    if (holdTime > 0.5)
    {
      barPercent += 100 * elapsed * mult;
      barPercent = Math.max(delayMin, Math.min(barPercent, delayMax));
      updateNoteDelay();
    }

    if (controls.RESET)
    {
      barPercent = 0;
      updateNoteDelay();
    }

    if (controls.BACK)
    {
      if (zoomTween != null)
      {
        zoomTween.cancel();
      }

      if (beatTween != null)
      {
        beatTween.cancel();
      }

      persistentUpdate = false;
      MarkHeadTransition.nextCamera = camOther;
      FlxTransitionableState.skipNextTransIn = false;
      FlxTransitionableState.skipNextTransOut = false;
      MusicBeatState.switchState(new OptionsState());
      FlxG.sound.playMusic(Paths.music('mus_machinations'), 1, true);
      FlxG.mouse.visible = false;
    }

    Conductor.songPosition = FlxG.sound.music.time;
    super.update(elapsed);
  }

  var zoomTween:FlxTween;
  var lastBeatHit:Int = -1;

  override public function beatHit()
  {
    super.beatHit();

    if (lastBeatHit == curBeat)
    {
      return;
    }

    if (curBeat % 4 == 2)
    {
      FlxG.camera.zoom = 1.15;

      if (zoomTween != null)
      {
        zoomTween.cancel();
      }

      zoomTween = FlxTween.tween(FlxG.camera, {zoom: 1}, 1,
        {
          ease: FlxEase.circOut,
          onComplete: function(twn:FlxTween) {
            zoomTween = null;
          }
        });

      beatText.alpha = 1;
      beatText.screenCenter();
      beatText.y = 320;
      beatText.velocity.y = -150;

      if (beatTween != null)
      {
        beatTween.cancel();
      }

      beatTween = FlxTween.tween(beatText, {alpha: 0}, 1,
        {
          ease: EaseUtil.stepped(4),
          onComplete: function(twn:FlxTween) {
            beatTween = null;
          }
        });
    }

    lastBeatHit = curBeat;
  }

  function updateNoteDelay()
  {
    ClientPrefs.noteOffset = Math.round(barPercent);
    timeTxt.text = 'Current offset: ' + Math.floor(barPercent) + ' ms';
  }
}