
// for displaying MIDI events on a simplified keyboard indication

class Keyboard {
  int x, y, w, h;
  int lowestNote, highestNote;
  boolean keys[] = new boolean[128];  //

  Keyboard(int x_in, int y_in, int w_in, int h_in, int low_in, int high_in ) {
    x = x_in;
    y = y_in;
    w = w_in;
    h = h_in;
    lowestNote = low_in;
    highestNote = high_in;
  }


  void display() {

    //splash
    if (frameCount<66) {
      //test fill pattern
      for (int i=0; i<128; i++) {
        if (int(random(2))==0) {
          keys[i] = true;
        } else {
          keys[i] = false;
        }
      }
    }
    if (frameCount==67) {
      for (int i=0; i<128; i++) {
        keys[i] = false;
      }
    }

    int noteAmount = highestNote-lowestNote;
    // fill(22, 111, 44);
    strokeWeight(3);
    int ww = w/noteAmount;
    for (int i=0; i<noteAmount; i++) {
      int xx = int(map(i, 0, noteAmount, x, x+w));
      if (keys[i+lowestNote]==true) {
        fill(66, 222, 22);
      } else {
        fill(33);
      }
      rect(xx, y, ww, h);
    }

    // note out-of-range errors
    boolean lowError = false;
    for (int i=0; i<lowestNote; i++) {
      if (keys[i]==true) lowError = true;
    }
    if (lowError) {
      fill(222, 22, 22);
    } else {
      fill(33);
    }
    rect(x-ww, y+h/4, ww, h/2); 

    boolean highError = false;
    for (int i=highestNote; i<128; i++) {
      if (keys[i]==true) highError = true;
    }
    if (highError) {
      fill(222, 22, 22);
    } else {
      fill(33);
    }
    rect(x+w, y+h/4, ww, h/2);
  }
}
