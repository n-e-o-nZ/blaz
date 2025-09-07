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
    if(type=="i") stdout.write(Colorize(_time()+type+"nfo:")..bold()..white()..bgGreen());
    if(type=="l") stdout.write(Colorize(_time()+type+"og:")..bold()..white()..bgDarkGray());
    if(type=="w") stdout.write(Colorize(_time()+type+"arning:")..bold()..white()..bgYellow());
    if(type=="e") stdout.write(Colorize(_time()+type+"rror:")..bold()..white()..bgRed());
    if(type=="res") stdout.write(Colorize(_time()+type+"ponse:")..bold()..white()..bgBlue());
    if(type=="req") stdout.write(Colorize(_time()+type+"est:")..bold()..white()..bgCyan());
    
    print(' '+text);
  }

  String _time() => "[${DateTime.now().hour..toString()}:${DateTime.now().minute..toString()}:${DateTime.now().second..toString()}] ";
}