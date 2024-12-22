package songs;

import backend.TextAndLanguage;

/**
 * THA SUPERVISTA
 */
class Supervista extends SongClass
{
  public override function new()
  {
    super();
    this.songNameForDisplay = 'FNF THE SUPERVISTA';
    this.playable = BF;
    this.songHasSections = false;
    this.introType = 'Default';
    this.songVariants = ["Normal"];
    this.songDescription = TextAndLanguage.getPhrase('desc_supervista', "they shoudlve called it something like supervista");
    this.ratingsType = "";
    this.skipCountdown = false;
    this.preloadCharacters = ["bf", "gf", "stop-loading"];
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