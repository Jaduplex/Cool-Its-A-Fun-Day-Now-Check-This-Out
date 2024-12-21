package states;

import ui.BoinerCounter;
import flixel.ui.FlxBar;
import adobeanimate.FlxAtlasSprite;
import openfl.Assets;
import haxe.Json;
import util.EaseUtil;
import visuals.PixelPerfectSprite;
import backend.ClientPrefs;
import flixel.util.FlxStringUtil;
import backend.Conductor;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionableState;
import util.CoolUtil;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
#if desktop
import backend.Discord.DiscordClient;
#end

class ResultsState extends MusicBeatState
{
  public var screenshotBackdrop:FlxBackdrop;
  public var bgColorOverlay:FlxSprite;

  public var resultsUi:FlxAtlasSprite;
  public var resultsAnim:FlxAtlasSprite;

  public var rankGfx:PixelPerfectSprite;

  public var botplayWatermark:PixelPerfectSprite;

  public var boinerCounter:BoinerCounter;

  public var statBars:Array<FlxBar>;
  public var statTexts:Array<FlxText>;
  public var accText:FlxText;
  public var scoreText:FlxText;

  public var realRank:ResultRanks;
  public var overridedRank:ResultRanks;

  public var resultsVariant:String = '';

  public var animname:String = 'results';

  public var botplay:Bool;

  public var score:Int = 0;
  public var hiscore:Int = 0;
  public var synergys:Int = 0;
  public var goods:Int = 0;
  public var eghs:Int = 0;
  public var bleghs:Int = 0;
  public var total:Int = 0;
  public var missed:Int = 0;
  public var percent:Float = 0;

  public var scoreLerp:Int = 0;
  public var hiscoreLerp:Int = 0;
  public var synergysLerp:Int = 0;
  public var goodsLerp:Int = 0;
  public var eghsLerp:Int = 0;
  public var bleghsLerp:Int = 0;
  public var totalLerp:Int = 0;
  public var missedLerp:Int = 0;
  public var percentLerp:Float = 0;

  public var addedBoiners:Bool;

  public var selectedSomethin:Bool = false;

  public var hasFadedOut:Bool = false;

  public var bgMovementMulti:Float = 0;
  public var bgMovementMultiTarget:Float = 1;

  public var elapsedTotal:Float;

  public override function new(score:Int = 0, hiscore:Int = 0, synergys:Int = 0, goods:Int = 0, eghs:Int = 0, bleghs:Int = 0, botplay:Bool = false,
      percent:Float = 0, missed:Int = 0, ?variation:String = '', ?overrideRank:ResultRanks)
  {
    super();

    this.score = score;
    this.hiscore = hiscore;
    this.synergys = synergys;
    this.goods = goods;
    this.eghs = eghs;
    this.bleghs = bleghs;
    this.total = synergys + goods + eghs + bleghs;
    this.botplay = botplay;
    this.percent = percent;
    this.missed = missed;
    this.overridedRank = overrideRank;
    this.resultsVariant = variation;
  }

  override function create()
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Total ResultsState create()");
    #end

    persistentUpdate = true;
    persistentDraw = true;

    CoolUtil.newStateMemStuff();

    #if desktop
    DiscordClient.changePresence("Results Screen", null, null, '-menus');
    #end

    realRank = calculateRank(missed, bleghs, eghs, goods, synergys, percent);

    if (overridedRank != null)
    {
      realRank = overridedRank;
    }

    if (botplay)
    {
      realRank = BOTPLAY;
    }

    var rankName = realRank.getName().toLowerCase();

    rankName += resultsVariant.toLowerCase();

    if (realRank == BOTPLAY)
    {
      rankName = 'botplay';
    }

    var json:Dynamic = Json.parse(Assets.getText('assets/results/$rankName.json'));

    FlxG.sound.music.stop();
    FlxG.sound.music = null;

    FlxG.sound.playMusic(Paths.music(json.song));
    Conductor.songPosition = 0;
    Conductor.changeBPM(json.tempo);

    screenshotBackdrop = new FlxBackdrop(FlxGraphic.fromBitmapData(CoolUtil.lastStateScreenShot.bitmapData));
    screenshotBackdrop.repeatAxes = XY;
    FlxTween.tween(screenshotBackdrop, {'scale.x': 0.25, 'scale.y': 0.25}, 1, {startDelay: 0.25, ease: FlxEase.circOut});
    screenshotBackdrop.antialiasing = ClientPrefs.globalAntialiasing;
    add(screenshotBackdrop);

