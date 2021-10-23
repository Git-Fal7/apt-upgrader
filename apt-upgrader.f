# data file for the Fltk User Interface Designer (fluid)
version 1.0304
header_name {.h}
code_name {.cxx}
decl {\#include <stdio.h>} {private local
}

decl {\#include <string>} {public local
}

decl {using namespace std;} {private local
}

Function {popenStdout(string cmd)} {open private return_type string
} {
  code {string data;
FILE* stream;
const int max_buffer = 256;
char buffer[max_buffer];
cmd.append(" 2>&1");

stream = popen(cmd.c_str(), "r");

if (stream) {
	while (!feof(stream)) {
		if (fgets(buffer, max_buffer, stream) != NULL)
			data.append(buffer);	
	}
	pclose(stream);
}

return data;} {}
}

Function {} {open
} {
  Fl_Window main_window {
    label {System Upgrader} open
    xywh {275 175 915 495} type Double color 38 visible
  } {
    Fl_Output cmd_op {
      xywh {0 25 915 360} box FLAT_BOX color 35 labelsize 12 labelcolor 7 textsize 12 textcolor 7
    }
    Fl_Button {} {
      label Upgrade
      callback CB_Button
      xywh {250 425 95 20} box FLAT_BOX color 33 labelsize 12 labelcolor 7
    }
    Fl_Button {} {
      label Cancel
      callback Exit_button
      xywh {555 425 95 20} box FLAT_BOX color 33 labelsize 12 labelcolor 7
    }
  }
  Fl_Window done_window {
    label {Sucessfully upgraded} open
    xywh {252 631 485 100} type Double color 38 labelcolor 38 visible
  } {
    Fl_Button {} {
      label OK
      callback Exit_button
      xywh {200 65 70 20} box FLAT_BOX color 0 labelcolor 7
    }
    Fl_Box {} {
      label {Sucessfully upgraded the system, you may restart the system}
      xywh {225 28 35 17} labelcolor 7
    }
  }
  code {string out = popenStdout("apt-get -o DEbug::NoLocking=true --trivial-only -V dist-upgrade");
cmd_op->value(out.c_str());
main_window->show();} {}
}

Function {CB_Button(Fl_Widget*, void*)} {open return_type {static void}
} {
  code {main_window->hide();
system("pkexec apt-get dist-upgrade -y");
done_window->show();} {}
}

Function {Exit_button(Fl_Widget*, void*)} {open
} {
  code {exit(0);} {}
}
