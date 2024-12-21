package states;

import util.RandomUtil;
import ui.TransitionScreenshotObject;
import util.EaseUtil;
import visuals.PixelPerfectSprite;
import shaders.ColorSwap;
import backend.ClientPrefs;
import ui.Alphabet;
import backend.Conductor;
import util.CoolUtil;
import flixel.text.FlxText;
import lime.app.Application;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;
#if desktop
import backend.Discord.DiscordClient;
#end

class TitleState extends MusicBeatState
{
  public static var fullscreenKeys:Array<FlxKey> = [FlxKey.F11, FlxKey.F12];

  public static var initialized:Bool = false;

  public var transitioning:Bool = false;

  private var screenCover:PixelPerfectSprite;

  private var credGroup:FlxGroup;
  private var credTextShit:Alphabet;
  private var textGroup:FlxTypedGroup<Alphabet>;

  private var exitButton:PixelPerfectSprite;
  private var playButton:PixelPerfectSprite;

  private var charec:String = 'mark';

  private var curWacky:Array<String> = [];

  private var tppLogo:PixelPerfectSprite;

  private var skippedIntro:Bool = false;

  private var logo:PixelPerfectSprite;

  private var titleCharacter:PixelPerfectSprite;

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

    curWacky = RandomUtil.randomLogic.getObject(getIntroTextShit());

    var bg:FlxSprite = new FlxSprite();
    bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    add(bg);

    if (FlxG.sound.music == null)
    {
      FlxG.sound.playMusic(Paths.music('mus_pauperized'));
      Conductor.changeBPM(110);
    }

    swagShader = new ColorSwap();

    charec = getTitleCharacter();

    titleCharacter = new PixelPerfectSprite(0, 0).loadGraphic(Paths.image('title/char/$charec'), true, 320, 360);
    titleCharacter.animation.add(charec, [0, 1], 0, false);
    titleCharacter.animation.play(charec, true);
    titleCharacter.antialiasing = false;
    titleCharacter.scale.set(2, 2);
    titleCharacter.updateHitbox();
    titleCharacter.shader = swagShader.shader;
    add(titleCharacter);

    var objects:PixelPerfectSprite = new PixelPerfectSprite(640, 0).loadGraphic(Paths.image('title/obj'));
    objects.antialiasing = false;
    objects.scale.set(2, 2);
    objects.updateHitbox();
    objects.shader = swagShader.shader;
    add(objects);

    logo = new PixelPerfectSprite(490, 0);
    logo.frames = Paths.getSparrowAtlas('title/logo');
    logo.antialiasing = false;
    logo.animation.addByPrefix('bump', 'idle', 24, false);
    logo.animation.play('bump');
    add(logo);

    var tppWatermarkTittle:PixelPerfectSprite = new PixelPerfectSprite(8, 590).loadGraphic(Paths.image("title/tpp"));
    tppWatermarkTittle.setGraphicSize(256);
    tppWatermarkTittle.updateHitbox();
    add(tppWatermarkTittle);

    exitButton = new PixelPerfectSprite(8, 8).loadGraphic(Paths.image('title/close'));
    exitButton.scale.set(2, 2);
    exitButton.updateHitbox();
    add(exitButton);

    playButton = new PixelPerfectSprite(FlxG.width - 210, FlxG.height - 210).loadGraphic(Paths.image('title/play'));
    playButton.scale.set(2, 2);
    playButton.updateHitbox();
    add(playButton);

    credGroup = new FlxGroup();
    add(credGroup);

    textGroup = new FlxTypedGroup<Alphabet>();

    screenCover = new PixelPerfectSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    credGroup.add(screenCover);

    credTextShit = new Alphabet(0, 20, "", true);
    credTextShit.screenCenter();
    credTextShit.visible = false;

    tppLogo = new PixelPerfectSprite().loadGraphic(Paths.image("title/tpp"));
    tppLogo.screenCenter();
    tppLogo.y = 70;
    tppLogo.antialiasing = false;
    tppLogo.visible = false;
    add(tppLogo);

    var transThing = new TransitionScreenshotObject();
    add(transThing);
    transThing.fadeout();

