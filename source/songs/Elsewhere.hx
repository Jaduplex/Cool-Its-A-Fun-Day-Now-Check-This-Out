package songs;

import backend.TextAndLanguage;

/**
 * Elsewhere's song class.
 */
class Elsewhere extends SongClass
{
  public override function new()
  {
    super();
    this.songNameForDisplay = 'Elsewhere';
    this.playable = BF;
    this.songHasSections = false;
    this.introType = 'Eggshells';
    this.gameoverChar = 'bf-dead';
    this.gameoverMusicSuffix = '';
    this.songVariants = ["Normal"];
    this.songDescription = TextAndLanguage.getPhrase('desc_elsewhere', "Gary shows you that maybe this world isn't as great as you thought it was.");
    this.ratingsType = "";
    this.skipCountdown = false;
    this.preloadCharacters = ["bf-mark", "gf", "stop-loading"];
    this.introCardBeat = 0;
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