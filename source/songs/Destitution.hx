package songs;

import backend.TextAndLanguage;
import flixel.animation.FlxAnimationController;
import util.EaseUtil;
import openfl.filters.ShaderFilter;
import ui.SubtitleObject.SubtitleTypes;
import flixel.util.FlxColor;
import backend.ClientPrefs;
import visuals.Boyfriend;
import visuals.Character;
import backend.Conductor;
import states.PlayState;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.tweens.FlxEase;

/**
 * Destitution's song class.
 */
class Destitution extends SongClass
{
  public override function new()
  {
    super();
    this.songNameForDisplay = 'Destitution';
    this.playable = BF;
    this.songHasSections = true;
    this.introType = 'Mark';
    this.gameoverChar = 'bf-dead';
    this.gameoverMusicSuffix = '';
    this.songVariants = ["Normal"];
    this.songDescription = TextAndLanguage.getPhrase('desc_destitution', "Mark and the gang show Nopeboy how to be a master investor!");
    this.ratingsType = "";
    this.skipCountdown = false;
    this.preloadCharacters = [
      'mark',
      'mark-alt',
      'mark-annoyed',
      'mark-annoyed-run',
      'mark-annoyed-run-body',
      'mark-annoyed-p3',
      'mark-angry',
      'ploinky',
      'ili-devil',
      'item',
      'whale',
      'rulez',
      'crypteh',
      'zam',
      'zam-ridin',
      'bf-mark',
      'bf-mark-ploink',
      'bf-mark-lurking',
      'bf-mark-item',
      'bf-mark-rulez',
      'bf-mark-back',
      'bf-mark-crypteh',
      'bf-mark-annoyed',
      'bf-mark-annoyed-run',
      'bf-mark-annoyed-run-body',
      'bf-mark-annoyed-p3',
      'bf-mark-angry',
      'bf-mark-ridin'
    ];

    if (!ClientPrefs.lowQuality)
    {
      preloadCharacters.push('bg-player');
    }

    preloadCharacters.push('stop-loading');

    this.introCardBeat = 64;
  }

