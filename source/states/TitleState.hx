package states;

import flixel.tweens.FlxEase;
import util.RandomUtil;
import ui.TransitionScreenshotObject;
import visuals.PixelPerfectSprite;
import shaders.ColorSwap;
import backend.ClientPrefs;
import backend.Conductor;
import util.CoolUtil;
import flixel.text.FlxText;
import lime.app.Application;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if desktop
import backend.Discord.DiscordClient;
#end

class TitleState extends MusicBeatState
{
  public static var fullscreenKeys:Array<FlxKey> = [FlxKey.F11, FlxKey.F12];

  public static var initialized:Bool = false;

  public var transitioning:Bool = false;

  private var exitButton:PixelPerfectSprite;
  private var playButton:PixelPerfectSprite;

  private var man:PixelPerfectSprite;

  private var tppLogo:PixelPerfectSprite;

  private var swagShader:ColorSwap = null;

  private var closeSequenceStarted:Bool = false;

  private var quitDoingIntroShit:Bool = false;

  public static var closedState:Bool = false;

  override public function create():Void
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Total TitleState create()");
    #end

    persistentUpdate = true;
    persistentDraw = true;

    #if desktop
    DiscordClient.changePresence("On the Title Screen", null, null, '-menus');
    #end

    FlxG.mouse.visible = true;

    RandomUtil.rerollRandomness();

    if (FlxG.sound.music == null)
    {
      FlxG.sound.playMusic(Paths.music('mus_pauperized'));
      Conductor.changeBPM(110);
    }

    swagShader = new ColorSwap();

    var back:PixelPerfectSprite = new PixelPerfectSprite(0, 0).loadGraphic(Paths.image('title/back'));
    back.antialiasing = false;
    back.screenCenter();
    back.shader = swagShader.shader;
    add(back);

    var logo:PixelPerfectSprite = new PixelPerfectSprite(0, 0).loadGraphic(Paths.image('title/logo'));
    logo.antialiasing = false;
    logo.shader = swagShader.shader;
    add(logo);

    var overlay:PixelPerfectSprite = new PixelPerfectSprite(0, 0).loadGraphic(Paths.image('title/overlay'));
    overlay.antialiasing = false;
    overlay.screenCenter();
    overlay.shader = swagShader.shader;
    add(overlay);

    var shadow:PixelPerfectSprite = new PixelPerfectSprite(0, 0).loadGraphic(Paths.image('title/shadow'));
    shadow.antialiasing = false;
    shadow.screenCenter();
    shadow.shader = swagShader.shader;
    add(shadow);

    man = new PixelPerfectSprite(0, 0).loadGraphic(Paths.image('title/man'), true, 1280, 720);
    man.animation.add('idle', [0, 1], 8, true);
    man.animation.play('idle', true);
    man.screenCenter();
    man.antialiasing = false;
    man.shader = swagShader.shader;
    add(man);

    var tppWatermarkTittle:PixelPerfectSprite = new PixelPerfectSprite(8, 590).loadGraphic(Paths.image("title/tpp"));
    tppWatermarkTittle.setGraphicSize(256);
    tppWatermarkTittle.updateHitbox();
    tppWatermarkTittle.alpha = 0.5;
    add(tppWatermarkTittle);

    exitButton = new PixelPerfectSprite(8, 8).loadGraphic(Paths.image('title/close'));
    exitButton.scale.set(2, 2);
    exitButton.updateHitbox();
    add(exitButton);

    playButton = new PixelPerfectSprite(FlxG.width - 210, FlxG.height - 210).loadGraphic(Paths.image('title/play'));
    playButton.scale.set(2, 2);
    playButton.updateHitbox();
    add(playButton);

    var transThing = new TransitionScreenshotObject();
    add(transThing);
    transThing.fadeout();

    #if DEVELOPERBUILD
    var versionShit:FlxText = new FlxText(-4, FlxG.height - 24, FlxG.width,
      "(DEV BUILD!!! - " + CoolUtil.gitCommitBranch + " - " + CoolUtil.gitCommitHash + ")", 12);
    versionShit.scrollFactor.set();
    versionShit.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    versionShit.antialiasing = ClientPrefs.globalAntialiasing;
    add(versionShit);
    #end

