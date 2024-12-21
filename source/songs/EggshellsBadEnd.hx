package songs;

import backend.TextAndLanguage;

/**
 * Eggshells' song class. (Bad Ending)
 */
class EggshellsBadEnd extends SongClass
{
  public override function new()
  {
    super();
    this.songNameForDisplay = 'Eggshells (Bad Ending)';
    this.playable = BF;
    this.songHasSections = false;
    this.introType = 'Eggshells';
    this.gameoverChar = 'bf-dead';
    this.gameoverMusicSuffix = '';
    this.songVariants = ["Normal"];
    // songVariants doesnt matter for the ending classes (since theyre just loaded in by force at the end of eggshells' dialogue)
    this.songDescription = TextAndLanguage.getPhrase('desc_eggshells_bad', "Well, that could've gone better.");
    this.ratingsType = "";
    this.skipCountdown = false;
    this.preloadCharacters = ["bf-mark", "gf", "stop-loading"];
    this.introCardBeat = 999999;
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