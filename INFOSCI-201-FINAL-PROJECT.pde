import controlP5.*;
ControlP5 cp5;
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
int knobPin = 0;
int ledPin = 10;
int readValue = 0;
int ledValue = 0;

PFont font_title;
PShape lotus, arrow, home;
PImage happy, grateful, excited, relaxed, content, tired, unsure, bored, anxious, angry, stressed, sad;
Button qs_btn, jb_btn, jc_btn, data_btn, start_btn, pause_btn;
Button happy_btn, grateful_btn, excited_btn, relaxed_btn, content_btn, tired_btn, unsure_btn, bored_btn, anxious_btn, angry_btn, stressed_btn, sad_btn;
Button analysis_1, analysis_2, analysis_3, analysis_4, analysis_btn; 
Button br_session, ci_session;
Button practice_1_btn, practice_2_btn, practice_3_btn;

// declare variables
float angle = -3.1415/2;
int page = 0;
int duration = 5;
boolean doOnce; // a boolean switch that helps avoid clicking multiple times in draw function
boolean breathing = false;
boolean inhale = true;
ArrayList<String> feelings = new ArrayList<String>();

// booleans to tell which is currently being typed
boolean analy = false;
boolean prac_1 = false;
boolean prac_2 = false;
boolean prac_3 = false;

// Variable to store text
String analysis = "";
String practice_1 = "";
String practice_2 = "";
String practice_3 = "";


void setup() {
  size(1000, 800);
  smooth(8);  
  arduino = new Arduino(this, "COM5", 57600);
  // ----------------Arduino Communication----------------------------
  // Set the Arduino digital pins as inputs.
  arduino.pinMode(knobPin, Arduino.INPUT);
  arduino.pinMode(ledPin, Arduino.OUTPUT);
  // -----------------------------------------------------------------
  
  // PFont font_text = createFont("arial",20);
  font_title = loadFont("Serif.bolditalic-48.vlw");
  lotus = loadShape("lotus_svg.svg");
  arrow = loadShape("right-arrow.svg");
  home = loadShape("home.svg");

  // emoticons
  happy = loadImage("happy.png");
  grateful = loadImage("grateful.png");
  excited = loadImage("excited.png");
  relaxed = loadImage("relaxed.png");
  content = loadImage("content.png");
  tired = loadImage("tired.png");
  unsure = loadImage("unsure.png");
  bored = loadImage("bored.png");
  anxious = loadImage("anxious.png");
  angry = loadImage("angry.png");
  stressed = loadImage("stressed.png");
  sad = loadImage("sad.png");

  happy_btn = new Button(100, 290, 250, 100, "Happy", 40,false);
  grateful_btn = new Button(width/2-125, 290, 250, 100, "Grateful", 40,false);
  excited_btn = new Button(width-350, 290, 250, 100, "Excited", 40,false);
  relaxed_btn = new Button(100, 410, 250, 100, "Relaxed", 40,false);
  content_btn = new Button(width/2-125, 410, 250, 100, "Content", 40,false);
  tired_btn = new Button(width-350, 410, 250, 100, "Tired", 40,false);
  bored_btn = new Button(100, 530, 250, 100, "Bored", 40,false);
  anxious_btn = new Button(width/2-125, 530, 250, 100, "Anxious", 40,false);
  stressed_btn = new Button(width-350, 530, 250, 100, "Stressed", 40,false);
  angry_btn = new Button(100, 650, 250, 100, "Angry", 40,false);
  unsure_btn = new Button(width/2-125, 650, 250, 100, "Unsure", 40,false);
  sad_btn = new Button(width-350, 650, 250, 100, "Sad", 40,false);

  // buttons
  qs_btn = new Button(width/2, height/2-50, 350, 0, "Quick Start", 50,true);
  jb_btn = new Button(width/2-450, height/2+150, 350, 100, "Just Breathe", 50,false);
  jc_btn = new Button(width/2+450-350, height/2+150, 350, 100, "Just Check In", 50,false);
  data_btn = new Button(width/2-175, height-125, 350, 100, "Past Activites", 50,false);
  start_btn = new Button(width/2-400, 50, 200, 70, "Start", 50,false);
  pause_btn = new Button(width/2+400-200, 50, 200, 70, "Pause", 50,false);

  analysis_1 = new Button(100, 270, 180, 80, "Family", 40,false);
  analysis_2 = new Button(300, 270, 180, 80, "School", 40,false);
  analysis_3 = new Button(500, 270, 180, 80, "Work", 40,false);
  analysis_4 = new Button(700, 270, 180, 80, "Friends", 40,false);
  analysis_btn = new Button(100, 450, 800, 300, "", 50, false);

  br_session = new Button(width/2-250, 200, 500, 100, "Breathing Sessions", 50,false);
  ci_session = new Button(width/2-250, 500, 500, 100, "Check-In Sessions", 50,false);

  practice_1_btn = new Button(100, 70, 800, 200, "", 50,false);
  practice_2_btn = new Button(100, 340, 800, 200, "", 50,false);
  practice_3_btn = new Button(100, 610, 800, 180, "", 50,false);

}

