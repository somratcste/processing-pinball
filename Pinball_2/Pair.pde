
// Create class for create pair with Particle and Box
class Pair {

  Particle p1;
  Box p2;

  float len;
  // Chain constructor
  Pair(float x, float y, Particle p1_, Box p2_) {
    len = 32;
    p1 = p1_;
    p2 = p2_;

    DistanceJointDef djd = new DistanceJointDef();
    djd.bodyA = p1.body;
    djd.bodyB = p2.body;
    djd.length = box2d.scalarPixelsToWorld(len);
    djd.frequencyHz = 3;
    djd.dampingRatio = 0.1;
    DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd); //processing says this isn't being used, it DEFINEITLEY IS!
  }

  void display() {
    Vec2 pos1 = box2d.getBodyPixelCoord(p1.body);
    Vec2 pos2 = box2d.getBodyPixelCoord(p2.body);
    stroke(0);
    strokeWeight(2);

    p1.display();
    p2.display();
  }
}
