import drop.*;
import java.util.List;


//Needed for handling drop events
SDrop drop;


//List of images to display
List<PImage> images = new ArrayList<PImage>();

//if likedStatus[i] == true that means that images[i] was marked was liked.
//(That's pretty old school. Could create a new class to hold PImage and liked fields together.)
List<Boolean> likedStatus = new ArrayList<Boolean>();


//Index of the currently displayed image
int currentImage = -1;

void settings() {
  size(400, 400);
}

void setup() {
  surface.setResizable(true);
  background(0);
  frameRate(30);
  drop = new SDrop(this);
  noStroke();
}

void draw() {
  if (currentImage >= 0) {   
    PImage image = images.get(currentImage);
    image(image, width/2.0 - image.width/2.0, height/2.0 - image.height/2.0);
    if (!likedStatus.get(currentImage)) {
      fill(0);
    } else {
      fill(255,255,255);
    }
    rect(20, 20, 20, 20);  
  }
}

  //Handle drag and drop events
  void dropEvent(DropEvent dropEvent) {
    if (dropEvent.isImage()) {
      String path = dropEvent.file().toString();
      PImage image = loadImage(path);
      image.resize(0, 600);
      images.add(image);
      likedStatus.add(false);
    }
    //is it the first image to be loaded? Set the currentImage;
    if (images.size() == 1) {
      currentImage = 0;
      surface.setSize(displayWidth, displayHeight);
    }
  }

  //Handle key press events
  void keyPressed() {
    if (keyCode == RIGHT && (currentImage+1) < images.size()) {
      background(0);
      currentImage += 1;
    };

    if (keyCode == LEFT && currentImage > 0) {
      background(0);
      currentImage -= 1;
    }

    if (keyCode == 0x20 && currentImage >=0 && currentImage < likedStatus.size()) {
      
      likedStatus.set(currentImage, !likedStatus.get(currentImage));
      System.out.println(likedStatus.get(currentImage));
    }

    if (keyCode == BACKSPACE) {
      background(0);
      currentImage = -1;
      images.clear();
    }
  }