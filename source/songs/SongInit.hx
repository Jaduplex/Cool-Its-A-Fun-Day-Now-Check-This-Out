package songs;

import songs.*;

/**
 * This class is used for generating a song's proper class. kinda hacky but whatever.
 */
class SongInit
{
  public static function genSongObj(songName:String):SongClass
  {
    var returnSong:SongClass = null;

    switch (songName.toLowerCase())
    {
      case 'fundamentals':
        returnSong = new Fundamentals();
      case 'destitution':
        returnSong = new Destitution();
      case 'superseded':
        returnSong = new Superseded();
      case 'd-stitution':
        returnSong = new DStitution();
      case 'quickshot':
        returnSong = new Quickshot();
      case 'eggshells':
        returnSong = new Eggshells();
      case 'eggshells-bad':
        returnSong = new EggshellsBadEnd();
      case 'eggshells-good':
        returnSong = new EggshellsGoodEnd();
      case 'elsewhere':
        returnSong = new Elsewhere();
      case 'collapse':
        returnSong = new Collapse();
      case 'megamix':
        returnSong = new Megamix();
      case 'quanta':
        returnSong = new Quanta();
      case 'abstraction':
        returnSong = new Abstraction();
    }

    try
    {
      var fun:String = returnSong.introType;
    }
    catch (e:Dynamic)
    {
      throw "Error loading song object! Class is missing or not assigned in SongInit!";
    }

    return returnSong;
  }
}