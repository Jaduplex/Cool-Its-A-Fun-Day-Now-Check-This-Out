package backend;

/**
 * Section typedef.
 * @param sectionNotes The notes in the section.
 * @param sectionBeats The quantity of beats in the section.
 * @param typeOfSection I'm... not sure what this is.
 * @param mustHitSection Which player the camera should focus on. True = Player, False = Opponent.
 * @param gfSection Focus camera on GF instead, and make opponent notes be sung by her.
 * @param bpm Target BPM for changeBPM. Does nothing if that isn't enabled.
 * @param changeBPM Is there a tempo change in this section?
 * @param altAnim Is this an alternate animation section?
 * @param middleCamSection Focus on the middle of the two players instead. Broken on songs that aren't Destitution for some reason.
 */
typedef SwagSection =
{
  var sectionNotes:Array<Dynamic>;
  var sectionBeats:Float;
  var typeOfSection:Int;
  var mustHitSection:Bool;
  var gfSection:Bool;
  var bpm:Float;
  var changeBPM:Bool;
  var altAnim:Bool;
  var middleCamSection:Bool;
}

/**
 * A Section.
 */
class Section
{
  public var sectionNotes:Array<Dynamic> = [];

  public var sectionBeats:Float = 4;
  public var gfSection:Bool = false;
  public var typeOfSection:Int = 0;
  public var mustHitSection:Bool = true;
  public var middleCamSection:Bool = false;

  public function new(sectionBeats:Float = 4)
  {
    this.sectionBeats = sectionBeats;
  }
}