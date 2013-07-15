ArrayList lines;
int[][] palettes = {
//  {184, 208, 222},
//  {159, 194, 214},
//  {134, 180, 207},
//  {114, 162, 189},
//  {103, 146, 171}
  {24, 72, 144},
  {72, 120, 168},
  {96, 144, 192},
  {200, 217, 233},
  {255, 255, 255}
};
float margin = 20;
float titlespace = 55;

int alive = 0;
int maxGen = 10;

void setup () {
  size(1000,800);
//  background(255,255,255);
  background(20, 42, 105);
  smooth();
  lines = new ArrayList();
  for (int l = 0; l < 6; l++) {
    int side = round(random(-0.5, 3.5));
    float x, y, dx, dy;
    if (side == 1) {
      x = margin;
      y = random(margin, height-margin-titlespace);
      dx = random(0.5,4);
      dy = random(-4,4);
    } else if (side == 2) {
      x = width - margin;
      y = random(margin, height-margin-titlespace);
      dx = random(-4,-0.5);
      dy = random(-4,4);
    } else if (side == 3) {
      y = margin;
      x = random(margin, width-margin);
      dx = random(-4,4);
      dy = random(0.5,4);
    } else {
      y = height-margin-titlespace;
      x = random(margin, width-margin);
      dx = random(-4,4);
      dy = random(-4,-0.5);
    }
    lines.add(new Line(x, y, dx, dy, 0, 0));
  }
}

void draw () {
  for (int l = 0; l < lines.size(); l++) {
    Line line = (Line) lines.get(l);
    line.extend();
  }
  for (int l1 = 0; l1 < lines.size() - 1; l1++) {
    Line line1 = (Line) lines.get(l1);
    for (int l2 = l1 + 1; l2 < lines.size(); l2++) {
      Line line2 = (Line) lines.get(l2);
      if (!line2.isDead()) {
        intersect(line1, line2);
      }
    }
  }
}

void intersect(Line l1, Line l2) {
  float c1[] = l1.coords();
  float c2[] = l2.coords();
  float x1 = c1[0];
  float y1 = c1[1];
  float x2 = c1[2];
  float y2 = c1[3];
  float x3 = c2[0];
  float y3 = c2[1];
  float x4 = c2[2];
  float y4 = c2[3];

  if (l1.getId() != l2.getParent() && l2.getId() != l1.getParent()) {
    float px = ((x1*y2-y1*x2)*(x3-x4) - (x1-x2)*(x3*y4-y3*x4))/
               ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
    float py = ((x1*y2-y1*x2)*(y3-y4) - (y1-y2)*(x3*y4-y3*x4))/
               ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
    if (((px >= x1 && px <= x2) || (px >= x2 && px <= x1)) &&((py >= y1 && py <= y2) || (py >= y2 && py <= y1)) &&((px >= x3 && px <= x4) || (px >= x4 && px <= x3)) &&((py >= y3 && py <= y4) || (py >= y4 && py <= y3))) {
      if (abs(x2-px) > abs(x4-px) && abs(y2-py) > abs(y4-py)) {
        l2.kill();
      } else {
        l1.kill();
      }
    }
  }
}

class Line {
  float x0, y0, x1, y1, dx, dy, parentId, id;
  boolean dead;
  int age, gen;
  int[] palette;
  Line (float x, float y, float delx, float dely, float p, int g) {
    x0 = x;
    y0 = y;
    dx = delx;
    dy = dely;
    x1 = x;
    y1 = y;
    dead = false;
    age = 0;
    parentId = p;
    id = lines.size() + 1;
    gen = g;
    palette = palettes[round(random(-0.5,4.5))];
    alive++;
  }
  void extend () {
    if (!dead) {
      if (y1 <= height - margin - titlespace && y1 >= margin && x1 <= width - margin && x1 >= margin) {
        stroke(palette[0], palette[1], palette[2], random(0,255));
        line(x1, y1, x1 + dx*0.3, y1 +dx*0.3);
        age++;
        x1 = x1 + dx * 0.3;
        y1 = y1 + dy * 0.3;
      } else {
        this.kill();
      }
    }
  }
  float[] coords () {
    float[] ret = {x0, y0, x1, y1};
    return ret;
  }
  void kill () {
    if (!dead && age > 5 && gen < maxGen) {
      float a1 = random(2, age-2);
      float dir;
      if (random(2) > 1) {
        dir = -1;
      } else {
        dir = 1;
      }
      lines.add(new Line(x0+a1*dx *0.3, y0+a1*dy*0.3, dy*dir, -dx*dir, id, gen+1));
      float a2 = random(2, age-2);
      if (random(2) > 1) {
        dir = -1;
      } else {
        dir = 1;
      }
      lines.add(new Line(x0+a2*dx *0.3, y0+a2*dy*0.3, dy*dir, -dx*dir, id, gen+1));
    }
    if (!dead) {
      alive--;
      println(alive);
      if (alive == 0) {
        decorate();
      }
      dead = true;
    }
  }
  float getParent () {
    return parentId;
  }
  float getId () {
    return id;
  }
  boolean isDead () {
    return dead;
  }
}

void decorate () {
//  String log[] = loadStrings("iteration.txt");
//  int num = 1;
//  if (log.length > 0) {
//    num = int(log[0]) + 1;
//  }
//  log[0] = str(num+1);
//  saveStrings("iteration.txt", log);
  int num = 42;
  stroke(20, 42, 105);
  rect(0, height, width, height - 75);
  strokeWeight(20);
  noFill();
  rect(10, 10, width-20, height-20);
  strokeWeight(3);
  stroke(200, 217, 233);
  rect(20, 20, width-40, height-40);
  line(20, height - 75, width-20, height - 75);
  PFont font = loadFont("Futura-Medium-30.vlw");
  textFont(font, 30);
  text("Blueprints for regrettable city plans, #" + num, 40, height - 35);
  font = loadFont("Futura-Medium-14.vlw");
  textFont(font, 14);
  text("Ian Malpass, @indec", 830, height - 35);
  strokeWeight(1);
  noLoop();
  save("plan.png");
}
