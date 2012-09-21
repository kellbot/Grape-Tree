import org.gicentre.handy.*;

HandyRenderer h;
ArrayList limbs;

void setup(){
  size(1000,800);
  smooth();
  h = new HandyRenderer(this);
  h.setFillGap(1.21);
  
  limbs = new ArrayList();
  for (int i = 0 ; i<4 ; i++) limbs.add(new Limb());

  
}
void draw(){
   strokeWeight(2);
   
  stroke(0);
  fill(0);

  for (int i = 0; i < limbs.size(); i++){
    Limb branch = (Limb) limbs.get(i);
    if(branch.thickness > 1) {
      branch.draw();
      branch.grow();
      
      //spawn approximately 10% of the time, more frequently in the beginning 
      if((random(0,100) + (2 * branch.thickness)) > 99) {
        limbs.add(branch.spawn());
      }
    } else {
      if (random(0,100) > 90) {
        //spawn grapes
          Bunch grapes = new Bunch(branch.pos.x, branch.pos.y, 20);
          grapes.root.spawn(4);
          grapes.draw();
      }
      limbs.remove(i);
    }
  }

}


  
  
public class Limb{
  PVector pos, pPos;
  float angle, spindle, thickness, curl;
  
  Limb(){
    //position is centered and between half and 3/4 height.
    pos = new PVector(width/2, height - 50);
    pPos = new PVector(0,0);
    pPos.set(pos);
    spindle = random(20,70);
    angle = random(-1.6,-1.53);
    thickness = random(10,20);
    curl = random(-.15,.15);

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

void mouseClicked(){
  background(60);
    limbs = new ArrayList();
  for (int i = 0 ; i<4 ; i++) limbs.add(new Limb());
}

public class Bunch{
  public Petal root;
  public color baseColor;
  
  Bunch(float _x, float _y, float _r){
  
    root = new Petal(_x, _y, _r);
    colorMode(HSB, 100);
    baseColor = color(random(20,92),random(20,80),random(55,100));
  }
  
  void draw(){
   root.draw(baseColor); 
  }
}

class Petal{
  float x = 0;
  float y = 0;
  float r = 0;
  public ArrayList<Petal> children;
  public Petal parent;
  
  Petal(float _x, float _y, float _r){
   x = _x;
   y = _y;
   r = _r;
   children = new ArrayList();
  }
  
  void addPetal(Petal child){

    child.parent = this;
    if(!children.contains(child)){
      int tries = 0;
      //find the root and walk down the collision tree
      Petal root = getRoot();
      
      //start rotating clockwise
      int rotation = 1;
      while(child.checkCollisions(root) && tries <= 90){
         child.rotate(x, y, radians(rotation));
         //if we're significantly above the parent's Y, rotate the other way
         if(child.y > child.parent.y - 2) rotation = -1;
         tries++;
      }
      if (tries < 90) children.add(child);
    }
  }
  
  Petal getRoot(){
    if (this.parent == null){
      return this;
    } else {
      return this.parent.getRoot();
    } 
  }
  
  boolean checkCollisions(Petal p){
    //first check for overlap with item itself
    if (overlaps(p)) {
      return true;
    } 
    //then check siblings
                 
    for (int n = p.children.size()-1; n >= 0; n--){
      Petal child = (Petal) p.children.get(n);

      if (checkCollisions(child)){
              return true;
      }
    }
    
    //no overlap? Return false!
    return false;
  }
  
  
  
  void draw(color fillColor){
    strokeWeight(1.2);
    fill(fillColor);
    h.ellipse(x, y, r * 2, r*2);
    for (int i = children.size()-1; i >= 0; i--){
      Petal p = (Petal) children.get(i);
      //lighten fill color
      color dimmer = color(hue(fillColor),saturation(fillColor), brightness(fillColor)-20);
      p.draw(dimmer);
    }
  }
  
  void move(float addX, float addY){
    x = x + addX;
    y = y + addY;
  }
  
  void spawn(int q){
    for (int i = 0; i < q; i++){ 
      //create a child petal centered to this petal.
      //child petals are betwen 75% and 90% of current petal's size
      Petal child = new Petal(this.x, this.y, random(r*.70, r*0.9));
    
      //move the petal so that it is tangent to this petal
      float t = random(PI/4, 3 * PI/4);
      child.move(cos(t) * (r + child.r), sin(t) * (r + child.r));
      
      this.addPetal(child);
      if (child.r > 10) {
        child.spawn(int(random(0,q)));
      }
    }
  }
  

  
  boolean overlaps(Petal p){
    if (this == p) return false;
    int distance = round(dist(x, y, p.x, p.y));
    int radii = round(r + p.r);
    if ( distance < radii) {
      return true;
    } else {
       return false;
    }
  }

  void rotate(float rotX, float rotY, float radians){
    //move to origin
    float xT = x - rotX;
    float yT = y - rotY;
    float newX = xT * cos(radians) - yT * sin(radians);
    float newY = xT * sin(radians) + yT * cos(radians);
    x = newX + rotX;
    y = newY + rotY;
  } 

}

