package backend;

import states.InitState;
import backend.TextAndLanguage.Languages;
import util.CoolUtil;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import backend.Controls;

/**
 * Handles all global save data, such as options.
 */
class ClientPrefs
{
  public static var downScroll:Bool = false;
  public static var middleScroll:Bool = false;
  public static var opponentStrums:Bool = true;
  public static var showFPS:Bool = false;
  public static var flashing:Bool = true;
  public static var globalAntialiasing:Bool = true;
  public static var noteSplashes:Bool = true;
  public static var lowQuality:Bool = false;
  public static var shaders:Bool = true;
  public static var framerate:Int = 240;
  public static var camZooms:Bool = true;
  public static var hideHud:Bool = false;
  public static var noteOffset:Int = 0;
  public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
  public static var ghostTapping:Bool = true;
  public static var timeBarType:String = 'Time Left';
  public static var scoreZoom:Bool = true;
  public static var noReset:Bool = false;
  public static var controllerMode:Bool = false;
  public static var hitsoundVolume:Float = 0;
  public static var comboStacking = false;
  public static var smootherBars = true;
  public static var pixelPerfection = true;
  public static var multithreading = true;

  public static var boiners:Int = 0;

  public static var unlockedQuanta:Bool = false;
  public static var unlockedAbstraction:Bool = false;
  public static var unlockedBoozeLoze:Bool = false;

  public static var unlockedGfMixes:Bool = false;
  public static var unlockedPearMixes:Bool = false;
  public static var unlockedMarkMixes:Bool = false;
  public static var unlockedKarmMixes:Bool = false;
  public static var unlockedYuuMixes:Bool = false;
  public static var unlockedEviMixes:Bool = false;
  public static var unlockedArgulowMixes:Bool = false;
  public static var unlockedBaldiMixes:Bool = false;

  public static var gameplaySettings:Map<String, Dynamic> = [
    'scrollspeed' => 1.0,
    'scrolltype' => 'multiplicative',
    'songspeed' => 1.0,
    'healthgain' => 1.0,
    'healthloss' => 1.0,
    'instakill' => false,
    'practice' => false,
    'botplay' => false,
    'opponentplay' => false
  ];

  public static var comboOffset:Array<Int> = [0, 0, 0, 0];
  public static var ratingOffset:Int = 0;
  public static var synergyWindow:Int = 45;
  public static var goodWindow:Int = 90;
  public static var eghWindow:Int = 135;
  public static var bleghWindow:Int = 160;
  public static var safeFrames:Float = 10;

  public static var keyBinds:Map<String, Array<FlxKey>> = [
    'note_left' => [A, LEFT],
    'note_down' => [S, DOWN],
    'note_up' => [W, UP],
    'note_right' => [D, RIGHT],
    'ui_left' => [A, LEFT],
    'ui_down' => [S, DOWN],
    'ui_up' => [W, UP],
    'ui_right' => [D, RIGHT],
    'accept' => [SPACE, ENTER],
    'back' => [BACKSPACE, ESCAPE],
    'pause' => [ENTER, ESCAPE],
    'reset' => [R, NONE],
    'volume_mute' => [ZERO, NONE],
    'volume_up' => [NUMPADPLUS, PLUS],
    'volume_down' => [NUMPADMINUS, MINUS],
    'debug_1' => [SEVEN, NONE],
    'debug_2' => [EIGHT, NONE]
  ];

  public static var defaultKeys:Map<String, Array<FlxKey>> = null;

  public static var language:Languages = ENGLISH;

  public static var lastEggshellsEnding:String = '';

  public static function loadDefaultKeys()
  {
    defaultKeys = keyBinds.copy();
  }

