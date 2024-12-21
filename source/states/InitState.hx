package states;

import util.EaseUtil;
import flixel.system.scaleModes.BaseScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import flixel.math.FlxPoint;
import visuals.PixelPerfectSprite;
import ui.MarkHeadTransition;
import flixel.addons.transition.FlxTransitionableState;
import backend.TextAndLanguage;
import backend.Highscore;
import backend.ClientPrefs;
import lime.app.Application;
import backend.PlayerSettings;
import util.CoolUtil;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
#if desktop
import backend.Discord.DiscordClient;
#end

class InitState extends MusicBeatState
{
  public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO, FlxKey.NUMPADZERO];
  public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
  public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

  var initGraphic:PixelPerfectSprite;

  var windowTwn:FlxTween;

  var windowRes:FlxPoint;
  var windowPos:FlxPoint;
  var startTime:Float;

  override public function create():Void
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Total InitState create()");
    #end

    windowPos = CoolUtil.getCenterWindowPoint();
    FlxG.resizeWindow(800, 600);
    FlxG.resizeGame(800, 600);
    CoolUtil.centerWindowOnPoint(windowPos);

    persistentUpdate = true;
    persistentDraw = true;

    FlxG.sound.muteKeys = muteKeys;
    FlxG.sound.volumeDownKeys = volumeDownKeys;
    FlxG.sound.volumeUpKeys = volumeUpKeys;

    FlxG.keys.preventDefaultKeys = [TAB];

    PlayerSettings.init();

    #if desktop
    if (!DiscordClient.isInitialized)
    {
      DiscordClient.initialize();

      Application.current.window.onClose.add(function() {
        DiscordClient.shutdown();
      });
    }
    #end

    Application.current.window.title = CoolUtil.appTitleString;

    FlxG.mouse.visible = false;

    FlxG.mouse.load(Paths.image('cursor').bitmap, 2);

    FlxG.save.bind('destitution', CoolUtil.savePath);

    ClientPrefs.loadPrefs();

    Highscore.load();

    TextAndLanguage.setLang(ClientPrefs.language);

    if (FlxG.save.data != null && FlxG.save.data.fullscreen)
    {
      FlxG.fullscreen = FlxG.save.data.fullscreen;
    }

    CoolUtil.hasInitializedWindow = true;

    initGraphic = new PixelPerfectSprite().loadGraphic(Paths.image('init'));
    initGraphic.scale.set(2, 2);
    initGraphic.updateHitbox();
    initGraphic.screenCenter();
    add(initGraphic);

    super.create();

    FlxTransitionableState.skipNextTransIn = false;
    FlxTransitionableState.skipNextTransOut = false;

    MarkHeadTransition.nextCamera = FlxG.camera;

    if (FlxG.save.data.flashing == null && !FlashingState.leftState)
    {
      MusicBeatState.switchState(new FlashingState());
    }
    else
    {
      gotoTitle();
    }

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  public function gotoTitle()
  {
    FlxTween.tween(initGraphic, {alpha: 0}, 0.5, {startDelay: 1, ease: EaseUtil.stepped(4)});

    var waitTime = new FlxTimer().start(1.5, function goDoIt(flux:FlxTimer)
    {
      FlxG.updateFramerate = 30; // Makes it smoother and consistant

      windowRes = FlxPoint.get(Lib.application.window.width, Lib.application.window.height);
      windowPos = CoolUtil.getCenterWindowPoint();
      startTime = Sys.time();

      windowTwn = FlxTween.tween(windowRes, {x: 1280, y: 720}, 0.3 * 4,
        {
          ease: FlxEase.circInOut,
          onUpdate: (_) -> {
            FlxG.resizeWindow(Std.int(windowRes.x), Std.int(windowRes.y));
            CoolUtil.centerWindowOnPoint(windowPos);
            if ((Sys.time() - startTime) > 1.35)
            {
              windowTwn.cancel();
              completeWindowTwn();
            }
          },
          onComplete: function(twn:FlxTween) {
            completeWindowTwn();
          }
        });
    });
  }

  public function completeWindowTwn()
  {
    BaseScaleMode.ogSize = FlxPoint.get(1280, 720);
    FlxG.updateFramerate = ClientPrefs.framerate;
    FlxG.resizeWindow(1280, 720);
    FlxG.resizeGame(1280, 720);
    CoolUtil.centerWindowOnPoint(windowPos);

    FlxG.scaleMode = new RatioScaleMode();

    MusicBeatState.switchState(new TitleState());
  }
}