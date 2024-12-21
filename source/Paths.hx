#if !macro
package;

import util.RandomUtil;
import adobeanimate.FlxAtlasSprite;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
import flixel.graphics.FlxGraphic;
import flash.media.Sound;

using StringTools;

class Paths
{
  inline public static var SOUND_EXT = "ogg";
  inline public static var VIDEO_EXT = "mp4";

  public static function excludeAsset(key:String)
  {
    if (!dumpExclusions.contains(key))
    {
      dumpExclusions.push(key);
    }
  }

  public static var dumpExclusions:Array<String> = [
    'assets/music/mus_pauperized.$SOUND_EXT',
    'assets/music/mus_overtime.$SOUND_EXT',
    'assets/music/mus_overtime_end.$SOUND_EXT',
    'assets/rhythm/music/mus_lunch_break.$SOUND_EXT'
  ];

  public static function clearUnusedMemory()
  {
    for (key in currentTrackedAssets.keys())
    {
      if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key))
      {
        var obj = currentTrackedAssets.get(key);
        @:privateAccess
        if (obj != null)
        {
          openfl.Assets.cache.removeBitmapData(key);
          FlxG.bitmap._cache.remove(key);
          obj.destroy();
          currentTrackedAssets.remove(key);
        }
      }
    }
  }

  public static var localTrackedAssets:Array<String> = [];

  public static function clearStoredMemory(?cleanUnused:Bool = false)
  {
    @:privateAccess
    for (key in FlxG.bitmap._cache.keys())
    {
      var obj = FlxG.bitmap._cache.get(key);
      if (obj != null && !currentTrackedAssets.exists(key))
      {
        openfl.Assets.cache.removeBitmapData(key);
        FlxG.bitmap._cache.remove(key);
        obj.destroy();
      }
    }

    for (key in currentTrackedSounds.keys())
    {
      if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && key != null)
      {
        Assets.cache.clear(key);
        currentTrackedSounds.remove(key);
      }
    }

    localTrackedAssets = [];
    #if !html5 openfl.Assets.cache.clear("songs"); #end
  }

  public static function stripLibrary(path:String):String
  {
    var parts:Array<String> = path.split(':');
    if (parts.length < 2)
    {
      return path;
    }
    return parts[1];
  }

  public static function getLibrary(path:String):String
  {
    var parts:Array<String> = path.split(':');
    if (parts.length < 2) return 'preload';
    return parts[0];
  }

  static public var currentLevel:String;

  static public function setCurrentLevel(name:String)
  {
    currentLevel = name.toLowerCase();
  }

  static public function getAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames
  {
    var useMod = false;
    var imageLoaded:FlxGraphic = image(key, library);

    var myXml:Dynamic = getPath('images/$key.xml', TEXT, library);

    if (OpenFlAssets.exists(myXml))
    {
      return FlxAtlasFrames.fromSparrow(imageLoaded, myXml);
    }
    else
    {
      var myJson:Dynamic = getPath('images/$key.json', TEXT, library);

      if (OpenFlAssets.exists(myJson))
      {
        return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, myJson);
      }
    }

    return getPackerAtlas(key, library);
  }

  public static function loadAnimateAtlas(spr:FlxAtlasSprite, folderOrImg:Dynamic, spriteJson:Dynamic = null, animationJson:Dynamic = null)
  {
    var changedAnimJson = false;
    var changedAtlasJson = false;
    var changedImage = false;

    if (spriteJson != null)
    {
      changedAtlasJson = true;
      spriteJson = File.getContent(spriteJson);
    }

    if (animationJson != null)
    {
      changedAnimJson = true;
      animationJson = File.getContent(animationJson);
    }

    if (Std.isOfType(folderOrImg, String))
    {
      var originalPath:String = folderOrImg;

      for (i in 0...10)
      {
        var st:String = '$i';

        if (i == 0)
        {
          st = '';
        }

        if (!changedAtlasJson)
        {
          spriteJson = getTextFromFile('images/$originalPath/spritemap$st.json');

          if (spriteJson != null)
          {
            changedImage = true;
            changedAtlasJson = true;
            folderOrImg = Paths.image('$originalPath/spritemap$st');
            break;
          }
        }
        else if (Paths.fileExists('images/$originalPath/spritemap$st.png', IMAGE))
        {
          changedImage = true;

          folderOrImg = Paths.image('$originalPath/spritemap$st');

          break;
        }
      }

      if (!changedImage)
      {
        changedImage = true;
        folderOrImg = Paths.image(originalPath);
      }

      if (!changedAnimJson)
      {
        changedAnimJson = true;
        animationJson = getTextFromFile('images/$originalPath/Animation.json');
      }
    }

    spr.loadAtlas(folderOrImg);
  }

  public static function getPath(file:String, type:AssetType, ?library:Null<String> = null)
  {
    if (library != null)
    {
      return getLibraryPath(file, library);
    }

    if (currentLevel != null)
    {
      var levelPath:String = '';

      if (currentLevel != 'rhythm' && currentLevel != 'rpg')
      {
        levelPath = getLibraryPathForce(file, currentLevel);

        if (OpenFlAssets.exists(levelPath, type))
        {
          return levelPath;
        }
      }

      levelPath = getLibraryPathForce(file, "rhythm");

      if (OpenFlAssets.exists(levelPath, type))
      {
        return levelPath;
      }
    }

    return getPreloadPath(file);
  }

  static public function getLibraryPath(file:String, library = "preload")
  {
    return if (library == "preload" || library == "default")
    {
      getPreloadPath(file);
    }
    else
    {
      getLibraryPathForce(file, library);
    }
  }

  inline static function getLibraryPathForce(file:String, library:String)
  {
    var returnPath = '$library:assets/$library/$file';

    return returnPath;
  }

  inline public static function getPreloadPath(file:String = '')
  {
    return 'assets/$file';
  }

  inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
  {
    return getPath(file, type, library);
  }

  inline static public function txt(key:String, ?library:String)
  {
    return getPath('data/$key.txt', TEXT, library);
  }

  inline static public function lang(key:String, ?library:String)
  {
    return getPath('languages/$key.lang', TEXT, library);
  }

  inline static public function xml(key:String, ?library:String)
  {
    return getPath('data/$key.xml', TEXT, library);
  }

  inline static public function json(key:String, ?library:String)
  {
    return getPath('data/$key.json', TEXT, library);
  }

  inline static public function frag(key:String, ?library:String)
  {
    return getPath('shaders/$key.frag', TEXT, library);
  }

  inline static public function vert(key:String, ?library:String)
  {
    return getPath('shaders/$key.vert', TEXT, library);
  }

  inline static public function lua(key:String, ?library:String)
  {
    return getPath('$key.lua', TEXT, library);
  }

  static public function video(key:String)
  {
    return 'assets/videos/$key.$VIDEO_EXT';
  }

  static public function sound(key:String, ?library:String):Sound
  {
    var sound:Sound = returnSound('sounds', key, library);

    return sound;
  }

  inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
  {
    return sound(key + RandomUtil.randomAudio.int(min, max), library);
  }

  inline static public function music(key:String, ?library:String):Sound
  {
    var file:Sound = returnSound('music', key, library);

    return file;
  }

  inline static public function voices(song:String, whichSide:String = 'Player'):Any
  {
    var songKey:String = '${formatToSongPath(song)}/Voices-$whichSide';

    var voices = returnSound('songs', songKey);

    return voices;
  }

  inline static public function inst(song:String):Any
  {
    var songKey:String = '${formatToSongPath(song)}/Inst';

    var inst = returnSound('songs', songKey);

    return inst;
  }

  inline static public function image(key:String, ?library:String, allowNullReturns:Bool = false):FlxGraphic
  {
    var returnAsset:FlxGraphic = returnGraphic(key, library);

    if (returnAsset == null && !allowNullReturns)
    {
      returnAsset = returnGraphic('debug/placeholder_graphic');
    }

    return returnAsset;
  }

  static public function getTextFromFile(key:String, ?ignoreMods:Bool = false):String
  {
    #if sys
    if (FileSystem.exists(getPreloadPath(key)))
    {
      return File.getContent(getPreloadPath(key));
    }

    if (currentLevel != null)
    {
      var levelPath:String = '';

      if (currentLevel != 'rhythm' && currentLevel != 'rpg')
      {
        levelPath = getLibraryPathForce(key, currentLevel);

        if (FileSystem.exists(levelPath))
        {
          return File.getContent(levelPath);
        }
      }

      levelPath = getLibraryPathForce(key, 'rhythm');

      if (FileSystem.exists(levelPath))
      {
        return File.getContent(levelPath);
      }
    }
    #end
    return Assets.getText(getPath(key, TEXT));
  }

  inline static public function font(key:String)
  {
    return 'assets/fonts/$key';
  }

  inline static public function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String)
  {
    if (OpenFlAssets.exists(getPath(key, type)))
    {
      return true;
    }

    return false;
  }

  inline static public function getSparrowAtlas(key:String, ?library:String):FlxAtlasFrames
  {
    return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
  }

  static public function getMultiAtlas(keys:Array<String>, ?parentFolder:String = null, ?allowGPU:Bool = true):FlxAtlasFrames
  {
    var parentFrames:FlxAtlasFrames = Paths.getAtlas(keys[0].trim());
    if (keys.length > 1)
    {
      var original:FlxAtlasFrames = parentFrames;
      parentFrames = new FlxAtlasFrames(parentFrames.parent);
      parentFrames.addAtlas(original, true);
      for (i in 1...keys.length)
      {
        var extraFrames:FlxAtlasFrames = Paths.getAtlas(keys[i].trim(), parentFolder, allowGPU);
        if (extraFrames != null) parentFrames.addAtlas(extraFrames, true);
      }
    }
    return parentFrames;
  }

  public static function animateAtlas(path:String, ?library:String):String
  {
    return getLibraryPath('images/$path', library);
  }

  inline static public function getPackerAtlas(key:String, ?library:String)
  {
    return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
  }

  inline static public function formatToSongPath(path:String)
  {
    var invalidChars = ~/[~&\\;:<>#]/;
    var hideChars = ~/[.,'"%?!]/;

    var path = invalidChars.split(path.replace(' ', '-')).join("-");

    return hideChars.split(path).join("").toLowerCase();
  }

  public static var currentTrackedAssets:Map<String, FlxGraphic> = [];

  public static function returnGraphic(key:String, ?library:String)
  {
    var path = getPath('images/$key.png', IMAGE, library);

    if (OpenFlAssets.exists(path, IMAGE))
    {
      if (!currentTrackedAssets.exists(path))
      {
        var newGraphic:FlxGraphic = FlxG.bitmap.add(path, false, path);
        newGraphic.persist = true;
        currentTrackedAssets.set(path, newGraphic);
      }

      localTrackedAssets.push(path);

      return currentTrackedAssets.get(path);
    }

    return null;
  }

  public static var currentTrackedSounds:Map<String, Sound> = [];

  public static function returnSound(path:String, key:String, ?library:String)
  {
    var gottenPath:String = getPath('$path/$key.$SOUND_EXT', SOUND, library);

    gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);

    if (!currentTrackedSounds.exists(gottenPath))
    {
      var folder:String = '';

      if (path == 'songs')
      {
        folder = 'songs:';
      }

      currentTrackedSounds.set(gottenPath, OpenFlAssets.getSound(folder + getPath('$path/$key.$SOUND_EXT', SOUND, library)));
    }

    localTrackedAssets.push(gottenPath);

    return currentTrackedSounds.get(gottenPath);
  }
}
#end