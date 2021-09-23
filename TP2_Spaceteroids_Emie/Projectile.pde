class Projectile extends GraphicObject {
  boolean isVisible = false;
  int diameter = 10;
  float r = diameter / 2;
  
  Projectile () {
    super();
  }
  
  void activate() {
    isVisible = true;
  }
  
  void setDirection(PVector v) {
    velocity = v;
  }
  
  
  void update(float deltaTime) {
    
    if (!isVisible) return;
    
    super.update();
    
    if (location.x < 0 || location.x > width || location.y < 0 || location.y > height) {
      isVisible = false;
    }
  }
  
  void display() {
    
    if (isVisible) {
      pushMatrix();
        translate (location.x, location.y);
        fill(255);
        ellipse (0, 0, diameter, diameter);
      popMatrix();
    }
  }
  float getRadius(){
    return r;
  }
  
  PVector getLocation()
  {
    return location;
  }
  void deleted(){
    isVisible = false;
  }
}
