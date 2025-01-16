package states;

import util.RandomUtil;
import flixel.FlxSprite;
import ui.TransitionScreenshotObject;
import util.EaseUtil;
import visuals.PixelPerfectSprite;
import lime.app.Application;
import ui.MainMenuButton;
import backend.Conductor;
import options.OptionsState;
import backend.ClientPrefs;
import util.CoolUtil;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
#if desktop
import backend.Discord.DiscordClient;
#end
#if DEVELOPERBUILD
import editors.MasterEditorMenu;
#end

class MainMenuState extends MusicBeatState
{
  public static var curSelected:Int = 0;

  private var menuItems:FlxTypedGroup<MainMenuButton>;

  public var camGame:FlxCamera;

  private var optionShit:Array<String> = ['freeplay', 'options'];

  public var debugKeys:Array<FlxKey>;

  private var sideThing:PixelPerfectSprite;

  private var cloudarray:Array<FlxSprite> = [];

  override function create()
  {
    #if DEVELOPERBUILD
    var perf = new Perf("MainMenuState create()");
    #end

    persistentUpdate = true;
    persistentDraw = true;

    CoolUtil.newStateMemStuff();

    FlxG.mouse.visible = false;

    #if desktop
    DiscordClient.changePresence("In the Main Menu", null, null, '-menus');
    #end

    debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

    if (FlxG.sound.music == null)
    {
      FlxG.sound.playMusic(Paths.music('mus_pauperized'));
      Conductor.changeBPM(110);
    }

    camGame = new FlxCamera();

    FlxG.cameras.reset(camGame);
    FlxG.cameras.setDefaultDrawTarget(camGame, true);

    transIn = FlxTransitionableState.defaultTransIn;
    transOut = FlxTransitionableState.defaultTransOut;

    var night:String = '';
    if ((Date.now().getHours() <= 5) || (Date.now().getHours() >= 19))
    {
      night = 'Night';
    }

    var bg:PixelPerfectSprite = new PixelPerfectSprite().loadGraphic(Paths.image('mainmenu/skybox' + night));
    bg.antialiasing = ClientPrefs.globalAntialiasing;
    bg.updateHitbox();
    bg.screenCenter();
    add(bg);

    for (i in 0...5)
    {
      var newCloud:FlxSprite = new FlxSprite((182 * i) + RandomUtil.randomLogic.float(-50, 50),
        RandomUtil.randomLogic.float(-10, 200)).loadGraphic(Paths.image('mainmenu/clouds' + night + '/' + RandomUtil.randomVisuals.int(1, 3)));
      newCloud.antialiasing = ClientPrefs.globalAntialiasing;
      newCloud.velocity.x = RandomUtil.randomLogic.float(15, 50);
      add(newCloud);
      cloudarray.push(newCloud);
    }

    var land:FlxSprite = new FlxSprite(640).loadGraphic(Paths.image('mainmenu/land' + night));
    land.antialiasing = ClientPrefs.globalAntialiasing;
    add(land);

    sideThing = new PixelPerfectSprite().loadGraphic(Paths.image("mainmenu/mm_side"));
    sideThing.updateHitbox();
    sideThing.antialiasing = ClientPrefs.globalAntialiasing;
    add(sideThing);

    var logo:PixelPerfectSprite = new PixelPerfectSprite(650, 0).loadGraphic(Paths.image('mainmenu/log'));
    logo.antialiasing = ClientPrefs.globalAntialiasing;
    add(logo);

    menuItems = new FlxTypedGroup<MainMenuButton>();
    add(menuItems);

    var scale:Float = 1;

    for (i in 0...optionShit.length)
    {
      var menuItem:MainMenuButton = new MainMenuButton(35, 32.5 + (190 * i), optionShit[i], scale);
      menuItem.ID = i;
      menuItems.add(menuItem);
    }

    var transThing = new TransitionScreenshotObject();
    add(transThing);
    transThing.fadeout();

    var versionShit:FlxText = new FlxText(-4, #if DEVELOPERBUILD FlxG.height
      - 44 #else FlxG.height
      - 24 #end, FlxG.width,
      "Cool! It's a Fun Day! Now, Check This Out! v"
      + Application.current.meta.get('version') #if DEVELOPERBUILD
        + "\n(DEV BUILD!!! - "
        + CoolUtil.gitCommitBranch
        + " - "
        + CoolUtil.gitCommitHash
        + ")" #end,
      12);
    versionShit.scrollFactor.set();
    versionShit.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    versionShit.antialiasing = ClientPrefs.globalAntialiasing;
    add(versionShit);

    changeItem();

    super.create();

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  var selectedSomethin:Bool = false;

  override function update(elapsed:Float)
  {
    if (FlxG.sound.music != null)
    {
      if (FlxG.sound.music.volume < 1)
      {
        FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
      }

      Conductor.songPosition = FlxG.sound.music.time;
    }

    for (i in cloudarray)
    {
      if (i.x >= 1300)
      {
        i.x = RandomUtil.randomLogic.float(-25, 250);
        i.y = RandomUtil.randomLogic.float(-10, 200);
        i.velocity.x = RandomUtil.randomLogic.float(15, 50);
      }
    }

    if (!selectedSomethin)
    {
      if (controls.UI_UP_P)
      {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        changeItem(-1);
      }

      if (controls.UI_DOWN_P)
      {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        changeItem(1);
      }

      if (controls.BACK)
      {
        selectedSomethin = true;
        FlxG.sound.play(Paths.sound('cancelMenu'));
        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;
        MusicBeatState.switchState(new TitleState());
      }

      if (controls.ACCEPT)
      {
        selectedSomethin = true;

        FlxG.sound.play(Paths.sound('confirmMenu'));

        menuItems.forEach(function(spr:MainMenuButton) {
          if (curSelected != spr.ID)
          {
            FlxTween.completeTweensOf(spr);

            spr.alpha = 1;

            FlxTween.tween(spr, {x: -600, alpha: 0}, 0.3,
              {
                ease: EaseUtil.stepped(8),
                onComplete: function(twn:FlxTween) {
                  spr.kill();
                }
              });
          }
          else
          {
            FlxTween.completeTweensOf(spr);
            spr.alpha = 1;
            spr.buttonFlicker(1, function flck()
            {
              var daChoice:String = optionShit[curSelected];

              switch (daChoice)
              {
                case 'freeplay':
                  ClientPrefs.saveSettings();
                  FlxTransitionableState.skipNextTransIn = true;
                  FlxTransitionableState.skipNextTransOut = true;
                  MusicBeatState.switchState(new FreeplayState());
                case 'options':
                  ClientPrefs.saveSettings();
                  FlxTransitionableState.skipNextTransIn = true;
                  FlxTransitionableState.skipNextTransOut = true;
                  MusicBeatState.switchState(new OptionsState());
              }
            });
          }
        });
      }
      #if DEVELOPERBUILD
      else if (FlxG.keys.anyJustPressed(debugKeys))
      {
        selectedSomethin = true;
        MusicBeatState.switchState(new MasterEditorMenu());
      }
      #end
    }

    super.update(elapsed);
  }

  function changeItem(huh:Int = 0)
  {
    curSelected += huh;

    if (curSelected >= menuItems.length)
    {
      curSelected = 0;
    }

    if (curSelected < 0)
    {
      curSelected = menuItems.length - 1;
    }

    menuItems.forEach(function(spr:MainMenuButton) {
      spr.playAnim('idle');
      spr.updateHitbox();

      if (spr.ID == curSelected)
      {
        spr.playAnim('selected');
        spr.centerOffsets();
      }
    });
  }
}