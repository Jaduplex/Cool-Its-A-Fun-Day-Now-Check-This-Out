package states;

import backend.TextAndLanguage;
import util.EaseUtil;
import visuals.PixelPerfectSprite;
import util.CoolUtil;
import backend.ClientPrefs;
import backend.Conductor;
import ui.Alphabet;
import lime.app.Application;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{
  private var grpMenuShit:FlxTypedGroup<Alphabet>;

  private var menuItems:Array<String> = [];
  private var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'Toggle Practice Mode', 'Exit to menu'];
  private var curSelected:Int = 0;

  private var pauseMusic:FlxSound;

  private var practiceText:FlxText;

  private static var songName:String = '';

  private var songCover:PixelPerfectSprite;
  private var descText:FlxText;

  private var cantUnpause:Float = 0.1;

  public function new(focusLost:Bool)
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Total PauseSubState new()");
    #end

    super();

    songName = PlayState.instance.songObj.songNameForDisplay;

    CoolUtil.newStateMemStuff(false);

    #if DEVELOPERBUILD
    if (PlayState.chartingMode)
    {
      menuItemsOG.insert(3, 'Leave Charting Mode');
      menuItemsOG.insert(4, 'End Song');
      menuItemsOG.insert(5, 'Toggle Botplay');
    }
    #end

    menuItems = menuItemsOG;

    pauseMusic = new FlxSound();
    pauseMusic.loadEmbedded(Paths.music("mus_lunch_break"), true, true);
    pauseMusic.volume = 0.25;
    pauseMusic.play(false);

    FlxG.sound.list.add(pauseMusic);

    FlxTween.globalManager.forEach(function killsSelf(i:FlxTween)
    {
      i.active = false;
    });

    var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    bg.alpha = 0;
    bg.scrollFactor.set();
    add(bg);

    var credit:FlxText = new FlxText(8, 0, 0, "", 32);
    credit.text = TextAndLanguage.getPhrase('pause_credits', 'Composer: {1}\nCharter: {2}', [PlayState.SONG.composer, PlayState.SONG.charter]);
    credit.scrollFactor.set();
    credit.setFormat(Paths.font("BAUHS93.ttf"), 32);
    credit.updateHitbox();
    credit.antialiasing = ClientPrefs.globalAntialiasing;
    credit.alpha = 0;
    add(credit);

    var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
    levelInfo.text += PlayState.instance.songObj.songNameForDisplay;
    levelInfo.scrollFactor.set();
    levelInfo.setFormat(Paths.font("BAUHS93.ttf"), 32);
    levelInfo.updateHitbox();
    levelInfo.antialiasing = ClientPrefs.globalAntialiasing;
    add(levelInfo);

    var blueballedTxt:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
    blueballedTxt.text = TextAndLanguage.getPhrase('pause_died', 'Died: {1}', [PlayState.deathCounter]);
    blueballedTxt.scrollFactor.set();
    blueballedTxt.setFormat(Paths.font("BAUHS93.ttf"), 32);
    blueballedTxt.updateHitbox();
    blueballedTxt.antialiasing = ClientPrefs.globalAntialiasing;
    add(blueballedTxt);

    var sectionTxt:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
    sectionTxt.text = "Section " + PlayState.sectionNum;
    sectionTxt.scrollFactor.set();
    sectionTxt.setFormat(Paths.font("BAUHS93.ttf"), 32);
    sectionTxt.updateHitbox();
    sectionTxt.antialiasing = ClientPrefs.globalAntialiasing;

    if (PlayState.songHasSections)
    {
      add(sectionTxt);
    }

    practiceText = new FlxText(20, 15 + 101, 0, TextAndLanguage.getPhrase('pause_practice', 'PRACTICE MODE'), 32);
    practiceText.scrollFactor.set();
    practiceText.setFormat(Paths.font("BAUHS93.ttf"), 32);
    practiceText.x = FlxG.width - (practiceText.width + 20);
    practiceText.updateHitbox();
    practiceText.visible = PlayState.instance.practiceMode;
    practiceText.antialiasing = ClientPrefs.globalAntialiasing;
    add(practiceText);

    #if DEVELOPERBUILD
    var chartingText:FlxText = new FlxText(20, 15 + 165, 0, TextAndLanguage.getPhrase('pause_charting', 'CHARTING MODE'), 32);
    chartingText.scrollFactor.set();
    chartingText.setFormat(Paths.font("BAUHS93.ttf"), 32);
    chartingText.x = FlxG.width - (chartingText.width + 20);
    chartingText.y = FlxG.height - (chartingText.height + 20);
    chartingText.updateHitbox();
    chartingText.visible = PlayState.chartingMode;
    chartingText.antialiasing = ClientPrefs.globalAntialiasing;
    add(chartingText);
    #end

    var theCover:String = 'song_covers/' + PlayState.removeVariationSuffixes(PlayState.SONG.song.toLowerCase());
    if (Paths.image(theCover, null, true) == null)
    {
      theCover = 'song_covers/placeholder';
    }

    songCover = new PixelPerfectSprite(936, 0).loadGraphic(Paths.image(theCover));
    songCover.screenCenter();
    songCover.x = FlxG.width - (256 + 15);
    songCover.y -= 76;
    songCover.antialiasing = false;
    add(songCover);

    descText = new FlxText(872, songCover.y + songCover.height + 21, 400, PlayState.instance.songObj.songDescription, 30);
    descText.setFormat(Paths.font("BAUHS93.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    descText.borderSize = 1.5;
    descText.x = FlxG.width - 415;
    descText.y = songCover.y + songCover.height + 21;
    descText.antialiasing = ClientPrefs.globalAntialiasing;
    add(descText);

    blueballedTxt.alpha = 0;
    levelInfo.alpha = 0;
    sectionTxt.alpha = 0;
    practiceText.alpha = 0;
    #if DEVELOPERBUILD
    chartingText.alpha = 0;
    #end
    songCover.alpha = 0;
    descText.alpha = 0;

    levelInfo.x = FlxG.width - (levelInfo.width + 20);
    blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);
    sectionTxt.x = FlxG.width - (sectionTxt.width + 20);

    songCover.y -= 5;
    descText.y -= 5;

    FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: EaseUtil.stepped(4)});
    FlxTween.tween(credit, {alpha: 1, y: 8}, 0.4, {ease: EaseUtil.stepped(4)});
    FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: EaseUtil.stepped(4)});
    FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: EaseUtil.stepped(4)});
    FlxTween.tween(sectionTxt, {alpha: 1, y: sectionTxt.y + 5}, 0.4, {ease: EaseUtil.stepped(4)});
    FlxTween.tween(practiceText, {alpha: 1, y: practiceText.y + 5}, 0.4, {ease: EaseUtil.stepped(4)});
    #if DEVELOPERBUILD
    FlxTween.tween(chartingText, {alpha: 1, y: chartingText.y + 5}, 0.4, {ease: EaseUtil.stepped(4)});
    #end
    FlxTween.tween(songCover, {alpha: 1, y: songCover.y + 5}, 0.4, {ease: EaseUtil.stepped(4)});
    FlxTween.tween(descText, {alpha: 1, y: descText.y + 5}, 0.4, {ease: EaseUtil.stepped(4)});

    if (focusLost)
    {
      FlxTween.completeTweensOf(bg);
      FlxTween.completeTweensOf(credit);
      FlxTween.completeTweensOf(levelInfo);
      FlxTween.completeTweensOf(blueballedTxt);
      FlxTween.completeTweensOf(sectionTxt);
      FlxTween.completeTweensOf(practiceText);
      #if DEVELOPERBUILD
      FlxTween.completeTweensOf(chartingText);
      #end
      FlxTween.completeTweensOf(songCover);
      FlxTween.completeTweensOf(descText);
    }

    grpMenuShit = new FlxTypedGroup<Alphabet>();
    add(grpMenuShit);

    regenMenu(focusLost);

    cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  override function update(elapsed:Float)
  {
    cantUnpause -= elapsed;

    if (pauseMusic.volume < 1)
    {
      pauseMusic.volume += 0.25 * elapsed;
    }

    super.update(elapsed);

    var upP = controls.UI_UP_P;
    var downP = controls.UI_DOWN_P;
    var accepted = controls.ACCEPT;

    if (upP)
    {
      changeSelection(-1);
    }

    if (downP)
    {
      changeSelection(1);
    }

    var daSelected:String = menuItems[curSelected];

    if (accepted && (cantUnpause <= 0 || !ClientPrefs.controllerMode))
    {
      switch (daSelected)
      {
        case "Resume":
          Application.current.window.title = CoolUtil.appTitleString + " - Playing " + PlayState.instance.songObj.songNameForDisplay;

          FlxTween.globalManager.forEach(function killsSelf(i:FlxTween)
          {
            i.active = true;
          });

          close();

          FlxG.sound.play(Paths.sound('resume'));
        case 'Toggle Practice Mode':
          PlayState.instance.practiceMode = !PlayState.instance.practiceMode;

          FlxG.sound.play(Paths.sound('toggle'));

          practiceText.visible = PlayState.instance.practiceMode;
        case "Restart Song":
          Application.current.window.title = CoolUtil.appTitleString + " - Playing " + PlayState.instance.songObj.songNameForDisplay;

          restartSong();

          FlxG.sound.play(Paths.sound('resume'));
        #if DEVELOPERBUILD
        case "Leave Charting Mode":
          restartSong();

          FlxG.sound.play(Paths.sound('resume'));

          PlayState.chartingMode = false;
        #end
        case "End Song":
          Application.current.window.title = CoolUtil.appTitleString;

          close();

          FlxG.sound.play(Paths.sound('resume'));

          PlayState.instance.finishSong(true);
        case 'Toggle Botplay':
          PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;

          FlxG.sound.play(Paths.sound('toggle'));

          #if !SHOWCASEVIDEO
          PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
          PlayState.instance.botplayTxt.alpha = 1;
          #end
        case "Exit to menu":
          Application.current.window.title = CoolUtil.appTitleString;

          PlayState.deathCounter = 0;

          FlxTransitionableState.skipNextTransIn = true;
          FlxTransitionableState.skipNextTransOut = true;

          FlxG.sound.play(Paths.sound('cancelMenu'));

          MusicBeatState.switchState(new MainMenuState());

          PlayState.cancelMusicFadeTween();

          FlxG.sound.playMusic(Paths.music('mus_pauperized'));
          Conductor.songPosition = 0;
          Conductor.changeBPM(110);

          #if DEVELOPERBUILD
          PlayState.chartingMode = false;
          #end
      }
    }
  }

  public static function restartSong()
  {
    PlayState.instance.paused = true;
    FlxG.sound.music.volume = 0;
    PlayState.instance.vocals.volume = 0;

    FlxTransitionableState.skipNextTransIn = true;
    FlxTransitionableState.skipNextTransOut = true;

    MusicBeatState.switchState(new PlayState());
  }

  override function destroy()
  {
    pauseMusic.destroy();

    super.destroy();
  }

  public function changeSelection(change:Int = 0):Void
  {
    curSelected += change;

    if (change != 0)
    {
      FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
    }

    if (curSelected < 0)
    {
      curSelected = menuItems.length - 1;
    }

    if (curSelected >= menuItems.length)
    {
      curSelected = 0;
    }

    var bullShit:Int = 0;

    for (item in grpMenuShit.members)
    {
      item.targetY = bullShit - curSelected;
      bullShit++;

      item.alpha = 0.6;

      if (item.targetY == 0)
      {
        item.alpha = 1;
      }
    }
  }

  public function regenMenu(focusLost:Bool):Void
  {
    for (i in 0...grpMenuShit.members.length)
    {
      var obj = grpMenuShit.members[0];
      obj.kill();
      grpMenuShit.remove(obj, true);
      obj.destroy();
    }

    for (i in 0...menuItems.length)
    {
      var item = new Alphabet(90, 320, menuItems[i], true);
      item.isMenuItem = true;
      item.targetY = i;

      if (focusLost)
      {
        item.snapToPosition();
      }

      grpMenuShit.add(item);
    }

    curSelected = 0;
    changeSelection();
  }
}