void draw() {
  background(138, 114, 190);
  noStroke();

  // reset doOnce to false in every iteration to avoid multiple clicks 
  if (!mousePressed){
    doOnce = false;
  }

  if (page == 0) {
    drawHomepage();
  }
  // Breathe page can be reached through both "Quick Start" and "JustBreathe". Return icon is different in the two scenarios
  if (page == 1) {
    shape(arrow, width-70, height-70, 50, 50); 
    drawBreathePage();
    if ((mouseX>width-70) && (mouseX<width-70+50) && (mouseY<height-70+50) && (mouseY>height-70) && mousePressed && (doOnce==false)) {
      page = 3;
      doOnce = true;
    }
  }
  if (page == 2) {
    shape(home, width-70, height-70, 50, 50); 
    drawBreathePage();
    if ((mouseX>width-70) && (mouseX<width-70+50) && (mouseY<height-70+50) && (mouseY>height-70) && mousePressed && (doOnce==false)) {
      page = 0;
      doOnce = true;
    }
  }
  if (page == 3) {
    drawFeelingPage();
  }
  if (page == 4) {
    drawAnalysisPage();
  }
  if (page == 5) {
    drawPracticePage();
  }
  if (page == 6) {
    drawDataPage();
  }
  if (page == 7){
    drawBrDataPage();
  }
  if (page == 8){
    drawCiDataPage();
  }
}

// ---------pages----------------
void drawHomepage() {
  // draw hovering lotus 
  angle += 0.02;
  shape(lotus, width/2-50, 25+(sin(angle) * 15), 100, 100);  

  qs_btn.display();
  if (qs_btn.hovering(mouseX,mouseY)) {
    qs_btn.display_hovering();
    if (mousePressed && doOnce==false) {
      page = 1;
      doOnce = true;
    }
  }

  jb_btn.display();
  if (jb_btn.hovering(mouseX,mouseY)) {
    jb_btn.display_hovering();
    if (mousePressed && doOnce==false) {
      page = 2;
      doOnce = true;
    }
  }

  jc_btn.display();
  if (jc_btn.hovering(mouseX,mouseY)) {
    jc_btn.display_hovering();
    if (mousePressed && doOnce==false) {
      page = 3;
      doOnce = true;
    }
  }

  data_btn.display();
  if (data_btn.hovering(mouseX,mouseY)) {
    data_btn.display_hovering();
    if (mousePressed && doOnce==false) {
      page = 6;
      doOnce = true;
    }
  }

}

void drawBreathePage() {
  fill(116, 193, 242);
  text(duration, width/2-35, 100);
  text("mins", width/2+35, 100);

  // draw static circle
  if (breathing == false) {
    circle(width/2, height/2+50, 101);
  }

  start_btn.display();
  if (start_btn.hovering(mouseX,mouseY)) {
    start_btn.display_hovering();
    if (mousePressed) {
      breathing = true;;
    }
  }
  
  pause_btn.display();
  if (pause_btn.hovering(mouseX,mouseY)) {
    pause_btn.display_hovering();
    if (mousePressed) {
      breathing = false;
      angle = -3.1415/2;
    }
  }

  // draw breathing circle
  if (breathing==true) {
    float d = 200+sin(angle)*100;
    noStroke();
    fill(116, 193, 242);
    circle(width/2, height/2+50, d);
    if (d>299.99) {
      inhale = false;
    }
    if (d<100.01) {
      inhale = true;
    }
    if (inhale) {
      text("Breathe in...", width/2, 200);
    } else {
      text("and out...", width/2, 200);
    }
    angle+=0.017;
  }

}

