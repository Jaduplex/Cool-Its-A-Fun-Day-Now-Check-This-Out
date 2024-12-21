package songs;

import backend.PlayablesData.Playables;
import states.PlayState;

/**
 * This class is used for storing song events and additional data, as opposed to crowding playstate.
 * each song has an override of it.
 */
class SongClass
{
  public var songNameForDisplay:String = "";

  public var playable:Playables = BF;

  public var introType:String = "Default";

  public var gameoverChar:String = "bf-dead";

  public var gameoverMusicSuffix:String = "";

  public var songDescription:String = 'Placeholder';

  public var songVariants:Array<String> = ["Normal"];

  public var songHasSections:Bool = false;

  public var ratingsType:String = "";

  public var skipCountdown:Bool = false;

  public var preloadCharacters:Array<String> = ["bf-mark", "gf", "stop-loading"];

  public var introCardBeat:Int = 0;

  public var rpcVolume:String = "";

  public function new() {}

  public function stepHitEvent(curStep:Float)
  {
    // this is where step hit events will be overrided by the song class
  }

  public function beatHitEvent(curBeat:Float)
  {
    // this is where beat hit events will be overrided by the song class

    if (curBeat == introCardBeat)
    {
      if (introCardBeat != 0)
      {
        PlayState.instance.songIntroCard();
      }
    }
  }
}