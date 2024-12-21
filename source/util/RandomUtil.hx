package util;

import flixel.math.FlxRandom;
import flixel.FlxG;

/**
 * Instead of using the same `FlxRandom` instance for everything, this includes seperate `FlxRandom`s for various elements.
 * This makes it so you cannot as easily link certain elements together for RNG manipulation purposes, which may not be desirable.
 */
class RandomUtil
{
  /**
   * Designated for randomizing **LOGIC and PROGRAMMING PURPOSES**. Use `randomSecrets` for random events and secrets, and `randomLottery` for any gambling logic.
   */
  public static var randomLogic:FlxRandom = new FlxRandom();

  /**
   * Designated for randomizing **VISUAL ASSETS, COLORS, and RANDOM TRANSPARENCY**. Locations and placement should be generated with `randomLogic`.
   */
  public static var randomVisuals:FlxRandom = new FlxRandom();

  /**
   * Designated for randomizing **AUDIO**. This includes assets and randomized volume.
   */
  public static var randomAudio:FlxRandom = new FlxRandom();

  /**
   * Designated for randomizing **GAMBLING OUTCOMES and OTHER LOTTERY RELATED LOGIC**.
   */
  public static var randomLottery:FlxRandom = new FlxRandom();

  /**
   * Designated for randomizing **RANDOM EVENTS and OTHER SECRETS**.
   */
  public static var randomSecrets:FlxRandom = new FlxRandom();

  /**
   * Reroll the seeds of `randomLogic`, `randomVisuals`, `randomAudio`, `randomLottery`, and `randomSecrets`.
   * Rerolls `FlxG.random`'s seed as well, even though it *SHOULD NOT EVER BE USED*!
   */
  public static function rerollRandomness()
  {
    randomLogic.resetInitialSeed();
    randomVisuals.resetInitialSeed();
    randomAudio.resetInitialSeed();
    randomLottery.resetInitialSeed();
    randomSecrets.resetInitialSeed();

    FlxG.random.resetInitialSeed();
  }
}