void drawFeelingPage() {
  shape(arrow, width-70, height-70, 50, 50);  
  if ((mouseX>width-70) && (mouseX<width-70+50) && (mouseY<height-70+50) && (mouseY>height-70) && mousePressed && (doOnce==false)) {
    page = 4;
    doOnce = true;
  }

  fill(116, 193, 242);
  // add texts and emoticons
  textSize(50);
  text("I am feeling", width/2, 100);
  text("And ", width/2, 250);
  textSize(50);
  fill(141, 203, 142);

  // ------------Arduino section-------------
  readValue = arduino.analogRead(knobPin);
  int mappedReadValue =  Math.round(readValue / 10.23);
  // map readValue to value within 0-255
  ledValue =  int(255*readValue/1024);
  arduino.analogWrite(ledPin, ledValue);
  
  // ----------------------------------------

  text(Integer.toString(mappedReadValue)+ "% Positive", width/2, 180);
  
  println(feelings);

  happy_btn.display();
  if (happy_btn.hovering(mouseX,mouseY)) {
    happy_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(happy_btn.label) && doOnce==false) {
      feelings.add(happy_btn.label);
      doOnce=true;
    }
  }
  grateful_btn.display();
  if (grateful_btn.hovering(mouseX,mouseY)) {
    grateful_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(grateful_btn.label) && doOnce==false) {
      feelings.add(grateful_btn.label);
      doOnce=true;
    }
  }
  excited_btn.display();
  if (excited_btn.hovering(mouseX,mouseY)) {
    excited_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(excited_btn.label) && doOnce==false) {
      feelings.add(excited_btn.label);
      doOnce=true;
    }
  }
  relaxed_btn.display();
  if (relaxed_btn.hovering(mouseX,mouseY)) {
    relaxed_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(relaxed_btn.label) && doOnce==false) {
      feelings.add(relaxed_btn.label);
      doOnce=true;
    }
  }
  content_btn.display();
  if (content_btn.hovering(mouseX,mouseY)) {
    content_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(content_btn.label) && doOnce==false) {
      feelings.add(content_btn.label);
      doOnce=true;
    }
  }
  tired_btn.display();
  if (tired_btn.hovering(mouseX,mouseY)) {
    tired_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(tired_btn.label) && doOnce==false) {
      feelings.add(tired_btn.label);
      doOnce=true;
    }
  }
  unsure_btn.display();
  if (unsure_btn.hovering(mouseX,mouseY)) {
    unsure_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(unsure_btn.label) && doOnce==false) {
      feelings.add(unsure_btn.label);
      doOnce=true;
    }
  }
  bored_btn.display();
  if (bored_btn.hovering(mouseX,mouseY)) {
    bored_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(bored_btn.label) && doOnce==false) {
      feelings.add(bored_btn.label);
      doOnce=true;
    }
  }
  anxious_btn.display();
  if (anxious_btn.hovering(mouseX,mouseY)) {
    anxious_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(anxious_btn.label) && doOnce==false) {
      feelings.add(anxious_btn.label);
      doOnce=true;
    }
  }
  angry_btn.display();
  if (angry_btn.hovering(mouseX,mouseY)) {
    angry_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(angry_btn.label) && doOnce==false) {
      feelings.add(angry_btn.label);
      doOnce=true;
    }
  }
  stressed_btn.display();
  if (stressed_btn.hovering(mouseX,mouseY)) {
    stressed_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(stressed_btn.label) && doOnce==false) {
      feelings.add(stressed_btn.label);
      doOnce=true;
    }
  }
  sad_btn.display();
  if (sad_btn.hovering(mouseX,mouseY)) {
    sad_btn.display_hovering();
    if (mousePressed && feelings.size()<3 && !feelings.contains(sad_btn.label) && doOnce==false) {
      feelings.add(sad_btn.label);
      doOnce=true;
    }
  }

  // emoticons
  image(happy, 105, 315, 40, 40);
  image(grateful, width/2-123, 315, 40, 40);
  image(excited, width/2+155, 315, 40, 40);

  image(relaxed, 105, 435, 40, 40);
  image(content, width/2-123, 435, 40, 40);
  image(tired, width/2+155, 435, 40, 40);

  image(bored, 105, 555, 40, 40);
  image(anxious, width/2-123, 555, 40, 40);
  image(stressed, width/2+155, 555, 40, 40);

  image(angry, 105, 675, 40, 40);
  image(unsure, width/2-123, 675, 40, 40);
  image(sad, width/2+155, 675, 40, 40);
}

