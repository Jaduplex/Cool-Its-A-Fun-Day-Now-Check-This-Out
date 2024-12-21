#if DEVELOPERBUILD
package editors;

import flixel.FlxObject;
import openfl.filters.ShaderFilter;
import states.MainMenuState;
import flixel.FlxSprite;
import shaders.*;
import shaders.NtscShaders.NTSCSFilter;
import shaders.NtscShaders.NTSCGlitch;
import shaders.NtscShaders.TVStatic;
import shaders.NtscShaders.Abberation;
import util.CoolUtil;
import states.MusicBeatState;
#if desktop
import backend.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import visuals.Character;

class ShadersTestState extends MusicBeatState
{
  var charPx:Character;
  var charAa:Character;
  var charAlpha:Character;

  public function new()
  {
    super();
  }

  private var camEditor:FlxCamera;

  public var curSelc:Int = 0;

  public var screenMode:Bool = false;

  public var camFollow:FlxObject;

  public var shaderz:Array<Dynamic> = [
    new RippleShader(),
    new AngelShader(),
    new BloomShader(),
    new BrightnessContrastShader(0.9, 2),
    new CamDupeShader(),
    new CRTShader(),
    new NTSCSFilter(),
    new NTSCGlitch(),
    new TVStatic(),
    new Abberation(0.5),
    new RippleShader(),
    new SilhouetteShader(255, 0, 0),
    new VCRBorder(),
    new FNAFShader(5),
    new InverseDotsShader(2)
  ];

  override function create()
  {
    #if DEVELOPERBUILD
    var perf = new Perf("Total ShadersTestState create()");
    #end

    CoolUtil.newStateMemStuff();

    #if desktop
    DiscordClient.changePresence("Shader Test Screen", null, null, '-menus');
    #end

    camEditor = new FlxCamera();
    FlxG.cameras.reset(camEditor);
    FlxG.cameras.setDefaultDrawTarget(camEditor, true);

    var lol:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.WHITE);
    lol.screenCenter();
    lol.scrollFactor.set(0, 0);
    add(lol);

    charPx = new Character(150, 256, 'bf-mark', true, false);
    add(charPx);
    charAa = new Character(650, 256, 'bf', true, false);
    add(charAa);
    charAlpha = new Character(1150, 256, 'bf-mark', true, false);
    charAlpha.alpha = 0.5;
    add(charAlpha);

    prepShaders();

    camFollow = new FlxObject(0, 0, 1, 1).screenCenter();

    FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 1);

    FlxG.mouse.visible = true;

    #if DEVELOPERBUILD
    var versionShit:FlxText = new FlxText(-4, FlxG.height - 24, FlxG.width,
      "(DEV BUILD!!! - " + CoolUtil.gitCommitBranch + " - " + CoolUtil.gitCommitHash + ")", 12);
    versionShit.scrollFactor.set();
    versionShit.setFormat(Paths.font("BAUHS93.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    add(versionShit);
    #end

    super.create();

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  override function update(elapsed:Float)
  {
    if (FlxG.mouse.pressed)
    {
      camFollow.setPosition(FlxG.mouse.gameX, FlxG.mouse.gameY);
    }

    if (FlxG.keys.pressed.E)
    {
      FlxG.camera.zoom += 1 * elapsed;
    }
    else if (FlxG.keys.pressed.Q)
    {
      FlxG.camera.zoom -= 1 * elapsed;
    }

    if (FlxG.keys.justPressed.TAB)
    {
      // switch display mode
      screenMode = !screenMode;
      switchShader(0);
    }

    if (controls.UI_LEFT_P)
    {
      switchShader(-1);
    }
    else if (controls.UI_RIGHT_P)
    {
      switchShader(1);
    }

    if (controls.BACK)
    {
      MusicBeatState.switchState(new MainMenuState());
    }

    shaderz[curSelc].update(elapsed);

    super.update(elapsed);
  }

  public function switchShader(change:Int)
  {
    curSelc += change;

    if (curSelc >= shaderz.length)
    {
      curSelc = 0;
    }
    else if (curSelc < 0)
    {
      curSelc = shaderz.length - 1;
    }

    trace('current shader: ' + curSelc + ' (' + shaderz[curSelc].name + ')');

    if (curSelc != 0)
    {
      if (screenMode)
      {
        FlxG.camera.filters = [new ShaderFilter(shaderz[curSelc])];
        charPx.shader = null;
        charAa.shader = null;
        charAlpha.shader = null;
      }
      else
      {
        FlxG.camera.filters = [];
        charPx.shader = shaderz[curSelc];
        charAa.shader = shaderz[curSelc];
        charAlpha.shader = shaderz[curSelc];
      }
    }
    else
    {
      FlxG.camera.filters = [];
      charPx.shader = null;
      charAa.shader = null;
      charAlpha.shader = null;
    }
  }

  public function prepShaders()
  {
    /**
     * order: 
     * none
     * angelshader
     * bloomshader
     * brightnesscontrastshader
     * camdupeshader
     * crtshader
     * ntscsfilter
     * ntscsglitch
     * tvstatic
     * abberation
     * rippleshader
     * sillouetteshader
     * vcrborder
     * fnafshader
     * inversedotsshader
     */
    shaderz[1].set_strength(1);
    shaderz[1].set_pixelSize(2);
    shaderz[4].set_mult(4);
    shaderz[9].setChrom(0.25);
  }
}
#end