    super.create();

    initialized = true;

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  override function update(elapsed:Float)
  {
    if (!closeSequenceStarted)
    {
      if (FlxG.sound.music != null)
      {
        Conductor.songPosition = FlxG.sound.music.time;
      }

      var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

      var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

      if (gamepad != null)
      {
        if (gamepad.justPressed.START)
        {
          pressedEnter = true;
        }
      }

      if (!transitioning)
      {
        if (FlxG.mouse.overlaps(exitButton, FlxG.camera) && !transitioning)
        {
          if (FlxG.mouse.justPressed)
          {
            gameCloseSequence();
          }
        }

        if (FlxG.mouse.overlaps(playButton, FlxG.camera) && !transitioning)
        {
          if (FlxG.mouse.justPressed)
          {
            pressedEnter = true;
          }
        }
      }

      if (initialized && !transitioning)
      {
        if (pressedEnter)
        {
          FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

          transitioning = true;

          FlxTween.tween(playButton, {'scale.x': 0.01, 'scale.y': 0.01}, 0.25,
            {
              ease: FlxEase.cubeInOut,
              onComplete: function fuckstween(t:FlxTween)
              {
                playButton.alpha = 0;
                playButton.visible = false;
                playButton.destroy();
              }
            });

          FlxTween.tween(exitButton, {'scale.x': 0.01, 'scale.y': 0.01}, 0.25,
            {
              ease: FlxEase.cubeInOut,
              onComplete: function fuckstween(t:FlxTween)
              {
                exitButton.alpha = 0;
                exitButton.visible = false;
                exitButton.destroy();
              }
            });

          new FlxTimer().start(1, function(tmr:FlxTimer) {
            FlxTransitionableState.skipNextTransIn = true;
            FlxTransitionableState.skipNextTransOut = true;

            MusicBeatState.switchState(new MainMenuState());

            closedState = true;
          });
        }
      }
    }

    if (swagShader != null)
    {
      if (controls.UI_LEFT && !controls.UI_RIGHT)
      {
        swagShader.hue -= elapsed * 0.1;
      }

      if (controls.UI_RIGHT && !controls.UI_LEFT)
      {
        swagShader.hue += elapsed * 0.1;
      }
    }

    super.update(elapsed);
  }

  public function gameCloseSequence()
  {
    closeSequenceStarted = true;

    FlxG.sound.music.stop();
    FlxG.sound.music = null;

    FlxG.camera.stopShake();

    FlxTween.tween(man, {alpha: 0}, 0.1);

    FlxTween.tween(playButton, {'scale.x': 0.01, 'scale.y': 0.01}, 0.25,
      {
        ease: FlxEase.cubeInOut,
        onComplete: function fuckstween(t:FlxTween)
        {
          playButton.alpha = 0;
          playButton.visible = false;
          playButton.destroy();
        }
      });

    FlxTween.tween(exitButton, {'scale.x': 0.01, 'scale.y': 0.01}, 0.25,
      {
        ease: FlxEase.cubeInOut,
        onComplete: function fuckstween(t:FlxTween)
        {
          exitButton.alpha = 0;
          exitButton.visible = false;
          exitButton.destroy();
        }
      });

    var timeyTheTimer:FlxTimer = new FlxTimer().start(2.5, function photoshopTimey(timeyX:FlxTimer)
    {
      Application.current.window.close();
    });
  }

  override function beatHit()
  {
    super.beatHit();

    if (!closeSequenceStarted)
    {
      FlxG.camera.shake(0.0001, Conductor.crochet / 1000);
    }
  }

  override public function onFocusLost():Void
  {
    if (FlxG.sound.music != null)
    {
      FlxG.sound.music.pause();
    }

    super.onFocusLost();
  }

  override public function onFocus():Void
  {
    if (FlxG.sound.music != null)
    {
      FlxG.sound.music.resume();
    }

    super.onFocus();
  }
}