  /**
   * Save current options configuration.
   */
  public static function saveSettings()
  {
    FlxG.save.data.downScroll = downScroll;
    FlxG.save.data.middleScroll = middleScroll;
    FlxG.save.data.opponentStrums = opponentStrums;
    FlxG.save.data.showFPS = showFPS;
    FlxG.save.data.flashing = flashing;
    FlxG.save.data.globalAntialiasing = globalAntialiasing;
    FlxG.save.data.noteSplashes = noteSplashes;
    FlxG.save.data.lowQuality = lowQuality;
    FlxG.save.data.shaders = shaders;
    FlxG.save.data.framerate = framerate;
    FlxG.save.data.camZooms = camZooms;
    FlxG.save.data.noteOffset = noteOffset;
    FlxG.save.data.hideHud = hideHud;
    FlxG.save.data.arrowHSV = arrowHSV;
    FlxG.save.data.ghostTapping = ghostTapping;
    FlxG.save.data.timeBarType = timeBarType;
    FlxG.save.data.scoreZoom = scoreZoom;
    FlxG.save.data.noReset = noReset;
    FlxG.save.data.comboOffset = comboOffset;
    FlxG.save.data.ratingOffset = ratingOffset;
    FlxG.save.data.synergyWindow = synergyWindow;
    FlxG.save.data.goodWindow = goodWindow;
    FlxG.save.data.eghWindow = eghWindow;
    FlxG.save.data.bleghWindow = bleghWindow;
    FlxG.save.data.safeFrames = safeFrames;
    FlxG.save.data.gameplaySettings = gameplaySettings;
    FlxG.save.data.controllerMode = controllerMode;
    FlxG.save.data.hitsoundVolume = hitsoundVolume;
    FlxG.save.data.comboStacking = comboStacking;
    FlxG.save.data.smootherBars = smootherBars;
    FlxG.save.data.pixelPerfection = pixelPerfection;
    FlxG.save.data.multithreading = multithreading;
    FlxG.save.data.boiners = boiners;
    FlxG.save.data.lastEggshellsEnding = lastEggshellsEnding;
    FlxG.save.data.language = language;

    FlxG.save.data.unlockedQuanta = unlockedQuanta;
    FlxG.save.data.unlockedBoozeLoze = unlockedBoozeLoze;
    FlxG.save.data.unlockedAbstraction = unlockedAbstraction;

    FlxG.save.data.unlockedGfMixes = unlockedGfMixes;
    FlxG.save.data.unlockedPearMixes = unlockedPearMixes;
    FlxG.save.data.unlockedMarkMixes = unlockedMarkMixes;
    FlxG.save.data.unlockedKarmMixes = unlockedKarmMixes;
    FlxG.save.data.unlockedYuuMixes = unlockedYuuMixes;
    FlxG.save.data.unlockedEviMixes = unlockedEviMixes;
    FlxG.save.data.unlockedArgulowMixes = unlockedArgulowMixes;
    FlxG.save.data.unlockedBaldiMixes = unlockedBaldiMixes;

    FlxG.save.flush();

    var save:FlxSave = new FlxSave();
    save.bind('controls', CoolUtil.savePath);
    save.data.customControls = keyBinds;
    save.flush();
  }

