package options;

import ui.AttachedText;
import ui.Alphabet;
import visuals.PixelPerfectSprite;
import backend.ClientPrefs;
import ui.CheckboxThingie;
#if desktop
import backend.Discord.DiscordClient;
#end
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import states.MusicBeatSubstate;

class BaseOptionsMenu extends MusicBeatSubstate
{
  private var curOption:Option = null;
  private var curSelected:Int = 0;
  private var optionsArray:Array<Option>;

  private var grpOptions:FlxTypedGroup<Alphabet>;
  private var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
  private var grpTexts:FlxTypedGroup<AttachedText>;

  private var spriteGrafx:FlxSprite = null;
  private var descBox:FlxSprite;
  private var descText:FlxText;

  public var title:String;
  public var rpcTitle:String;
  public var backGroundColor:FlxColor;

  var bg:PixelPerfectSprite;
  var clipboard:PixelPerfectSprite;

  public function new()
  {
    super();

    if (title == null)
    {
      title = 'Options';
    }

    if (rpcTitle == null)
    {
      rpcTitle = 'Options Menu';
    }

    #if desktop
    DiscordClient.changePresence(rpcTitle, null, null, '-menus');
    #end

    bg = new PixelPerfectSprite().loadGraphic(Paths.image('options/optionsBg'));
    bg.color = backGroundColor;
    bg.screenCenter();
    add(bg);

    clipboard = new PixelPerfectSprite().loadGraphic(Paths.image('options/clipboard'));
    clipboard.scale.set(2, 2);
    clipboard.updateHitbox();
    clipboard.screenCenter();
    add(clipboard);

    // avoids lagspikes while scrolling through menus!
    grpOptions = new FlxTypedGroup<Alphabet>();
    add(grpOptions);

    grpTexts = new FlxTypedGroup<AttachedText>();
    add(grpTexts);

    checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
    add(checkboxGroup);

    descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    descBox.alpha = 0.6;
    add(descBox);

    var titleText:Alphabet = new Alphabet(75, 40, title, true, true);
    titleText.scaleX = 0.6;
    titleText.scaleY = 0.6;
    titleText.alpha = 0.4;
    add(titleText);

    descText = new FlxText(50, 600, 1180, "", 32);
    descText.setFormat(Paths.font("serife-converted.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    descText.scrollFactor.set();
    descText.borderSize = 2;
    descText.antialiasing = false;
    add(descText);

    for (i in 0...optionsArray.length)
    {
      var optionText:Alphabet = new Alphabet(0, 260, optionsArray[i].name, false, true);
      optionText.isMenuItem = true;
      optionText.changeX = false;
      optionText.targetY = i;
      optionText.screenCenter(X);
      optionText.x -= 55;
      grpOptions.add(optionText);

      if (optionsArray[i].type == 'bool')
      {
        optionText.x += 105;
        var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x - 105, optionText.y, optionsArray[i].getValue() == true);
        checkbox.sprTracker = optionText;
        checkbox.ID = i;
        checkboxGroup.add(checkbox);
      }
      else
      {
        var valueText:AttachedText = new AttachedText('' + optionsArray[i].getValue(), optionText.width + 80, 0, false, 1, true);
        valueText.antialiasing = ClientPrefs.globalAntialiasing;
        valueText.sprTracker = optionText;
        valueText.copyAlpha = true;
        valueText.ID = i;
        optionText.x -= valueText.width;
        valueText.x -= valueText.width;
        grpTexts.add(valueText);
        optionsArray[i].setChild(valueText);
      }

      if (optionsArray[i].showSprites != 'none')
      {
        reloadGfx(optionsArray[i].showSprites);
      }

      updateTextFrom(optionsArray[i]);
    }

    if (spriteGrafx != null)
    {
      spriteGrafx.visible = false;
    }

    changeSelection();
    reloadCheckboxes();
  }

  public function addOption(option:Option)
  {
    if (optionsArray == null || optionsArray.length < 1)
    {
      optionsArray = [];
    }

    optionsArray.push(option);
  }

  var nextAccept:Int = 5;
  var holdTime:Float = 0;
  var holdValue:Float = 0;

  override function update(elapsed:Float)
  {
    if (controls.UI_UP_P)
    {
      changeSelection(-1);
    }

    if (controls.UI_DOWN_P)
    {
      changeSelection(1);
    }

    if (controls.BACK)
    {
      close();

      FlxG.sound.play(Paths.sound('cancelMenu'));
    }

    if (nextAccept <= 0)
    {
      var usesCheckbox = true;

      if (curOption.type != 'bool')
      {
        usesCheckbox = false;
      }

      if (usesCheckbox)
      {
        if (controls.ACCEPT)
        {
          FlxG.sound.play(Paths.sound('toggle'));
          curOption.setValue((curOption.getValue() == true) ? false : true);
          curOption.change();
          reloadCheckboxes();
        }
      }
      else
      {
        if (controls.UI_LEFT || controls.UI_RIGHT)
        {
          var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
          if (holdTime > 0.5 || pressed)
          {
            if (pressed)
            {
              var add:Dynamic = null;
              if (curOption.type != 'string')
              {
                add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;
              }

              switch (curOption.type)
              {
                case 'int' | 'float' | 'percent':
                  holdValue = curOption.getValue() + add;

                  if (holdValue < curOption.minValue)
                  {
                    holdValue = curOption.minValue;
                  }
                  else if (holdValue > curOption.maxValue)
                  {
                    holdValue = curOption.maxValue;
                  }

                  switch (curOption.type)
                  {
                    case 'int':
                      holdValue = Math.round(holdValue);
                      curOption.setValue(holdValue);
                    case 'float' | 'percent':
                      holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
                      curOption.setValue(holdValue);
                  }

                case 'string':
                  var num:Int = curOption.curOption; // lol

                  if (controls.UI_LEFT_P)
                  {
                    --num;
                  }
                  else
                  {
                    num++;
                  }

                  if (num < 0)
                  {
                    num = curOption.options.length - 1;
                  }
                  else if (num >= curOption.options.length)
                  {
                    num = 0;
                  }

                  curOption.curOption = num;
                  curOption.setValue(curOption.options[num]); // lol
              }
              updateTextFrom(curOption);
              curOption.change();
              FlxG.sound.play(Paths.sound('toggle'));
            }
            else if (curOption.type != 'string')
            {
              holdValue += curOption.scrollSpeed * elapsed * (controls.UI_LEFT ? -1 : 1);

              if (holdValue < curOption.minValue)
              {
                holdValue = curOption.minValue;
              }
              else if (holdValue > curOption.maxValue)
              {
                holdValue = curOption.maxValue;
              }

              switch (curOption.type)
              {
                case 'int':
                  curOption.setValue(Math.round(holdValue));
                case 'float' | 'percent':
                  curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
              }

              updateTextFrom(curOption);
              curOption.change();
            }
          }

          if (curOption.type != 'string')
          {
            holdTime += elapsed;
          }
        }
        else if (controls.UI_LEFT_R || controls.UI_RIGHT_R)
        {
          clearHold();
        }
      }

      if (controls.RESET)
      {
        for (i in 0...optionsArray.length)
        {
          var leOption:Option = optionsArray[i];
          leOption.setValue(leOption.defaultValue);

          if (leOption.type != 'bool')
          {
            if (leOption.type == 'string')
            {
              leOption.curOption = leOption.options.indexOf(leOption.getValue());
            }

            updateTextFrom(leOption);
          }

          leOption.change();
        }

        FlxG.sound.play(Paths.sound('toggle'));

        reloadCheckboxes();
      }
    }

    if (nextAccept > 0)
    {
      nextAccept -= 1;
    }

    bg.antialiasing = false;
    clipboard.antialiasing = false;

    if (spriteGrafx != null)
    {
      spriteGrafx.antialiasing = ClientPrefs.globalAntialiasing;
    }

    super.update(elapsed);
  }

  function updateTextFrom(option:Option)
  {
    var text:String = option.displayFormat;
    var val:Dynamic = option.getValue();
    if (option.type == 'percent')
    {
      val *= 100;
    }
    var def:Dynamic = option.defaultValue;
    option.text = text.replace('%v', val).replace('%d', def);
  }

  function clearHold()
  {
    if (holdTime > 0.5)
    {
      FlxG.sound.play(Paths.sound('scrollMenu'));
    }
    holdTime = 0;
  }

  function changeSelection(change:Int = 0)
  {
    curSelected += change;
    if (curSelected < 0) curSelected = optionsArray.length - 1;
    if (curSelected >= optionsArray.length) curSelected = 0;

    descText.text = optionsArray[curSelected].description;
    descText.screenCenter(Y);
    descText.y += 270;

    var bullShit:Int = 0;

    for (item in grpOptions.members)
    {
      item.targetY = bullShit - curSelected;
      bullShit++;

      item.alpha = 0.6;

      if (item.targetY == 0)
      {
        item.alpha = 1;
      }
    }

    for (text in grpTexts)
    {
      text.alpha = 0.6;

      if (text.ID == curSelected)
      {
        text.alpha = 1;
      }
    }

    descBox.setPosition(descText.x - 10, descText.y - 10);
    descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
    descBox.updateHitbox();

    if (optionsArray[curSelected].showSprites != 'none')
    {
      reloadGfx(optionsArray[curSelected].showSprites);
      spriteGrafx.visible = true;
    }
    else
    {
      if (spriteGrafx != null)
      {
        spriteGrafx.visible = false;
      }
    }

    curOption = optionsArray[curSelected]; // shorter lol
    FlxG.sound.play(Paths.sound('scrollMenu'));
  }

  public function reloadGfx(str:String)
  {
    var wasVisible:Bool = false;

    if (spriteGrafx != null)
    {
      wasVisible = spriteGrafx.visible;
      spriteGrafx.kill();
      remove(spriteGrafx);
      spriteGrafx.destroy();
    }

    spriteGrafx = new FlxSprite(840, 170).loadGraphic(Paths.image('options/' + str));
    spriteGrafx.antialiasing = ClientPrefs.globalAntialiasing;
    spriteGrafx.scale.set(1.1, 1.1);
    spriteGrafx.updateHitbox();
    spriteGrafx.x = (FlxG.width - spriteGrafx.width) - 32;
    spriteGrafx.y = (FlxG.height - spriteGrafx.height) - 32;
    insert(members.indexOf(descText) - 2, spriteGrafx);
    spriteGrafx.visible = wasVisible;
  }

  function reloadCheckboxes()
  {
    for (checkbox in checkboxGroup)
    {
      checkbox.daValue = (optionsArray[checkbox.ID].getValue() == true);
    }
  }
}