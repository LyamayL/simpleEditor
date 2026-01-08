class Circle extends Shape{

  float diam;
  
  void draw(){
    stroke(0);
    fill(col);
    ellipse(p1.x, p1.y, diam, diam);
  }
  
  boolean isPointIn(PVector pt){
    // Utilisation de l'eqaution mathématique d'un cercle
    return (pt.x-p1.x)*(pt.x-p1.x) + (pt.y-p1.y)*(pt.y-p1.y) <= diam/2*diam/2;
  }
  
  void drawPoints(){
    
    stroke(1);
    fill(0);
    ellipse(p1.x, p1.y, 15, 15);
    ellipse(p1.x+diam/2, p1.y, 15, 15);
  }

}