    bgColorOverlay = new FlxSprite().makeGraphic(1, 1, FlxColor.fromRGB(json.bgColor[0], json.bgColor[1], json.bgColor[2]));
    bgColorOverlay.scale.set(2560, 2560);
    bgColorOverlay.updateHitbox();
    bgColorOverlay.screenCenter();
    bgColorOverlay.blend = SCREEN;
    bgColorOverlay.alpha = 0;
    add(bgColorOverlay);
    FlxTween.tween(bgColorOverlay, {alpha: 0.65}, 1, {ease: EaseUtil.stepped(8), startDelay: 0.1});

    var animLibrary:String = Paths.getLibrary(json.path);
    var animPath:String = Paths.stripLibrary(json.path);
    var assetPath:String = Paths.animateAtlas(animPath, animLibrary);

    animname = json.animation;

    resultsAnim = new FlxAtlasSprite(json.position[0], json.position[1], assetPath,
      {
        FrameRate: 24.0,
        Reversed: false,
        ShowPivot: false,
        Antialiasing: ClientPrefs.globalAntialiasing,
        ScrollFactor: null,
      });
    resultsAnim.anim.addBySymbol(animname, animname, 24, false);
    resultsAnim.playAnimation(animname, true, false, false);
    if (json.loop)
    {
      resultsAnim.onAnimationComplete.add(function goo(str:String)
      {
        resultsAnim.playAnimation(animname, true, false, false);
      });
    }
    resultsAnim.antialiasing = ClientPrefs.globalAntialiasing;
    add(resultsAnim);
    if (json.slidesIn)
    {
      resultsAnim.x += 1280;
      FlxTween.tween(resultsAnim, {x: resultsAnim.x - 1280}, 0.35, {ease: EaseUtil.stepped(16), startDelay: 0.8});
    }

    var animLibraryUi:String = Paths.getLibrary('results/ui');
    var animPathUi:String = Paths.stripLibrary('results/ui');
    var assetPathUi:String = Paths.animateAtlas(animPathUi, animLibraryUi);

    resultsUi = new FlxAtlasSprite(-82, -273, assetPathUi,
      {
        FrameRate: 24.0,
        Reversed: false,
        ShowPivot: false,
        Antialiasing: ClientPrefs.globalAntialiasing,
        ScrollFactor: null,
      });
    resultsUi.anim.addBySymbol('ui', 'ui', 24, false);
    resultsUi.playAnimation('ui', true, false, false);
    resultsUi.antialiasing = ClientPrefs.globalAntialiasing;
    add(resultsUi);

    statBars = [];
    statTexts = [];

    var barExes:Array<Float> = [106, 183, 251, 315, 400];
    var uhuh:Int = 0;
    for (i in barExes)
    {
      var theBarIsHere:FlxBar = new FlxBar(i, 218, FlxBarFillDirection.BOTTOM_TO_TOP, 45, 225);
      theBarIsHere.ID = uhuh;
      theBarIsHere.setRange(-1, total + missed);
      if (ClientPrefs.smootherBars)
      {
        theBarIsHere.numDivisions = total + missed;
      }
      else
      {
        theBarIsHere.numDivisions = 1000;
      }
      add(theBarIsHere);
      theBarIsHere.alpha = 0;
      FlxTween.tween(theBarIsHere, {alpha: 1}, 0.4, {ease: EaseUtil.stepped(4), startDelay: 1.9});
      statBars.push(theBarIsHere);

      var stattySon:FlxText = new FlxText(i, 173, 60, '0', 16);
      stattySon.setFormat(Paths.font('Calculator.ttf'), 16, FlxColor.fromRGB(0, 255, 0), CENTER, NONE);
      stattySon.ID = uhuh;
      add(stattySon);
      stattySon.alpha = 0;
      FlxTween.tween(stattySon, {alpha: 1}, 0.4, {ease: EaseUtil.stepped(4), startDelay: 1.9});
      statTexts.push(stattySon);

      uhuh++;
    }

    accText = new FlxText(109, 570, 134, '0%', 52);
    accText.setFormat(Paths.font('Calculator.ttf'), 52, FlxColor.fromRGB(0, 255, 0), CENTER, NONE, FlxColor.BLACK);
    accText.alpha = 0;
    add(accText);

    scoreText = new FlxText(315, 565, 170, '0\nHi: 0', 36);
    scoreText.setFormat(Paths.font('Calculator.ttf'), 36, FlxColor.fromRGB(0, 255, 0), CENTER, NONE, FlxColor.BLACK);
    scoreText.alpha = 0;
    add(scoreText);

    FlxTween.tween(accText, {alpha: 1}, 0.4, {ease: EaseUtil.stepped(4), startDelay: 1.9});
    FlxTween.tween(scoreText, {alpha: 1}, 0.4, {ease: EaseUtil.stepped(4), startDelay: 1.95});