void drawAnalysisPage() {
  String feelings_merged = "";
  // buttons
  shape(arrow, width-70, height-70, 50, 50);  
  if ((mouseX>width-70) && (mouseX<width-70+50) && (mouseY<height-70+50) && (mouseY>height-70) && mousePressed && (doOnce==false)) {
    page = 5;
    doOnce = true;
  }
  // add texts
  fill(116, 193, 242);
  textSize(50);
  text("I am feeling", width/2, 100);
  text("because of ..", width/2, 230);

  fill(255);
  if (feelings.size()==0){
    feelings_merged = "~Empty~";
  }
  else{
      for (String feeling : feelings){
        if (feelings_merged == ""){
          feelings_merged = feeling;
        }
        else{
          feelings_merged = feelings_merged + ", " + feeling;
        }
      }
  }

  text(feelings_merged, width/2, 170);

  analysis_1.display();
  if (analysis_1.hovering(mouseX,mouseY)) {
    analysis_1.display_hovering();
    if (mousePressed && doOnce==false) {
      
      doOnce=true;
    }
  }
  analysis_2.display();
  if (analysis_2.hovering(mouseX,mouseY)) {
    analysis_2.display_hovering();
    if (mousePressed && doOnce==false) {
      
      doOnce=true;
    }
  }
  analysis_3.display();
  if (analysis_3.hovering(mouseX,mouseY)) {
    analysis_3.display_hovering();
    if (mousePressed && doOnce==false) {
      
      doOnce=true;
    }
  }
  analysis_4.display();
  if (analysis_4.hovering(mouseX,mouseY)) {
    analysis_4.display_hovering();
    if (mousePressed && doOnce==false) {
      
      doOnce=true;
    }
  }
  // add text box
  analysis_btn.display();
  if (analysis_btn.hovering(mouseX,mouseY)) {
    analysis_btn.display_hovering();
    if (mousePressed && doOnce==false) {
      analy = true;;
      prac_1 = false;
      prac_2 = false;
      prac_3 = false;
      doOnce=true;
    }
  }


  fill(255);
  textSize(30);
  text("Click the textbox below and then add any notes, hit enter to break lines",width/2, 410);
  textSize(35);
  text(analysis, width/2, 500);
}

void drawPracticePage() {

  shape(home, width-70, height-70, 50, 50);  
  if ((mouseX>width-70) && (mouseX<width-70+50) && (mouseY<height-70+50) && (mouseY>height-70) && mousePressed && (doOnce==false)) {
    page = 0;
    doOnce = true;
  }
  
  // button
  fill(116, 193, 242); 
  practice_1_btn.display();
  if (practice_1_btn.hovering(mouseX,mouseY)) {
    practice_1_btn.display_hovering();
    if (mousePressed && doOnce==false) {
      analy = false;
      prac_1 = true;
      prac_2 = false;
      prac_3 = false;
      doOnce=true;
    }
  }

  
  
  practice_2_btn.display();
  if (practice_2_btn.hovering(mouseX,mouseY)) {
    practice_2_btn.display_hovering();
    if (mousePressed && doOnce==false) {
      analy = false;
      prac_1 = false;
      prac_2 = true;
      prac_3 = false;
      doOnce=true;
    }
  }

  


  practice_3_btn.display();
  if (practice_3_btn.hovering(mouseX,mouseY)) {
    practice_3_btn.display_hovering();
    if (mousePressed && doOnce==false) {
      analy = false;
      prac_1 = false;
      prac_2 = false;
      prac_3 = true;
      doOnce=true;
    }
  }

  // texts
  textSize(40);
  text("I will focus on", width/2, 50);
  text("I am grateful for", width/2, 320);
  text("I will let go of", width/2, 590);

  fill(255);
  textSize(35);
  // println(practice_1,practice_2,practice_3);
  text(practice_1, width/2, 100);
  text(practice_2, width/2, 370);
  text(practice_3, width/2, 640);

 
  if ((mouseX>25) & (mouseX<50+50) & (mouseY<height-60+50) & (mouseY>height-60) & mousePressed ) {
    page = 0;
  }
}

