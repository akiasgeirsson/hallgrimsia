//HALLGRIMSIA

// hallgrimskirkja KLAIS organ interface
// MIDI display notes and stops and out-of-bounds
// Filter unneeded commands (record, playback, combinations etc)
// MIDI-through for note range fitting with keyboards and stops
// MIDI PANIC BUTTON

// Aki Asgeirsson january 2023




import themidibus.*;
MidiBus myBus;


//  keyboard display
Keyboard kb1, kb2, kb3, kb4, kb5;


// object array for voice registers
Voice[] stop;
int stopDamperTime = 500;


//swellwerk
float swell = 0.1;


int slowPanic = 129;
int voicePanic = 11;
int hardPanic = 22;

void setup() {
  size(1100, 700);
  background(255);
  frameRate(20);

  // List all MIDI devices
  MidiBus.list();

  // Connect to one of the devices
  myBus = new MidiBus(this, 1, 2);

  // objects for voice registers
  stop = new Voice[90];
  for (int i = 0; i<90; i++) {
    stop[i] = new Voice(i);
  }



  for (int i=0; i<10; i++) {
    stop[i].pos(int((width/17.0)*(i+4)), int(height*0.18));
  }

  for (int i=10; i<31; i++) {
    stop[i].pos(int((width/26.0)*(i-7)), int(height*0.33));
  }

  for (int i=31; i<51; i++) {
    stop[i].pos(int((width/25.0)*(i-28)), int(height*0.48));
  }  

  for (int i=51; i<67; i++) {
    stop[i].pos(int((width/21.0)*(i-48)), int(height*0.63));
  }  
  for (int i=67; i<87; i++) {
    stop[i].pos(int((width/39.0)*(i-57)), int(height*0.78));
  }  

  stop[87].pos(int((width/33.0)*27), int(height*0.85));
  stop[88].pos(int((width/33.0)*28), int(height*0.85));
  stop[89].pos(int((width/33.0)*29), int(height*0.85));


  // objects for keyboard display
  //int x_in, int y_in, int w_in, int h_in, int low_in, int high_in 

  kb1 = new Keyboard(int(width*0.3), int(height*0.8), int(width*0.4), int(height*0.07), 36, 67);
  kb2 = new Keyboard(int(width*0.1), int(height*0.65), int(width*0.8), int(height*0.07), 36, 96);
  kb3 = new Keyboard(int(width*0.1), int(height*0.5), int(width*0.8), int(height*0.07), 36, 96);
  kb4 = new Keyboard(int(width*0.1), int(height*0.35), int(width*0.8), int(height*0.07), 36, 96);
  kb5 = new Keyboard(int(width*0.1), int(height*0.2), int(width*0.8), int(height*0.07), 36, 96);
}


void draw() {
  background(99, 55, 88);
  fill(188);
  textSize(16);
  text("MIDI Traffic Controller for Hallgrimskirkja Klais Organ", width*0.1, height*0.08);
  text("aki asgeirsson, jan'23", width*0.1, height*0.11);

  // display keyboards
  kb1.display();
  kb2.display();
  kb3.display();
  kb4.display();
  kb5.display();



  // display swellwerk
  rectMode(CENTER);
  fill(111);
  rect(width*0.15, height*0.85, width*0.1, height*0.1);
  fill(77, 222, 55);
  rect(width*0.15, height*0.85, width*0.1*swell, height*0.1*swell);

  // rectangle for effect stops
  fill(111);
  rect(width*0.85, height*0.85, width*0.1, height*0.1);

  // rectangle for panic buttons
  rect(width*0.85, height*0.1, width*0.1, height*0.1);




  // display registers
  for (int i = 0; i<90; i++) {
    stop[i].display();
  }



  // display panic buttons

  // voice panic
  if (voicePanic<5) {
    fill(222, 2, 22);
  } else {
    fill(55);
  }
  voicePanic++;
  rect(width*0.825, height*0.1, width*0.01, height*0.05);


  //slow panic
  if (slowPanic<128) {
    kb1.keys[slowPanic] = false; 
    kb2.keys[slowPanic] = false; 
    kb3.keys[slowPanic] = false; 
    kb4.keys[slowPanic] = false; 
    kb5.keys[slowPanic] = false; 
    myBus.sendNoteOff(0, slowPanic, 0);
    myBus.sendNoteOff(1, slowPanic, 0);
    myBus.sendNoteOff(2, slowPanic, 0);
    myBus.sendNoteOff(3, slowPanic, 0);
    myBus.sendNoteOff(4, slowPanic, 0);
    fill(222, 2, 22);
  } else {
    fill(55);
  }
  slowPanic++;
  rect(width*0.85, height*0.1, width*0.01, height*0.05);


  // hard panic
  fill(66);
  rect(width*0.875, height*0.1, width*0.01, height*0.05);

  rectMode(CORNER);
}