    rankGfx = new PixelPerfectSprite().loadGraphic(Paths.image('results/texts/' + realRank.getName().toLowerCase(), null, true));
    if (Paths.image('results/texts/' + realRank.getName().toLowerCase(), null, true) == null)
    {
      rankGfx.loadGraphic(Paths.image('results/texts/placeholder'));
    }
    rankGfx.setPosition((FlxG.width - rankGfx.width) - 10, (FlxG.height - rankGfx.height) - 10);
    rankGfx.alpha = 0;
    add(rankGfx);
    FlxTween.tween(rankGfx, {alpha: 1}, 0.4, {ease: EaseUtil.stepped(4), startDelay: 2});

    boinerCounter = new BoinerCounter(1280 + 416, 0);
    add(boinerCounter);
    FlxTween.tween(boinerCounter, {x: 1280 - 416}, 0.4,
      {
        ease: EaseUtil.stepped(16),
        startDelay: 2,
        onComplete: function doit(t:FlxTween)
        {
          addBoiners();
        }
      });

    botplayWatermark = new PixelPerfectSprite(FlxG.width - 130, 2).loadGraphic(Paths.image('ui/botplay'));
    botplayWatermark.scale.set(0.5, 0.5);
    botplayWatermark.updateHitbox();
    botplayWatermark.alpha = 0.75;
    add(botplayWatermark);
    botplayWatermark.visible = botplay;

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
    elapsedTotal += elapsed;

    if (FlxG.sound.music != null)
    {
      Conductor.songPosition = FlxG.sound.music.time;
    }

    if (FlxG.keys.justPressed.F && !hasFadedOut)
    {
      FlxG.camera.fade(FlxColor.BLACK, (Conductor.crochet / 1000) * 32, false);
      hasFadedOut = true;
    }

    if (hasFadedOut)
    {
      FlxG.sound.music.volume -= 0.075 * elapsed;
    }

    if ((controls.ACCEPT || controls.BACK) && !selectedSomethin)
    {
      selectedSomethin = true;

      FlxG.sound.play(Paths.sound('confirmMenu'));

      FlxG.sound.music.stop();
      FlxG.sound.music = null;

      bgMovementMultiTarget = 0;

      FlxTween.tween(resultsAnim, {alpha: 0}, 0.15, {ease: EaseUtil.stepped(4)});
      FlxTween.tween(resultsUi, {x: resultsUi.x - 800}, 0.25, {ease: FlxEase.circIn});
      for (i in statTexts)
      {
        FlxTween.tween(i, {x: i.x - 800}, 0.25, {ease: FlxEase.circIn});
      }
      for (i in statBars)
      {
        FlxTween.tween(i, {x: i.x - 800}, 0.25, {ease: FlxEase.circIn});
      }
      FlxTween.tween(accText, {x: accText.x - 800}, 0.25, {ease: FlxEase.circIn});
      FlxTween.tween(scoreText, {x: scoreText.x - 800}, 0.25, {ease: FlxEase.circIn});
      FlxTween.tween(rankGfx, {x: rankGfx.x + rankGfx.width + 25}, 0.25, {ease: FlxEase.circIn});
      FlxTween.cancelTweensOf(boinerCounter);
      if (!addedBoiners)
      {
        addBoiners();
      }
      FlxTween.tween(boinerCounter, {alpha: 0}, 0.25, {ease: FlxEase.circIn});

      var fuck:FlxTimer = new FlxTimer().start(0.75, function dire(fuckse:FlxTimer)
      {
        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;
        MusicBeatState.switchState(new MainMenuState());
      });
    }

    if (botplayWatermark != null)
    {
      botplayWatermark.angle += Math.cos(elapsedTotal) * 0.25;
    }

    if (accText.alpha != 0)
    {
      synergysLerp = Math.floor(FlxMath.lerp(synergysLerp, synergys, CoolUtil.boundTo(elapsed * 16, 0, 1)));
      goodsLerp = Math.floor(FlxMath.lerp(goodsLerp, goods, CoolUtil.boundTo(elapsed * 16, 0, 1)));
      eghsLerp = Math.floor(FlxMath.lerp(eghsLerp, eghs, CoolUtil.boundTo(elapsed * 16, 0, 1)));
      bleghsLerp = Math.floor(FlxMath.lerp(bleghsLerp, bleghs, CoolUtil.boundTo(elapsed * 16, 0, 1)));
      missedLerp = Math.floor(FlxMath.lerp(missedLerp, missed, CoolUtil.boundTo(elapsed * 16, 0, 1)));
      percentLerp = Math.ffloor((FlxMath.lerp(percentLerp, percent, CoolUtil.boundTo(elapsed * 16, 0, 1))) * 10) / 10;

      if (Math.abs(synergysLerp - synergys) <= 30)
      {
        synergysLerp = synergys;
      }

      if (Math.abs(goodsLerp - goods) <= 30)
      {
        goodsLerp = goods;
      }

      if (Math.abs(eghsLerp - eghs) <= 30)
      {
        eghsLerp = eghs;
      }

      if (Math.abs(bleghsLerp - bleghs) <= 30)
      {
        bleghsLerp = bleghs;
      }

      if (Math.abs(missedLerp - missed) <= 30)
      {
        missedLerp = missed;
      }

      if (Math.abs(percentLerp - percent) <= 5)
      {
        percentLerp = percent;
      }
    }

