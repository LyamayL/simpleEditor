ArrayList<Shape> objs = new ArrayList<Shape>();

color color1 = color(255, 0, 0);
color color2 = color(0, 255, 0);
color color3 = color(0, 0, 255);
color color4 = color(255, 255, 0);
color color5 = color(255, 0, 255);
color color6 = color(0, 255, 255);
int pipette = 256; // On met a 256 car color est entre 0 et 255

PImage img;

// Création de la liste de couleurs
ArrayList<Integer> colors = new ArrayList<Integer>();


color currentColor = color1;

int TRIANGLE = 0;
int RECT = 1;
int POLYGON = 2;
int currentShape = TRIANGLE;
Shape selectedShape = null;

// Création des paramètres toggle-ables
boolean showBg = true; // Enlevable avec f
boolean showBorder = true; // Enlevable avec b
boolean isMosaique = true; // Si pas mosaique alors vitrail (bords très épais), modifiable avec m

void setup(){ 
  // Ajout des couleurs pré-définies à la liste
  colors.add(color1);
  colors.add(color2);
  colors.add(color3);
  colors.add(color4);
  colors.add(color5); 
  colors.add(color6);
  
  // On charge une image chosie par l'user
  selectInput("Select a file to process:", "initImg");

  size(1400, 1200);
}

int getCurrentStrokeWeight(){

   if(showBorder){
  
    if(isMosaique)
      return 3;
    else
      return 10;
  }else
    return 0;
}

void initImg(File selection) {
  if (selection == null) {
    println("Aucun fichier choisit...");
  } else {
    img = loadImage(selection.getAbsolutePath());
  }
}

void draw(){
  background(196);
  fill(255);
  strokeWeight(1);
  stroke(0);
  rect(32+2*8, 0, width-2*32-4*8, height);
  
  // On dessine notre image au fond
  if(img != null && showBg){
    img.resize(800, 800);
    image(img, width/2- img.width/2, height/2 - img.height/2);
  }
  
  strokeWeight(getCurrentStrokeWeight());
  
  // on dessine (au fond=derriere) tous les objets
  for (Shape obj: objs){
    obj.draw();
  }
  
  // on dessine par dessus la forme encours ou selectionnee
  strokeWeight(4);
  if(selectedShape != null)
    selectedShape.draw();
    
    // On parcourt notre liste colors et on dessine à chaque itération un rectangle de l*L 32*32, de coordonnées x = 8 et y = 8*(i+1) + 32*i ou i est l'indice du rectangle  
  for(int i=0; i<colors.size(); i++){
    if (currentColor == colors.get(i) && currentColor != pipette) strokeWeight(4); else strokeWeight(1);
    stroke(0);
    fill(colors.get(i));
    rect (8, 8*(i+1)+32*i, 32, 32);
  
  }

  // Dessin du bouton ajouter
  if (currentColor == pipette) strokeWeight(4); else strokeWeight(1);
  stroke(0);
  fill(color(200, 200, 200));
  rect (8, 8*(colors.size()+1)+32*colors.size(), 32, 32);
  fill(color(0, 0, 0));
  // + a l'intérieur
  strokeWeight(1);
  rect((8+32+(5/2))/2, 8*(colors.size()+1)+32*colors.size() + (12/2), 5, 32-12); // +(5/2) au début pour bien tout centrer puis +12/2 pour écarter des bords
  rect((32+8)/2-(12/2), (8*(colors.size()+1)+32*colors.size() + (8*(colors.size()+1)+32*colors.size() + 32))/2 - (5/2), 32-12, 5); // Pour le y, on fait la moyenne entre le y et le y+32 et on divise par 2. On retire 5/2 pour bien centrer. 

    
  if (currentShape == TRIANGLE) strokeWeight(4); else strokeWeight(1);
  fill(196);
  rect (width-8-32, 8, 32, 32);
  strokeWeight(2);
  fill(255);
  triangle(width-8-32+5, 8+5,
           width-8-32+26, 8+12,
           width-8-32+12, 8+27);
           
  if (currentShape == RECT) strokeWeight(4); else strokeWeight(1);
  fill(196);
  rect (width-8-32, 8*2+32*1, 32, 32);
  strokeWeight(2);
  fill(255);
  rect(width-8-32+5, 8*2+32*1+7, 22, 16);
  
  // Dessin de la case polygone
  if (currentShape == POLYGON) strokeWeight(4); else strokeWeight(1);
  fill(196);
  rect (width-8-32, 8*3+32*2, 32, 32);
  strokeWeight(2);
  fill(255);
  beginShape();
  vertex(width-(40/2) - 4, (8*3+32*2) + 5);
  vertex(width - 10 - 4, (8*3+32*2) + 5 + 5);
  vertex(width - 10 - 4, (8*3+32*2) + 5 + 5 + 17); // Notre polygone de son point le plus haut à celui le plus bas aura pour hateur (32-5-5) puisqu'on laisse 5px en haut et 5px en bas. A ce stade, on a déjà parcouru 5 en hauteur entre p1 et p2. il nous reste donc 22-5=17px a parcourir.
  vertex(width-(40/2)-4-10, (8*3+32*2) + 5 + 5 + 17); // On enluève -5-10 pour garder notre écart par rapport au rectangle.
  vertex(width-(40/2)-4-10, (8*3+32*2) + 5 + 5);
  vertex(width-(40/2) - 4, (8*3+32*2) + 5);
  endShape();
}


