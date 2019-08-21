//控制台输出函数
void d(data){
  // var debugPrintStack2 = debugPrintStack;
    // var debugPrintStack = debugPrintStack2()[3];
    // debugPrintStack(label: data,maxFrames: 3);
    // print(StackTrace.current);
  Iterable<String> lines = StackTrace.current.toString().trimRight().split('\n');
    var line = lines.elementAt(1);  
     print('输出内容：');
     print(data);
     print('行号'+line);
}
