package;

import flixel.FlxG;
import flixel.util.FlxSignal;
#if hxCodec
import hxcodec.flixel.FlxVideoSprite;
#end
import flixel.group.FlxSpriteGroup;

class VideoCutscene extends FlxSpriteGroup
{
  #if hxCodec
  public var vid:FlxVideoSprite;
  #end

  /**
   * Called when the video is started.
   */
  public static final onVideoStarted:FlxSignal = new FlxSignal();

  /**
   * Called if the video is paused.
   */
  public static final onVideoPaused:FlxSignal = new FlxSignal();

  /**
   * Called if the video is resumed.
   */
  public static final onVideoResumed:FlxSignal = new FlxSignal();

  /**
   * Called if the video is restarted. onVideoStarted is not called.
   */
  public static final onVideoRestarted:FlxSignal = new FlxSignal();

  /**
   * Called when the video is ended or skipped.
   */
  public static final onVideoEnded:FlxSignal = new FlxSignal();

  public var finishCallback:Void->Void = null;

  public var vidwidth:Int = 1280;
  public var vidheight:Int = 720;

  /**
   * Play a video cutscene.
   * @param path The path to the video file. Use Paths.video(path) to get the correct path.
   */
  public function play(filePath:String, onComplete:Void->Void, width:Int, height:Int):Void
  {
    finishCallback = onComplete;

    vidwidth = width;
    vidheight = height;

    // var rawFilePath = Paths.stripLibrary(filePath);
    var rawFilePath = filePath;

    #if hxCodec
    playVideoNative(rawFilePath);
    #else
    throw "No video support for this platform!";
    #end
  }

  public function isPlaying():Bool
  {
    #if (hxCodec)
    return vid != null;
    #else
    return false;
    #end
  }

  #if hxCodec
  function playVideoNative(filePath:String):Void
  {
    // Video displays OVER the FlxState.
    vid = new FlxVideoSprite(0, 0);

    if (vid != null)
    {
      add(vid);

      vid.bitmap.onEndReached.add(finishVideo.bind(0.5));

      vid.play(filePath, false);

      // Resize videos bigger or smaller than the screen.
      vid.bitmap.onTextureSetup.add(() -> {
        vid.setGraphicSize(vidwidth, vidheight);
        vid.updateHitbox();
      });

      onVideoStarted.dispatch();
    }
    else
    {
      trace('ALERT: Video is null! Could not play cutscene!');
    }
  }
  #end

  public function restartVideo(resume:Bool = true):Void
  {
    #if hxCodec
    if (vid != null)
    {
      // Seek to the start of the video.
      vid.bitmap.time = 0;
      if (resume)
      {
        // Resume the video if it was paused.
        vid.resume();
      }

      onVideoRestarted.dispatch();
    }
    #end
  }

  public function pauseVideo():Void
  {
    #if hxCodec
    if (vid != null)
    {
      vid.pause();
      onVideoPaused.dispatch();
    }
    #end
  }

  public function hideVideo():Void
  {
    #if hxCodec
    if (vid != null)
    {
      vid.visible = false;
    }
    #end
  }

  public function showVideo():Void
  {
    #if hxCodec
    if (vid != null)
    {
      vid.visible = true;
    }
    #end
  }

  public function resumeVideo():Void
  {
    #if hxCodec
    if (vid != null)
    {
      vid.resume();
      onVideoResumed.dispatch();
    }
    #end
  }

  /**
   * Finish the active video cutscene. Done when the video is finished or when the player skips the cutscene.
   * @param transitionTime The duration of the transition to the next state. Defaults to 0.5 seconds (this time is always used when cancelling the video).
   * @param finishCutscene The callback to call when the transition is finished.
   */
  public function finishVideo(?transitionTime:Float = 0.5):Void
  {
    trace('ALERT: Finish video cutscene called!');

    #if hxCodec
    if (vid != null)
    {
      vid.stop();
    }
    #end

    #if (html5 || hxCodec)
    vid.visible = false;
    vid.destroy();
    vid = null;
    #end

    onCutsceneFinish();
  }

  /**
   * The default callback used when a cutscene is finished.
   * You can specify your own callback when calling `VideoCutscene#play()`.
   */
  function onCutsceneFinish():Void
  {
    if (finishCallback != null)
    {
      finishCallback();
    }
    this.destroy();
  }
}