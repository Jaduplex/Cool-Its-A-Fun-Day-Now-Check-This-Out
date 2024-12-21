package backend;

/**
 * A static class which holds any functions related to scoring.
 */
class Scoring
{
  /**
   * Determine the score a note receives under a given scoring system.
   * @param msTiming The difference between the note's time and when it was hit.
   * @param scoringSystem The scoring system to use.
   * @return The score the note receives.
   */
  public static function scoreNote(msTiming:Float):Int
  {
    return scoreNotePBOT1(msTiming);
  }

  /**
   * Determine the judgement a note receives under a given scoring system.
   * @param msTiming The difference between the note's time and when it was hit.
   * @return The judgement the note receives.
   */
  public static function judgeNote(msTiming:Float):String
  {
    return judgeNotePBOT1(msTiming);
  }

  /**
   * The maximum score a note can receive.
   */
  public static var PBOT1_MAX_SCORE:Int = 500;

  /**
   * The offset of the sigmoid curve for the scoring function.
   */
  public static var PBOT1_SCORING_OFFSET:Float = 54.99;

  /**
   * The slope of the sigmoid curve for the scoring function.
   */
  public static var PBOT1_SCORING_SLOPE:Float = 0.080;

  /**
   * The minimum score a note can receive while still being considered a hit.
   */
  public static var PBOT1_MIN_SCORE:Float = 9.0;

  /**
   * The score a note receives when it is missed.
   */
  public static var PBOT1_MISS_SCORE:Int = 0;

  /**
   * The threshold at which a note hit is considered perfect and always given the max score.
   */
  public static var PBOT1_PERFECT_THRESHOLD:Float = 5.0; // 5ms

  /**
   * The threshold at which a note hit is considered missed.
   * `160ms`
   */
  public static var PBOT1_MISS_THRESHOLD:Float = 160.0;

  /**
   * The time within which a note is considered to have been hit with the Synergy judgement.
   * `~25% of the hit window, or 45ms`
   */
  public static var PBOT1_SYNERGY_THRESHOLD:Float = 45.0;

  /**
   * The time within which a note is considered to have been hit with the Good judgement.
   * `~55% of the hit window, or 90ms`
   */
  public static var PBOT1_GOOD_THRESHOLD:Float = 90.0;

  /**
   * The time within which a note is considered to have been hit with the Egh judgement.
   * `~85% of the hit window, or 135ms`
   */
  public static var PBOT1_EGH_THRESHOLD:Float = 135.0;

  /**
   * The time within which a note is considered to have been hit with the Blegh judgement.
   * `100% of the hit window, or 160ms`
   */
  public static var PBOT1_BLEGH_THRESHOLD:Float = 160.0;

  static function scoreNotePBOT1(msTiming:Float):Int
  {
    // Absolute value because otherwise late hits are always given the max score.
    var absTiming:Float = Math.abs(msTiming);

    return switch (absTiming)
    {
      case(_ > PBOT1_MISS_THRESHOLD) => true:
        PBOT1_MISS_SCORE;
      case(_ < PBOT1_PERFECT_THRESHOLD) => true:
        PBOT1_MAX_SCORE;
      default:
        // Fancy equation.
        var factor:Float = 1.0 - (1.0 / (1.0 + Math.exp(-PBOT1_SCORING_SLOPE * (absTiming - PBOT1_SCORING_OFFSET))));

        var score:Int = Std.int(PBOT1_MAX_SCORE * factor + PBOT1_MIN_SCORE);

        score;
    }
  }

  static function judgeNotePBOT1(msTiming:Float):String
  {
    var absTiming:Float = Math.abs(msTiming);

    return switch (absTiming)
    {
      case(_ < PBOT1_SYNERGY_THRESHOLD) => true:
        'synergy';
      case(_ < PBOT1_GOOD_THRESHOLD) => true:
        'good';
      case(_ < PBOT1_EGH_THRESHOLD) => true:
        'egh';
      case(_ < PBOT1_BLEGH_THRESHOLD) => true:
        'blegh';
      default:
        'miss';
    }
  }
}