void drawDataPage(){
  fill(116, 193, 242);
  textSize(50);
  text("Past Activities", width/2, 100);


  br_session.display();
  if (br_session.hovering(mouseX,mouseY)) {
    br_session.display_hovering();
    if (mousePressed && doOnce==false) {
        page = 7;
        doOnce = true;
    }
  }
  ci_session.display();
  if (ci_session.hovering(mouseX,mouseY)) {
    ci_session.display_hovering();
    if (mousePressed && doOnce==false) {
        page = 8;
        doOnce = true;
    }
  }
}

void drawBrDataPage(){
  shape(home, width-70, height-70, 50, 50);  
  if ((mouseX>width-70) && (mouseX<width-70+50) && (mouseY<height-70+50) && (mouseY>height-70) && mousePressed && (doOnce==false)) {
    page = 0;
    doOnce = true;
  }
}

void drawCiDataPage(){
  shape(home, width-70, height-70, 50, 50);  
  if ((mouseX>width-70) && (mouseX<width-70+50) && (mouseY<height-70+50) && (mouseY>height-70) && mousePressed && (doOnce==false)) {
    page = 0;
    doOnce = true;
  }
}


// ---------Button Class-----------------
class Button{
  ///INSTANCE VARIABLES
  float x,y; //position
  float w,h; //size
  boolean selected, is_circle; // circle or rect button
  int font_size; // font size
  color borderColor, bgColor;
  String label; // text overlaid on button

  Button(float x, float y, float w, float h, String label, int font_size, boolean is_circle){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.font_size = font_size;
    this.is_circle = is_circle;
    // selected = false;
    borderColor = color(237, 178, 216); // border color when hovered
    bgColor = color(116, 193, 242); // button color

  }

  ///METHODS
  void display(){
    fill(bgColor);
    if (is_circle == false){
      rect(x, y, w, h, 20);
      fill(255);
      textSize(font_size);
      textFont(font_title);
      textAlign(CENTER);
      text(label, x + w/2, y + (h/2)+0.3*font_size);
    }
    else{
      circle(x, y, w); // note that w=2r
      fill(255);
      textAlign(CENTER);
      text(label, x, y+0.3*font_size);
    }
  }

  Boolean hovering(int mx, int my){
    if (is_circle == true){
      return (dist(mx, my, x, y)<w/2);
    }
    else{
      return (mx > x && mx < x + w  && my > y && my < y+h);
    }
  }

  void display_hovering(){
    // stroke
    strokeWeight(10);
    stroke(237, 178, 216);
    display();
    noStroke();
  }
  
  boolean clicked(){
    // selected = !selected;
    return !selected;
  }

}  //end Button class


// ---------helper functions----------------
void keyPressed() {
  if (prac_1){
    if (key=='\u0008' && practice_1.length()!=0){
      practice_1 = practice_1.substring(0, practice_1.length() - 1);
    }
    else {
      // Each character typed by the user is added to the end of the String variable.
      practice_1 = practice_1 + key; 
    }
  }

  else if (prac_2){
    if (key=='\u0008' && practice_1.length()!=0){
      practice_2 = practice_2.substring(0, practice_2.length() - 1);
    }
    else {
      // Each character typed by the user is added to the end of the String variable.
      practice_2 = practice_2 + key; 
    }
  }

  else if (prac_3){
    if (key=='\u0008' && practice_1.length()!=0){
      practice_3 = practice_3.substring(0, practice_3.length() - 1);
    }
    else {
      // Each character typed by the user is added to the end of the String variable.
      practice_3 = practice_3 + key; 
    }
  }
  
  else if (analy){
    if (key=='\u0008' && practice_1.length()!=0){
      analysis = analysis.substring(0, analysis.length() - 1);
    }
    else {
      // Each character typed by the user is added to the end of the String variable.
      analysis = analysis + key; 
    }  
  }
}