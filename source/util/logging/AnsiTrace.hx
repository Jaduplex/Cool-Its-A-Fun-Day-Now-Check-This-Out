package util.logging;

import haxe.PosInfos;

class AnsiTrace
{
  // mostly a copy of haxe.Log.trace()
  // but adds nice cute ANSI things
  public static function trace(v:Dynamic, ?info:PosInfos)
  {
    var str = formatOutput(v, info);
    #if sys
    Sys.println(str);
    #end
  }

  public static var colorSupported:Bool = #if sys (Sys.getEnv("TERM") == "xterm" || Sys.getEnv("ANSICON") != null) #else false #end;

  // ansi stuff
  public static inline var RED = "\x1b[31m";
  public static inline var YELLOW = "\x1b[33m";
  public static inline var WHITE = "\x1b[37m";
  public static inline var NORMAL = "\x1b[0m";
  public static inline var BOLD = "\x1b[1m";
  public static inline var ITALIC = "\x1b[3m";

  // where the real mf magic happens with ansi stuff!
  public static function formatOutput(v:Dynamic, infos:PosInfos):String
  {
    var str = Std.string(v);

    if (infos == null)
    {
      return str;
    }

    if (colorSupported)
    {
      var dirs:Array<String> = infos.fileName.split("/");

      dirs[dirs.length - 1] = ansiWrap(dirs[dirs.length - 1], BOLD);

      // rejoin the dirs
      infos.fileName = dirs.join("/");
    }

    var pstr = infos.fileName + ":" + ansiWrap(infos.lineNumber, BOLD);
    if (infos.customParams != null) for (v in infos.customParams)
    {
      str += ", " + Std.string(v);
    }

    return pstr + ": " + str;
  }

  public static function traceMark()
  {
    if (colorSupported)
    {
      for (line in ansiMark)
      {
        Sys.stdout().writeString(line + "\n");
      }

      Sys.stdout().flush();
    }
  }

  public static function ansiWrap(str:Dynamic, ansiCol:String)
  {
    return ansify(ansiCol) + str + ansify(NORMAL);
  }

  public static function ansify(ansiCol:String)
  {
    return (colorSupported ? ansiCol : "");
  }

