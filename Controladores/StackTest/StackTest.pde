PrintWriter Out;

void setup() {
  //
  Out = createWriter("StackTest/StackTest.ino");
  String[] lines = loadStrings("StackTest.vm");
  String[] currentLineParts;  
  String currentLine;
  Out.println("int16_t M[16384] = {0};");  // Define Stack Space 
  Out.println("#define SP M[0]");  // SP Pointer in the Stack 
  Out.println("");
  Out.println("void setup() {");
  Out.println("M[0] = 256;");  // Initial Sp Position in the Stack 
  Out.println("");

  // Read the lines of the Vm File 
  for (int i = 0; i < lines.length; i++) {
    currentLine = lines[i];
    currentLineParts = split(currentLine, ' ');
    //Check if there's a Push in the first position  
    if (currentLineParts[0].equals("push")) { 
      //Check The Segment where we are doing the push ( in this case Constant) 
      if (currentLineParts[1].equals("constant")) {
        Out.println("M[SP++] = " + currentLineParts[2] + ";");
      }
    }
    if (currentLineParts[0].equals("add")) {
      Out.println("M[SP - 2] = M[SP - 2] + M[SP - 1];");
      Out.println("SP--;");
    }
    // Using this Algorithm For the Same 3 states >,<,= 
    if (currentLineParts[0].equals("eq")) {
      Out.println("if(M[SP - 2] == M[SP - 1])");
      Out.println("M[SP - 2] = -1;");
      Out.println("else");
      Out.println("M[SP - 2] = 0;");
      Out.println("SP--;");
    }
    if (currentLineParts[0].equals("lt")) {
      Out.println("if(M[SP - 2] < M[SP - 1])");
      Out.println("M[SP - 2] = -1;");
      Out.println("else");
      Out.println("M[SP - 2] = 0;");
      Out.println("SP--;");
    }
    if (currentLineParts[0].equals("gt")) {
      Out.println("if(M[SP - 2] > M[SP - 1])");
      Out.println("M[SP - 2] = -1;");
      Out.println("else");
      Out.println("M[SP - 2] = 0;");
      Out.println("SP--;");
    }
    if (currentLineParts[0].equals("sub")) {
      Out.println("M[SP - 2] = M[SP - 2] - M[SP - 1];");
      Out.println("SP--;");
    }
    if (currentLineParts[0].equals("neg")) {
      Out.println("M[SP-1] = -M[SP-1];");
    }
    if (currentLineParts[0].equals("and")) {
      Out.println("M[SP-2]= M[SP-2] & M[SP-1];");
      Out.println("SP--;");
    }
    if (currentLineParts[0].equals("or")) {
      Out.println("M[SP - 2] = M[SP - 2] | M[SP - 1];");
      Out.println("SP--;");
    }
    // This one return A2 complement of the number so we negate it and the add +1 ( Cause Checked on the Calculator ) 
    if (currentLineParts[0].equals("not")) {
      Out.println("M[SP - 1] = -(M[SP - 1] + 1);");
    }
  }
  Out.println("Serial.begin(9600);");
  Out.println(""); 
  Out.println("Serial.println();");
  Out.println("Serial.println();");  

  // Print The TestVector Results 

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(0);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[0]);");

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(M[0]-10);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[M[0] - 10]);");

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(M[0]-9);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[M[0] - 9]);");

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(M[0]-8);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[M[0] - 8]);");

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(M[0]-7);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[M[0] - 7]);");

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(M[0]-6);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[M[0] - 6]);");

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(M[0]-5);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[M[0] - 5]);");

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(M[0]-4);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[M[0] - 4]);");

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(M[0]-3);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[M[0] - 3]);");

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(M[0]-2);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[M[0] - 2]);");

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(M[0]-1);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[M[0] - 1]);");

  Out.println("}");  

  Out.println("void loop() {");
  Out.println("}");

  Out.flush();
  Out.close();
}
