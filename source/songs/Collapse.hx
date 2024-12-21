package songs;

import backend.TextAndLanguage;

/**
 * Collapse's song class.
 */
class Collapse extends SongClass
{
  public override function new()
  {
    super();
    this.songNameForDisplay = 'Collapse';
    this.playable = MARK;
    this.songHasSections = true;
    this.introType = 'Mark';
    this.gameoverChar = 'bf-dead';
    this.gameoverMusicSuffix = '';
    this.songVariants = ["Normal"];
    this.songDescription = TextAndLanguage.getPhrase('desc_collapse',
      "Mark's world is thrown for a loop when footage of him killing Nopeboy is leaked by his father. Now, it's time to end this, once and for all...");
    this.ratingsType = "";
    this.skipCountdown = false;
    this.preloadCharacters = ["bf-mark", "gf", "stop-loading"];
    this.introCardBeat = 0;
    this.rpcVolume = "-mark";
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