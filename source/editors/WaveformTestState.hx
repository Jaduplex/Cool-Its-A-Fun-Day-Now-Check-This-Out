#if DEVELOPERBUILD
package editors;

import backend.Conductor;
import states.MainMenuState;
import flixel.FlxSprite;
import util.CoolUtil;
import states.MusicBeatState;
#if desktop
import backend.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import waveform.WaveformDataParser;
import waveform.WaveformSprite;

class WaveformTestState extends MusicBeatState
{
  public function new()
  {
    super();
  }

  var wave:WaveformSprite;

  override function create()
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Total WaveformTestState create()");
    #end

    CoolUtil.newStateMemStuff();

    #if desktop
    DiscordClient.changePresence("Waveform Test Screen", null, null, '-menus');
    #end

    FlxG.mouse.visible = true;

    add(new FlxSprite().makeGraphic(5000, 5000).screenCenter());

    FlxG.sound.playMusic(Paths.music('mus_pauperized'));
    Conductor.changeBPM(150);

    wave = new WaveformSprite(WaveformDataParser.interpretFlxSound(FlxG.sound.music), WaveformOrientation.HORIZONTAL, FlxColor.fromRGB(195, 207, 209),
      Conductor.crochet / 500);
    wave.width = 1408;
    wave.height = 360;
    wave.amplitude = 4;
    wave.screenCenter();
    add(wave);

    super.create();

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
    if (FlxG.sound.music != null)
    {
      Conductor.songPosition = FlxG.sound.music.time;
    }

    if (controls.BACK)
    {
      MusicBeatState.switchState(new MainMenuState());
    }

    wave.time = Conductor.songPosition / 1000;
    wave.update(elapsed);

    super.update(elapsed);
  }
}
#end