import drop.*;
import java.util.List;


//Needed for handling drop events
SDrop drop;


//List of images to display
List<PImage> images = new ArrayList<PImage>();

//If the image is liked its index number will be stored in this list
List<Integer> likedImages = new ArrayList<Integer>();

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
    image(image, width/2.0 - image.width/2.0 , height/2.0 - image.height/2.0);
  }
}


//Handle drag and drop events
void dropEvent(DropEvent dropEvent) {
  if (dropEvent.isImage()) {
    String path = dropEvent.file().toString();
    PImage image = loadImage(path);
    image.resize(0, 600);
    images.add(image);
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
  
  if (keyCode == BACKSPACE) {
    background(0);
    currentImage = -1;
    images.clear();
  }
}