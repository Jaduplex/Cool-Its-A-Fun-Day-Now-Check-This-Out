package options;

import ui.Alphabet;
import visuals.Character;
import backend.ClientPrefs;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
  public function new()
  {
    title = 'Graphics';
    rpcTitle = 'Graphics Settings Menu'; // for Discord Rich Presence
    backGroundColor = 0xff803353;

    // I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
    var option:Option = new Option('Low Quality', // Name
      'If checked, disables some background details,\ndecreases loading times and improves performance.', // Description
      'lowQuality', // Save data variable name
      'bool', // Variable type
      false); // Default value
    addOption(option);

    var option:Option = new Option('Anti-Aliasing', 'If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.',
      'globalAntialiasing', 'bool', true);
    option.showSprites = 'antialiasing';
    option.onChange = onChangeAntiAliasing; // Changing onChange is only needed if you want to make a special interaction after it changes the value
    addOption(option);

    var option:Option = new Option('Shaders', // Name
      'If unchecked, disables shaders.\nIt\'s used for some visual effects, and also CPU intensive for weaker PCs.', // Description
      'shaders', // Save data variable name
      'bool', // Variable type
      true); // Default value
    addOption(option);

    var option:Option = new Option('Pixel Perfect Graphics', // Name
      'If unchecked, disables pixel perfect graphics.\nI know some people won\'t like how it looks, so you get a toggle.', // Description
      'pixelPerfection', // Save data variable name
      'bool', // Variable type
      true); // Default value
    addOption(option);

    var option:Option = new Option('Multithreading', // Name
      'If unchecked, disables multithreading.\nDisabling multithreading will cause certain things to lag spike more, but will most likely fix issues on lower end PCs.', // Description
      'multithreading', // Save data variable name
      'bool', // Variable type
      true); // Default value
    addOption(option);

    #if !html5 // Apparently other framerates isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
    var option:Option = new Option('Framerate:', "Pretty self explanatory, isn't it?", 'framerate', 'int', 240);
    addOption(option);

    option.minValue = 30;
    option.maxValue = 240;
    option.displayFormat = '%v FPS';
    option.onChange = onChangeFramerate;
    #end

    super();
  }

  function onChangeAntiAliasing():Void
  {
    for (sprite in members)
    {
      var sprite:Dynamic = sprite; // Make it check for FlxSprite instead of FlxBasic
      var sprite:FlxSprite = sprite; // Don't judge me ok
      if (sprite != null && (sprite is FlxSprite))
      {
        if ((sprite is Character))
        {
          var sprChar:Dynamic = sprite;
          var sprChar:Character = sprChar;

          if (!sprChar.noAntialiasing)
          {
            sprChar.antialiasing = ClientPrefs.globalAntialiasing;
          }
        }
        else if ((sprite is Alphabet))
        {
          var sprAlph:Dynamic = sprite;
          var sprAlph:Alphabet = sprAlph;

          if (!sprAlph.options)
          {
            sprAlph.antialiasing = ClientPrefs.globalAntialiasing;
          }
        }
        else if (!(sprite is FlxText))
        {
          sprite.antialiasing = ClientPrefs.globalAntialiasing;
        }
      }
    }
  }

  function onChangeFramerate():Void
  {
    if (ClientPrefs.framerate > FlxG.drawFramerate)
    {
      FlxG.updateFramerate = ClientPrefs.framerate;
      FlxG.drawFramerate = ClientPrefs.framerate;
    }
    else
    {
      FlxG.drawFramerate = ClientPrefs.framerate;
      FlxG.updateFramerate = ClientPrefs.framerate;
    }

    FlxG.game.focusLostFramerate = Std.int(ClientPrefs.framerate / 12);
  }
}