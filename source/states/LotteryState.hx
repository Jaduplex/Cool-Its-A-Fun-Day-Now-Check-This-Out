package states;

import ui.MarkHeadTransition;
import flixel.FlxCamera;
import ui.BoinerCounter;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.addons.transition.FlxTransitionableState;
import openfl.display.BlendMode;
import backend.ClientPrefs;
import util.RandomUtil;
import backend.Conductor;
import flixel.FlxG;
import visuals.PixelPerfectSprite;
import util.CoolUtil;
import visuals.Character;
#if desktop
import backend.Discord.DiscordClient;
#end

class LotteryState extends MusicBeatState
{
  public var bg:PixelPerfectSprite;
  public var mark:Character;
  public var machinelights:PixelPerfectSprite;
  public var subFlicker:PixelPerfectSprite;
  public var counter:BoinerCounter;

  public var camOther:FlxCamera;
  public var camHUD:FlxCamera;
  public var camGame:FlxCamera;

  public var funnyColorsArray:Array<FlxColor> = [
    FlxColor.BLUE,
    FlxColor.CYAN,
    FlxColor.GREEN,
    FlxColor.LIME,
    FlxColor.MAGENTA,
    FlxColor.ORANGE,
    FlxColor.PINK,
    FlxColor.PURPLE,
    FlxColor.RED,
    FlxColor.YELLOW
  ];

  public var busy:Bool = false;

  override function create()
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Total LotteryState create()");
    #end

    persistentUpdate = true;
    persistentDraw = true;

    CoolUtil.newStateMemStuff();

    #if desktop
    DiscordClient.changePresence("At the Lottery", null, null, '-menus');
    #end

    if (FlxG.sound.music != null)
    {
      FlxG.sound.music.stop();
      FlxG.sound.music = null;
    }

    FlxG.sound.playMusic(Paths.music('mus_gambling'));
    Conductor.changeBPM(150);

    camGame = new FlxCamera();
    camHUD = new FlxCamera();
    camHUD.bgColor.alpha = 0;
    camOther = new FlxCamera();
    camOther.bgColor.alpha = 0;

    FlxG.cameras.reset(camGame);
    FlxG.cameras.add(camHUD, false);
    FlxG.cameras.add(camOther, false);

    FlxG.cameras.setDefaultDrawTarget(camGame, true);

    MarkHeadTransition.nextCamera = camOther;

    bg = new PixelPerfectSprite().loadGraphic(Paths.image('gamble/bg'));
    bg.scale.set(2, 2);
    bg.updateHitbox();
    bg.screenCenter();
    bg.scrollFactor.set();
    bg.antialiasing = false;
    add(bg);

    mark = new Character(-18, 192, 'gambling-mark', false, false);
    add(mark);
    mark.playAnim('intro', true);

    machinelights = new PixelPerfectSprite().loadGraphic(Paths.image('gamble/machinelights'));
    machinelights.updateHitbox();
    machinelights.screenCenter();
    machinelights.antialiasing = ClientPrefs.globalAntialiasing;
    machinelights.color = FlxColor.GREEN;
    machinelights.blend = BlendMode.ADD;
    add(machinelights);

    subFlicker = new PixelPerfectSprite().loadGraphic(Paths.image('gamble/subtractive_green_flicker'));
    subFlicker.updateHitbox();
    subFlicker.screenCenter();
    subFlicker.antialiasing = ClientPrefs.globalAntialiasing;
    subFlicker.blend = BlendMode.SUBTRACT;
    add(subFlicker);

    if (ClientPrefs.flashing)
    {
      subFlicker.visible = false;
    }

    // hud time here

    counter = new BoinerCounter(0, 0);
    counter.cameras = [camHUD];
    add(counter);

    #if DEVELOPERBUILD
    perf.print();
    #end

    super.create();
  }

  override function update(elapsed:Float)
  {
    if (FlxG.sound.music != null)
    {
      Conductor.songPosition = FlxG.sound.music.time;
    }

    if (machinelights.alpha > 0)
    {
      machinelights.alpha -= elapsed;
    }

    if (!ClientPrefs.flashing)
    {
      subFlicker.alpha -= elapsed;
    }

    super.update(elapsed);

    if (controls.BACK && !busy)
    {
      busy = true;
      // to flush the boiners to the save file because they werent before
      ClientPrefs.saveSettings();
      FlxG.sound.music.stop();
      FlxG.sound.music = null;
      FlxG.sound.play(Paths.sound('cancelMenu'));
      FlxTransitionableState.skipNextTransIn = false;
      FlxTransitionableState.skipNextTransOut = false;
      MusicBeatState.switchState(new MainMenuState());
    }
  }

  override function beatHit()
  {
    super.beatHit();

    if (curBeat % 4 == 0)
    {
      curSection++;
      sectionHit();
    }

    if (curBeat % 2 == 0 && !mark.hasTransitionsMap.get(mark.animation.curAnim.name))
    {
      mark.dance();
    }
  }

  override function sectionHit()
  {
    if (curSection % 2 == 0)
    {
      if (ClientPrefs.flashing)
      {
        FlxFlicker.flicker(subFlicker, 0.5, 0.1, false, true);
      }
      else
      {
        subFlicker.visible = true;
        subFlicker.alpha = 1;
      }
    }

    machinelights.color = funnyColorsArray[RandomUtil.randomVisuals.int(0, funnyColorsArray.length - 1)];
    machinelights.alpha = 1;

    super.sectionHit();
  }
}