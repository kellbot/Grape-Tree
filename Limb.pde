
public class Limb{
  PVector pos, pPos;
  float angle, spindle, thickness, curl;
  
  Limb(){
    //position is centered and between half and 3/4 height.
    pos = new PVector(width/2, height - 70);
    pPos = new PVector(0,0);
    pPos.set(pos);
    spindle = random(20,70);
    angle = random(-1.6,-1.7);
    thickness = random(10,20);
    curl = random(-.1,.1);

  }
  
  Limb(Limb base){
    pos = new PVector(base.pos.x, base.pos.y);
    pPos = new PVector(base.pos.x, base.pos.y);
    angle = base.angle;
    spindle = base.spindle;
    thickness = base.thickness * 0.9;
    curl = base.curl;
  }
  
  void draw(){
    strokeWeight(thickness);
    line(pos.x, pos.y, pPos.x, pPos.y);
  }
  
  Limb spawn(){
    Limb branch = new Limb(this);
    branch.angle += random(-0.75, 0.75);
    //branch.grow();
    return branch;
  }
  
  void grow(){
    pPos.set(pos);
    pos.x += spindle * cos(angle); 
    pos.y += spindle * sin(angle);
    angle += curl;
    spindle *= 0.9;
    thickness *= 0.9;
  }
}  