  /**
   * Load all saved data.
   */
  public static function loadPrefs()
  {
    if (FlxG.save.data.language != null)
    {
      language = FlxG.save.data.language;
    }

    if (FlxG.save.data.downScroll != null)
    {
      downScroll = FlxG.save.data.downScroll;
    }

    if (FlxG.save.data.middleScroll != null)
    {
      middleScroll = FlxG.save.data.middleScroll;
    }

    if (FlxG.save.data.opponentStrums != null)
    {
      opponentStrums = FlxG.save.data.opponentStrums;
    }

    if (FlxG.save.data.showFPS != null)
    {
      showFPS = FlxG.save.data.showFPS;

      if (Main.fpsVar != null)
      {
        Main.fpsVar.visible = showFPS;
      }
    }

    if (FlxG.save.data.flashing != null)
    {
      flashing = FlxG.save.data.flashing;
    }

    if (FlxG.save.data.globalAntialiasing != null)
    {
      globalAntialiasing = FlxG.save.data.globalAntialiasing;
    }

    if (FlxG.save.data.noteSplashes != null)
    {
      noteSplashes = FlxG.save.data.noteSplashes;
    }

    if (FlxG.save.data.lowQuality != null)
    {
      lowQuality = FlxG.save.data.lowQuality;
    }

    if (FlxG.save.data.shaders != null)
    {
      shaders = FlxG.save.data.shaders;
    }

    if (FlxG.save.data.framerate != null)
    {
      framerate = FlxG.save.data.framerate;

      if (framerate > FlxG.drawFramerate)
      {
        FlxG.updateFramerate = framerate;
        FlxG.drawFramerate = framerate;
      }
      else
      {
        FlxG.drawFramerate = framerate;
        FlxG.updateFramerate = framerate;
      }

      FlxG.game.focusLostFramerate = framerate;
    }

    if (FlxG.save.data.camZooms != null)
    {
      camZooms = FlxG.save.data.camZooms;
    }

    if (FlxG.save.data.hideHud != null)
    {
      hideHud = FlxG.save.data.hideHud;
    }

    if (FlxG.save.data.noteOffset != null)
    {
      noteOffset = FlxG.save.data.noteOffset;
    }

    if (FlxG.save.data.arrowHSV != null)
    {
      arrowHSV = FlxG.save.data.arrowHSV;
    }

    if (FlxG.save.data.ghostTapping != null)
    {
      ghostTapping = FlxG.save.data.ghostTapping;
    }

    if (FlxG.save.data.timeBarType != null)
    {
      timeBarType = FlxG.save.data.timeBarType;
    }

    if (FlxG.save.data.scoreZoom != null)
    {
      scoreZoom = FlxG.save.data.scoreZoom;
    }

    if (FlxG.save.data.noReset != null)
    {
      noReset = FlxG.save.data.noReset;
    }

    if (FlxG.save.data.comboOffset != null)
    {
      comboOffset = FlxG.save.data.comboOffset;
    }

    if (FlxG.save.data.ratingOffset != null)
    {
      ratingOffset = FlxG.save.data.ratingOffset;
    }

    if (FlxG.save.data.synergyWindow != null)
    {
      synergyWindow = FlxG.save.data.synergyWindow;
    }

    if (FlxG.save.data.goodWindow != null)
    {
      goodWindow = FlxG.save.data.goodWindow;
    }

    if (FlxG.save.data.eghWindow != null)
    {
      eghWindow = FlxG.save.data.eghWindow;
    }

    if (FlxG.save.data.bleghWindow != null)
    {
      bleghWindow = FlxG.save.data.bleghWindow;
    }

    if (FlxG.save.data.safeFrames != null)
    {
      safeFrames = FlxG.save.data.safeFrames;
    }

    if (FlxG.save.data.controllerMode != null)
    {
      controllerMode = FlxG.save.data.controllerMode;
    }

    if (FlxG.save.data.hitsoundVolume != null)
    {
      hitsoundVolume = FlxG.save.data.hitsoundVolume;
    }

    if (FlxG.save.data.boiners != null)
    {
      boiners = FlxG.save.data.boiners;
    }

    if (FlxG.save.data.gameplaySettings != null)
    {
      var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;

      for (name => value in savedMap)
      {
        gameplaySettings.set(name, value);
      }
    }

    if (FlxG.save.data.volume != null)
    {
      FlxG.sound.volume = FlxG.save.data.volume;
    }

    if (FlxG.save.data.mute != null)
    {
      FlxG.sound.muted = FlxG.save.data.mute;
    }

    if (FlxG.save.data.comboStacking != null)
    {
      comboStacking = FlxG.save.data.comboStacking;
    }

    if (FlxG.save.data.smootherBars != null)
    {
      smootherBars = FlxG.save.data.smootherBars;
    }

    if (FlxG.save.data.pixelPerfection != null)
    {
      pixelPerfection = FlxG.save.data.pixelPerfection;
    }

    if (FlxG.save.data.multithreading != null)
    {
      multithreading = FlxG.save.data.multithreading;
    }

    if (FlxG.save.data.lastEggshellsEnding != null)
    {
      lastEggshellsEnding = FlxG.save.data.lastEggshellsEnding;
    }

    if (FlxG.save.data.unlockedQuanta != null)
    {
      unlockedQuanta = FlxG.save.data.unlockedQuanta;
    }

    if (FlxG.save.data.unlockedBoozeLoze != null)
    {
      unlockedBoozeLoze = FlxG.save.data.unlockedBoozeLoze;
    }

    if (FlxG.save.data.unlockedAbstraction != null)
    {
      unlockedAbstraction = FlxG.save.data.unlockedAbstraction;
    }

    if (FlxG.save.data.unlockedGfMixes != null)
    {
      unlockedGfMixes = FlxG.save.data.unlockedGfMixes;
    }

    if (FlxG.save.data.unlockedPearMixes != null)
    {
      unlockedPearMixes = FlxG.save.data.unlockedPearMixes;
    }

    if (FlxG.save.data.unlockedMarkMixes != null)
    {
      unlockedMarkMixes = FlxG.save.data.unlockedMarkMixes;
    }

    if (FlxG.save.data.unlockedKarmMixes != null)
    {
      unlockedKarmMixes = FlxG.save.data.unlockedKarmMixes;
    }

    if (FlxG.save.data.unlockedYuuMixes != null)
    {
      unlockedYuuMixes = FlxG.save.data.unlockedYuuMixes;
    }

    if (FlxG.save.data.unlockedEviMixes != null)
    {
      unlockedEviMixes = FlxG.save.data.unlockedEviMixes;
    }

    if (FlxG.save.data.unlockedArgulowMixes != null)
    {
      unlockedArgulowMixes = FlxG.save.data.unlockedArgulowMixes;
    }

    if (FlxG.save.data.unlockedBaldiMixes != null)
    {
      unlockedBaldiMixes = FlxG.save.data.unlockedBaldiMixes;
    }

    var save:FlxSave = new FlxSave();

    save.bind('controls', CoolUtil.savePath);

    if (save != null && save.data.customControls != null)
    {
      var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;

      for (control => keys in loadedControls)
      {
        keyBinds.set(control, keys);
      }

      reloadControls();
    }
  }

  /**
   * Returns the value of a Gameplay Setting (set by user in GameplayChangersSubstate).
   * @param name The name of the gameplay setting you're retrieving.
   * @param defaultValue The default value of the gameplay setting you're retrieving. Will be used if no user setting is found.
   * @return The current value of the gameplay setting you're retrieving.
   */
  inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic
  {
    return (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
  }

  /**
   * Reload controls.
   */
  public static function reloadControls()
  {
    PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

    InitState.muteKeys = copyKey(keyBinds.get('volume_mute'));
    InitState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
    InitState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));

    FlxG.sound.muteKeys = InitState.muteKeys;
    FlxG.sound.volumeDownKeys = InitState.volumeDownKeys;
    FlxG.sound.volumeUpKeys = InitState.volumeUpKeys;
  }

  public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey>
  {
    var copiedArray:Array<FlxKey> = arrayToCopy.copy();
    var i:Int = 0;
    var len:Int = copiedArray.length;

    while (i < len)
    {
      if (copiedArray[i] == NONE)
      {
        copiedArray.remove(NONE);
        --i;
      }

      i++;

      len = copiedArray.length;
    }

    return copiedArray;
  }
}