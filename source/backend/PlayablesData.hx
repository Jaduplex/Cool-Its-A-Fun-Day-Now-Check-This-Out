package backend;

import openfl.utils.Assets;
import haxe.Json;

enum Playables
{
  DEFAULT;

  BF;
  GF;
  PEAR;

  MARK;
  KARM;
  YUU;

  BALDI;
  ARGULOW;
  EVI;

  DSIDES_BF;
  ILI;
}

typedef PlayableJson =
{
  var gameoverChar:String;

  var deathstingSuffix:String;

  var gameoverSuffix:String;
  var gameoverTempo:Float;

  var pauseSuffix:String;

  var missSuffix:String;

  var suffix:String;

  var freeplay:String;

  var resultVariant:String;

  var atkStat:Float;
  var defStat:Float;
  var spdStat:Float;

  var specialStat:Float;
  var specialStatName:String;
}

class PlayablesData
{
  public var gameoverChar:String;

  public var deathstingSuffix:String;

  public var gameoverSuffix:String;
  public var gameoverTempo:Float;

  public var pauseSuffix:String;

  public var missSuffix:String;

  public var suffix:String;

  public var freeplay:String;

  public var resultVariant:String;

  public var atkStat:Float;
  public var defStat:Float;
  public var spdStat:Float;

  public var specialStat:Float;
  public var specialStatName:String;

  public function new(json:Dynamic)
  {
    gameoverChar = json.gameoverChar;
    deathstingSuffix = json.deathstingSuffix;
    gameoverSuffix = json.gameoverSuffix;
    gameoverTempo = json.gameoverTempo;
    pauseSuffix = json.pauseSuffix;
    missSuffix = json.missSuffix;
    suffix = json.suffix;
    freeplay = json.freeplay;
    resultVariant = json.resultVariant;
    atkStat = json.atkStat;
    defStat = json.defStat;
    spdStat = json.spdStat;
    specialStat = json.specialStat;
    specialStatName = json.specialStatName;
  }
}

class PlayableDataGrabber
{
  public static function getPlayableData(playable:Playables):PlayablesData
  {
    var ply:String = playable.getName().toLowerCase();
    var plyjson:Dynamic = Json.parse(Assets.getText('assets/playables/$ply.json'));

    var playbleData:PlayablesData = new PlayablesData(plyjson);

    return playbleData;
  }
}