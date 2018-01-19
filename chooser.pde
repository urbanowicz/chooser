import drop.*;
import java.util.List;
import java.nio.file.Files;


//------------------------------------------
//HELPER FUNCTIONS
//------------------------------------------

//create a directory if it doesn't already exist
void createDir(File dir) {
  if (!dir.exists()) {
    try {
      dir.mkdir();
    } 
    catch(Exception e) {
      throw new RuntimeException(e);
    }
  }
}

void fcopy(File source, File destination) {
  try {
    Files.copy(source.toPath(), destination.toPath());
  } catch(Exception e) {
    throw new RuntimeException(e);
  }
}


//-------------------------------------------
//SHARED VARIABLES
//-------------------------------------------

//Needed for handling drop events
SDrop drop;

//List of images to display
List<PImage> images = new ArrayList<PImage>();

//List of paths to image files
List<String> imagePaths = new ArrayList<String>();

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
      fill(255, 255, 255);
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
    imagePaths.add(path);
  }
  //is it the first image to be loaded? Set the currentImage;
  if (images.size() == 1) {
    currentImage = 0;
    surface.setSize(displayWidth, displayHeight);
  }
}

//Callback function for when the user selects the folder to export the images to
void exportFolderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    //mkdir outtakes
    File outtakesDir = new File(selection.getAbsolutePath() + "/outtakes");
    createDir(outtakesDir);
    //mkdir liked
    File selectedDir = new File(selection.getAbsolutePath() + "/selected");
    createDir(selectedDir);

    for (int i = 0; i < images.size(); i++) {
      File source = new File(imagePaths.get(i));
      if (likedStatus.get(i)) {
        File destination = new File(selectedDir.getAbsolutePath() + "/" + source.getName());
        System.out.println(source.getAbsolutePath() + " -> " + destination.getAbsolutePath());
        fcopy(source, destination);
      } else {
        File destination = new File(outtakesDir.getAbsolutePath() + "/" + source.getName());
        System.out.println(source.getAbsolutePath() + " -> " + destination.getAbsolutePath());
        fcopy(source, destination);
      }
    }
  }
}

//Handle key press events
void keyPressed() {

  //previous image
  if (keyCode == RIGHT && (currentImage+1) < images.size()) {
    background(0);
    currentImage += 1;
  };

  //next image
  if (keyCode == LEFT && currentImage > 0) {
    background(0);
    currentImage -= 1;
  }

  //mark image as liked
  if (keyCode == 0x20 && currentImage >=0 && currentImage < likedStatus.size()) {
    likedStatus.set(currentImage, !likedStatus.get(currentImage));
  }

  //clear all images
  if (keyCode == BACKSPACE) {
    background(0);
    currentImage = -1;
    images.clear();
    imagePaths.clear();
    likedStatus.clear();
  }

  //export selected images
  if (key == 'e' && images.size() > 0) {
    selectFolder("Select a folder to process:", "exportFolderSelected");
  }
}