    if (scoreText.alpha != 0)
    {
      scoreLerp = Math.floor(FlxMath.lerp(scoreLerp, score, CoolUtil.boundTo(elapsed * 24, 0, 1)));
      hiscoreLerp = Math.floor(FlxMath.lerp(hiscoreLerp, hiscore, CoolUtil.boundTo(elapsed * 24, 0, 1)));

      if (Math.abs(scoreLerp - score) <= 25)
      {
        scoreLerp = score;
      }

      if (Math.abs(hiscoreLerp - hiscore) <= 25)
      {
        hiscoreLerp = hiscore;
      }
    }

    bgMovementMulti = FlxMath.lerp(bgMovementMulti, bgMovementMultiTarget, CoolUtil.boundTo(elapsed * 6, 0, 1));

    var scort:String = FlxStringUtil.formatMoney(scoreLerp, false, true);
    var hiscort:String = FlxStringUtil.formatMoney(hiscoreLerp, false, true);

    super.update(elapsed);

    var ee:Int = 0;
    var used:Int = 0;

    for (i in statTexts)
    {
      switch (ee)
      {
        case 1:
          used = bleghsLerp;
        case 2:
          used = eghsLerp;
        case 3:
          used = goodsLerp;
        case 4:
          used = synergysLerp;
        default:
          used = missedLerp;
      }
      i.text = Std.string(used);
      statBars[ee].value = used;
      ee++;
    }

    accText.text = '$percentLerp%';
    scoreText.text = '$scort\nHi: $hiscort';

    screenshotBackdrop.x += (225 * bgMovementMulti) * elapsed;
    screenshotBackdrop.y += (225 * bgMovementMulti) * elapsed;
  }

  override function beatHit()
  {
    super.beatHit();
  }

  /**
   * Get the intended ranking. this does NOT include variations, those are tacked on later.
   * @param misses Number of misses.
   * @param bleghs Number of Blegh ratings.
   * @param eghs Number of Egh ratings.
   * @param goods Number of Good ratings.
   * @param synergys Number of Synergy ratings.
   * @param percent Accuracy percent
   * @return Ranking.
   */
  public static function calculateRank(misses:Int, bleghs:Int, eghs:Int, goods:Int, synergys:Int, percent:Float):ResultRanks
  {
    if (misses <= 0 && bleghs == 0 && eghs == 0 && percent >= 90)
    {
      return SYNERGY;
    }

    if (percent >= 85)
    {
      return EXCELLENT;
    }

    if (percent >= 75)
    {
      return GREAT;
    }

    if (percent >= 55)
    {
      return GOOD;
    }

    return BLEGH;
  }

  public function addBoiners():Void
  {
    var boinersToAdd:Int = Math.floor((score * 0.005) * (percent / 50));

    var rankBonus:Int;

    switch (realRank)
    {
      case GOOD:
        rankBonus = 50;
      case GREAT:
        rankBonus = 100;
      case EXCELLENT:
        rankBonus = 250;
      case SYNERGY:
        rankBonus = 500;
      default:
        rankBonus = 0;
    }

    boinersToAdd += rankBonus;

    if (botplay)
    {
      boinersToAdd = 0;
    }

    ClientPrefs.boiners += boinersToAdd;

    // to flush the boiners to the save file because they werent before
    ClientPrefs.saveSettings();

    addedBoiners = true;

    FlxTween.tween(boinerCounter, {alpha: 0}, 0.4, {ease: EaseUtil.stepped(16), startDelay: 2});
  }
}

/**
 * All unique ranks. Variations not included, those are tacked on later.
 */
enum ResultRanks
{
  BLEGH;
  GOOD;
  GREAT;
  EXCELLENT;
  SYNERGY;
  BOTPLAY;
}

/**
 * Ranking JSON typedef. This IS used for variants.
 */
typedef RankAnimation =
{
  var song:String;
  var tempo:Float;
  var path:String;
  var animation:String;
  var loop:Bool;
  var slidesIn:Bool;
  var position:Array<Float>;
  var bgColor:Array<Float>;
}