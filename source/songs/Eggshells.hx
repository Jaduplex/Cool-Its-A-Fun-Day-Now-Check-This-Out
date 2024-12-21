package songs;

import backend.TextAndLanguage;

/**
 * Eggshells' song class.
 */
class Eggshells extends SongClass
{
  public override function new()
  {
    super();
    this.songNameForDisplay = 'Eggshells';
    this.playable = BF;
    this.songHasSections = false;
    this.introType = 'Eggshells';
    this.gameoverChar = 'bf-dead';
    this.gameoverMusicSuffix = '';
    this.songVariants = ["Normal"];
    this.songDescription = TextAndLanguage.getPhrase('desc_eggshells',
      "Mark's lonely cousin seems like he's not much for conversation, but that won't stop Nopeboy from trying!");
    this.ratingsType = "";
    this.skipCountdown = true;
    this.preloadCharacters = ["gary", "bf-eggshells", "gf-eggshells", "stop-loading"];
    this.introCardBeat = 32;
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