  public override function stepHitEvent(curStep:Float)
  {
    // this is where step hit events go
    super.stepHitEvent(curStep);

    switch (curStep)
    {
      // lipsync shit literally just copied from d-stitution LMAO
      case 128:
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
      case 496:
        PlayState.instance.defaultCamZoom += 0.15;
      case 504:
        PlayState.instance.defaultCamZoom -= 0.3;
      case 508:
        PlayState.instance.defaultCamZoom += 0.05;
      case 512:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom += 0.4;
      case 576:
        PlayState.instance.defaultCamZoom -= 0.15;
      case 640:
        PlayState.instance.defaultCamZoom += 0.35;
        PlayState.instance.camGame.zoom = PlayState.instance.defaultCamZoom;
        PlayState.instance.moveCamera(true);
        PlayState.instance.disallowCamMove = true;
        PlayState.instance.snapCamFollowToPos(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
      case 656:
        PlayState.instance.disallowCamMove = false;
        FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom - 0.4}, Conductor.crochet / 1000, {ease: FlxEase.circOut});
        PlayState.instance.defaultCamZoom -= 0.4;
      case 672:
        PlayState.instance.defaultCamZoom += 0.05;
      case 688:
        PlayState.instance.defaultCamZoom += 0.15;
      case 696 | 700:
        PlayState.instance.defaultCamZoom += 0.05;
      case 704:
        PlayState.instance.defaultCamZoom -= 0.25;
      case 760 | 764:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 768:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 792 | 796:
        PlayState.instance.defaultCamZoom += 0.05;
      case 800:
        PlayState.instance.defaultCamZoom += 0.1;
      case 816:
        PlayState.instance.defaultCamZoom += 0.1;
      case 820:
        PlayState.instance.defaultCamZoom += 0.05;
      case 824:
        PlayState.instance.defaultCamZoom = 0.8;
      case 832:
        PlayState.instance.defaultCamZoom += 0.1;
      case 848:
        PlayState.instance.defaultCamZoom -= 0.025;
      case 864:
        PlayState.instance.defaultCamZoom -= 0.1;
        FlxG.camera.zoom = PlayState.instance.defaultCamZoom;
      case 868:
        PlayState.instance.defaultCamZoom += 0.2;
      case 872:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 876:
        PlayState.instance.defaultCamZoom += 0.1;
      case 880:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 896:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 912:
        PlayState.instance.defaultCamZoom -= 0.05;
        FlxG.camera.zoom = PlayState.instance.defaultCamZoom;
      case 916 | 920 | 924:
        PlayState.instance.defaultCamZoom += 0.05;
      case 936 | 940 | 952 | 956:
        PlayState.instance.defaultCamZoom += 0.1;
      case 944 | 960:
        PlayState.instance.defaultCamZoom -= 0.2;
      case 1024:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 1040:
        PlayState.instance.defaultCamZoom += 0.25;
      case 1088:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 1096:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 1296:
        PlayState.instance.defaultCamZoom += 0.25;
      case 1312:
        PlayState.instance.defaultCamZoom -= 0.3;
      case 1328:
        PlayState.instance.defaultCamZoom += 0.05;
      case 1344:
        PlayState.instance.defaultCamZoom = 0.875;
      case 1424 | 1488:
        PlayState.instance.defaultCamZoom += 0.1;
      case 1440 | 1504:
        PlayState.instance.defaultCamZoom -= 0.15;
      case 1456 | 1520:
        PlayState.instance.defaultCamZoom += 0.05;
      case 1536:
        PlayState.instance.camGame.zoom = PlayState.instance.defaultCamZoom;
        PlayState.instance.moveCamera(true);
        PlayState.instance.disallowCamMove = true;
        PlayState.instance.snapCamFollowToPos(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
      case 1538 | 1602:
        PlayState.instance.disallowCamMove = false;
        PlayState.instance.defaultCamZoom += 0.1;
      case 1588 | 1652:
        PlayState.instance.defaultCamZoom -= 0.15;
      case 1592 | 1656:
        PlayState.instance.defaultCamZoom += 0.05;
      case 1600:
        PlayState.instance.camGame.zoom = PlayState.instance.defaultCamZoom;
        PlayState.instance.moveCamera(false);
        PlayState.instance.disallowCamMove = true;
        PlayState.instance.snapCamFollowToPos(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
      case 1664:
        PlayState.instance.defaultCamZoom -= 0.15;
      case 1728 | 1734 | 1740:
        PlayState.instance.defaultCamZoom += 0.01666666666;
      case 1744:
        PlayState.instance.defaultCamZoom += 0.1;
      case 1784:
        PlayState.instance.defaultCamZoom = 0.875;
        FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom}, Conductor.crochet / 500, {ease: FlxEase.quadInOut});
      case 1792:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom -= 0.15;
      case 1920:
        PlayState.instance.defaultCamZoom += 0.05;
      case 2032:
        PlayState.instance.defaultCamZoom += 0.1;
      case 2040:
        PlayState.instance.defaultCamZoom += 0.05;
      case 2044:
        PlayState.instance.defaultCamZoom += 0.1;
      case 2048:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 2560:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 2568:
        PlayState.instance.defaultCamZoom += 0.05;
      case 2576:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 2588:
        PlayState.instance.defaultCamZoom += 0.05;
      case 2592 | 2598 | 2608 | 2614:
        PlayState.instance.defaultCamZoom += 0.05;
      case 2624:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 2736:
        PlayState.instance.defaultCamZoom += 0.25;
      case 2740 | 2742 | 2744 | 2748 | 2750:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 2752:
        PlayState.instance.defaultCamZoom = 0.875;
      case 2816:
        PlayState.instance.defaultCamZoom += 0.15;
      case 2880:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 2944:
        PlayState.instance.defaultCamZoom -= 0.2;
      case 3008:
        PlayState.instance.defaultCamZoom += 0.1;
      case 3072:
        PlayState.instance.defaultCamZoom += 0.25;
      case 3088 | 3124:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 3104:
        PlayState.instance.defaultCamZoom += 0.05;
      case 3134:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 3140:
        PlayState.instance.defaultCamZoom = 0.875;
      case 3216:
        PlayState.instance.defaultCamZoom += 0.1;
      case 3344:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 3376 | 3380 | 3384 | 3388 | 3440 | 3444 | 3448 | 3452:
        PlayState.instance.defaultCamZoom += 0.05;
      case 3392 | 3456:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 3408 | 3472:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 3536 | 3664:
        PlayState.instance.defaultCamZoom += 0.075;
      case 3600:
        PlayState.instance.defaultCamZoom -= 0.075;
      case 3696 | 3704 | 3712 | 3720:
        PlayState.instance.defaultCamZoom += 0.05;
      case 3728:
        PlayState.instance.defaultCamZoom = 0.875;
      case 4144:
        PlayState.instance.defaultCamZoom = 0.875;
      case 4208:
        PlayState.instance.defaultCamZoom += 0.05;
      case 4328:
        PlayState.instance.defaultCamZoom += 0.1;
      case 4332:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 4336:
        PlayState.instance.defaultCamZoom -= 0.15;
      case 4400:
        PlayState.instance.defaultCamZoom += 0.05;
      case 4464:
        PlayState.instance.defaultCamZoom += 0.15;
      case 4480 | 4512:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 4496:
        PlayState.instance.defaultCamZoom += 0.05;
      case 4528:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 4536 | 4540:
        FlxG.camera.zoom += 0.075;
      case 4784:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 4912 | 4918 | 4924:
        PlayState.instance.defaultCamZoom += 0.01666666666;
      case 4937:
        PlayState.instance.defaultCamZoom += 0.1;
      case 4944:
        PlayState.instance.defaultCamZoom = 0.825;
      case 5008:
        PlayState.instance.defaultCamZoom += 0.1;
      case 5064 | 5068:
        PlayState.instance.defaultCamZoom -= 0.025;
      case 5072:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 5136:
        PlayState.instance.defaultCamZoom += 0.05;
      case 5200:
        PlayState.instance.defaultCamZoom = 1;
      case 5204:
        PlayState.instance.defaultCamZoom -= 0.15;
      case 5264:
        PlayState.instance.defaultCamZoom += 0.15;
      case 5296 | 5304 | 5312 | 5320:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 5328:
        PlayState.instance.defaultCamZoom = 0.75;
      case 5392:
        PlayState.instance.defaultCamZoom = 0.825;
      case 5648:
        PlayState.instance.defaultCamZoom += 0.05;
      case 5904:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 6032:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 6160:
        PlayState.instance.defaultCamZoom += 0.25;
      case 6418:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 6912:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 6928:
        PlayState.instance.defaultCamZoom += 0.1;
      case 7056:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 7088:
        PlayState.instance.defaultCamZoom = 1;
      case 7122:
        PlayState.instance.defaultCamZoom -= 0.125;
      case 7624:
        PlayState.instance.defaultCamZoom += 0.2;
      case 7626 | 7628 | 7630:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 7632:
        PlayState.instance.defaultCamZoom = 0.825;
      case 7888:
        PlayState.instance.defaultCamZoom += 0.05;
      case 8144 | 8152 | 8160:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 8202:
        PlayState.instance.defaultCamZoom = 0.875;
      case 8208:
        PlayState.instance.camZoomingMult = 1.25;
        PlayState.instance.camZoomingDecay = 1.5;
      case 8338:
        PlayState.instance.defaultCamZoom += 0.1;
      case 8468:
        PlayState.instance.defaultCamZoom -= 0.2;
      case 8528:
        PlayState.instance.defaultCamZoom += 0.15;
      case 8592:
        PlayState.instance.defaultCamZoom = 0.875;
      case 8720:
        PlayState.instance.camZoomingMult = 1;
        PlayState.instance.camZoomingDecay = 1;
        PlayState.instance.defaultCamZoom += 0.05;
      case 8848:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 8976:
        PlayState.instance.camZoomingMult = 1.25;
        PlayState.instance.camZoomingDecay = 1.5;
      case 9104 | 9110 | 9114 | 9126 | 9130 | 9142 | 9146 | 9158 | 9162:
        PlayState.instance.defaultCamZoom += 0.05;
      case 9120 | 9136 | 9152 | 9168:
        PlayState.instance.defaultCamZoom -= 0.1;
      case 9232:
        FlxG.camera.flash(FlxColor.WHITE, 0.25);
        PlayState.instance.defaultCamZoom = 0.875;
        PlayState.instance.camZoomingMult = 1.75;
        PlayState.instance.camZoomingDecay = 2.25;
      case 9360:
        PlayState.instance.defaultCamZoom += 0.1;
      case 9488:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 9616:
        PlayState.instance.defaultCamZoom += 0.05;
      case 9744:
        PlayState.instance.defaultCamZoom += 0.05;
      case 9872:
        PlayState.instance.defaultCamZoom = 0.875;
        PlayState.instance.camZoomingMult = 1.25;
        PlayState.instance.camZoomingDecay = 1.5;
      case 10000:
        PlayState.instance.defaultCamZoom += 0.1;
      case 10016 | 10064 | 10080 | 10088:
        PlayState.instance.defaultCamZoom += 0.05;
      case 10048 | 10096 | 10104 | 10112 | 10120:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 10128:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom = 0.875;
        PlayState.instance.camZoomingMult = 1;
        PlayState.instance.camZoomingDecay = 1;
      case 10752 | 10756 | 10760 | 10764:
        PlayState.instance.defaultCamZoom += 0.05;
      case 10768:
        FlxG.camera.flash(FlxColor.WHITE, 0.5);
        PlayState.instance.defaultCamZoom -= 0.25;
      case 10896:
        PlayState.instance.defaultCamZoom += 0.05;
        PlayState.instance.camZoomingMult = 2;
        PlayState.instance.camZoomingDecay = 1.5;
      case 11008 | 11014 | 11020:
        FlxG.camera.zoom += 0.1;
      case 11024:
        FlxG.camera.zoom += 0.1;
        PlayState.instance.camZoomingMult = 0;
        PlayState.instance.camZoomingDecay = 1;
      case 11056:
        PlayState.instance.defaultCamZoom += 0.1;
        PlayState.instance.camZoomingMult = 0.75;
        PlayState.instance.camZoomingDecay = 0.75;
      case 11248:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 11312:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 11440:
        PlayState.instance.defaultCamZoom += 0.1;
      case 11504:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 11568:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom -= 0.05;
        PlayState.instance.camZoomingMult = 1;
        PlayState.instance.camZoomingDecay = 1;
      case 11824:
        FlxG.camera.flash(FlxColor.WHITE, (Conductor.crochet / 250) * 2);
      case 12144 | 12176 | 12208 | 12240:
        PlayState.instance.camGame.zoom = PlayState.instance.defaultCamZoom;
        PlayState.instance.moveCamera(true);
        PlayState.instance.disallowCamMove = true;
        PlayState.instance.snapCamFollowToPos(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
        PlayState.instance.disallowCamMove = false;
        FlxTween.completeTweensOf(PlayState.instance.boyfriend);
        PlayState.instance.bfAlphaTwnBack = null;
        PlayState.instance.boyfriend.alpha = 0.5;
      case 12304 | 12336 | 12386:
        PlayState.instance.camGame.zoom = PlayState.instance.defaultCamZoom;
        PlayState.instance.moveCamera(false);
        PlayState.instance.disallowCamMove = true;
        PlayState.instance.snapCamFollowToPos(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
        PlayState.instance.disallowCamMove = false;
        FlxTween.completeTweensOf(PlayState.instance.boyfriend);
        PlayState.instance.bfAlphaTwnBack = null;
        PlayState.instance.boyfriend.alpha = 1;
      case 12400:
        FlxG.camera.flash();
      case 12404 | 12408 | 12412:
        PlayState.instance.defaultCamZoom -= 0.05;
      case 12416:
        FlxG.camera.flash();
        FlxG.camera.zoom += 0.1;
        PlayState.instance.defaultCamZoom += 0.2;
      case 12432 | 12448 | 12464 | 12496 | 12512 | 12528 | 13072 | 13088 | 13104 | 13120 | 13136 | 13152 | 13168 | 13184 | 13200 | 13216 | 13232 | 13248 |
        13264 | 13280 | 13296:
        FlxG.camera.zoom += 0.1;
      case 12480:
        FlxG.camera.flash();
        FlxG.camera.zoom += 0.1;
      case 12544:
        PlayState.instance.defaultCamZoom -= 0.05;
        FlxG.camera.zoom += 0.1;
      case 13312 | 13318 | 13324:
        FlxG.camera.flash(FlxColor.WHITE, 0.75, null, true);
        FlxG.camera.zoom += 0.1;
        PlayState.instance.defaultCamZoom += 0.1;
      case 13344:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom -= 0.3;
      case 13584:
        FlxG.camera.flash();
        PlayState.instance.camZoomingDecay = 1.75;
        PlayState.instance.camZoomingMult = 2;
      case 13840:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom -= 0.05;
        PlayState.instance.camZoomingMult = 0;
        PlayState.instance.camZoomingDecay = 1;
      case 13872:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom += 0.05;
        PlayState.instance.camZoomingMult = 1;
      case 14000:
        FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, Conductor.crochet / 250, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom + 0.1}, Conductor.crochet / 500, {ease: FlxEase.cubeOut});
        PlayState.instance.defaultCamZoom += 0.1;
        PlayState.instance.dad.canDance = false;
        PlayState.instance.dad.canSing = false;
        PlayState.instance.dad.playAnim("lipsync", true);
      case 14120:
        FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom + 0.2}, Conductor.crochet / 500, {ease: FlxEase.cubeInOut});
        PlayState.instance.defaultCamZoom += 0.2;
      case 14128:
        PlayState.instance.dad.canDance = true;
        PlayState.instance.dad.canSing = true;
        PlayState.instance.defaultCamZoom -= 0.3;
        FlxG.camera.flash();
      case 14384:
        PlayState.instance.defaultCamZoom += 0.1;
      case 14636:
        PlayState.instance.camGame.zoom = PlayState.instance.defaultCamZoom;
        PlayState.instance.moveCamera(true);
        PlayState.instance.disallowCamMove = true;
        PlayState.instance.snapCamFollowToPos(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
      case 14640:
        PlayState.instance.disallowCamMove = false;
        PlayState.instance.defaultCamZoom -= 0.1;
      case 15408:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom += 0.2;
      case 15536:
        FlxG.camera.flash();
        PlayState.instance.defaultCamZoom -= 0.1;
      case 15664:
        FlxG.camera.flash(FlxColor.WHITE, (Conductor.crochet / 250) * 4);
        PlayState.instance.dad.visible = false;
        PlayState.instance.boyfriend.visible = false;
        PlayState.instance.angryDadCover.visible = false;
        PlayState.instance.angry.visible = false;
        PlayState.instance.skyboxThingy.visible = false;
    }
  }

  public override function beatHitEvent(curBeat:Float)
  {
    // this is where beat hit events go
    super.beatHitEvent(curBeat);

    switch (curBeat)
    {
      case 288 | 512:
        if (curBeat == 288)
        {
          PlayState.instance.dadGroup.remove(PlayState.instance.dad);
          PlayState.instance.dad.destroy();
          PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'mark-alt', false, false);
          PlayState.instance.dadGroup.add(PlayState.instance.dad);

          FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, Conductor.crochet / 250, {ease: EaseUtil.stepped(4)});
          FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom + 0.1}, Conductor.crochet / 500, {ease: FlxEase.cubeOut});
          PlayState.instance.defaultCamZoom += 0.1;
          PlayState.instance.dad.canDance = false;
          PlayState.instance.dad.canSing = false;
          PlayState.instance.dad.playAnim("lipsync", true);

          FlxTween.tween(PlayState.instance.gf, {alpha: 0}, Conductor.crochet / 250,
            {
              ease: EaseUtil.stepped(8),
              onComplete: function puss(fff:FlxTween)
              {
                PlayState.instance.gf.visible = false;
              }
            });

          Paths.clearUnusedMemory();
        }

        if (!ClientPrefs.lowQuality)
        {
          PlayState.instance.bgPlayer.canDance = false;
          PlayState.instance.bgPlayer.playAnim("walk", true);
        }

        var fuckeryWad:Int = 1;

        if (curBeat >= 512)
        {
          fuckeryWad = 2;
        }

        if (!ClientPrefs.lowQuality)
        {
          FlxTween.tween(PlayState.instance.bgPlayer, {x: PlayState.instance.bgPlayerWalkTarget}, (4 * fuckeryWad) / PlayState.instance.playbackRate,
            {
              onComplete: function fucksake(ferkck:FlxTween)
              {
                PlayState.instance.bgPlayer.playAnim("notice", true);
              }
            });
        }
      case 318:
        FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom + 0.2}, Conductor.crochet / 500, {ease: FlxEase.cubeInOut});
        PlayState.instance.defaultCamZoom += 0.2;
      case 320:
        PlayState.instance.defaultCamZoom -= 0.3;
        PlayState.instance.dad.canDance = true;
        PlayState.instance.dad.canSing = true;
        if (!ClientPrefs.lowQuality)
        {
          FlxTween.completeTweensOf(PlayState.instance.bgPlayer);
          PlayState.instance.bgPlayer.x = PlayState.instance.bgPlayerWalkTarget;
          PlayState.instance.bgPlayer.canDance = true;
          PlayState.instance.bgPlayer.dance();
          PlayState.instance.bgPlayerWalkTarget += 2800;
        }
        FlxG.camera.flash();
      case 576:
        // 1.01 instead of just 1 to prevent weird edge clipping? damn
        PlayState.instance.defaultCamZoom = 1.01;
        PlayState.instance.remove(PlayState.instance.ploinkyTransition, true);
        PlayState.instance.ploinkyTransition.cameras = [PlayState.instance.camGame];
        PlayState.instance.add(PlayState.instance.ploinkyTransition);
        PlayState.instance.ploinkyTransition.screenCenter();
        PlayState.instance.ploinkyTransition.scrollFactor.set();
        PlayState.instance.ploinkyTransition.visible = true;
        PlayState.instance.ploinkyTransition.animation.play('1', true);
        PlayState.instance.ploinkyTransition.alpha = 0;
        FlxTween.tween(PlayState.instance.ploinkyTransition, {alpha: 1}, Conductor.crochet / 250, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, Conductor.crochet / 250, {ease: EaseUtil.stepped(4)});
      case 584:
        PlayState.instance.ploinkyTransition.animation.play('2', true);
      case 592:
        PlayState.instance.ploinkyTransition.animation.play('3', true);
      case 600:
        PlayState.instance.ploinkyTransition.animation.play('4', true);
      case 608:
        PlayState.instance.bgPlayer.visible = false;
        PlayState.instance.bgPlayer.destroy();
        PlayState.instance.defaultCamZoom = 0.875;
        PlayState.instance.camZoomingMult = 1.5;
        PlayState.instance.camZoomingDecay = 0.9;
        PlayState.instance.camZoomingDiv = 1;
        FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, Conductor.crochet / 250, {ease: EaseUtil.stepped(4)});
        PlayState.instance.ploinkyTransition.visible = false;
        PlayState.instance.ploinkyTransition.destroy();

        PlayState.instance.starting.visible = false;
        PlayState.instance.starting.destroy();

        PlayState.instance.shoulderCam = true;
        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(0, 0, 'ploinky', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);
        PlayState.instance.dad.screenCenter();
        PlayState.instance.dad.x += 76;
        PlayState.instance.dad.y += 200;

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.destroy();
        PlayState.instance.boyfriend = new Boyfriend(-74, -84, 'bf-mark-ploink', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        FlxG.camera.flash();

        PlayState.instance.sectionIntroThing("This is Ploinky");

        Paths.clearUnusedMemory();
      case 800:
        PlayState.instance.dad.canDance = false;
        PlayState.instance.dad.canSing = false;
        PlayState.instance.dad.playAnim('pull', true);
        PlayState.instance.camZoomingDiv = 4;
      case 804:
        PlayState.instance.dad.canDance = true;
        PlayState.instance.dad.canSing = true;
        FlxG.camera.flash();
        PlayState.instance.camZoomingDiv = 2;
      case 932:
        PlayState.instance.dad.canDance = false;
        PlayState.instance.dad.canSing = false;
        PlayState.instance.dad.playAnim('leave', true);
        FlxG.camera.flash();
      case 944:
        PlayState.instance.shoulderCam = false;

        PlayState.instance.ploinky.visible = false;
        PlayState.instance.ploinky.destroy();

        PlayState.instance.dad.visible = false;
        PlayState.instance.boyfriend.visible = false;

        PlayState.instance.lurkingTransition.animation.play('idle', true);
      case 948:
        PlayState.instance.dad.canDance = true;
        PlayState.instance.dad.canSing = true;

        PlayState.instance.shoulderCam = false;

        PlayState.instance.lurkingTransition.visible = false;
        PlayState.instance.lurkingTransition.destroy();

        PlayState.instance.camZoomingMult = 2;
        PlayState.instance.camZoomingDecay = 0.8;
        PlayState.instance.camZoomingDiv = 4;

        PlayState.instance.defaultCamZoom = 1;

        PlayState.instance.blackVoid.visible = true;

        PlayState.instance.dad.alpha = 1;
        PlayState.instance.dad.visible = true;
        PlayState.instance.boyfriend.visible = true;

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(564 - PlayState.instance.dadGroup.x, 64 - PlayState.instance.dadGroup.y, 'ili-devil', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.destroy();
        PlayState.instance.boyfriend = new Boyfriend(264 - PlayState.instance.boyfriendGroup.x, 114 - PlayState.instance.boyfriendGroup.y, 'bf-mark-lurking',
          false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

        FlxG.camera.flash(FlxColor.RED, 3);

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        PlayState.instance.sectionIntroThing("L U R K I N G . . .");

        Paths.clearUnusedMemory();
      case 1020:
        FlxG.camera.flash();

        PlayState.instance.blackVoid.visible = false;

        PlayState.instance.defaultCamZoom = 0.875;
        PlayState.instance.defaultCamZoom -= 0.125;

        PlayState.instance.camZoomingDiv = 1;

        PlayState.instance.dad.visible = true;
        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(800, 344, 'item', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);
        PlayState.instance.dad.x += 160;
        PlayState.instance.dad.y -= 520;

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.destroy();
        PlayState.instance.boyfriend = new Boyfriend(-370, 220, 'bf-mark-item', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.x -= 700;
        PlayState.instance.boyfriend.y -= 574;

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();
        PlayState.instance.camZoomingMult = 1.5;
        PlayState.instance.camZoomingDecay = 1.5;
        PlayState.instance.chromAbbPulse = true;
        PlayState.instance.chromAbbBeat = 1;
        FlxG.camera.flash();

        PlayState.instance.spaceTimeDadArray[0] = PlayState.instance.dad.x;
        PlayState.instance.spaceTimeDadArray[1] = PlayState.instance.dad.y;
        PlayState.instance.spaceTimeBfArray[0] = PlayState.instance.boyfriend.x;
        PlayState.instance.spaceTimeBfArray[1] = PlayState.instance.boyfriend.y;

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

        if (ClientPrefs.shaders)
        {
          PlayState.instance.camGame.filters = [new ShaderFilter(PlayState.instance.chromAbb)];
        }

        PlayState.instance.sectionIntroThing("I LIEK ITEM");

        Paths.clearUnusedMemory();
      case 1148 | 1228:
        if (curBeat < 1228)
        {
          FlxG.camera.flash();
        }

        PlayState.instance.camZooming = false;
        PlayState.instance.camZoomingMult = 1;
        PlayState.instance.camZoomingDecay = 1;
        PlayState.instance.camZoomingDiv = 2;
        PlayState.instance.space.visible = false;
        PlayState.instance.spaceTime = false;

        if (!ClientPrefs.lowQuality)
        {
          PlayState.instance.spaceItems.visible = false;
        }

        if (curBeat >= 1228)
        {
          FlxG.camera.flash();

          if (!ClientPrefs.lowQuality)
          {
            for (spitem in PlayState.instance.spaceItems.members)
            {
              FlxTween.tween(spitem, {'scale.x': 0, 'scale.y': 0}, 1.5 / PlayState.instance.playbackRate, {ease: FlxEase.backInOut});
            }
          }

          FlxTween.tween(PlayState.instance.space, {alpha: 0}, 1.5 / PlayState.instance.playbackRate, {ease: FlxEase.backInOut});

          var fuckyouman:FlxTimer = new FlxTimer().start(1.55 / PlayState.instance.playbackRate, function dierels(fuck:FlxTimer)
          {
            if (!ClientPrefs.lowQuality)
            {
              for (spitem in PlayState.instance.spaceItems.members)
              {
                FlxTween.completeTweensOf(spitem);
                spitem.destroy();
              }

              PlayState.instance.spaceItems.destroy();
            }
          });

          FlxTween.tween(PlayState.instance.dad, {x: PlayState.instance.spaceTimeDadArray[0], y: PlayState.instance.spaceTimeDadArray[1], angle: 0}, 1,
            {ease: FlxEase.elasticOut});
          FlxTween.tween(PlayState.instance.boyfriend, {x: PlayState.instance.spaceTimeBfArray[0], y: PlayState.instance.spaceTimeBfArray[1], angle: 0}, 1,
            {ease: FlxEase.elasticOut});
        }
        else
        {
          PlayState.instance.dad.setPosition(PlayState.instance.spaceTimeDadArray[0], PlayState.instance.spaceTimeDadArray[1]);
          PlayState.instance.boyfriend.setPosition(PlayState.instance.spaceTimeBfArray[0], PlayState.instance.spaceTimeBfArray[1]);
          PlayState.instance.dad.angle = 0;
          PlayState.instance.boyfriend.angle = 0;
        }

        PlayState.instance.boyfriend.canDance = true;
        PlayState.instance.boyfriend.canSing = true;
        PlayState.instance.dad.canDance = true;
        PlayState.instance.dad.canSing = true;
        PlayState.instance.dad.dance();
        PlayState.instance.boyfriend.dance();
      case 1164 | 1236:
        FlxG.camera.flash();
        PlayState.instance.camZooming = true;
        PlayState.instance.camZoomingMult = 1.5;
        PlayState.instance.camZoomingDecay = 1.5;
        PlayState.instance.camZoomingDiv = 1;

        if (curBeat <= 1164)
        {
          PlayState.instance.camZoomingDiv = 2;
          PlayState.instance.chromAbbPulse = true;
          PlayState.instance.chromAbbBeat = 2;

          PlayState.instance.spaceItems.visible = true;
          PlayState.instance.spaceTime = true;
          PlayState.instance.space.visible = true;
          PlayState.instance.boyfriend.canDance = false;
          PlayState.instance.boyfriend.canSing = false;
          PlayState.instance.boyfriend.playAnim("floaty space mcgee", true);
          PlayState.instance.dad.canDance = false;
          PlayState.instance.dad.canSing = false;
          PlayState.instance.dad.playAnim("floaty space mcgee", true);
        }
        else
        {
          PlayState.instance.chromAbbPulse = true;
          PlayState.instance.chromAbbBeat = 1;
        }
      case 1332:
        PlayState.instance.camZoomingMult = 1;
        PlayState.instance.camZoomingDecay = 1;
        PlayState.instance.chromAbbPulse = false;
        PlayState.instance.chromAbbBeat = 4;
        PlayState.instance.camZoomingDiv = 4;
        FlxG.camera.flash();
      case 1340:
        if (ClientPrefs.shaders)
        {
          PlayState.instance.camGame.filters = [];
        }
        FlxTween.completeTweensOf(PlayState.instance.dad);
        FlxTween.completeTweensOf(PlayState.instance.boyfriend);
        FlxTween.tween(PlayState.instance.dad, {alpha: 0}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(PlayState.instance.boyfriend, {alpha: 0}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
      case 1344:
        PlayState.instance.centerCamOnBg = true;
        PlayState.instance.liek.animation.play("idle", true);
        PlayState.instance.cuttingSceneThing.visible = true;

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
      case 1348:
        PlayState.instance.cuttingSceneThing.visible = false;
        PlayState.instance.centerCamOnBg = false;
        PlayState.instance.clearItemNoteShit();

        PlayState.instance.camZoomingDiv = 4;

        FlxG.camera.flash();

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.destroy();
        PlayState.instance.boyfriend = new Boyfriend(-200, 64, 'bf-mark-annoyed', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.visible = false;

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(0, 0, 'whale', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);
        PlayState.instance.dad.screenCenter();
        PlayState.instance.dad.x += 90;
        PlayState.instance.dad.y += 300;

        FlxTween.completeTweensOf(PlayState.instance.dad);
        FlxTween.completeTweensOf(PlayState.instance.boyfriend);
        PlayState.instance.dad.alpha = 0;
        PlayState.instance.boyfriend.alpha = 0;
        FlxTween.tween(PlayState.instance.dad, {alpha: 1}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(PlayState.instance.boyfriend, {alpha: 1}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});

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

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        PlayState.instance.sectionIntroThing("Wiggy Whale");

        Paths.clearUnusedMemory();
      case 1540:
        // JUMPY FUN PART
        PlayState.instance.whaleFuckShit = true;
      case 1604:
        PlayState.instance.whaleFuckShit = false;
        FlxG.camera.flash();
      case 1768:
        FlxTween.completeTweensOf(PlayState.instance.dad);
        FlxTween.completeTweensOf(PlayState.instance.boyfriend);
        FlxTween.tween(PlayState.instance.dad, {alpha: 0}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(PlayState.instance.boyfriend, {alpha: 0}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
      case 1776:
        PlayState.instance.cuttingSceneThing.visible = true;
        PlayState.instance.liek.visible = false;
        PlayState.instance.liek.destroy();
        PlayState.instance.annoyed.animation.play("idle", true);
        PlayState.instance.centerCamOnBg = true;
      case 1780:
        // phase 1
        PlayState.instance.cuttingSceneThing.visible = false;
        PlayState.instance.centerCamOnBg = false;
        PlayState.instance.shoulderCam = true;

        FlxG.camera.flash();

        PlayState.instance.boyfriend.visible = true;
        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(-214, -60, 'mark-annoyed', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        FlxTween.completeTweensOf(PlayState.instance.dad);
        FlxTween.completeTweensOf(PlayState.instance.boyfriend);
        PlayState.instance.dad.alpha = 0;
        PlayState.instance.boyfriend.alpha = 0;
        FlxTween.tween(PlayState.instance.dad, {alpha: 1}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(PlayState.instance.boyfriend, {alpha: 1}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        PlayState.instance.sectionIntroThing("Mark Mc. Marketing (B)");

        if (!ClientPrefs.middleScroll)
        {
          PlayState.instance.timerGoMiddlescroll(true);

          for (i in PlayState.instance.opponentStrums.members)
          {
            FlxTween.tween(i, {x: i.x + 575}, 1 / PlayState.instance.playbackRate, {ease: FlxEase.quadInOut});
          }

          for (i in PlayState.instance.playerStrums.members)
          {
            FlxTween.tween(i, {x: i.x - -320}, 1 / PlayState.instance.playbackRate, {ease: FlxEase.quadInOut});
          }
        }

        Paths.clearUnusedMemory();
      case 1908:
        // switch to phase 2 (running)
        FlxG.camera.flash();

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dadRunBod = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'mark-annoyed-run-body', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dadRunBod);
        PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'mark-annoyed-run', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.destroy();
        PlayState.instance.boyfriendRunBod = new Boyfriend(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, 'bf-mark-annoyed-run-body', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriendRunBod);
        PlayState.instance.boyfriend = new Boyfriend(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, 'bf-mark-annoyed-run', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);
      case 1970:
        // slow down animations
        FlxTween.tween(FlxAnimationController, {globalSpeed: 0}, Conductor.crochet / 1000);
      case 1972:
        // switch to phase 3, and change back global speed
        FlxG.camera.flash();

        FlxAnimationController.globalSpeed = PlayState.instance.playbackRate;

        PlayState.instance.dadRunBod.visible = false;
        PlayState.instance.boyfriendRunBod.visible = false;

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'mark-annoyed-p3', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.destroy();
        PlayState.instance.boyfriend = new Boyfriend(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, 'bf-mark-annoyed-p3', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);
      case 2036:
        PlayState.instance.rulezGuySlideScaleWorldFunnyClips.animation.play("intro", true);
      case 2044:
        PlayState.instance.rulezGuySlideScaleWorldFunnyClips.animation.play("zoom", true);
      case 2052:
        FlxTween.tween(PlayState.instance.rulezGuySlideScaleWorldFunnyClips, {y: PlayState.instance.rulezGuySlideScaleWorldFunnyClips.y + 20000},
          (Conductor.crochet / 250) * 2, {
            ease: FlxEase.backOut,
            onComplete: function gaga(dddd:FlxTween)
            {
              var fucksTimerSake:FlxTimer = new FlxTimer().start(2, function fuuck(stupidFuckler:FlxTimer)
              {
                FlxTween.completeTweensOf(PlayState.instance.rulezGuySlideScaleWorldFunnyClips);
                PlayState.instance.rulezGuySlideScaleWorldFunnyClips.destroy();
              });
            }
          });

        PlayState.instance.shoulderCam = false;
        FlxG.camera.flash();
        PlayState.instance.annoyed.visible = false;
        PlayState.instance.annoyed.destroy();

        PlayState.instance.reloadAllNotes('ui/notes_rulez');

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(74, 114, 'rulez', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.destroy();
        PlayState.instance.boyfriend = new Boyfriend(0, 0, 'bf-mark-rulez', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

        FlxTween.completeTweensOf(PlayState.instance.dad);
        FlxTween.completeTweensOf(PlayState.instance.boyfriend);
        PlayState.instance.dad.alpha = 0;
        PlayState.instance.boyfriend.alpha = 0;
        FlxTween.tween(PlayState.instance.dad, {alpha: 1}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(PlayState.instance.boyfriend, {alpha: 1}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});

        PlayState.instance.iconP1.changeIcon(PlayState.instance.boyfriend.healthIcon);
        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        PlayState.instance.sectionIntroThing("RULEZ GUY");

        Paths.clearUnusedMemory();
      case 2557:
        FlxTween.completeTweensOf(PlayState.instance.dad);
        FlxTween.completeTweensOf(PlayState.instance.boyfriend);
        FlxTween.tween(PlayState.instance.dad, {alpha: 0}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
        FlxTween.tween(PlayState.instance.boyfriend, {alpha: 0}, Conductor.crochet / 500, {ease: EaseUtil.stepped(4)});
      case 2560:
        PlayState.instance.cuttingSceneThing.visible = true;
        PlayState.instance.centerCamOnBg = true;
        PlayState.instance.office.animation.play("idle", true);
      case 2564:
        PlayState.instance.cuttingSceneThing.visible = false;

        PlayState.instance.reloadAllNotes('ui/notes');

        PlayState.instance.defaultCamZoom = 0.875 - 0.25;
        FlxG.camera.flash();
        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(-234, -460, 'crypteh', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.destroy();
        PlayState.instance.boyfriend = new Boyfriend(-128, -164, 'bf-mark-crypteh', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

        PlayState.instance.boyfriend.x -= 1280;

        FlxTween.completeTweensOf(PlayState.instance.dad);
        FlxTween.completeTweensOf(PlayState.instance.boyfriend);
        PlayState.instance.dad.alpha = 0;
        PlayState.instance.boyfriend.alpha = 0;
        FlxTween.tween(PlayState.instance.dad, {alpha: 1}, Conductor.crochet / 500, {ease: EaseUtil.stepped(8)});
        FlxTween.tween(PlayState.instance.boyfriend, {alpha: 1, x: PlayState.instance.boyfriend.x + 1280}, Conductor.crochet / 500,
          {ease: EaseUtil.stepped(8)});

        PlayState.instance.iconP1.changeIcon(PlayState.instance.boyfriend.healthIcon);
        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        PlayState.instance.remove(PlayState.instance.office, true);
        PlayState.instance.remove(PlayState.instance.dadGroup, true);
        PlayState.instance.remove(PlayState.instance.boyfriendGroup, true);
        PlayState.instance.add(PlayState.instance.dadGroup);
        PlayState.instance.add(PlayState.instance.office);
        PlayState.instance.add(PlayState.instance.boyfriendGroup);

        PlayState.instance.sectionIntroThing("Misteh Crypteh");

        Paths.clearUnusedMemory();
      case 2968:
        PlayState.instance.dad.canDance = false;
        PlayState.instance.dad.playAnim("scared", true);
      case 2972:
        PlayState.instance.funBackCamFadeShit = true;
        PlayState.instance.centerCamOnBg = false;
        PlayState.instance.defaultCamZoom += 0.15;
        FlxG.camera.flash();

        PlayState.instance.cryptehB.visible = false;
        PlayState.instance.office.visible = false;

        PlayState.instance.cryptehB.destroy();
        PlayState.instance.office.destroy();

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(0, 0, 'zam', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);
        PlayState.instance.dad.screenCenter();
        PlayState.instance.dad.x += 196;
        PlayState.instance.dad.y += 372;

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend = new Boyfriend(120, 70, 'bf-mark-back', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.screenCenter();
        PlayState.instance.boyfriend.x += 150;
        PlayState.instance.boyfriend.y += 240;
        PlayState.instance.boyfriend.alpha = 0.5;

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        if (!ClientPrefs.middleScroll)
        {
          PlayState.instance.timerGoMiddlescroll(false);

          for (i in PlayState.instance.opponentStrums.members)
          {
            FlxTween.tween(i, {x: i.x - 575}, 1 / PlayState.instance.playbackRate, {ease: FlxEase.quadInOut});
          }

          for (i in PlayState.instance.playerStrums.members)
          {
            FlxTween.tween(i, {x: i.x + -320}, 1 / PlayState.instance.playbackRate, {ease: FlxEase.quadInOut});
          }
        }

        PlayState.instance.sectionIntroThing("Guy with a Zamboni");

        Paths.clearUnusedMemory();
      case 3136 | 3336:
        // pixels mode activate

        PlayState.instance.reloadAllNotes('ui/notes_zam');

        FlxG.camera.flash();

        PlayState.instance.zamboniChaseBg.visible = true;

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(384 - PlayState.instance.dadGroup.x, 294 - PlayState.instance.dadGroup.y, 'zam-ridin', false, false);
        PlayState.instance.dad.y = ((PlayState.instance.zamboniChaseBg.y + PlayState.instance.zamboniChaseBg.height) - PlayState.instance.dad.height) - 128;
        PlayState.instance.dad.y -= 96;
        PlayState.instance.dadGroup.add(PlayState.instance.dad);

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend = new Boyfriend(684 - PlayState.instance.boyfriendGroup.x, 316 - PlayState.instance.boyfriendGroup.y, 'bf-mark-ridin',
          false);
        PlayState.instance.boyfriend.y = ((PlayState.instance.zamboniChaseBg.y + PlayState.instance.zamboniChaseBg.height)
          - PlayState.instance.boyfriend.height)
          - 156;
        PlayState.instance.boyfriend.y -= 128;
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.alpha = 1;

        PlayState.instance.dadGroup.scrollFactor.set(0, 0);
        PlayState.instance.boyfriendGroup.scrollFactor.set(0, 0);

        PlayState.instance.funBackCamFadeShit = false;
      case 3264 | 3468:
        // swap back to normal zamboniness

        PlayState.instance.reloadAllNotes('ui/notes');

        PlayState.instance.zamboniChaseBg.visible = false;

        FlxG.camera.flash();

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(0, 0, 'zam', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);
        PlayState.instance.dad.screenCenter();
        PlayState.instance.dad.x += 196;
        PlayState.instance.dad.y += 372;

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend = new Boyfriend(120, 70, 'bf-mark-back', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.screenCenter();
        PlayState.instance.boyfriend.x += 150;
        PlayState.instance.boyfriend.y += 240;
        PlayState.instance.boyfriend.alpha = 0.5;

        PlayState.instance.dadGroup.scrollFactor.set(1, 1);
        PlayState.instance.boyfriendGroup.scrollFactor.set(1, 1);

        PlayState.instance.funBackCamFadeShit = true;
      case 3499:
        PlayState.instance.zamMarkCamFlipShit.visible = true;
        PlayState.instance.zamMarkCamFlipShit.animation.play("idle", true);
      case 3500:
        PlayState.instance.funBackCamFadeShit = false;
        PlayState.instance.zamMarkCamFlipShit.visible = false;
        PlayState.instance.zamMarkCamFlipShit.destroy();

        PlayState.instance.defaultCamZoom -= 0.05;
        FlxG.camera.flash();

        PlayState.instance.zamboni.visible = false;
        PlayState.instance.zamboni.destroy();

        PlayState.instance.angryDadCover.visible = true;

        PlayState.instance.dadGroup.remove(PlayState.instance.dad);
        PlayState.instance.dad.destroy();
        PlayState.instance.dad = new Character(126, 80, 'mark-angry', false, false);
        PlayState.instance.dadGroup.add(PlayState.instance.dad);
        PlayState.instance.dad.screenCenter();
        PlayState.instance.dad.x += 326;
        PlayState.instance.dad.y += 320;

        PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend = new Boyfriend(120, 70, 'bf-mark-angry', false);
        PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);
        PlayState.instance.boyfriend.screenCenter();
        PlayState.instance.boyfriend.x -= 412;
        PlayState.instance.boyfriend.y += 348;

        PlayState.instance.dad.alpha = 1;
        PlayState.instance.boyfriend.alpha = 1;

        PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
        PlayState.instance.reloadHealthBarColors();

        PlayState.instance.sectionIntroThing("Mark Mc. Marketing (C)");

        Paths.clearUnusedMemory();
    }

    switch (curBeat)
    {
      case 33:
        PlayState.instance.addSubtitleObj("So, you say you're a master at everything?", (Conductor.crochet / 1000) * 9, SubtitleTypes.NORMAL);
      case 42:
        PlayState.instance.addSubtitleObj("Well, let's see about that!", (Conductor.crochet / 1000) * 6, SubtitleTypes.NORMAL);
      case 48:
        PlayState.instance.addSubtitleObj("Nopeboy, are you ready to see if you truly are a master investor?", (Conductor.crochet / 1000) * 16,
          SubtitleTypes.NORMAL);
      case 288:
        PlayState.instance.addSubtitleObj("I don't like you one bit.", (Conductor.crochet / 1000) * 5, SubtitleTypes.NORMAL);
      case 294:
        PlayState.instance.addSubtitleObj("It takes YEARS to master investing,", (Conductor.crochet / 1000) * 6, SubtitleTypes.NORMAL);
      case 301:
        PlayState.instance.addSubtitleObj("and you act like you've got it down in a minute and a half?", (Conductor.crochet / 1000) * 12, SubtitleTypes.NORMAL);
      case 314:
        PlayState.instance.addSubtitleObj("G-R-R-R, why I oughta-", (Conductor.crochet / 1000) * 6, SubtitleTypes.NORMAL);
      case 704:
        PlayState.instance.addSubtitleObj("I'm Ploinky, I'm the man!", (Conductor.crochet / 1000) * 4, SubtitleTypes.NORMAL);
      case 708:
        PlayState.instance.addSubtitleObj("You are Nopeboy, you're a sham!", (Conductor.crochet / 1000) * 4, SubtitleTypes.NORMAL);
      case 712:
        PlayState.instance.addSubtitleObj("Mark is going to kill you, man!", (Conductor.crochet / 1000) * 4, SubtitleTypes.NORMAL);
      case 716:
        PlayState.instance.addSubtitleObj("I like the taste of tar on ham!", (Conductor.crochet / 1000) * 4, SubtitleTypes.NORMAL);
      case 1772:
        PlayState.instance.addSubtitleObj("Hey, hey, hey! What's all this?", (Conductor.crochet / 1000) * 8, SubtitleTypes.NORMAL);
      case 3504:
        PlayState.instance.addSubtitleObj("Get out of the way, runt!", (Conductor.crochet / 1000) * 5, SubtitleTypes.NORMAL);
      case 3510:
        PlayState.instance.addSubtitleObj("I've had it up to here with you!", (Conductor.crochet / 1000) * 8, SubtitleTypes.NORMAL);
      case 3519:
        PlayState.instance.addSubtitleObj("This is your final bout!", (Conductor.crochet / 1000) * 8, SubtitleTypes.NORMAL);
      case 3528:
        PlayState.instance.addSubtitleObj("Say goodbye!", (Conductor.crochet / 1000) * 4, SubtitleTypes.NORMAL);
    }
  }
}