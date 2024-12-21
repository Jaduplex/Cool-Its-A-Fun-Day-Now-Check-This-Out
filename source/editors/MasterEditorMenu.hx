#if DEVELOPERBUILD
package editors;

import visuals.PixelPerfectSprite;
import util.CoolUtil;
import visuals.Character;
import states.MainMenuState;
import ui.Alphabet;
#if desktop
import backend.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.MusicBeatState;

class MasterEditorMenu extends MusicBeatState
{
  var options:Array<String> = ['Character Editor', 'Chart Editor', 'Shader Test', 'Video Test', 'Waveform Test'];
  private var grpTexts:FlxTypedGroup<Alphabet>;
  private var directories:Array<String> = [null];

  private var curSelected = 0;
  private var curDirectory = 0;
  private var directoryTxt:FlxText;

  override function create()
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Total MasterEditorMenu create()");
    #end

    FlxG.camera.bgColor = FlxColor.BLACK;

    #if desktop
    DiscordClient.changePresence("Editors Main Menu", null, null, '-menus');
    #end

    CoolUtil.newStateMemStuff();

    var bg:PixelPerfectSprite = new PixelPerfectSprite().loadGraphic(Paths.image('bg/menuDesat'));
    bg.scrollFactor.set();
    bg.color = 0xFF353535;
    add(bg);

    grpTexts = new FlxTypedGroup<Alphabet>();
    add(grpTexts);

    for (i in 0...options.length)
    {
      var leText:Alphabet = new Alphabet(90, 320, options[i], true);
      leText.isMenuItem = true;
      leText.targetY = i;
      grpTexts.add(leText);
      leText.snapToPosition();
    }

    changeSelection();

    FlxG.mouse.visible = false;
    super.create();

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  override function update(elapsed:Float)
  {
    if (controls.UI_UP_P)
    {
      changeSelection(-1);
    }

    if (controls.UI_DOWN_P)
    {
      changeSelection(1);
    }

    if (controls.BACK)
    {
      MusicBeatState.switchState(new MainMenuState());
    }

    if (controls.ACCEPT)
    {
      switch (options[curSelected])
      {
        case 'Character Editor':
          MusicBeatState.switchState(new CharacterEditorState(Character.DEFAULT_CHARACTER, false));
        case 'Chart Editor':
          MusicBeatState.switchState(new ChartingState());
        case 'Shader Test':
          MusicBeatState.switchState(new ShadersTestState());
        case 'Video Test':
          MusicBeatState.switchState(new VideoTestState());
        case 'Waveform Test':
          MusicBeatState.switchState(new WaveformTestState());
      }

      FlxG.sound.music.volume = 0;
    }

    var bullShit:Int = 0;

    for (item in grpTexts.members)
    {
      item.targetY = bullShit - curSelected;
      bullShit++;

      item.alpha = 0.6;

      if (item.targetY == 0)
      {
        item.alpha = 1;
      }
    }

    super.update(elapsed);
  }

  function changeSelection(change:Int = 0)
  {
    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

    curSelected += change;

    if (curSelected < 0)
    {
      curSelected = options.length - 1;
    }

    if (curSelected >= options.length)
    {
      curSelected = 0;
    }
  }
}
#end