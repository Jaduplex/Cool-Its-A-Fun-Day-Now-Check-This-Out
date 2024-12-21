package visuals;

import backend.ClientPrefs;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxTileFrames;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxFrame;
import flixel.FlxCamera;

class PixelPerfectSprite extends FlxSprite
{
  public var pixelPerfect:Bool = true;
  public var pixelPerfectDiv:Float = 2;

  /**
   * @param x Starting X position
   * @param y Starting Y position
   */
  public function new(?x:Float = 0, ?y:Float = 0)
  {
    super(x, y);
    if (!ClientPrefs.pixelPerfection)
    {
      pixelPerfect = false;
    }
  }

  @:access(flixel.FlxCamera)
  override function getBoundingBox(camera:FlxCamera):FlxRect
  {
    getScreenPosition(_point, camera);
    _rect.set(_point.x, _point.y, width, height);
    _rect = camera.transformRect(_rect);
    if (pixelPerfect)
    {
      _rect.width = _rect.width / 2;
      _rect.height = _rect.height / 2;
      _rect.x = _rect.x / 2;
      _rect.y = _rect.y / 2;
      _rect.floor();
      _rect.x = _rect.x * 2;
      _rect.y = _rect.y * 2;
      _rect.width = _rect.width * 2;
      _rect.height = _rect.height * 2;
    }
    return _rect;
  }

  /**
   * Returns the screen position of this object.
   *
   * @param   result  Optional arg for the returning point
   * @param   camera  The desired "screen" coordinate space. If `null`, `FlxG.camera` is used.
   * @return  The screen position of this object.
   */
  public override function getScreenPosition(?result:FlxPoint, ?camera:FlxCamera):FlxPoint
  {
    if (result == null) result = FlxPoint.get();
    if (camera == null) camera = FlxG.camera;
    result.set(x, y);
    if (pixelPerfect)
    {
      _rect.width = _rect.width / pixelPerfectDiv;
      _rect.height = _rect.height / pixelPerfectDiv;
      _rect.x = _rect.x / pixelPerfectDiv;
      _rect.y = _rect.y / pixelPerfectDiv;
      _rect.round();
      _rect.x = _rect.x * pixelPerfectDiv;
      _rect.y = _rect.y * pixelPerfectDiv;
      _rect.width = _rect.width * pixelPerfectDiv;
      _rect.height = _rect.height * pixelPerfectDiv;
    }
    return result.subtract(camera.scroll.x * scrollFactor.x, camera.scroll.y * scrollFactor.y);
  }

  override function drawSimple(camera:FlxCamera):Void
  {
    getScreenPosition(_point, camera).subtractPoint(offset);
    if (pixelPerfect)
    {
      _point.x = _point.x / pixelPerfectDiv;
      _point.y = _point.y / pixelPerfectDiv;
      _point.round();
      _point.x = _point.x * pixelPerfectDiv;
      _point.y = _point.y * pixelPerfectDiv;
    }
    _point.copyToFlash(_flashPoint);
    camera.copyPixels(_frame, framePixels, _flashRect, _flashPoint, colorTransform, blend, antialiasing);
  }

