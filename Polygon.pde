class Polygon extends Shape{

  // On crée une liste de PVector qui sont les points de notre polygone 
  boolean isEditing = true;
  boolean isTriangle = false;
  
  void draw(){
    // Différentes couleurs en fonction de si on trace notre polygone ou s'il est terminé 
    if(isEditing){
      stroke(128);
      fill(red(col), green(col), blue(col), 128);
    }else{
      stroke(0);
      fill(col);
    }
    beginShape();
    for(PVector vect: points){
      vertex(vect.x, vect.y);
    }
    
    if(isEditing){
      // Ajout d'un trait vers la souris si on édite le polygone
      vertex(mouseX, mouseY);
      
    }
    
    endShape();
  
  }
  
  // inspiré de Jonas Raoni Soares Silva
  // http://jsfromhell.com/math/is-point-in-poly [rev. #0]
  boolean isPointIn(PVector pt){
    boolean c = false;
    for(int i = -1, l = points.size(), j = l - 1; ++i < l; j = i)
      if (((points.get(i).y <= pt.y && pt.y < points.get(j).y) || (points.get(j).y <= pt.y && pt.y < points.get(i).y))
           && (pt.x < (points.get(j).x - points.get(i).x) * (pt.y - points.get(i).y) / (points.get(j).y - points.get(i).y) + points.get(i).x))
        c = !c;
    return c;
  }
  
  void drawPoints(){
  
      for(PVector pts: points){
        ellipse(pts.x, pts.y, 15, 15);
        fill(0);
    }
  
  } 
}
