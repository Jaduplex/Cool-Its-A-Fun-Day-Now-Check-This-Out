package backend;

import util.CoolUtil;

/**
 * a LOTTA the gritty o this is stolen from psych but shhh
 */
class TextAndLanguage
{
  public static var curLoadedLanguage:Languages = ENGLISH;

  private static var phrases:Map<String, String> = [];

  public static function setLang(value:Languages)
  {
    #if DEVELOPERBUILD
    trace('LANGUAGE TO LOAD IS ' + Std.string(value));
    #end

    var lowCase:String = Std.string(value).toLowerCase();
    var json:Array<String> = CoolUtil.coolTextFile(Paths.lang(lowCase));

    #if DEVELOPERBUILD
    if (json == null)
    {
      trace('FUCK!!!! LANG JSON IS NULL! IM KILLING MYSELF');
    }
    #end

    phrases.clear();
    var hasPhrases:Bool = false;
    for (num => phrase in json)
    {
      phrase = phrase.trim();
      if (num < 1 && !phrase.contains(':'))
      {
        phrases.set('language_name', phrase.trim());
        continue;
      }

      if (phrase.length < 4 || phrase.startsWith('//')) continue;

      var n:Int = phrase.indexOf(':');
      if (n < 0) continue;

      var key:String = phrase.substr(0, n).trim().toLowerCase();

      var value:String = phrase.substr(n);
      n = value.indexOf('"');
      if (n < 0) continue;

      phrases.set(key, value.substring(n + 1, value.lastIndexOf('"')).replace('\\n', '\n'));
      hasPhrases = true;
    }

    curLoadedLanguage = value;
  }

  inline public static function getPhrase(key:String, ?defaultPhrase:String, values:Array<Dynamic> = null):String
  {
    var str:String = phrases.get(formatKey(key));

    #if !DEVELOPERBUILD
    if (str == null) str = defaultPhrase;
    #end

    if (str == null) str = key;

    if (values != null) for (num => value in values)
      str = str.replace('{${num + 1}}', value);

    return str;
  }

  inline static private function formatKey(key:String)
  {
    final hideChars = ~/[~&\\\/;:<>#.,'"%?!]/g;
    return hideChars.replace(key.replace(' ', '_'), '').toLowerCase().trim();
  }
}

enum Languages
{
  ENGLISH;
  TEST;
}