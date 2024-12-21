package backend;

import openfl.utils.Assets;
import haxe.Json;
import backend.Song;

/**
 * Stage typedef.
 * @param defaultZoom The stage's starting camera zoom.
 * @param boyfriend The stage's starting player position.
 * @param girlfriend The stage's starting middle character position.
 * @param opponent The stage's starting opponent position.
 * @param hide_girlfriend Do you want to hide the middle character on this stage?
 * @param camera_boyfriend The stage's player camera offset.
 * @param camera_opponent The stage's opponent camera offset.
 * @param camera_girlfriend The stage's middle character camera offset.
 * @param camera_speed The stage's camera speed multiplier.
 * @param artist The artist who made the stage's graphics.
 */
typedef StageFile =
{
  var defaultZoom:Float;

  var boyfriend:Array<Dynamic>;
  var girlfriend:Array<Dynamic>;
  var opponent:Array<Dynamic>;

  var hide_girlfriend:Bool;

  var camera_boyfriend:Array<Float>;
  var camera_opponent:Array<Float>;
  var camera_girlfriend:Array<Float>;
  var camera_speed:Null<Float>;

  var artist:String;
}

/**
 * Stage data class.
 */
class StageData
{
  /**
   * Loads a stage, but in... a different way?
   * Why is this here?
   * @param SONG The song, I guess.
   */
  public static function loadDirectory(SONG:SwagSong)
  {
    var stage:String = '';

    if (SONG.stage != null)
    {
      stage = SONG.stage;
    }
    else
    {
      stage = 'mark';
    }

    var stageFile:StageFile = getStageFile(stage);
  }

  /**
   * Loads and returns a stage's data.
   * @param stage The stage to load.
   * @return The stage's data.
   */
  public static function getStageFile(stage:String):StageFile
  {
    var rawJson:String = null;

    var path:String = Paths.getPreloadPath('stages/' + stage + '.json');

    if (Assets.exists(path))
    {
      rawJson = Assets.getText(path);
    }
    else
    {
      return null;
    }

    return cast Json.parse(rawJson);
  }
}