package backend;

import backend.Controls;
import flixel.FlxG;
import flixel.util.FlxSignal;

/**
 * Additional controls handling.
 * Also handles gamepads.
 */
class PlayerSettings
{
  static public var numPlayers(default, null) = 0;
  static public var numAvatars(default, null) = 0;
  static public var player1(default, null):PlayerSettings;
  static public var player2(default, null):PlayerSettings;

  static public final onAvatarAdd = new FlxTypedSignal<PlayerSettings->Void>();
  static public final onAvatarRemove = new FlxTypedSignal<PlayerSettings->Void>();

  public var id(default, null):Int;

  public final controls:Controls;

  /**
   * Create a new PlayerSettings.
   * @param id Player ID.
   * @param scheme Default scheme.
   */
  function new(id, scheme)
  {
    this.id = id;
    this.controls = new Controls('player$id', scheme);
  }

  /**
   * Sets the keyboard scheme.
   * @param scheme The scheme you want to set it to.
   */
  public function setKeyboardScheme(scheme)
  {
    controls.setKeyboardScheme(scheme);
  }

  static public function init():Void
  {
    if (player1 == null)
    {
      player1 = new PlayerSettings(0, Solo);

      ++numPlayers;
    }

    var numGamepads = FlxG.gamepads.numActiveGamepads;

    if (numGamepads > 0)
    {
      var gamepad = FlxG.gamepads.getByID(0);

      #if DEVELOPERBUILD
      if (gamepad == null)
      {
        throw 'Unexpected null gamepad. id:0';
      }
      #end

      player1.controls.addDefaultGamepad(0);
    }

    if (numGamepads > 1)
    {
      if (player2 == null)
      {
        player2 = new PlayerSettings(1, None);
        ++numPlayers;
      }

      var gamepad = FlxG.gamepads.getByID(1);

      #if DEVELOPERBUILD
      if (gamepad == null)
      {
        throw 'Unexpected null gamepad. id:0';
      }
      #end

      player2.controls.addDefaultGamepad(1);
    }
  }

  static public function reset()
  {
    player1 = null;
    player2 = null;
    numPlayers = 0;
  }
}