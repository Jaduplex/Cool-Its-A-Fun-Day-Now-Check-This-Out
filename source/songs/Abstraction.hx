package songs;

import backend.TextAndLanguage;

/**
 * Abstraction's song class.
 */
class Abstraction extends SongClass
{
  public override function new()
  {
    super();
    this.songNameForDisplay = 'ABSTRACTION';
    this.playable = ARGULOW;
    this.songHasSections = false;
    this.introType = 'Mark';
    this.gameoverChar = 'bf-dead';
    this.gameoverMusicSuffix = '';
    this.songVariants = ["Normal"];
    this.songDescription = TextAndLanguage.getPhrase('desc_abstraction', "Experience the magic of Mark's very own self written television program firsthand!");
    this.ratingsType = "";
    this.skipCountdown = true;
    this.preloadCharacters = ["bf-mark", "gf", "stop-loading"];
    this.introCardBeat = 0;
    this.rpcVolume = "-argulow";
  }

  public override function stepHitEvent(curStep:Float)
  {
    // this is where step hit events go
    super.stepHitEvent(curStep);
  }

  public override function beatHitEvent(curBeat:Float)
  {
    // this is where beat hit events go
    super.beatHitEvent(curBeat);
  }
}