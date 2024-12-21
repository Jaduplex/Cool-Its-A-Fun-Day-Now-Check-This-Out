package states;

import backend.TextAndLanguage;
import flixel.util.FlxTimer;
import util.EaseUtil;
import flixel.tweens.FlxTween;
import songs.SongInit;
import backend.Highscore;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import ui.Alphabet;

class ResetScoreSubState extends MusicBeatSubstate
{
  public var bg:FlxSprite;

  public var trashcan:FlxSprite;

  public var alphabetArray:Array<Alphabet> = [];

  public var onYes:Bool = false;

  public var yesText:Alphabet;
  public var noText:Alphabet;

  public var song:String;

  public var pressed:Bool = true;

  public var songCover:FlxSprite;

  public function new(song:String)
  {
    #if DEVELOPERBUILD
    var perf = new Perf("ResetScoreSubState new()");
    #end

    this.song = song;

    super();

    var gettin = SongInit.genSongObj(song);

    var name:String = gettin.songNameForDisplay;

    name += '?';

    bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    bg.alpha = 0;
    bg.scrollFactor.set();
    add(bg);

    FlxTween.tween(bg, {alpha: 0.75}, 0.25, {ease: EaseUtil.stepped(4)});

    trashcan = new FlxSprite();
    trashcan.frames = Paths.getSparrowAtlas('reset/trash');
    trashcan.animation.addByPrefix('intro', 'intro', 24, false);
    trashcan.animation.addByPrefix('close', 'close', 24, false);
    trashcan.animation.play('intro', true);
    trashcan.animation.pause();
    trashcan.scale.set(2, 2);
    trashcan.updateHitbox();
    trashcan.screenCenter();
    add(trashcan);
    trashcan.alpha = 0;

    FlxTween.tween(trashcan, {alpha: 1}, 0.25,
      {
        ease: EaseUtil.stepped(4),
        onComplete: function shitt(fuckstween:FlxTween)
        {
          trashcan.animation.play('intro', true);
        }
      });

    var tooLong:Float = (name.length > 18) ? 0.8 : 1;

    var text:Alphabet = new Alphabet(0, 110, TextAndLanguage.getPhrase('reset_score_of', 'Reset the score of'), true);
    text.screenCenter(X);
    alphabetArray.push(text);
    text.alpha = 0;
    add(text);

    FlxTween.tween(text, {alpha: 1}, 0.25, {startDelay: 0.75, ease: EaseUtil.stepped(4)});

    var text:Alphabet = new Alphabet(0, text.y + 85, name, true);
    text.scaleX = tooLong;
    text.screenCenter(X);
    alphabetArray.push(text);
    text.alpha = 0;
    add(text);

    songCover = new FlxSprite();
    if (Paths.image('song_covers/' + PlayState.removeVariationSuffixes(song).toLowerCase(), null, true) != null)
    {
      songCover.loadGraphic(Paths.image('song_covers/' + PlayState.removeVariationSuffixes(song).toLowerCase()));
    }
    else
    {
      songCover.loadGraphic(Paths.image('song_covers/placeholder'));
    }
    songCover.setGraphicSize(175);
    songCover.updateHitbox();
    songCover.screenCenter();
    songCover.alpha = 0;
    add(songCover);

    FlxTween.tween(songCover, {alpha: 1}, 0.25, {startDelay: 0.75, ease: EaseUtil.stepped(4)});

    yesText = new Alphabet(0, text.y + 250, TextAndLanguage.getPhrase('yes', 'Yes'), true);
    yesText.screenCenter(X);
    yesText.x -= 200;
    yesText.alpha = 0;
    add(yesText);

    noText = new Alphabet(0, text.y + 250, TextAndLanguage.getPhrase('no', 'No'), true);
    noText.screenCenter(X);
    noText.x += 200;
    noText.alpha = 0;
    add(noText);

    FlxTween.tween(text, {alpha: 1}, 0.25,
      {
        startDelay: 0.75,
        ease: EaseUtil.stepped(4),
        onComplete: function doit(f:FlxTween)
        {
          pressed = false;
          updateOptions();
        }
      });

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    if (pressed)
    {
      return;
    }

    if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
    {
      FlxG.sound.play(Paths.sound('scrollMenu'), 1);

      onYes = !onYes;

      updateOptions();
    }

    if (controls.BACK)
    {
      pressed = true;

      FlxG.sound.play(Paths.sound('cancelMenu'), 1);

      close();
    }
    else if (controls.ACCEPT)
    {
      pressed = true;

      if (onYes)
      {
        trashcan.animation.play('close', true);

        for (text in alphabetArray)
        {
          text.alpha = 0;
        }

        yesText.alpha = 0;
        noText.alpha = 0;

        songCover.alpha = 0;

        Highscore.resetSong(song);

        FlxG.sound.play(Paths.sound('cancelMenu'), 1);

        var fadeTimer = new FlxTimer().start(1, function die(fu:FlxTimer)
        {
          FlxTween.tween(bg, {alpha: 0}, 0.25, {ease: EaseUtil.stepped(4)});
          FlxTween.tween(trashcan, {alpha: 0}, 0.25, {ease: EaseUtil.stepped(4)});

          var closeTimer = new FlxTimer().start(0.5, function die(fu:FlxTimer)
          {
            close();
          });
        });
      }
      else
      {
        FlxG.sound.play(Paths.sound('cancelMenu'), 1);

        close();
      }
    }
  }

  function updateOptions()
  {
    var scales:Array<Float> = [0.75, 1];
    var alphas:Array<Float> = [0.6, 1.25];
    var confirmInt:Int = onYes ? 1 : 0;

    yesText.alpha = alphas[confirmInt];
    yesText.scale.set(scales[confirmInt], scales[confirmInt]);
    noText.alpha = alphas[1 - confirmInt];
    noText.scale.set(scales[1 - confirmInt], scales[1 - confirmInt]);
  }
}