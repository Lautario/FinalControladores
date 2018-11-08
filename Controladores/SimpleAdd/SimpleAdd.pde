PrintWriter Out;

void setup() {
  //
  Out = createWriter("SimpleAdd/SimpleAdd.ino");
  String[] lines = loadStrings("SimpleAdd.vm");
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
  Out.println("Serial.print(M[0]-1);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[M[0] - 1]);");



  Out.println("}");  

  Out.println("void loop() {");
  Out.println("}");

  Out.flush();
  Out.close();
}
