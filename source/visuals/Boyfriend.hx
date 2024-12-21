package visuals;

import visuals.Character;

using StringTools;

class Boyfriend extends Character
{
  public var startedDeath:Bool = false;

  public function new(x:Float, y:Float, ?char:String = 'bf', doPositioning = true)
  {
    super(x, y, char, true, doPositioning);
  }

  override function update(elapsed:Float)
  {
    if (!debugMode && animation.curAnim != null)
    {
      if (animation.curAnim.name.startsWith('sing'))
      {
        holdTimer += elapsed;
      }
      else
      {
        holdTimer = 0;
      }

      if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished && startedDeath)
      {
        playAnim('deathLoop', true);
      }
    }

    super.update(elapsed);
  }
}