package songs;

/**
 * Song class template.
 */
class SongTemplate extends SongClass
{
  public override function new()
  {
    super();
    this.songNameForDisplay = 'Template Song';
    this.playable = BF;
    this.songHasSections = false;
    this.introType = 'Default';
    this.songVariants = ["Normal"];
    this.songDescription = "Placeholder";
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