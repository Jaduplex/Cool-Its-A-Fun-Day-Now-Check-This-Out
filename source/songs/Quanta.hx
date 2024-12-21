package songs;

import backend.TextAndLanguage;

/**
 * Quanta's song class.
 */
class Quanta extends SongClass
{
  public override function new()
  {
    super();
    this.songNameForDisplay = 'Quanta';
    this.playable = ILI;
    this.songHasSections = false;
    this.introType = 'Default';
    this.songVariants = ["Normal"];
    this.songDescription = TextAndLanguage.getPhrase('desc_quanta', "A flashback of quantum proportions!");
    this.ratingsType = "";
    this.skipCountdown = false;
    this.preloadCharacters = ["bf-mark", "gf", "stop-loading"];
    this.introCardBeat = 0;
    this.rpcVolume = "-ili";
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