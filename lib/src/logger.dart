import 'package:colorize/colorize.dart';
import 'dart:io';

class Logger{
  void i(dynamic text) {_formatter("i", text.toString());}
  void l(dynamic text) {_formatter("l", text.toString());}
  void w(dynamic text) {_formatter("w", text.toString());}
  void e(dynamic text) {_formatter("e", text.toString());}

  void res(dynamic text) {_formatter("res", text.toString());}
  void req(dynamic text) {_formatter("req", text.toString());}

  void _formatter(dynamic type, String text){
    if(type=="i") stdout.write(Colorize(type+"nfo:")..bold()..white()..bgGreen());
    if(type=="l") stdout.write(Colorize(type+"og:")..bold()..white()..bgDarkGray());
    if(type=="w") stdout.write(Colorize(type+"arning:")..bold()..white()..bgYellow());
    if(type=="e") stdout.write(Colorize(type+"rror:")..bold()..white()..bgRed());
    if(type=="res") stdout.write(Colorize(type+"ponse:")..bold()..white()..bgBlue());
    if(type=="req") stdout.write(Colorize(type+"est:")..bold()..white()..bgCyan());
    
    print(' '+text);
  }
}