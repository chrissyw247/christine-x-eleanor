import SimpleOpenNI.*;
SimpleOpenNI kinect;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
String message;

//Target firstTrig;
Target[] targArray;
int[] trigArray;

void setup() {
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 kinect.enableUser();// this changed
 
 oscP5 = new OscP5(this,12000);
 myRemoteLocation = new NetAddress("127.0.0.1",12000);
 message = "not triggered";
 
 size(640, 480);
 fill(255, 0, 0);
 
 setupArray();
 //firstTrig = new Target(0, 0, 0, width/4);
}

void draw() {
  kinect.update();
  image(kinect.depthImage(), 0, 0);

  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  if (userList.size() > 0) {
  int userId = userList.get(0);

    if ( kinect.isTrackingSkeleton(userId)) {
    drawSkeleton(userId);
    }
  }
}

void drawSkeleton(int userId) {
 stroke(0);
 strokeWeight(5);
 
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);

 noStroke();

 fill(255,0,0);
 drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
 drawJoint(userId, SimpleOpenNI.SKEL_NECK);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
 drawJoint(userId, SimpleOpenNI.SKEL_NECK);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
 drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
 
 PVector test = getJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
 checkTargets(test);
 //firstTrig.checkCollision(test);
 
 //if (firstTrig.triggered == true){
 //  tint(250, 0, 0);
 //  if (message == "not triggered"){
 //    message = "triggered";
 //    sendOSCMessage();
 //  }
 //} else {
 //  noTint();
 //  if (message == "triggered"){
 //    message = "not triggered";
 //    sendOSCMessage();
 //  }
 //}
 
 
 
}

void drawJoint(int userId, int jointID) {
 PVector joint = new PVector();

 float confidence = kinect.getJointPositionSkeleton(userId, jointID,
joint);
 if(confidence < 0.5){
   return;
 }
 PVector convertedJoint = new PVector();
 kinect.convertRealWorldToProjective(joint, convertedJoint);
 ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
 //println(convertedJoint);
}

PVector getJoint(int userId, int jointID){
  PVector temp = new PVector();
  
  float confidence = kinect.getJointPositionSkeleton(userId, jointID,
temp);
 if(confidence < 0.5){
   return temp;
 }
 PVector convertedJoint = new PVector();
 kinect.convertRealWorldToProjective(temp, convertedJoint);
 return convertedJoint;
}

//Calibration not required

void onNewUser(SimpleOpenNI kinect, int userID){
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}

void sendOSCMessage() {
  OscMessage myMessage = new OscMessage(message);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}

void setupArray(){
  trigArray = new int[4];
  targArray = new Target[4];
  targArray[0] = new Target(0, 0, 0, width/4);
  targArray[1] = new Target(width/2, 0, 0, width/4);
  targArray[2] = new Target(0, height/2, 0, width/4);
  targArray[3] = new Target(width/2, height/2, 0, width/4);
}

/* Loop through target array to check if the joint is triggering it
* if it is set the trigger array to 1, if it is not set it to 0.
*/
void checkTargets(PVector joint){
  for (int i = 0; i < targArray.length; i++){
    targArray[i].checkCollision(joint);
    if (targArray[i].triggered == true){
      trigArray[i] = 1;
      println("trigger " + i + " activated");
    } else if (targArray[i].triggered == false) {
      trigArray[i] = 0;
    }
  }
  printArray(trigArray);
}