    #if DEVELOPERBUILD
    var versionShit:FlxText = new FlxText(-4, FlxG.height - 24, FlxG.width,
      "(DEV BUILD!!! - " + CoolUtil.gitCommitBranch + " - " + CoolUtil.gitCommitHash + ")", 12);
    versionShit.scrollFactor.set();
    versionShit.setFormat(Paths.font("BAUHS93.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    versionShit.antialiasing = ClientPrefs.globalAntialiasing;
    add(versionShit);
    #end

    super.create();

    if (initialized)
    {
      skipIntro(true);
    }
    else
    {
      initialized = true;
    }

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  public function getIntroTextShit():Array<Array<String>>
  {
    var fullText:String = Assets.getText(Paths.txt('introText'));

    var firstArray:Array<String> = fullText.split('\n');
    var swagGoodArray:Array<Array<String>> = [];

    for (i in firstArray)
    {
      swagGoodArray.push(i.split('--'));
    }

    return swagGoodArray;
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
        if (skippedIntro && FlxG.mouse.overlaps(exitButton, FlxG.camera) && !transitioning)
        {
          if (FlxG.mouse.justPressed)
          {
            gameCloseSequence();
          }
        }

        if (skippedIntro && FlxG.mouse.overlaps(playButton, FlxG.camera) && !transitioning)
        {
          if (FlxG.mouse.justPressed)
          {
            pressedEnter = true;
          }
        }
      }

      if (initialized && !transitioning && skippedIntro)
      {
        if (pressedEnter)
        {
          FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

          transitioning = true;

          FlxTween.tween(playButton, {'scale.x': 0.01, 'scale.y': 0.01}, 0.25,
            {
              ease: EaseUtil.stepped(4),
              onComplete: function fuckstween(t:FlxTween)
              {
                playButton.alpha = 0;
                playButton.visible = false;
                playButton.destroy();
              }
            });

          FlxTween.tween(exitButton, {'scale.x': 0.01, 'scale.y': 0.01}, 0.25,
            {
              ease: EaseUtil.stepped(4),
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

      if (initialized && pressedEnter && !skippedIntro)
      {
        skipIntro();
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

    titleCharacter.animation.curAnim.curFrame = 0;

    FlxG.sound.music.stop();
    FlxG.sound.music = null;

    FlxG.sound.play(Paths.sound('titleExit/$charec'), 1, false);

    FlxTween.tween(playButton, {'scale.x': 0.01, 'scale.y': 0.01}, 0.25,
      {
        ease: EaseUtil.stepped(4),
        onComplete: function fuckstween(t:FlxTween)
        {
          playButton.alpha = 0;
          playButton.visible = false;
          playButton.destroy();
        }
      });

    FlxTween.tween(exitButton, {'scale.x': 0.01, 'scale.y': 0.01}, 0.25,
      {
        ease: EaseUtil.stepped(4),
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

  public function createCoolText(textArray:Array<String>, ?offset:Float = 0)
  {
    for (i in 0...textArray.length)
    {
      var money:Alphabet = new Alphabet(0, 0, textArray[i], true);

      money.screenCenter(X);
      money.y += (i * 70) + 200 + offset;
      money.ID = textGroup.length;

      money.alpha = 0;

      FlxTween.tween(money, {alpha: 1}, 0.1, {ease: EaseUtil.stepped(4)});

      if (credGroup != null && textGroup != null)
      {
        credGroup.add(money);
        textGroup.add(money);
      }
    }
  }

  public function addMoreText(text:String, ?offset:Float = 0)
  {
    if (textGroup != null && credGroup != null)
    {
      var coolText:Alphabet = new Alphabet(0, 0, text, true);

      coolText.screenCenter(X);
      coolText.y += (textGroup.length * 70) + 200 + offset;
      coolText.ID = textGroup.length;

      coolText.alpha = 0;

      FlxTween.tween(coolText, {alpha: 1}, 0.1, {ease: EaseUtil.stepped(4)});

      credGroup.add(coolText);
      textGroup.add(coolText);
    }
  }

  public function deleteCoolText()
  {
    while (textGroup.members.length > 0)
    {
      var thist = textGroup.members[0];
      FlxTween.completeTweensOf(thist);
      credGroup.remove(thist, true);
      textGroup.remove(thist, true);
      thist.destroy();
    }
  }

  override function beatHit()
  {
    super.beatHit();

    if (logo != null)
    {
      logo.animation.play('bump', true);
    }

    if (titleCharacter != null)
    {
      if (titleCharacter.animation.curAnim != null)
      {
        if (titleCharacter.animation.curAnim.curFrame == 0)
        {
          titleCharacter.animation.curAnim.curFrame = 1;
        }
        else
        {
          titleCharacter.animation.curAnim.curFrame = 0;
        }
      }
    }

    if (!closedState && !quitDoingIntroShit)
    {
      switch (curBeat)
      {
        case 2:
          tppLogo.visible = true;
        case 3:
          createCoolText(['...present'], tppLogo.height);
        case 4:
          tppLogo.visible = false;
          deleteCoolText();
          createCoolText([curWacky[0]]);
        case 6:
          addMoreText(curWacky[1]);
        case 7:
          deleteCoolText();
        case 8:
          addMoreText('The');
        case 10:
          addMoreText('Destitution');
        case 12:
          addMoreText('Mod');
        case 15:
          skipIntro();
      }
    }
  }

  function skipIntro(skipFade:Bool = false):Void
  {
    CoolUtil.hasInitializedWindow = true;

    if (!skippedIntro)
    {
      quitDoingIntroShit = true;

      remove(tppLogo);

      if (skipFade)
      {
        remove(credGroup);
      }
      else
      {
        for (cool in textGroup)
        {
          FlxTween.tween(cool, {alpha: 0}, Conductor.crochet / 1000, {ease: EaseUtil.stepped(4)});
        }

        FlxTween.tween(screenCover, {alpha: 0}, Conductor.crochet / 1000,
          {
            ease: EaseUtil.stepped(4),
            onComplete: function die(fuuuck:FlxTween)
            {
              remove(credGroup);
            }
          });
      }

      skippedIntro = true;
    }
  }

  /**
   * seperate function for cleanliness
   * @return the character name
   */
  function getTitleCharacter():String
  {
    var arrey:Array<String> = ['bf', 'crypteh', 'ili', 'karm', 'mark', 'ploinky', 'rulez', 'whale'];
    var char:String = 'mark';

    // the rare chance characters
    if (RandomUtil.randomSecrets.bool(5))
    {
      arrey = ['blocken', 'plant'];
    }

    if (getHolidayCharacter() != null)
    {
      arrey = [getHolidayCharacter()];
    }

    char = arrey[RandomUtil.randomVisuals.int(0, arrey.length - 1)];

    if (Paths.image('title/char/$char', null, true) == null)
    {
      char = 'mark';
    }

    #if SHOWCASEVIDEO
    // force set to mark for showcase video, cuz i want it to be as non random as possible.
    char = 'mark';
    #end

    return char;
  }

  function getHolidayCharacter():String
  {
    var dayLol = Date.now();

    if (dayLol.getMonth() == 11 && (dayLol.getDate() == 24 || dayLol.getDate() == 25))
    {
      return 'christmas';
    }

    if ((dayLol.getMonth() == 0 && dayLol.getDate() == 31) || (dayLol.getMonth() == 0 && dayLol.getDate() == 1))
    {
      return 'newyear';
    }

    if ((dayLol.getMonth() == 2 && dayLol.getDate() == 17))
    {
      return 'patricks';
    }

    if ((dayLol.getMonth() == 1 && dayLol.getDate() == 14))
    {
      return 'valentines';
    }

    if ((dayLol.getMonth() == 6 && dayLol.getDate() == 4))
    {
      return 'july';
    }

    if ((dayLol.getMonth() == 9 && dayLol.getDate() == 31))
    {
      return 'halloween';
    }

    // literally every possible easter lmao
    if ((dayLol.getMonth() == 3 && (dayLol.getDate() == 20 || dayLol.getDate() == 13 || dayLol.getDate() == 6))
      || (dayLol.getMonth() == 2 && (dayLol.getDate() == 31 || dayLol.getDate() == 24)))
    {
      return 'easter';
    }

    // same for thanksgiving
    // fuck dynamic holidays
    if ((dayLol.getMonth() == 10
      && dayLol.getDay() == 4
      && (dayLol.getDate() == 22 || dayLol.getDate() == 23 || dayLol.getDate() == 24 || dayLol.getDate() == 25 || dayLol.getDate() == 26
        || dayLol.getDate() == 27 || dayLol.getDate() == 28)))
    {
      return 'thanks';
    }

    return null;
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