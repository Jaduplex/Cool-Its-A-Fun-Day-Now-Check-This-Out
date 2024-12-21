package backend;

import flixel.FlxG;

/**
 * Handles all song score data.
 */
class Highscore
{
  public static var songScores:Map<String, Int> = new Map();
  public static var songRating:Map<String, Float> = new Map();

  /**
   * Reset a song's score and rating.
   * @param song The song name.
   */
  public static function resetSong(song:String):Void
  {
    var daSong:String = formatSong(song);

    setScore(daSong, 0);
    setRating(daSong, 0);
  }

  /**
   * The math floor function, but for the decimal point in a decimal.
   * @param value Value to floor.
   * @param decimals Level of decimals.
   * @return Value, floored.
   */
  public static function floorDecimal(value:Float, decimals:Int):Float
  {
    if (decimals < 1)
    {
      return Math.floor(value);
    }

    var tempMult:Float = 1;

    for (i in 0...decimals)
    {
      tempMult *= 10;
    }

    var newValue:Float = Math.floor(value * tempMult);

    return newValue / tempMult;
  }

  /**
   * Save a song's score and rating.
   * Won't override high scores.
   * @param song The song name.
   * @param score The score.
   * @param rating The rating.
   */
  public static function saveScore(song:String, score:Int = 0, ?rating:Float = -1):Void
  {
    var daSong:String = formatSong(song);

    if (songScores.exists(daSong))
    {
      if (songScores.get(daSong) < score)
      {
        setScore(daSong, score);

        if (rating >= 0)
        {
          setRating(daSong, rating);
        }
      }
    }
    else
    {
      setScore(daSong, score);

      if (rating >= 0)
      {
        setRating(daSong, rating);
      }
    }
  }

  /**
   * Actually set a score value.
   * WILL override high scores, this is why saveScore exists.
   * @param song The song name.
   * @param score The score.
   */
  static function setScore(song:String, score:Int):Void
  {
    songScores.set(song, score);

    FlxG.save.data.songScores = songScores;

    FlxG.save.flush();
  }

  /**
   * Actually set a rating value.
   * WILL override highest rating, this is why saveScore exists.
   * @param song The song name.
   * @param rating The rating.
   */
  static function setRating(song:String, rating:Float):Void
  {
    songRating.set(song, rating);

    FlxG.save.data.songRating = songRating;

    FlxG.save.flush();
  }

  /**
   * Just runs Paths.fromatToSongPath.
   * Not sure why this is here.
   * @param song The song name.
   * @return Literally just the song run through Paths.formatToSongPath. Why.
   */
  public static function formatSong(song:String):String
  {
    return Paths.formatToSongPath(song);
  }

  /**
   * Get a song's score.
   * @param song The song name.
   * @return The player's highest score on the song.
   */
  public static function getScore(song:String):Int
  {
    var daSong:String = formatSong(song);

    if (!songScores.exists(daSong))
    {
      setScore(daSong, 0);
    }

    return songScores.get(daSong);
  }

  /**
   * Get a song's rating.
   * @param song The song name.
   * @return The player's highest rating on the song.
   */
  public static function getRating(song:String):Float
  {
    var daSong:String = formatSong(song);

    if (!songRating.exists(daSong))
    {
      setRating(daSong, 0);
    }

    return songRating.get(daSong);
  }

  /**
   * Loads song score data.
   */
  public static function load():Void
  {
    if (FlxG.save.data.songScores != null)
    {
      songScores = FlxG.save.data.songScores;
    }

    if (FlxG.save.data.songRating != null)
    {
      songRating = FlxG.save.data.songRating;
    }
  }
}