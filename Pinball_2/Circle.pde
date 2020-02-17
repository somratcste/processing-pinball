// For Circle 
class Circle
{

  Body body;
  float rad;

  Circle(float x, float y, float r) {
    rad = r;
    makeBody(x, y, r);
    body.setUserData(this); //for collision detection
  }


  void display() {

    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x, pos.y);
    fill(40, 255, 255);
    stroke(0);
    rotate(a);
    ellipse(0, 0, rad, rad);
    popMatrix();
  }

  void makeBody(float x, float y, float r) {
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.STATIC;
    bd.bullet = true;
    body = box2d.world.createBody(bd);

    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(rad);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = .99;

    body.createFixture(fd);
  }
}
