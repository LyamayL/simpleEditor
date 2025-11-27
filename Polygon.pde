class Polygon extends Shape{

  // On crée une liste de PVector qui sont les points de notre polygone 
  ArrayList<PVector> points = new ArrayList<PVector>();
  boolean isEditing = true;
  
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
  
}
