PrintWriter Out;

void setup() {
  Out = createWriter("BasicLoop/BasicLoop.ino");
  String[] lines = loadStrings("BasicLoop.vm");
  String[] currentLineParts;  
  String currentLine;
  Out.println("int16_t M[16384] = {0};");  // Define Stack Space 
  Out.println("#define SP M[0]"); // SP Pointer in the Stack 
  Out.println("#define LCL M[1]"); // Local Pointer in the Stack 
  Out.println("#define ARG M[2]"); // Argument Pointer in the Stack 
  Out.println("#define THIS M[3]"); // this Pointer in the Stack 
  Out.println("#define THAT M[4]"); // that Pointer in the Stack 
  Out.println("#define TEMP 5"); // Temp Pointer 
  Out.println("#define STATIC 16");
  Out.println("");
  Out.println("void setup() {");
  Out.println("Serial.begin(9600);");
  Out.println("M[0] = 256;"); // Initial Sp Position in the Stack 
  Out.println("M[1] = 300;");  // Initial LCL Position in the Stack 
  Out.println("M[2] = 400;");  // Initial ARG Position in the Stack 
  Out.println("M[3] = 3000;");  // Initial THIS Position in the Stack 
  Out.println("M[4] = 3010;");  // Initial THAT Position in the Stack 
  Out.println("M[ARG] = 3;");
  Out.println("");


  // Read the lines of the Vm File 
  for (int i = 0; i < lines.length; i++) {
    currentLine = lines[i];
    currentLineParts = split(currentLine, ' ');
    // If there´s something called "label"  
    if (currentLineParts[0].equals("label")) {
      Out.println(currentLineParts[1]+":");
    }
    // If there´s something called " if-goto"  
    if (currentLineParts[0].equals("if-goto")) {
      Out.println("SP--;");
      Out.println("if(M[SP]){");
      Out.println("goto "+currentLineParts[1]+";");
      Out.println("}");
    }
    //Check if there's a Push in the first position  
    if (currentLineParts[0].equals("push")) {
      //Check The Segment where we are doing the push.
      if (currentLineParts[1].equals("constant")) {
        Out.println("M[SP++] = " + currentLineParts[2] + ";");
      }
      if (currentLineParts[1].equals("local")) {
        Out.println("M[SP] = M[LCL+"+currentLineParts[2]+"];");
        Out.println("SP++;");
      }   
      if (currentLineParts[1].equals("argument")) {
        Out.println("M[SP] = M[ARG+"+currentLineParts[2]+"];");
        Out.println("SP++;");
      }
      if (currentLineParts[1].equals("this")) {
        Out.println("M[SP] = M[THIS+"+currentLineParts[2]+"];");
        Out.println("SP++;");
      } 
      if (currentLineParts[1].equals("that")) {
        Out.println("M[SP] = M[THAT+"+currentLineParts[2]+"];");
        Out.println("SP++;");
      }
      if (currentLineParts[1].equals("temp")) {
        Out.println("M[SP] = M[TEMP+"+currentLineParts[2]+"];");
        Out.println("SP++;");
      }

      // Implemetation of the Pointer Segment Acording to NandToTetris
      if (currentLineParts[1].equals("pointer")) {
        if (currentLineParts[2].equals("0")) {
          Out.println("M[SP] = THIS;");
          Out.println("SP++;");
        }
        if (currentLineParts[2].equals("1")) {
          Out.println("M[SP] = THAT;");
          Out.println("SP++;");
        }
      }
      if (currentLineParts[1].equals("static")) {
        Out.println("M[SP] = M[STATIC+"+currentLineParts[2]+"];");
        Out.println("SP++;");
      }
    }
    //Check if there's a Pop in the first position  
    if (currentLineParts[0].equals("pop")) {   
      if (currentLineParts[1].equals("local")) {
        Out.println("SP--;");
        Out.println("M[LCL+"+ currentLineParts[2] +"] = M[SP];");
      }      
      if (currentLineParts[1].equals("argument")) {
        Out.println("SP--;");
        Out.println("M[ARG+"+ currentLineParts[2] +"] = M[SP];");
      }  
      if (currentLineParts[1].equals("this")) {
        Out.println("SP--;");
        Out.println("M[THIS+"+ currentLineParts[2] +"] = M[SP];");
      } 
      if (currentLineParts[1].equals("that")) {
        Out.println("SP--;");
        Out.println("M[THAT+"+ currentLineParts[2] +"] = M[SP];");
      } 
      if (currentLineParts[1].equals("temp")) {
        Out.println("SP--;");
        Out.println("M[TEMP+"+ currentLineParts[2] +"] = M[SP];");
      }
      //Si es un 'pointer'   
      if (currentLineParts[1].equals("pointer")) {
        //Si es un '0'   
        if (currentLineParts[2].equals("0")) {
          Out.println("SP--;");
          Out.println("THIS = M[SP];");
        }
        //Si es un '1'
        if (currentLineParts[2].equals("1")) {
          Out.println("SP--;");
          Out.println("THAT = M[SP];");
        }
      }
      if (currentLineParts[1].equals("static")) {
        Out.println("SP--;");
        Out.println("M[STATIC+"+ currentLineParts[2] +"] = M[SP];");
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
  Out.println(""); 
  Out.println("Serial.println();");
  Out.println("Serial.println();");  

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(0);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[0]);"); 

  Out.println("");  
  Out.println("Serial.print(\"RAM[\");");
  Out.println("Serial.print(256);");
  Out.println("Serial.print(\"] = \");");
  Out.println("Serial.println(M[256]);"); 
  Out.println("}");  

  Out.println("void loop() {");
  Out.println("}");

  Out.flush();
  Out.close();
}
