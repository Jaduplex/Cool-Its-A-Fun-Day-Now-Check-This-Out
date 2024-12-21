package songs;

import util.RandomUtil;
import backend.TextAndLanguage;
import util.EaseUtil;
import backend.ClientPrefs;
import visuals.Boyfriend;
import visuals.Character;
import backend.Conductor;
import states.PlayState;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.tweens.FlxEase;

/**
 * D-stitution's song class.
 */
class DStitution extends SongClass
{
  public override function new()
  {
    super();
    this.songNameForDisplay = 'D-Stitution';
    this.playable = DSIDES_BF;
    this.songHasSections = true;
    this.introType = 'Karm';
    this.gameoverChar = 'd-bf-dead';
    this.gameoverMusicSuffix = '_dsides';
    this.songVariants = ["Normal"];
    this.songDescription = TextAndLanguage.getPhrase('desc_dstitution',
      "Mark enlists Nopeboy to test the new dimension shifter on his time machine, and shenanigans ensue!");
    this.ratingsType = "Dsides";
    this.skipCountdown = false;
    this.preloadCharacters = [
      'karm',
      'd-bf',
      'd-gf',
      'pinkerton',
      'd-ili',
      'd-bf-doug',
      'douglass',
      'karm-scold',
      'douglass-player',
      'd-rules',
      'd-bf-rules',
      'maestro',
      'd-bf-maestro',
      'zamboney',
      'karm-finale',
      'stop-loading'
    ];
    this.introCardBeat = 64;
  }

