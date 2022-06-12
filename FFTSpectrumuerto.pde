/**
 * This sketch shows how to use the FFT class to analyze a stream
 * of sound. Change the number of bands to get more spectral bands
 * (at the expense of more coarse-grained time resolution of the spectrum).
 */

import processing.sound.*;

// Declare the sound source and FFT analyzer variables
SoundFile sample;
FFT fft;
Sound s;
// Define how many FFT bands to use (this needs to be a power of two)
int bands = 2048;

// Define a smoothing factor which determines how much the spectrums of consecutive
// points in time should be combined to create a smoother visualisation of the spectrum.
// A smoothing factor of 1.0 means no smoothing (only the data from the newest analysis
// is rendered), decrease the factor down towards 0.0 to have the visualisation update
// more slowly, which is easier on the eye.
float smoothingFactor = 0.3;

// Create a vector to store the smoothed spectrum data in
float[] sum = new float[bands];

// Variables for drawing the spectrum:
// Declare a scaling factor for adjusting the height of the rectangles
int scale = 8;
// Declare a drawing variable for calculating the width of the 
float[] barWidth = new float[bands];
float flying = 0.01;
int dB = 0;
public void setup() {
  size(1600, 800,P3D);
  background(255);
  s = new Sound(this);
  //s.sampleRate(44100);
  Sound.list();
  // Calculate the width of the rects depending on how many bands we have
  //
  for (int i = 1; i < bands; i++) {
    barWidth[i] = 1590* (float) Math.log10(i) /((float)Math.log10(bands));
    
  } //<>//
   //<>//
  // Load and play a soundfile and loop it. //<>//
  sample = new SoundFile(this, "D:/desarrollo/processing-workspace/nidea/song2.wav"); //<>//
  sample.loop();

  // Create the FFT analyzer and connect the playing soundfile to it.
  fft = new FFT(this, bands);
  fft.input(sample);
}

public void draw() {
  rotateX(-PI/6);
  rotateY(-PI/14);
  translate(0,0,-1000);
  
  background(0, 0, 125);
  fill(255, 255, 255);
  noStroke();

  // Perform the analysis
  fft.analyze();
  for(int j = 0 ; j < 1; j++){
    
    for (int i = 1; i < bands; i++) {
    // Smooth the FFT spectrum data by smoothing factor
      sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
      
      rect(barWidth[i], height, bands/width, map(sum[i],0,1,0,-height*scale));
    }
    
    translate(0,0,flying+=0.01);
  }
  
}
