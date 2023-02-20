class Voice {
  int id; // same nr as pitch value
  int status;
  int onTime, offTime;  //timing variables
  int warning = 0;
  boolean delayedNoteOff = false;
  boolean delayedNoteOn = false;
  int x, y, s;  //position and size

  /*
   status 1:  voice off, available for new note on message
   if note on received: play note
   goto status 2
   
   status 2:  voice on, waiting time after note on message
   if received another note ON: reset waiting time, report warning Yellow
   if received OFF: transmit OFF after waiting time, report RED warning 
   if nothing received: goto status 3
   
   status 3:  voice on, available for new note off message
   
   status 4: voice off, waiting after note off
   if received ON: transmit ON after waiting time, report red warning
   if received another OFF: reset waiting time, report yellow warning  
   
   */

  Voice (int id_in) {
    id = id_in;
    status = 1;
    onTime = 0;
    offTime = 0;
    x = -111;
    y = -111;
    s = 17;
  }


  void on() {
    switch(status) {
    case 1: 
      myBus.sendNoteOn(13, id, 127);
      onTime = millis();
      status = 2;
      break;
    case 2: 
      onTime = millis();
      warning = 1; // yellow warning
      break;
    case 3: 
      break;
    case 4: 
      delayedNoteOn = true;
      warning = 2;  // red warning
      break;
    }
  }

  void off() {
    switch(status) {
    case 1: 
      break;
    case 2: 
      delayedNoteOff = true;
      warning = 2; // red warning
      break;
    case 3:
      myBus.sendNoteOff(13, id, 0);  //note off
      offTime = millis();
      status = 4;
      break;
    case 4: 
      offTime = millis();
      warning = 1;
      break;
    }
  }

  void display() {
    switch(status) {
    case 1: 
      fill(44);
      break;
    case 2: 
      fill(44, 244, 222);
      if ( millis() - onTime > stopDamperTime) {
        status = 3;
        if (delayedNoteOff) {
          myBus.sendNoteOff(13, id, 0);
          delayedNoteOff = false;
          warning = 0;
          status = 4;
        }
      }
      break;
    case 3: 
      fill(44, 177, 144);
      break;
    case 4: 
      fill(111);
      if ( millis() - offTime > stopDamperTime) {
        if (delayedNoteOn) {
          myBus.sendNoteOn(13, id, 128);
          delayedNoteOn = false;
          warning = 0;
        }
        status = 1;
      }
      break;
    }

    if (warning == 1) fill(222, 222, 33);
    if (warning == 2) fill(222, 11, 11);

    ellipse(x, y, s, s);
  }

  void pos(int x_in, int y_in) {
    x = x_in;
    y = y_in;
  }
}
