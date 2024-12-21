#if DEVELOPERBUILD
package editors;

import states.MainMenuState;
import util.CoolUtil;
import states.MusicBeatState;
#if desktop
import backend.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class VideoTestState extends MusicBeatState
{
  public function new()
  {
    super();
  }

  override function create()
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Total VideoTestState create()");
    #end

    CoolUtil.newStateMemStuff();

    #if desktop
    DiscordClient.changePresence("Video Test Screen", null, null, '-menus');
    #end

    FlxG.mouse.visible = true;

    super.create();

    var videoz:VideoCutscene = new VideoCutscene(0, 0);
    videoz.play(Paths.video('sports_countdown'), null, FlxG.height, FlxG.width);
    add(videoz);

    #if DEVELOPERBUILD
    var versionShit:FlxText = new FlxText(-4, FlxG.height - 24, FlxG.width,
      "(DEV BUILD!!! - " + CoolUtil.gitCommitBranch + " - " + CoolUtil.gitCommitHash + ")", 12);
    versionShit.scrollFactor.set();
    versionShit.setFormat(Paths.font("BAUHS93.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    add(versionShit);
    #end

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  override function update(elapsed:Float)
  {
    if (controls.BACK)
    {
      MusicBeatState.switchState(new MainMenuState());
    }

    super.update(elapsed);
  }
}
#end