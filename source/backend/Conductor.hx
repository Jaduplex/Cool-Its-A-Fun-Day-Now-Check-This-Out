package backend;

import backend.Song.SwagSong;

/**
 * BPM change event.
 * @param stepTime Current step, I'm pretty sure?
 * @param songTime Current song time, in milliseconds.
 * @param bpm Target tempo.
 * @param stepCrochet Target step crochet? I think? I'm confused.
 */
typedef BPMChangeEvent =
{
  var stepTime:Int;
  var songTime:Float;
  var bpm:Float;
  @:optional var stepCrochet:Float;
}

/**
 * Handles all tempo, beat, step, and section things.
 */
class Conductor
{
  public static var bpm:Float = 100;
  public static var crochet:Float = ((60 / bpm) * 1000);
  public static var stepCrochet:Float = crochet / 4;
  public static var songPosition:Float = 0;
  public static var lastSongPos:Float;
  public static var offset:Float = 0;

  public static var safeZoneOffset:Float = (ClientPrefs.safeFrames / 60) * 1000;

  public static var bpmChangeMap:Array<BPMChangeEvent> = [];

  public function new() {}

  /**
   * Get the crotchet for a certain time.
   * @param time The time you want the crotchet for.
   * @return The crotchet for that time.
   */
  public static function getCrotchetAtTime(time:Float)
  {
    var lastChange = getBPMFromSeconds(time);

    return lastChange.stepCrochet * 4;
  }

  /**
   * Get the BPM for a certain second in the song.
   * @param time The second you want the BPM of.
   * @return The BPM for that second.
   */
  public static function getBPMFromSeconds(time:Float)
  {
    var lastChange:BPMChangeEvent =
      {
        stepTime: 0,
        songTime: 0,
        bpm: bpm,
        stepCrochet: stepCrochet
      }

    for (i in 0...Conductor.bpmChangeMap.length)
    {
      if (time >= Conductor.bpmChangeMap[i].songTime)
      {
        lastChange = Conductor.bpmChangeMap[i];
      }
    }

    return lastChange;
  }

  /**
   * Get the BPM for a certain step in the song.
   * @param step The step you want the BPM of.
   * @return The BPM of that step.
   */
  public static function getBPMFromStep(step:Float)
  {
    var lastChange:BPMChangeEvent =
      {
        stepTime: 0,
        songTime: 0,
        bpm: bpm,
        stepCrochet: stepCrochet
      }

    for (i in 0...Conductor.bpmChangeMap.length)
    {
      if (Conductor.bpmChangeMap[i].stepTime <= step)
      {
        lastChange = Conductor.bpmChangeMap[i];
      }
    }

    return lastChange;
  }

  /**
   * Get the time of a beat in seconds.
   * @param beat The beat you want the time of.
   * @return The time of that beat
   */
  public static function beatToSeconds(beat:Float):Float
  {
    var step = beat * 4;
    var lastChange = getBPMFromStep(step);

    return lastChange.songTime + ((step - lastChange.stepTime) / (lastChange.bpm / 60) / 4) * 1000;
  }

  public static function getStep(time:Float)
  {
    var lastChange = getBPMFromSeconds(time);

    return lastChange.stepTime + (time - lastChange.songTime) / lastChange.stepCrochet;
  }

  public static function getStepRounded(time:Float)
  {
    var lastChange = getBPMFromSeconds(time);

    return lastChange.stepTime + Math.floor(time - lastChange.songTime) / lastChange.stepCrochet;
  }

  public static function getBeat(time:Float)
  {
    return getStep(time) / 4;
  }

  public static function getBeatRounded(time:Float):Int
  {
    return Math.floor(getStepRounded(time) / 4);
  }

  /**
   * Set up all BPM changes for a song.
   * @param song The song data you want to map BPM changes from.
   */
  public static function mapBPMChanges(song:SwagSong)
  {
    bpmChangeMap = [];

    var curBPM:Float = song.bpm;
    var totalSteps:Int = 0;
    var totalPos:Float = 0;

    for (i in 0...song.notes.length)
    {
      if (song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
      {
        curBPM = song.notes[i].bpm;

        var event:BPMChangeEvent =
          {
            stepTime: totalSteps,
            songTime: totalPos,
            bpm: curBPM,
            stepCrochet: calculateCrochet(curBPM) / 4
          };

        bpmChangeMap.push(event);
      }

      var deltaSteps:Int = Math.round(getSectionBeats(song, i) * 4);

      totalSteps += deltaSteps;
      totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
    }
  }

  static function getSectionBeats(song:SwagSong, section:Int)
  {
    var val:Null<Float> = null;

    if (song.notes[section] != null)
    {
      val = song.notes[section].sectionBeats;
    }

    return val != null ? val : 4;
  }

  inline public static function calculateCrochet(bpm:Float)
  {
    return (60 / bpm) * 1000;
  }

  public static function changeBPM(newBpm:Float)
  {
    bpm = newBpm;

    crochet = calculateCrochet(bpm);

    stepCrochet = crochet / 4;
  }
}