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
      case 'fnf-the-supervista':
        returnSong = new Supervista();
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