void mouseClicked(){
  
  // Lors d'un click, on vérifie pour chaque élément de la liste colors si 8 < mouseX < 32+8 && 8*(i+1)+32*i < mouseY < 8*(i+1)+32*(i+1)
  for(int i=0; i<colors.size(); i++){
    if(mouseX>8 && mouseX<8+32 && mouseY>8*(i+1)+32*i && mouseY<8*(i+1)+32*(i+1)){
      currentColor = colors.get(i);
    }
  }
  
  // Vérifier si on est sur le btn add
  if(mouseX>8 && mouseX<8+32 && mouseY>8*(colors.size()+1)+32*colors.size() && mouseY<8*(colors.size()+1)+32*(colors.size()+1))
    currentColor = pipette;
  
  
  // chaque bouton a sa zone qui peut etre testee zone de dessin
  // pour savoir dans quel bouton l'utilisateurice a cliquee
  // On vérifie si currentColor != 256 puisque sinon, on est en mode "pipette"
  if(mouseX>width-8-32 && mouseX<width-8 && mouseY>8*1+0*32 && mouseY<8*1+1*32 && currentColor != 256)
    currentShape = TRIANGLE;

  else if(mouseX>width-8-32 && mouseX<width-8 && mouseY>8*2+1*32 && mouseY<8*2+2*32 && currentColor != 256)
    currentShape = RECT;
  
  // On vérifie si on est sur le bouton poylgone
  else if(mouseX>width-8-32 && mouseX<width-8 && mouseY>8*3+2*32 && mouseY<8*2+3*32 && currentColor != 256)
    currentShape = POLYGON; 
  
}
 
    
void mousePressed(){
  // on est dans la zone de dessin
  if(mouseX>8+32 && mouseX<width-8-32) {

    // si on commence un dessin de rectangle
    // On vérifie si currentColor != pipette puisque sinon, on est en mode "pipette"
    if(currentShape == RECT && selectedShape==null && currentColor != pipette){
      Rectangle r  = new Rectangle(); //on cree l'objet 
      r.col = currentColor; // on met a jour sa couleur
      r.p1 = new PVector(mouseX, mouseY);// on met a jour son premier point
      r.dims = new PVector(0, 0); // on met des dimensions nulles par defaut
      selectedShape = r; // on dit que ce nouvel objet est le nouvel objet selectionne
    
    // si on commence un nouveau triangle
    } else if(currentShape == TRIANGLE && selectedShape==null && currentColor != pipette){
      Triangle t  = new Triangle();
      t.col = currentColor;
      t.p1 = new PVector(mouseX, mouseY);
      t.ptToDraw = 2; // on met a jour son compte a rebour de points
      selectedShape = t;
    
    // si on a deja un triangle en cours de creation 
    // Pas besoin de vérification sur le 256 car on le fait déjà lors de la création du triangle.
    } else if(currentShape == TRIANGLE && selectedShape!=null){
      Triangle t = (Triangle)selectedShape;
      if(t.ptToDraw==2){ // selon ou on en est du noombre de points qui restent a donner
        t.p2 = new PVector(mouseX, mouseY);
        t.ptToDraw = 1;
      } else if(t.ptToDraw==1){
        t.p3 = new PVector(mouseX, mouseY);
        t.ptToDraw = 0;
      }
    }
    
    // On vérifie si currentColor == 256, si oui on est en mode pipette.
    else if(currentColor == pipette){
      color currentPixelColor = get(mouseX, mouseY);
      colors.add(currentPixelColor);
    }
    
  }
}

void mouseDragged(){
  // uniquement pour les rectangles on met a jour les dimensions
  if(currentShape == RECT && selectedShape!=null){
    Rectangle r = (Rectangle)selectedShape;
    r.dims = new PVector(mouseX-r.p1.x,mouseY-r.p1.y);
  }
}

void mouseReleased(){
  // dans mouseReleased (et selon ou on en est de la creation)
  // on fait passer la selectedShape dans la liste des objets "classiques" 
  if(currentShape == RECT && selectedShape!=null){
    objs.add(selectedShape);
    selectedShape = null;
  }
  if(currentShape == TRIANGLE && selectedShape!=null && ((Triangle)selectedShape).ptToDraw==0){
    objs.add(selectedShape);
    selectedShape = null;
  }
}

void keyPressed(){
  if(key == 32){ // Code 32 = touche espace
      // Si espace est préssé, on enregistre le rendu dans une image.
      int debutZone = 32+2*8;
      int widthZone = width - (2*32+4*8);
      PImage output = createImage(widthZone, height, ARGB); // width - ... car notre zone de dessin se situe entre 32+2*8 et width-...
      
      // Chargement des pixels de la fenêtre & de l'image
      loadPixels();
      output.loadPixels();
      
      int idx = 0;
      for(int j=0; j<height; j++){
         // On se place dans notre zone de dessin
         for(int i=debutZone; i<debutZone+widthZone; i++){
            // Obligé d'utiliser un autre index
            output.pixels[idx] = pixels[i+j*width];
            idx += 1;
         }
      
      }
      
      output.updatePixels();
      output.save("save.png");
      println("Enregistré !");
  }
  
  else if(key == 98){ // Si b alors on affiche les bordures
    
    showBorder = !showBorder;
    print("Bordures modifiées !");
  
  }
  
  else if(key == 102){
    
    showBg = !showBg;
    println("Fond modifié !");
  
  }
  else if(key == 109){
    
    isMosaique = !isMosaique;
    println("Style modifié !");
  
  }
  
} 
