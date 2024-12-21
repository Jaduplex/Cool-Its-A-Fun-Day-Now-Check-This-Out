package waveform;

import json2object.Error;
import json2object.JsonParser;
import openfl.Assets;
import flixel.sound.FlxSound;
import lime.media.AudioBuffer;
import lime.utils.Int16Array;
import util.TimerUtil;

class WaveformDataParser
{
  static final INT16_MAX:Int = 32767;
  static final INT16_MIN:Int = -32768;

  static final INT8_MAX:Int = 127;
  static final INT8_MIN:Int = -128;

  public static function interpretFlxSound(sound:FlxSound):Null<WaveformData>
  {
    if (sound == null) return null;

    // Method 1. This only works if the sound has been played before.
    @:privateAccess
    var soundBuffer:Null<AudioBuffer> = sound?._channel?.__audioSource?.buffer;

    if (soundBuffer == null)
    {
      // Method 2. This works if the sound has not been played before.
      @:privateAccess
      soundBuffer = sound?._sound?.__buffer;

      if (soundBuffer == null)
      {
        return null;
      }
    }

    return interpretAudioBuffer(soundBuffer);
  }

  public static function interpretAudioBuffer(soundBuffer:AudioBuffer):Null<WaveformData>
  {
    var sampleRate = soundBuffer.sampleRate;
    var channels = soundBuffer.channels;
    var bitsPerSample = soundBuffer.bitsPerSample;
    var samplesPerPoint:Int = 256; // I don't think we need to configure this.
    var pointsPerSecond:Float = sampleRate / samplesPerPoint; // 172 samples per second for most songs is plenty precise while still being performant..

    var soundData:Int16Array = cast soundBuffer.data;

    var soundDataRawLength:Int = soundData.length;
    var soundDataSampleCount:Int = Std.int(Math.ceil(soundDataRawLength / channels / (bitsPerSample == 16 ? 2 : 1)));
    var outputPointCount:Int = Std.int(Math.ceil(soundDataSampleCount / samplesPerPoint));

    var minSampleValue:Int = bitsPerSample == 16 ? INT16_MIN : INT8_MIN;
    var maxSampleValue:Int = bitsPerSample == 16 ? INT16_MAX : INT8_MAX;

    var outputData:Array<Int> = [];

    var perfStart:Float = TimerUtil.start();

    for (pointIndex in 0...outputPointCount)
    {
      var values:Array<Int> = [];

      for (i in 0...channels)
      {
        values.push(bitsPerSample == 16 ? INT16_MAX : INT8_MAX);
        values.push(bitsPerSample == 16 ? INT16_MIN : INT8_MIN);
      }

      var rangeStart = pointIndex * samplesPerPoint;
      var rangeEnd = rangeStart + samplesPerPoint;
      if (rangeEnd > soundDataSampleCount) rangeEnd = soundDataSampleCount;

      for (sampleIndex in rangeStart...rangeEnd)
      {
        for (channelIndex in 0...channels)
        {
          var sampleIndex:Int = sampleIndex * channels + channelIndex;
          var sampleValue = soundData[sampleIndex];

          if (sampleValue < values[channelIndex * 2]) values[(channelIndex * 2)] = sampleValue;
          if (sampleValue > values[channelIndex * 2 + 1]) values[(channelIndex * 2) + 1] = sampleValue;
        }
      }

      // We now have the min and max values for the range.
      for (value in values)
        outputData.push(value);
    }

    var outputDataLength:Int = Std.int(outputData.length / channels / 2);
    var result = new WaveformData(null, channels, sampleRate, samplesPerPoint, bitsPerSample, outputPointCount, outputData);

    return result;
  }

  public static function parseWaveformData(path:String):Null<WaveformData>
  {
    var rawJson:String = Assets.getText(path).trim();
    return parseWaveformDataString(rawJson, path);
  }

  public static function parseWaveformDataString(contents:String, ?fileName:String):Null<WaveformData>
  {
    var parser = new JsonParser<WaveformData>();
    parser.ignoreUnknownVariables = false;
    parser.fromJson(contents, fileName);

    if (parser.errors.length > 0)
    {
      printErrors(parser.errors, fileName);
      return null;
    }
    return parser.value;
  }

  static function printErrors(errors:Array<Error>, id:String = ''):Void
  {
    #if DEVELOPERBUILD
    trace('[WAVEFORM] Failed to parse waveform data: ${id}');
    #end
  }
}