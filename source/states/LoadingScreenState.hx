package states;

import util.RandomUtil;
import backend.TextAndLanguage;
import ui.TransitionScreenshotObject;
import visuals.PixelPerfectSprite;
import ui.MarkHeadTransition;
import songs.SongInit;
import backend.Conductor;
import backend.ClientPrefs;
import flixel.addons.transition.FlxTransitionableState;
import visuals.Character;
import util.CoolUtil;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.FlxG;
import flixel.math.FlxMath;
#if desktop
import backend.Discord.DiscordClient;
#end

class LoadingScreenState extends MusicBeatState
{
  private var funkay:PixelPerfectSprite;

  private var loadedBar:FlxBar;

  private var charactersToLoad:Array<String> = [];

  public var characters:Array<Character> = [];

  private var loadCooldown:Float = 0.525;

  private var toLoad:Int;

  private var finishedPreloading:Bool = false;

  private var startedSwitching:Bool = false;

  private var holdingEscText:FlxText;

  private var escHoldTimer:Float;

  private var realPercent:Float = 0;
  private var smoothenedPercent:Float = 0;

  private var gotSportsEvent:Bool = false;

  private var finishedSportVid:Bool = true;

  private var sportVid:VideoCutscene;

  override function create()
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Total LoadingScreenState create()");
    #end

    persistentUpdate = true;
    persistentDraw = true;

    CoolUtil.newStateMemStuff();

    #if desktop
    DiscordClient.changePresence("Loading!", null, null, '-menus');
    #end

    #if !SHOWCASEVIDEO
    gotSportsEvent = RandomUtil.randomSecrets.bool(#if FORCESPORTSEVENT 100 #else 0.1 #end);
    #end

    loadedBar = new FlxBar(74, 199, FlxBarFillDirection.TOP_TO_BOTTOM, 370, 247, this, "loaded", 0, 2, false);
    if (ClientPrefs.smootherBars)
    {
      loadedBar.numDivisions = 247;
    }
    loadedBar.percent = 0;
    loadedBar.createFilledBar(FlxColor.GRAY, FlxColor.WHITE);
    add(loadedBar);

    var bg:PixelPerfectSprite = new PixelPerfectSprite(0, 0).loadGraphic(Paths.image("loading/loadBg"));
    if (gotSportsEvent)
    {
      loadedBar.visible = false;
      bg.loadGraphic(Paths.image("loading/sport"));
    }
    bg.scale.set(2, 2);
    bg.updateHitbox();
    add(bg);

    if (gotSportsEvent)
    {
      finishedSportVid = false;
      sportVid = new VideoCutscene(11 * 2, 99 * 2);
      add(sportVid);
      sportVid.play(Paths.video('sports_countdown'), function setThingy()
      {
        finishedSportVid = true;
      }, 275 * 2, 156 * 2);
    }

    var marksSuffix:String = "";

    #if !SHOWCASEVIDEO
    if (RandomUtil.randomSecrets.bool(3.125))
    {
      marksSuffix = "_secret";
    }
    #end

    funkay = new PixelPerfectSprite(0, 0).loadGraphic(Paths.image("loading/loadMark" + marksSuffix));
    funkay.scale.set(2, 2);
    funkay.updateHitbox();
    funkay.pixelPerfectDiv = 4;
    add(funkay);

    var transThing = new TransitionScreenshotObject();
    add(transThing);
    transThing.fadeout();

    charactersToLoad = SongInit.genSongObj(PlayState.SONG.song.toLowerCase()).preloadCharacters;

    toLoad = charactersToLoad.length - 1;

    holdingEscText = new FlxText(6, FlxG.height - 28, FlxG.width - 4, TextAndLanguage.getPhrase('loading_back', 'Going Back...'), 16);
    holdingEscText.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK, 2);
    holdingEscText.scrollFactor.set();
    holdingEscText.alpha = 0;
    holdingEscText.antialiasing = false;
    add(holdingEscText);

    #if DEVELOPERBUILD
    var versionShit:FlxText = new FlxText(-4, FlxG.height - 24, FlxG.width,
      "(DEV BUILD!!! - " + CoolUtil.gitCommitBranch + " - " + CoolUtil.gitCommitHash + ")", 12);
    versionShit.scrollFactor.set();
    versionShit.setFormat(Paths.font("BAUHS93.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    versionShit.antialiasing = ClientPrefs.globalAntialiasing;
    add(versionShit);
    #end

    #if DEVELOPERBUILD
    perf.print();
    #end

    super.create();
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    if (FlxG.sound.music != null)
    {
      Conductor.songPosition = FlxG.sound.music.time;
    }

    loadCooldown -= elapsed;

    if (FlxG.keys.pressed.ESCAPE)
    {
      escHoldTimer += elapsed;
    }
    else
    {
      if (escHoldTimer > 0)
      {
        escHoldTimer -= elapsed;
      }
    }

    if (escHoldTimer >= 1.5)
    {
      startedSwitching = true;
      FlxTransitionableState.skipNextTransIn = true;
      FlxTransitionableState.skipNextTransOut = true;
      MusicBeatState.switchState(new MainMenuState());
    }

    if (sportVid != null && !finishedSportVid)
    {
      finishedSportVid = (sportVid.vid == null);
    }

    holdingEscText.alpha = FlxMath.bound(escHoldTimer * 2, 0, 1);

    if (!startedSwitching)
    {
      if (!finishedPreloading)
      {
        if (loadCooldown <= 0)
        {
          if (charactersToLoad[0] != "stop-loading")
          {
            preloadCharacter(charactersToLoad[0]);
          }
          else if (finishedSportVid)
          {
            loadCooldown = 1;
            finishedPreloading = true;
          }
        }
      }
      else if (finishedPreloading && loadCooldown >= 0 && finishedSportVid)
      {
        startedSwitching = true;
        FlxTransitionableState.skipNextTransIn = false;
        FlxTransitionableState.skipNextTransOut = false;
        MarkHeadTransition.nextCamera = FlxG.camera;
        MusicBeatState.switchState(new PlayState());
      }
    }

    realPercent = ((charactersToLoad.length - 1) / toLoad) * 100;

    smoothenedPercent = FlxMath.lerp(smoothenedPercent, realPercent, CoolUtil.boundTo(elapsed * 6, 0, 1));

    loadedBar.percent = smoothenedPercent;

    if (FlxG.keys.justPressed.SPACE)
    {
      funkay.y = 100;
    }

    funkay.y = FlxMath.lerp(0, funkay.y, CoolUtil.boundTo(1 - (elapsed * 4), 0, 1));
  }

  public function preloadCharacter(charName:String)
  {
    loadCooldown = 0.575;

    if (FlxG.keys.pressed.SHIFT)
    {
      loadCooldown = 0.25;
    }

    #if DEVELOPERBUILD
    var perf = new Perf("Preload Character: " + charName);
    trace("loading " + charName);
    #end

    var chrazy:Character = new Character(1279, 719, charName);
    chrazy.scale.set(0.1, 0.1);
    chrazy.updateHitbox();
    chrazy.alpha = 0.05;
    add(chrazy);
    insert(members.indexOf(funkay) - 1, chrazy);
    characters.push(chrazy);
    charactersToLoad.remove(charName);

    #if DEVELOPERBUILD
    perf.print();
    #end
  }
}