void keyPressed() {


  // voice panic
  if (key == 'i' || key == 'I') {
    voicePanic = 0;
    for (int i = 0; i<90; i++) {
      stop[i].off();
      //myBus.sendNoteOn(13, i, 0);
      myBus.sendNoteOff(13, i, 0);
    }
  }


  // slow panic
  if (key == 'o' || key == 'O') {
    slowPanic = 0;  //MIDI messages sent from draw function
  }

  // hard panic
  if (key == 'p' || key == 'P') {
    fill(255, 0, 0);
    rectMode(CENTER);
    rect(width*0.875, height*0.1, width*0.01, height*0.05); // ath display
    rectMode(CORNER);
    for (int i = 0; i<128; i++) {
      kb1.keys[i] = false; 
      kb2.keys[i] = false; 
      kb3.keys[i] = false; 
      kb4.keys[i] = false; 
      kb5.keys[i] = false; 
      myBus.sendNoteOff(0, i, 0);
      myBus.sendNoteOff(1, i, 0);
      myBus.sendNoteOff(2, i, 0);
      myBus.sendNoteOff(3, i, 0);
      myBus.sendNoteOff(4, i, 0);

      delay(1); // ath  midibus thread.yield delay ??
    }
  }
}

void noteOff(Note note) {
  // Receive a noteOn
  println();
  println("Note Offfff:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());


  if (note.channel()==0) {
  //  if (note.velocity()==0) {
      kb1.keys[note.pitch()] = false;
  //  }
  }


  if (note.channel()==1) {
    //if (note.velocity()==0) {
      kb2.keys[note.pitch()] = false;
    //}
  }


  if (note.channel()==2) {
    //if (note.velocity()==0) {
      kb3.keys[note.pitch()] = false;
    //}
  }


  if (note.channel()==3) {
    //if (note.velocity()==0) {
      kb4.keys[note.pitch()] = false;
    //}
  }


  if (note.channel()==4) {
    //if (note.velocity()==0) {
      kb5.keys[note.pitch()] = false;
    //}
  }




  // MIDI-through
  if (note.channel() == 0 && (note.pitch() >= 36 && note.pitch() <= 67) )   myBus.sendNoteOff(note);
  if (note.channel() == 1 && (note.pitch() >= 36 && note.pitch() <= 93) )   myBus.sendNoteOff(note);
  if (note.channel() == 2 && (note.pitch() >= 36 && note.pitch() <= 93) )   myBus.sendNoteOff(note);
  if (note.channel() == 3 && (note.pitch() >= 36 && note.pitch() <= 93) )   myBus.sendNoteOff(note);
  if (note.channel() == 4 && (note.pitch() >= 36 && note.pitch() <= 93) )   myBus.sendNoteOff(note);




  // forward chan 14 to speed damper 
  if (note.channel() == 13) {
    if (note.pitch() < 90) {
      //  if (note.velocity()==0) { 
      stop[note.pitch()].off();
      // }
    }
  }
}

void noteOn(Note note) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+note.channel());
  println("Pitch:"+note.pitch());
  println("Velocity:"+note.velocity());


  //write to array for keyboard display
  if (note.channel()==0) {
    if (note.velocity()==0) {           // note ON with zero velocity (note off) 
      kb1.keys[note.pitch()] = false;
    } else {
      kb1.keys[note.pitch()] = true;    // note ON with any velocity
    }
  }


  if (note.channel()==1) {
    if (note.velocity()==0) {
      kb2.keys[note.pitch()] = false;
    } else {
      kb2.keys[note.pitch()] = true;
    }
  }


  if (note.channel()==2) {
    if (note.velocity()==0) {
      kb3.keys[note.pitch()] = false;
    } else {
      kb3.keys[note.pitch()] = true;
    }
  }


  if (note.channel()==3) {
    if (note.velocity()==0) {
      kb4.keys[note.pitch()] = false;
    } else {
      kb4.keys[note.pitch()] = true;
    }
  }


  if (note.channel()==4) {
    if (note.velocity()==0) {
      kb5.keys[note.pitch()] = false;
    } else {
      kb5.keys[note.pitch()] = true;
    }
  }


  // MIDI-through
  if (note.channel() == 0 && (note.pitch() >= 36 && note.pitch() <= 67) )   myBus.sendNoteOn(note);
  if (note.channel() == 1 && (note.pitch() >= 36 && note.pitch() <= 93) )   myBus.sendNoteOn(note);
  if (note.channel() == 2 && (note.pitch() >= 36 && note.pitch() <= 93) )   myBus.sendNoteOn(note);
  if (note.channel() == 3 && (note.pitch() >= 36 && note.pitch() <= 93) )   myBus.sendNoteOn(note);
  if (note.channel() == 4 && (note.pitch() >= 36 && note.pitch() <= 93) )   myBus.sendNoteOn(note);


  // forward chan 14 to speed damper 
  if (note.channel() == 13) {
    if (note.pitch() < 90) {
      if (note.velocity()==0) { 
        stop[note.pitch()].off();
      } else {
        stop[note.pitch()].on();
      }
    }
  }
}


void controllerChange(ControlChange change) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+change.channel());
  println("Number:"+change.number());
  println("Value:"+change.value());

  if (change.channel() == 3) {
    if (change.number() == 7) {  // ath zero based or not??
      swell = change.value()/128.0;
      myBus.sendControllerChange(change);
    }
  }
}


//midibus thread delay

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
