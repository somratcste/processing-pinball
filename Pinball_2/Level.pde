
// Class for defining the outside of the level
// Pinball moves around this level
class Level
{
  ArrayList<Vec2> points;
  Level() {
    points = new ArrayList<Vec2>();

    float theta = 0;
    float count = 5;

    points.add(new Vec2(width-50, height - 300));
    points.add(new Vec2(width - 50, height));
    points.add(new Vec2(width-2, height));


    //creates the arch
    while (radians(theta) > (-PI))
    {
      points.add(new Vec2(width/2+(width/2)*cos(radians(theta)), 200+200*sin(radians(theta))));
      theta -= count;
    }

    points.add(new Vec2(0, height));
    points.add(new Vec2(0, height - 100));

    ChainShape c = new ChainShape();

    Vec2[] v = new Vec2[points.size()];
    for (int i=0; i < v.length; ++i)
    {
      v[i] = box2d.coordPixelsToWorld(points.get(i));
    }

    c.createChain(v, v.length);

    BodyDef bd = new BodyDef();
    Body body = box2d.world.createBody(bd);
    body.createFixture(c, 1);
  }

  void display() {
    strokeWeight(2);
    stroke(0);
    noFill();
    beginShape();
    for (Vec2 v : points) {
      vertex(v.x, v.y);
    }
    endShape();
  }
}