  public override function stepHitEvent(curStep:Float)
  {
    // this is where step hit events go
    super.stepHitEvent(curStep);

    switch (curStep)
    {
      case 96:
        FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, Conductor.crochet / 250, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom + 0.1}, Conductor.crochet / 500, {ease: FlxEase.cubeOut});
        PlayState.instance.defaultCamZoom += 0.1;
        PlayState.instance.dad.canDance = false;
        PlayState.instance.dad.canSing = false;
        PlayState.instance.dad.playAnim("lipsync", true);
      case 248:
        FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom + 0.2}, Conductor.crochet / 500, {ease: FlxEase.cubeInOut});
        PlayState.instance.defaultCamZoom += 0.2;
      case 256:
        PlayState.instance.dad.canDance = true;
        PlayState.instance.dad.canSing = true;
        PlayState.instance.defaultCamZoom -= 0.3;
        FlxG.camera.flash();
      case 368 | 372 | 376 | 378:
        PlayState.instance.defaultCamZoom += 0.05;
      case 380:
        PlayState.instance.defaultCamZoom -= 0.3;
        FlxG.camera.zoom = PlayState.instance.defaultCamZoom;
      case 384:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom += 0.1;
      case 496:
        PlayState.instance.defaultCamZoom -= 0.05;
        FlxG.camera.zoom = PlayState.instance.defaultCamZoom;
        PlayState.instance.moveCamera(true);
        PlayState.instance.disallowCamMove = true;
        PlayState.instance.snapCamFollowToPos(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
        PlayState.instance.dad.canDance = false;
        PlayState.instance.dad.canSing = false;
        PlayState.instance.dad.playAnim("coolify", true);
      case 512:
        PlayState.instance.dad.canDance = true;
        PlayState.instance.dad.canSing = true;
        FlxTween.tween(PlayState.instance.funnyBgColors, {alpha: 0.4}, Conductor.crochet / 500, {ease: FlxEase.circOut});
        PlayState.instance.disallowCamMove = false;
        PlayState.instance.defaultCamZoom += 0.25;
      case 516:
        PlayState.instance.funnyBgColorsPumpin = true;
      case 640:
        PlayState.instance.defaultCamZoom -= 0.1;
        PlayState.instance.bgColorsCrazyBeats = 2;
      case 768:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom -= 0.1;
        PlayState.instance.bgColorsCrazyBeats = 2;
        PlayState.instance.bgColorsRandom = true;
      case 1012:
        PlayState.instance.moveCamera(true);
        PlayState.instance.disallowCamMove = true;
        PlayState.instance.snapCamFollowToPos(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
        PlayState.instance.dad.canDance = false;
        PlayState.instance.dad.canSing = false;
        PlayState.instance.dad.playAnim("decool", true);
      case 1024:
        PlayState.instance.bgColorsRandom = false;
        PlayState.instance.funnyBgColorsPumpin = false;
        PlayState.instance.funnyBgColors.color = FlxColor.BLACK;
        PlayState.instance.funnyBgColors.alpha = 0;
        FlxG.camera.flash();
        PlayState.instance.dad.canDance = true;
        PlayState.instance.dad.canSing = true;
        PlayState.instance.disallowCamMove = false;
      case 2236:
        PlayState.instance.defaultCamZoom -= 0.2;
      case 2384 | 2392 | 2448 | 2456:
        PlayState.instance.defaultCamZoom += 0.15;
      case 2400:
        PlayState.instance.defaultCamZoom -= 0.3;
      case 2464:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 2516:
        PlayState.instance.defaultCamZoom -= 0.1;
        FlxG.camera.zoom -= 0.1;
        PlayState.instance.moveCamera(false);
        PlayState.instance.disallowCamMove = true;
        PlayState.instance.snapCamFollowToPos(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
      case 2528:
        PlayState.instance.defaultCamZoom += 0.1;
        PlayState.instance.disallowCamMove = false;
      case 2588:
        PlayState.instance.defaultCamZoom += 0.4;
        FlxG.camera.zoom += 0.4;
      case 2596:
        PlayState.instance.defaultCamZoom -= 0.65;
      case 2720:
        PlayState.instance.defaultCamZoom += 0.05;
      case 3088:
        PlayState.instance.defaultCamZoom += 0.4;
      case 3104:
        PlayState.instance.defaultCamZoom -= 0.2;
      case 3232:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 3264 | 3272 | 3280 | 3288 | 3328 | 3336 | 3344 | 3352:
        FlxG.camera.zoom += 0.1;
      case 3360:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 3424:
        PlayState.instance.defaultCamZoom += 0.1;
      case 3636:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom += 0.1;
      case 3964:
        PlayState.instance.defaultCamZoom += 0.15;
      case 5464 | 5468:
        FlxG.camera.zoom += 0.1;
      case 5472:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom += 0.2;
      case 5536:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 5724:
        FlxG.camera.zoom -= 0.2;
        PlayState.instance.defaultCamZoom -= 0.2;
      case 5728:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom += 0.1;
      case 5856:
        FlxG.camera.flash();
        PlayState.instance.camZoomingMult = 1.5;
        PlayState.instance.camZoomingDecay = 0.8;
      case 5984:
        FlxG.camera.zoom += 0.5;
        PlayState.instance.camZoomingMult = 0;
        PlayState.instance.camZoomingDecay = 1;
      case 6016:
        FlxG.camera.flash();
        PlayState.instance.camZoomingMult = 1;
      case 6040:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 6080:
        PlayState.instance.defaultCamZoom += 0.1;
      case 6272:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom += 0.1;
      case 6400:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 6608 | 6624 | 6636:
        PlayState.instance.boyfriend.canSing = false;
        PlayState.instance.boyfriend.canDance = false;
        PlayState.instance.boyfriend.playAnim('warble', true);
        FlxG.camera.zoom += 0.1;
      case 6612 | 6628 | 6640:
        PlayState.instance.boyfriend.canSing = true;
        PlayState.instance.boyfriend.canDance = true;
      case 6784 | 6912 | 7040 | 7168 | 7232 | 7296:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom += 0.05;
      case 7328:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom -= 0.3;
    }
  }

  public override function beatHitEvent(curBeat:Float)
  {
    // this is where beat hit events go
    super.beatHitEvent(curBeat);

    switch (curBeat)
    {
      case 320:
        if (!ClientPrefs.lowQuality)
        {
          PlayState.instance.cloudSpeedAdditive = 25;
          for (i in PlayState.instance.cloudsGroup.members)
          {
            i.velocity.x += 25;
          }
        }
      case 448:
        if (!ClientPrefs.lowQuality)
        {
          PlayState.instance.cloudSpeedAdditive = 0;
          for (i in PlayState.instance.cloudsGroup.members)
          {
            i.velocity.x -= 25;
          }
        }
      case 512:
        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(0, 0, 'pinkerton', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.fuckMyLife = true;
        PlayState.instance.lightningBg();
        PlayState.instance.add(PlayState.instance.lightningStrikes);

        if (!ClientPrefs.lowQuality)
        {
          PlayState.instance.cloudSpeedAdditive = -10;
          for (i in PlayState.instance.cloudsGroup.members)
          {
            i.velocity.x -= 10;
          }

          PlayState.instance.theIncredibleTornado.active = true;
          PlayState.instance.theIncredibleTornado.velocity.x = RandomUtil.randomLogic.float(50, 75);
        }

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        PlayState.instance.sectionIntroThing("Sir Pinkerton III");

        if (!ClientPrefs.lowQuality)
        {
          PlayState.instance.karmScaredy.visible = true;

          FlxG.sound.play(Paths.sound('dsides/karmFlees'), 0.95, false).pan = RandomUtil.randomAudio.float(-0.55, -0.45);
        }

        FlxG.camera.flash();

        Paths.clearUnusedMemory();
      case 520:
        PlayState.instance.strikeyStrikes = true;
      case 920:
        if (!ClientPrefs.lowQuality)
        {
          PlayState.instance.cloudSpeedAdditive = 0;
          for (i in PlayState.instance.cloudsGroup.members)
          {
            i.velocity.x += 10;
          }
        }

        PlayState.instance.gf.visible = false;
        PlayState.instance.fuckMyLife = false;
        if (!ClientPrefs.lowQuality)
        {
          PlayState.instance.karmScaredy.visible = false;
          PlayState.instance.karmScaredy.destroy();
        }
        PlayState.instance.train.visible = true;
        PlayState.instance.unLightningBg();
        PlayState.instance.strikeyStrikes = false;

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(64, 196, 'd-ili', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        FlxG.camera.flash();

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();
        PlayState.instance.iconP2.visible = false;
        PlayState.instance.dad.visible = false;

        Paths.clearUnusedMemory();
      case 992:
        PlayState.instance.iconP2.visible = true;
        PlayState.instance.train.visible = false;
        PlayState.instance.train.destroy();
        PlayState.instance.dad.visible = true;
        FlxG.camera.flash();

        PlayState.instance.defaultCamZoom -= 0.3;
        FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom}, Conductor.crochet / 250, {ease: FlxEase.smootherStepOut});

        FlxTween.tween(PlayState.instance.boyfriend, {y: PlayState.instance.boyfriend.y + 136}, Conductor.crochet / 250, {ease: EaseUtil.stepped(8)});

        PlayState.instance.sky.loadGraphic(Paths.image('dsides/iliSky'));
        PlayState.instance.backing.loadGraphic(Paths.image('dsides/iliBacking'));
        PlayState.instance.starting.loadGraphic(Paths.image('dsides/iliRoom'));

        PlayState.instance.sectionIntroThing("I LIEK ITEM");

        Paths.clearUnusedMemory();
      case 1124:
        if (!ClientPrefs.lowQuality)
        {
          PlayState.instance.chefBanner.visible = true;
          FlxTween.tween(PlayState.instance.chefBanner, {y: PlayState.instance.sky.y}, Conductor.crochet / 1000, {ease: EaseUtil.stepped(64)});
        }
      case 1128:
        if (!ClientPrefs.lowQuality)
        {
          PlayState.instance.chefTable.visible = true;
          FlxTween.tween(PlayState.instance.chefTable, {y: PlayState.instance.sky.y + 64}, Conductor.crochet / 500, {ease: EaseUtil.stepped(64)});
        }
        PlayState.instance.dad.canDance = false;
        PlayState.instance.dad.canSing = false;
        PlayState.instance.dad.playAnim('chef', true);
        FlxG.camera.flash();
      case 1192:
        PlayState.instance.defaultCamZoom += 0.2;
      case 1256:
        PlayState.instance.defaultCamZoom -= 0.05;
        PlayState.instance.dad.canDance = true;
        PlayState.instance.dad.canSing = true;
        PlayState.instance.dad.dance();

        if (!ClientPrefs.lowQuality)
        {
          FlxTween.tween(PlayState.instance.chefBanner, {y: PlayState.instance.chefBanner.y - 1280}, Conductor.crochet / 1000,
            {
              ease: EaseUtil.stepped(32),
              onComplete: function fuck(AHHHHHHHHH:FlxTween)
              {
                PlayState.instance.chefBanner.visible = false;
                PlayState.instance.chefBanner.destroy();
              }
            });

          FlxTween.tween(PlayState.instance.chefTable, {alpha: 0}, Conductor.crochet / 1000,
            {
              ease: EaseUtil.stepped(8),
              onComplete: function fuck(AHHHHHHHHH:FlxTween)
              {
                PlayState.instance.chefTable.visible = false;
                PlayState.instance.chefTable.destroy();
              }
            });
        }

        FlxG.camera.flash();
      case 1260:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 1264:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom -= 0.1;
        Paths.clearUnusedMemory();
      case 1336:
        FlxG.camera.flash();

        PlayState.instance.clearItemNoteShit();

        PlayState.instance.defaultCamZoom += 0.15;
        FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom}, 1 / PlayState.instance.playbackRate, {ease: FlxEase.smootherStepOut});

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(0, 0, 'douglass', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.destroy();
        PlayState.instance.boyfriend = new Boyfriend(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, 'd-bf-doug', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

        PlayState.instance.sky.loadGraphic(Paths.image('dsides/dougSky'));
        PlayState.instance.backing.loadGraphic(Paths.image('dsides/dougBacking'));
        PlayState.instance.starting.loadGraphic(Paths.image('dsides/dougRoom'));

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        PlayState.instance.sectionIntroThing("Douglass Dolphin");

        Paths.clearUnusedMemory();
      case 1832:
        FlxG.camera.flash();

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend = new Boyfriend(PlayState.instance.dad.x, PlayState.instance.dad.y, 'douglass-player', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'karm-scold', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.sky.loadGraphic(Paths.image('dsides/dougSky'));
        PlayState.instance.backing.loadGraphic(Paths.image('dsides/dougBacking'));
        PlayState.instance.starting.loadGraphic(Paths.image('dsides/dougRoom'));

        PlayState.instance.iconP1.changeIcon(PlayState.instance.boyfriend.healthIcon);
        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        PlayState.instance.sectionIntroThing("Being Rude is Not Nice!");

        Paths.clearUnusedMemory();
      case 2240:
        FlxG.camera.flash();

        PlayState.instance.reloadAllNotes('ui/notes_rulez');

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(724, 32, 'd-rules', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.destroy();
        PlayState.instance.boyfriend = new Boyfriend(-564, 86, 'd-bf-rules', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

        PlayState.instance.sky.loadGraphic(Paths.image('dsides/skyworldSky'));
        PlayState.instance.backing.destroy();
        PlayState.instance.starting.loadGraphic(Paths.image('dsides/skyworldStage'));

        PlayState.instance.iconP1.changeIcon(PlayState.instance.boyfriend.healthIcon);
        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        PlayState.instance.sectionIntroThing("I, Rules");

        if (!ClientPrefs.middleScroll)
        {
          for (i in PlayState.instance.opponentStrums.members)
          {
            FlxTween.tween(i, {x: i.x + ((FlxG.width / 2) * 1)}, 1 / PlayState.instance.playbackRate, {ease: FlxEase.quadInOut});
          }

          for (i in PlayState.instance.playerStrums.members)
          {
            FlxTween.tween(i, {x: i.x - ((FlxG.width / 2) * 1)}, 1 / PlayState.instance.playbackRate, {ease: FlxEase.quadInOut});
          }
        }

        Paths.clearUnusedMemory();
      case 2672:
        FlxG.camera.flash();

        PlayState.instance.dadZoomsCamOut = true;

        PlayState.instance.reloadAllNotes('ui/notes');

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(PlayState.instance.boyfriend.x - 412, -48, 'maestro', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend = new Boyfriend(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, 'd-bf-maestro', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

        PlayState.instance.iconP1.changeIcon(PlayState.instance.boyfriend.healthIcon);
        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        PlayState.instance.sectionIntroThing("Maestro Cryptehnt");

        if (!ClientPrefs.middleScroll)
        {
          for (i in PlayState.instance.opponentStrums.members)
          {
            FlxTween.tween(i, {x: i.x - ((FlxG.width / 2) * 1)}, Conductor.crochet / 1005, {ease: FlxEase.quadInOut});
          }

          for (i in PlayState.instance.playerStrums.members)
          {
            FlxTween.tween(i, {x: i.x + ((FlxG.width / 2) * 1)}, Conductor.crochet / 1005, {ease: FlxEase.quadInOut});
          }
        }

        Paths.clearUnusedMemory();
      case 3140 | 3209:
        PlayState.instance.castanetTalking.visible = true;
      case 3144 | 3212:
        FlxG.camera.flash();
        PlayState.instance.castanetTalking.visible = false;
      case 3224:
        PlayState.instance.dadZoomsCamOut = false;

        FlxG.camera.flash();

        PlayState.instance.defaultCamZoom = 1;

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(0, 0, 'zamboney', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.dad.screenCenter();

        PlayState.instance.dad.canDance = false;
        PlayState.instance.dad.canSing = false;
        PlayState.instance.dad.playAnim('bark', true);

        PlayState.instance.boyfriend.visible = false;

        PlayState.instance.sky.destroy();
        PlayState.instance.starting.destroy();
        if (!ClientPrefs.lowQuality)
        {
          PlayState.instance.cloudsGroup.visible = false;
          PlayState.instance.theIncredibleTornado.visible = false;
        }

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        if (!ClientPrefs.middleScroll)
        {
          PlayState.instance.timerGoMiddlescroll(false);

          for (i in PlayState.instance.opponentStrums.members)
          {
            FlxTween.completeTweensOf(i);
            FlxTween.tween(i, {x: i.x - 575}, 1 / PlayState.instance.playbackRate, {ease: FlxEase.quadInOut});
          }

          for (i in PlayState.instance.playerStrums.members)
          {
            FlxTween.completeTweensOf(i);
            FlxTween.tween(i, {x: i.x + -320}, 1 / PlayState.instance.playbackRate, {ease: FlxEase.quadInOut});
          }
        }

        Paths.clearUnusedMemory();
      case 3240:
        FlxG.camera.flash();
        PlayState.instance.dad.canDance = true;
        PlayState.instance.dad.canSing = true;
        PlayState.instance.sectionIntroThing("Zam-boney!");
      case 3736:
        FlxG.camera.flash();

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(0, 0, 'karm-finale', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.dad.canDance = false;
        PlayState.instance.dad.canSing = false;
        PlayState.instance.dad.playAnim('intro', true);

        PlayState.instance.dad.screenCenter();

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        Paths.clearUnusedMemory();
      case 3740:
        FlxG.camera.flash();
        FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, Conductor.crochet / 250, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom + 0.1}, Conductor.crochet / 500, {ease: FlxEase.cubeOut});
        PlayState.instance.defaultCamZoom += 0.1;
        PlayState.instance.dad.canDance = false;
        PlayState.instance.dad.canSing = false;
        PlayState.instance.dad.playAnim("lipsync", true);
      case 3804:
        FlxG.camera.flash();
        FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom - 0.1}, Conductor.crochet / 500, {ease: FlxEase.cubeInOut});
        PlayState.instance.defaultCamZoom -= 0.1;
        PlayState.instance.dad.canDance = true;
        PlayState.instance.dad.canSing = true;
        PlayState.instance.sectionIntroThing("Karm Kurt Karmason Jr. (C)");
    }
  }
}