  // generated using https://dom111.github.io/image-to-ansi/
  public static var ansiMark:Array<String> = [
    "\x1b[49m                                                                                                \x1b[m",
    "\x1b[49m                                                                                                \x1b[m",
    "\x1b[49m                                                                                                \x1b[m",
    "\x1b[49m                                                                                                \x1b[m",
    "\x1b[49m                                                                                                \x1b[m",
    "\x1b[49m                                            \x1b[48;5;15m    \x1b[48;5;254m  \x1b[48;5;138m  \x1b[48;5;254m  \x1b[48;5;15m  \x1b[48;5;1m    \x1b[49m                                    \x1b[m",
    "\x1b[49m                                \x1b[48;5;95m  \x1b[48;5;131m  \x1b[48;5;138m  \x1b[48;5;255m  \x1b[48;5;253m    \x1b[48;5;251m  \x1b[48;5;250m  \x1b[48;5;138m    \x1b[48;5;251m  \x1b[48;5;253m  \x1b[48;5;255m  \x1b[48;5;15m      \x1b[49m                                \x1b[m",
    "\x1b[49m                              \x1b[48;5;138m  \x1b[48;5;247m  \x1b[48;5;181m  \x1b[48;5;138m  \x1b[48;5;137m  \x1b[48;5;94m  \x1b[48;5;1m      \x1b[48;5;88m  \x1b[48;5;1m      \x1b[48;5;95m  \x1b[48;5;138m  \x1b[48;5;248m  \x1b[48;5;15m    \x1b[49m                              \x1b[m",
    "\x1b[49m                            \x1b[48;5;15m  \x1b[48;5;254m  \x1b[48;5;137m  \x1b[48;5;1m    \x1b[48;5;88m  \x1b[48;5;1m      \x1b[48;5;88m  \x1b[48;5;1m            \x1b[48;5;237m  \x1b[48;5;247m  \x1b[48;5;255m  \x1b[48;5;15m  \x1b[49m                            \x1b[m",
    "\x1b[49m                          \x1b[48;5;15m  \x1b[48;5;254m  \x1b[48;5;1m      \x1b[48;5;88m  \x1b[48;5;1m      \x1b[48;5;88m  \x1b[48;5;1m          \x1b[48;5;88m      \x1b[48;5;1m    \x1b[48;5;254m  \x1b[48;5;7m  \x1b[48;5;95m  \x1b[49m                        \x1b[m",
    "\x1b[49m                        \x1b[48;5;15m  \x1b[48;5;181m  \x1b[48;5;94m  \x1b[48;5;1m    \x1b[48;5;88m  \x1b[48;5;1m      \x1b[48;5;88m      \x1b[48;5;1m          \x1b[48;5;88m    \x1b[48;5;1m    \x1b[48;5;95m  \x1b[48;5;255m  \x1b[48;5;95m  \x1b[49m                        \x1b[m",
    "\x1b[49m                      \x1b[48;5;15m  \x1b[48;5;254m  \x1b[48;5;94m  \x1b[48;5;88m    \x1b[48;5;1m  \x1b[48;5;88m  \x1b[48;5;1m    \x1b[48;5;88m  \x1b[48;5;1m  \x1b[48;5;88m      \x1b[48;5;1m  \x1b[48;5;88m  \x1b[48;5;1m    \x1b[48;5;88m  \x1b[48;5;1m        \x1b[48;5;248m  \x1b[48;5;254m  \x1b[49m                        \x1b[m",
    "\x1b[49m                      \x1b[48;5;15m  \x1b[48;5;174m  \x1b[48;5;88m                      \x1b[48;5;1m  \x1b[48;5;95m  \x1b[48;5;254m  \x1b[48;5;255m  \x1b[48;5;15m    \x1b[48;5;95m  \x1b[48;5;88m  \x1b[48;5;1m    \x1b[48;5;247m  \x1b[48;5;15m  \x1b[48;5;95m  \x1b[49m                      \x1b[m",
    "\x1b[49m                    \x1b[48;5;15m    \x1b[48;5;88m                    \x1b[48;5;1m  \x1b[48;5;88m  \x1b[48;5;130m  \x1b[48;5;252m  \x1b[48;5;15m  \x1b[48;5;1m  \x1b[48;5;138m  \x1b[48;5;181m  \x1b[48;5;253m  \x1b[48;5;1m  \x1b[49m  \x1b[48;5;95m  \x1b[48;5;254m  \x1b[48;5;15m  \x1b[48;5;95m    \x1b[49m                    \x1b[m",
    "\x1b[49m                    \x1b[48;5;252m  \x1b[48;5;15m  \x1b[48;5;124m  \x1b[48;5;88m                \x1b[48;5;52m  \x1b[48;5;1m  \x1b[48;5;88m  \x1b[48;5;254m  \x1b[48;5;15m      \x1b[49m  \x1b[48;5;1m  \x1b[48;5;15m  \x1b[48;5;138m  \x1b[48;5;255m    \x1b[48;5;181m  \x1b[48;5;95m        \x1b[49m                  \x1b[m",
    "\x1b[49m                \x1b[48;5;95m      \x1b[48;5;255m  \x1b[48;5;131m  \x1b[48;5;88m        \x1b[48;5;131m  \x1b[48;5;174m  \x1b[48;5;15m    \x1b[48;5;181m  \x1b[48;5;95m  \x1b[48;5;138m  \x1b[48;5;15m          \x1b[49m  \x1b[48;5;15m    \x1b[48;5;255m  \x1b[48;5;251m  \x1b[48;5;95m    \x1b[49m  \x1b[48;5;95m    \x1b[48;5;239m  \x1b[49m                \x1b[m",
    "\x1b[49m              \x1b[48;5;95m        \x1b[48;5;252m  \x1b[48;5;255m  \x1b[48;5;137m  \x1b[48;5;94m  \x1b[48;5;1m  \x1b[48;5;131m  \x1b[48;5;255m  \x1b[48;5;15m        \x1b[48;5;254m  \x1b[48;5;255m  \x1b[48;5;15m          \x1b[49m  \x1b[48;5;15m    \x1b[48;5;181m  \x1b[48;5;95m        \x1b[49m  \x1b[48;5;95m    \x1b[49m                \x1b[m",
    "\x1b[49m            \x1b[48;5;95m            \x1b[48;5;254m  \x1b[48;5;15m  \x1b[48;5;181m  \x1b[48;5;137m  \x1b[48;5;255m  \x1b[48;5;15m  \x1b[49m  \x1b[48;5;15m    \x1b[49m  \x1b[48;5;15m    \x1b[49m  \x1b[48;5;15m      \x1b[49m    \x1b[48;5;15m    \x1b[48;5;181m  \x1b[48;5;131m      \x1b[48;5;95m  \x1b[49m  \x1b[48;5;239m  \x1b[48;5;95m    \x1b[49m              \x1b[m",
    "\x1b[49m            \x1b[48;5;95m    \x1b[49m  \x1b[48;5;95m  \x1b[48;5;131m    \x1b[48;5;95m  \x1b[48;5;181m  \x1b[48;5;15m  \x1b[48;5;137m  \x1b[48;5;15m          \x1b[49m  \x1b[48;5;15m      \x1b[49m        \x1b[48;5;15m      \x1b[48;5;131m          \x1b[48;5;95m  \x1b[49m  \x1b[48;5;95m    \x1b[49m              \x1b[m",
    "\x1b[49m            \x1b[48;5;95m        \x1b[48;5;131m      \x1b[48;5;181m  \x1b[48;5;15m  \x1b[48;5;179m  \x1b[48;5;15m              \x1b[48;5;180m  \x1b[48;5;255m  \x1b[48;5;15m        \x1b[48;5;187m  \x1b[48;5;254m  \x1b[48;5;253m  \x1b[48;5;95m  \x1b[48;5;131m        \x1b[48;5;95m  \x1b[49m  \x1b[48;5;95m    \x1b[49m              \x1b[m",
    "\x1b[49m            \x1b[48;5;95m  \x1b[49m  \x1b[48;5;95m  \x1b[48;5;131m        \x1b[48;5;181m  \x1b[48;5;15m  \x1b[48;5;137m  \x1b[48;5;15m    \x1b[49m    \x1b[48;5;15m    \x1b[48;5;144m  \x1b[48;5;137m    \x1b[48;5;180m  \x1b[48;5;137m  \x1b[48;5;15m  \x1b[48;5;180m  \x1b[48;5;137m  \x1b[48;5;131m  \x1b[48;5;181m  \x1b[48;5;137m  \x1b[48;5;95m  \x1b[48;5;131m        \x1b[49m  \x1b[48;5;95m      \x1b[49m            \x1b[m",
    "\x1b[49m          \x1b[48;5;95m        \x1b[48;5;131m        \x1b[48;5;174m  \x1b[48;5;15m  \x1b[48;5;137m  \x1b[48;5;187m  \x1b[48;5;255m  \x1b[48;5;15m      \x1b[48;5;137m    \x1b[48;5;173m    \x1b[48;5;137m    \x1b[48;5;15m          \x1b[48;5;137m  \x1b[48;5;95m  \x1b[48;5;131m  \x1b[48;5;95m  \x1b[48;5;131m      \x1b[49m  \x1b[48;5;95m    \x1b[49m            \x1b[m",
    "\x1b[49m          \x1b[48;5;95m      \x1b[48;5;131m      \x1b[48;5;95m  \x1b[48;5;131m  \x1b[48;5;167m  \x1b[48;5;254m  \x1b[48;5;137m  \x1b[48;5;173m  \x1b[48;5;137m  \x1b[49m  \x1b[48;5;137m      \x1b[48;5;173m  \x1b[48;5;137m          \x1b[48;5;253m  \x1b[48;5;15m  \x1b[48;5;187m  \x1b[48;5;223m  \x1b[48;5;173m  \x1b[48;5;95m  \x1b[48;5;131m  \x1b[48;5;95m    \x1b[48;5;131m  \x1b[48;5;167m  \x1b[49m  \x1b[48;5;95m    \x1b[49m            \x1b[m",
    "\x1b[49m          \x1b[48;5;95m      \x1b[48;5;131m    \x1b[48;5;95m  \x1b[48;5;131m  \x1b[48;5;167m  \x1b[48;5;173m  \x1b[48;5;254m  \x1b[48;5;137m  \x1b[48;5;179m  \x1b[48;5;254m  \x1b[48;5;255m  \x1b[48;5;137m    \x1b[48;5;173m  \x1b[48;5;137m            \x1b[48;5;181m  \x1b[48;5;15m  \x1b[48;5;137m  \x1b[48;5;217m  \x1b[48;5;173m  \x1b[48;5;167m  \x1b[48;5;95m      \x1b[48;5;131m  \x1b[48;5;167m  \x1b[49m  \x1b[48;5;95m    \x1b[49m            \x1b[m",
    "\x1b[49m          \x1b[48;5;95m  \x1b[49m  \x1b[48;5;95m  \x1b[48;5;131m    \x1b[48;5;95m  \x1b[48;5;131m  \x1b[48;5;167m  \x1b[48;5;173m  \x1b[48;5;180m  \x1b[48;5;254m  \x1b[48;5;15m    \x1b[48;5;255m  \x1b[48;5;173m    \x1b[48;5;137m          \x1b[48;5;173m  \x1b[48;5;144m  \x1b[48;5;255m  \x1b[48;5;137m  \x1b[48;5;15m  \x1b[48;5;174m  \x1b[48;5;173m  \x1b[48;5;167m  \x1b[48;5;95m    \x1b[48;5;131m      \x1b[49m  \x1b[48;5;95m    \x1b[49m            \x1b[m",
    "\x1b[49m          \x1b[48;5;95m  \x1b[49m  \x1b[48;5;95m  \x1b[48;5;131m    \x1b[48;5;95m  \x1b[48;5;131m  \x1b[48;5;167m  \x1b[48;5;173m  \x1b[48;5;131m  \x1b[48;5;15m  \x1b[48;5;187m    \x1b[48;5;255m  \x1b[48;5;180m  \x1b[48;5;137m  \x1b[48;5;173m  \x1b[48;5;137m      \x1b[48;5;181m    \x1b[48;5;224m  \x1b[48;5;180m  \x1b[48;5;187m  \x1b[48;5;181m  \x1b[48;5;167m  \x1b[48;5;173m    \x1b[48;5;131m  \x1b[48;5;95m  \x1b[48;5;131m      \x1b[49m  \x1b[48;5;95m    \x1b[49m            \x1b[m",
    "\x1b[49m          \x1b[48;5;95m        \x1b[48;5;131m        \x1b[48;5;173m    \x1b[48;5;180m  \x1b[48;5;181m  \x1b[48;5;137m  \x1b[48;5;180m  \x1b[48;5;224m  \x1b[48;5;255m        \x1b[48;5;254m  \x1b[48;5;144m  \x1b[48;5;179m    \x1b[48;5;180m  \x1b[48;5;15m  \x1b[48;5;173m      \x1b[48;5;167m  \x1b[48;5;131m  \x1b[48;5;95m  \x1b[48;5;131m  \x1b[48;5;95m  \x1b[48;5;131m  \x1b[48;5;95m      \x1b[49m            \x1b[m",
    "\x1b[49m          \x1b[48;5;95m    \x1b[48;5;239m  \x1b[48;5;95m  \x1b[48;5;131m      \x1b[48;5;167m    \x1b[48;5;173m    \x1b[48;5;224m  \x1b[48;5;180m  \x1b[48;5;173m  \x1b[48;5;137m    \x1b[48;5;173m    \x1b[48;5;137m        \x1b[48;5;179m  \x1b[48;5;253m  \x1b[48;5;15m  \x1b[48;5;254m  \x1b[48;5;173m    \x1b[48;5;167m  \x1b[48;5;95m    \x1b[48;5;131m  \x1b[48;5;95m  \x1b[48;5;131m  \x1b[48;5;95m      \x1b[49m            \x1b[m",
    "\x1b[49m            \x1b[48;5;95m  \x1b[49m  \x1b[48;5;95m    \x1b[48;5;131m    \x1b[48;5;173m  \x1b[48;5;167m  \x1b[48;5;173m    \x1b[48;5;252m  \x1b[48;5;15m  \x1b[48;5;181m  \x1b[48;5;144m  \x1b[48;5;137m        \x1b[48;5;173m  \x1b[48;5;137m  \x1b[48;5;180m  \x1b[48;5;254m  \x1b[48;5;180m  \x1b[48;5;255m    \x1b[48;5;173m  \x1b[48;5;167m  \x1b[48;5;131m  \x1b[48;5;95m    \x1b[48;5;131m    \x1b[48;5;95m      \x1b[49m              \x1b[m",
    "\x1b[49m            \x1b[48;5;95m        \x1b[48;5;131m    \x1b[48;5;95m  \x1b[48;5;167m    \x1b[48;5;255m  \x1b[48;5;15m  \x1b[48;5;254m  \x1b[48;5;173m  \x1b[48;5;15m    \x1b[48;5;137m      \x1b[48;5;180m  \x1b[48;5;255m  \x1b[48;5;187m  \x1b[48;5;173m    \x1b[48;5;254m    \x1b[48;5;131m              \x1b[49m  \x1b[48;5;95m    \x1b[49m              \x1b[m",
    "\x1b[49m            \x1b[48;5;95m    \x1b[49m  \x1b[48;5;95m    \x1b[48;5;131m    \x1b[48;5;137m  \x1b[48;5;255m    \x1b[48;5;180m  \x1b[48;5;131m    \x1b[48;5;167m  \x1b[48;5;181m  \x1b[48;5;254m      \x1b[48;5;188m  \x1b[48;5;137m  \x1b[48;5;131m  \x1b[48;5;173m  \x1b[48;5;131m  \x1b[48;5;254m  \x1b[48;5;180m  \x1b[48;5;131m    \x1b[48;5;95m  \x1b[48;5;131m    \x1b[48;5;95m  \x1b[49m  \x1b[48;5;95m    \x1b[49m                \x1b[m",
    "\x1b[49m            \x1b[48;5;95m            \x1b[48;5;131m  \x1b[48;5;181m  \x1b[48;5;15m  \x1b[48;5;180m  \x1b[48;5;173m  \x1b[48;5;167m    \x1b[48;5;173m  \x1b[48;5;167m    \x1b[48;5;131m      \x1b[48;5;167m  \x1b[48;5;173m  \x1b[48;5;167m  \x1b[48;5;137m  \x1b[48;5;255m  \x1b[48;5;95m      \x1b[48;5;131m      \x1b[49m  \x1b[48;5;95m      \x1b[49m                \x1b[m",
    "\x1b[49m              \x1b[48;5;95m    \x1b[49m  \x1b[48;5;95m      \x1b[48;5;138m  \x1b[48;5;15m  \x1b[48;5;180m  \x1b[48;5;173m  \x1b[48;5;167m  \x1b[48;5;173m  \x1b[48;5;167m    \x1b[48;5;173m  \x1b[48;5;131m    \x1b[48;5;167m  \x1b[48;5;173m  \x1b[48;5;131m    \x1b[48;5;173m  \x1b[48;5;255m  \x1b[48;5;95m      \x1b[48;5;131m    \x1b[49m    \x1b[48;5;95m    \x1b[49m                  \x1b[m",
    "\x1b[49m                \x1b[48;5;95m            \x1b[48;5;188m  \x1b[48;5;255m  \x1b[48;5;131m  \x1b[48;5;167m      \x1b[48;5;173m  \x1b[48;5;167m  \x1b[48;5;131m  \x1b[48;5;167m  \x1b[48;5;173m  \x1b[48;5;167m  \x1b[48;5;131m  \x1b[48;5;173m  \x1b[48;5;179m  \x1b[48;5;255m  \x1b[49m  \x1b[48;5;95m    \x1b[49m  \x1b[48;5;95m        \x1b[48;5;239m  \x1b[49m                  \x1b[m",
    "\x1b[49m                  \x1b[48;5;95m          \x1b[48;5;131m  \x1b[48;5;15m  \x1b[48;5;224m  \x1b[48;5;173m      \x1b[48;5;167m  \x1b[48;5;131m    \x1b[48;5;167m    \x1b[48;5;131m    \x1b[48;5;173m  \x1b[48;5;180m  \x1b[48;5;15m  \x1b[49m      \x1b[48;5;95m          \x1b[49m                    \x1b[m",
    "\x1b[49m                      \x1b[48;5;239m  \x1b[48;5;95m    \x1b[49m  \x1b[48;5;15m    \x1b[48;5;180m  \x1b[48;5;131m  \x1b[48;5;167m  \x1b[48;5;131m    \x1b[48;5;173m    \x1b[48;5;131m    \x1b[48;5;173m  \x1b[48;5;167m  \x1b[48;5;180m  \x1b[48;5;255m  \x1b[48;5;131m    \x1b[48;5;130m  \x1b[49m  \x1b[48;5;95m      \x1b[49m                      \x1b[m",
    "\x1b[49m                                \x1b[48;5;15m    \x1b[48;5;173m    \x1b[48;5;167m  \x1b[48;5;173m      \x1b[48;5;131m  \x1b[48;5;167m  \x1b[48;5;173m  \x1b[48;5;131m  \x1b[48;5;137m  \x1b[48;5;255m  \x1b[48;5;131m      \x1b[49m                              \x1b[m",
    "\x1b[49m                                  \x1b[48;5;15m  \x1b[48;5;255m  \x1b[48;5;173m  \x1b[48;5;167m  \x1b[48;5;173m    \x1b[48;5;167m  \x1b[48;5;131m  \x1b[48;5;173m  \x1b[48;5;131m      \x1b[48;5;254m  \x1b[48;5;187m  \x1b[48;5;131m    \x1b[49m                              \x1b[m",
    "\x1b[49m                                    \x1b[48;5;15m  \x1b[48;5;255m  \x1b[48;5;137m  \x1b[48;5;173m    \x1b[48;5;131m  \x1b[48;5;173m    \x1b[48;5;167m  \x1b[48;5;173m  \x1b[48;5;167m  \x1b[48;5;187m  \x1b[48;5;15m  \x1b[49m                                  \x1b[m",
    "\x1b[49m                                    \x1b[48;5;130m  \x1b[48;5;180m  \x1b[48;5;15m  \x1b[48;5;137m  \x1b[48;5;173m  \x1b[48;5;167m    \x1b[48;5;173m      \x1b[48;5;131m    \x1b[49m                                    \x1b[m",
    "\x1b[49m                                      \x1b[48;5;131m  \x1b[48;5;187m  \x1b[48;5;15m  \x1b[48;5;180m  \x1b[48;5;131m    \x1b[48;5;167m  \x1b[48;5;131m        \x1b[49m                                    \x1b[m",
    "\x1b[49m                                        \x1b[48;5;131m  \x1b[48;5;15m  \x1b[48;5;253m  \x1b[49m  \x1b[48;5;131m          \x1b[49m                                      \x1b[m",
    "\x1b[49m                                                                                                \x1b[m",
    "\x1b[49m                                                                                                \x1b[m",
    "\x1b[49m                                                                                                \x1b[m",
    "\x1b[49m                                                                                                \x1b[m",
    "\x1b[49m                                                                                                \x1b[m",
    "\x1b[49m                                                                                                \x1b[m"
  ];
}