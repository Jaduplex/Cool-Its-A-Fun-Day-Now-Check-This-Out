package options;

import backend.ClientPrefs;
import flixel.FlxG;

class VisualsUISubState extends BaseOptionsMenu
{
  public function new()
  {
    title = 'Visuals and UI';
    rpcTitle = 'Visuals & UI Settings Menu'; // for Discord Rich Presence
    backGroundColor = 0xff547e7a;

    var option:Option = new Option('Note Splashes', "If unchecked, hitting \"Synergy!\" notes won't show particles.", 'noteSplashes', 'bool', true);
    addOption(option);

    var option:Option = new Option('Hide HUD', 'If checked, hides most HUD elements.', 'hideHud', 'bool', false);
    addOption(option);

    var option:Option = new Option('Flashing Lights', "Uncheck this if you're sensitive to flashing lights!", 'flashing', 'bool', true);
    addOption(option);

    var option:Option = new Option('Camera Zooms', "If unchecked, the camera won't zoom in on a beat hit.", 'camZooms', 'bool', true);
    addOption(option);

    var option:Option = new Option('Score Text Zoom on Hit', "If unchecked, disables the Score text zooming\neverytime you hit a note.", 'scoreZoom', 'bool',
      true);
    addOption(option);

    #if !SHOWCASEVIDEO
    var option:Option = new Option('FPS Counter', 'If unchecked, hides FPS Counter.', 'showFPS', 'bool', false);
    addOption(option);
    option.onChange = onChangeFPSCounter;
    #end

    var option:Option = new Option('Combo Stacking', "If checked, combo graphics will stack like in basegame FNF.", 'comboStacking', 'bool', false);
    addOption(option);

    var option:Option = new Option('Smoother Bars',
      "If checked, bars such as the health bar will be subdivided more, resulting in smoother movement. This also leads to more CPU usage!", 'smootherBars',
      'bool', false);
    addOption(option);

    var option:Option = new Option('Time Block:', "What should the Time Block display over the song duration?", 'timeBarType', 'string', 'Time Left',
      ['Time Left', 'Time Elapsed', 'Disabled']);
    addOption(option);

    super();
  }

  var changedMusic:Bool = false;

  override function destroy()
  {
    if (changedMusic)
    {
      FlxG.sound.playMusic(Paths.music('mus_machinations'));
    }

    super.destroy();
  }

  #if !mobile
  function onChangeFPSCounter()
  {
    if (Main.fpsVar != null)
    {
      Main.fpsVar.visible = ClientPrefs.showFPS;
    }
  }
  #end
}