  override function drawComplex(camera:FlxCamera):Void
  {
    _frame.prepareMatrix(_matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
    _matrix.translate(-origin.x, -origin.y);
    _matrix.scale(scale.x, scale.y);
    if (bakedRotationAngle <= 0)
    {
      updateTrig();
      if (angle != 0) _matrix.rotateWithTrig(_cosAngle, _sinAngle);
    }
    getScreenPosition(_point, camera).subtractPoint(offset);
    _point.add(origin.x, origin.y);
    _matrix.translate(_point.x, _point.y);
    if (pixelPerfect)
    {
      _matrix.tx = Math.round(_matrix.tx / pixelPerfectDiv) * pixelPerfectDiv;
      _matrix.ty = Math.round(_matrix.ty / pixelPerfectDiv) * pixelPerfectDiv;
    }
    camera.drawPixels(_frame, framePixels, _matrix, colorTransform, blend, antialiasing, shader);
  }

  /**
   * Load an image from an embedded graphic file.
   *
   * HaxeFlixel's graphic caching system keeps track of loaded image data.
   * When you load an identical copy of a previously used image, by default
   * HaxeFlixel copies the previous reference onto the `pixels` field instead
   * of creating another copy of the image data, to save memory.
   *
   * NOTE: This method updates hitbox size and frame size.
   *
   * @param   graphic      The image you want to use.
   * @param   animated     Whether the `Graphic` parameter is a single sprite or a row / grid of sprites.
   * @param   frameWidth   Specify the width of your sprite
   *                       (helps figure out what to do with non-square sprites or sprite sheets).
   * @param   frameHeight  Specify the height of your sprite
   *                       (helps figure out what to do with non-square sprites or sprite sheets).
   * @param   unique       Whether the graphic should be a unique instance in the graphics cache.
   *                       Set this to `true` if you want to modify the `pixels` field without changing
   *                       the `pixels` of other sprites with the same `BitmapData`.
   * @param   key          Set this parameter if you're loading `BitmapData`.
   * @return  This `FlxSprite` instance (nice for chaining stuff together, if you're into that).
   */
  public override function loadGraphic(graphic:FlxGraphicAsset, animated = false, frameWidth = 0, frameHeight = 0, unique = false,
      ?key:String):PixelPerfectSprite
  {
    var graph:FlxGraphic = FlxG.bitmap.add(graphic, unique, key);
    if (graph == null) return this;

    if (frameWidth == 0)
    {
      frameWidth = animated ? graph.height : graph.width;
      frameWidth = (frameWidth > graph.width) ? graph.width : frameWidth;
    }
    else if (frameWidth > graph.width) FlxG.log.warn('frameWidth:$frameWidth is larger than the graphic\'s width:${graph.width}');

    if (frameHeight == 0)
    {
      frameHeight = animated ? frameWidth : graph.height;
      frameHeight = (frameHeight > graph.height) ? graph.height : frameHeight;
    }
    else if (frameHeight > graph.height) FlxG.log.warn('frameHeight:$frameHeight is larger than the graphic\'s height:${graph.height}');

    if (animated) frames = FlxTileFrames.fromGraphic(graph, FlxPoint.get(frameWidth, frameHeight));
    else
      frames = graph.imageFrame;

    return this;
  }

  /**
   * This function creates a flat colored rectangular image dynamically.
   *
   * HaxeFlixel's graphic caching system keeps track of loaded image data.
   * When you make an identical copy of a previously used image, by default
   * HaxeFlixel copies the previous reference onto the pixels field instead
   * of creating another copy of the image data, to save memory.
   *
   * NOTE: This method updates hitbox size and frame size.
   *
   * @param   Width    The width of the sprite you want to generate.
   * @param   Height   The height of the sprite you want to generate.
   * @param   Color    Specifies the color of the generated block (ARGB format).
   * @param   Unique   Whether the graphic should be a unique instance in the graphics cache. Default is `false`.
   *                   Set this to `true` if you want to modify the `pixels` field without changing the
   *                   `pixels` of other sprites with the same `BitmapData`.
   * @param   Key      An optional `String` key to identify this graphic in the cache.
   *                   If `null`, the key is determined by `Width`, `Height` and `Color`.
   *                   If `Unique` is `true` and a graphic with this `Key` already exists,
   *                   it is used as a prefix to find a new unique name like `"Key3"`.
   * @return  This `FlxSprite` instance (nice for chaining stuff together, if you're into that).
   */
  public override function makeGraphic(width:Int, height:Int, color = FlxColor.WHITE, unique = false, ?key:String):PixelPerfectSprite
  {
    var graph:FlxGraphic = FlxG.bitmap.create(width, height, color, unique, key);
    frames = graph.imageFrame;

    #if FLX_TRACK_GRAPHICS
    graph.trackingInfo = 'makeGraphic($ID, ${color.toHexString()})';
    #end

    return this;
  }
}