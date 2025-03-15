import processing.serial.*;
Serial myPort;
float temperature = 0, humidity = 0, lightIntensity = 0, waterLevel = 0;

void setup() {
  size(600, 1000); // Increased size for better UI
  myPort = new Serial(this, "COM5", 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  drawBackground();
  drawWeatherCard();
}

void drawBackground() {
  int bgColor = lerpColor(color(30, 31, 60), color(20, 20, 50), map(waterLevel, 0, 100, 0, 1));
  background(bgColor);
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    stroke(lerpColor(color(40, 42, 74), color(87, 84, 146), inter));
    line(0, i, width, i);
  }
}

void drawWeatherCard() {
  fill(255, 50);
  noStroke();
  rect(50, 200, 500, 450, 20);
  
  fill(255);
  textSize(32);
  textAlign(CENTER);
  text("Weather Dashboard", width / 2, 240);
  
  textSize(40);
  text(temperature + "°C", width / 2, 300);
  textSize(30);
  text("Humidity: " + humidity + "%", width / 2, 350);
  text("Light: " + lightIntensity + "%", width / 2, 400);
  text("Water Level: " + waterLevel + "%", width / 2, 450);
  
  drawWeatherIcon();
}

void drawWeatherIcon() {
  if (temperature > 30) {
    fill(255, 204, 0);
    ellipse(300, 120, 80, 80);
  } else if (temperature > 20) {
    fill(200);
    ellipse(300, 120, 80, 80);
    fill(180);
    ellipse(280, 110, 50, 50);
  } else {
    fill(100);
    ellipse(300, 120, 80, 80);
    fill(200);
    ellipse(280, 110, 50, 50);
    fill(255);
    text("❄", 280, 120);
  }
}

void serialEvent(Serial myPort) {
  String data = myPort.readStringUntil('\n');
  if (data != null) {
    data = trim(data);
    String[] values = split(data, ',');
    if (values.length == 4) {
      temperature = safeParseFloat(values[0]);
      humidity = safeParseFloat(values[1]);
      lightIntensity = safeParseFloat(values[2]);
      waterLevel = safeParseFloat(values[3]);
    }
  }
}

float safeParseFloat(String value) {
  try {
    return Float.parseFloat(value);
  } catch (NumberFormatException e) {
    return 0; // Return 0 if data is invalid
  }
}
