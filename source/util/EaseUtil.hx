package util;

class EaseUtil
{
  /**
   * Returns an ease function that eases via steps.
   * Useful for "retro" style fades (week 6!)
   * @param steps how many steps to ease over
   * @return Float->Float (i.e. use this like a `FlxEase`)
   */
  public static inline function stepped(steps:Int):Float->Float
  {
    return function(t:Float):Float {
      return Math.floor(t * steps) / steps;
    }
  }
}