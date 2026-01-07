ArrayList<Shape> objs = new ArrayList<Shape>();

color ancienne;
color color1 = color(255, 0, 0);
color color2 = color(0, 255, 0);
color color3 = color(0, 0, 255);
color color4 = color(255, 255, 0);
color color5 = color(255, 0, 255);
color color6 = color(0, 255, 255);
int pipette = 256; // On met a 256 car color est entre 0 et 255


// Gérer le déplacement des points en mode édition
boolean deplace = false;
boolean resize = false;
PVector ptsDeplace = null;
Shape formeDeplace = null;
int index = -1;

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
boolean edition = false;

Shape currentSelected = null;

void setup(){ 
  // Ajout des couleurs pré-définies à la liste
  colors.add(color1);
  colors.add(color2);
  colors.add(color3);
  colors.add(color4);
  colors.add(color5); 
  colors.add(color6);
  
  // On charge une image chosie par l'user
  selectInput("Choisissez un fichier à afficher en fond:", "initImg");

  size(1400, 1200);
}

// Retourne la strokeWeight en fonction du mode
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
  
  strokeWeight(3);
  
  // on dessine (au fond=derriere) tous les objets
  for (Shape obj: objs){
    if(edition){
       strokeWeight(0);
       if(currentSelected == obj)
         strokeWeight(getCurrentStrokeWeight());
    }
      
    obj.draw();    
    // Si on est en mode édition, on dessine les points
    if(edition){
      obj.drawPoints();
    }
    
  }
  
  // On redéssine par dessus si un objet est séléctionné
  if(currentSelected != null){
    strokeWeight(getCurrentStrokeWeight());
    currentSelected.draw();
    currentSelected.drawPoints();
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
  if (currentColor == pipette && !edition) strokeWeight(4); else strokeWeight(1);
  stroke(0);
  fill(color(200, 200, 200));
  rect (8, 8*(colors.size()+1)+32*colors.size(), 32, 32);
  fill(color(0, 0, 0));
  // + a l'intérieur
  strokeWeight(1);
  rect((8+32+(5/2))/2, 8*(colors.size()+1)+32*colors.size() + (12/2), 5, 32-12); // +(5/2) au début pour bien tout centrer puis +12/2 pour écarter des bords
  rect((32+8)/2-(12/2), (8*(colors.size()+1)+32*colors.size() + (8*(colors.size()+1)+32*colors.size() + 32))/2 - (5/2), 32-12, 5); // Pour le y, on fait la moyenne entre le y et le y+32 et on divise par 2. On retire 5/2 pour bien centrer. 
  
  if (currentShape == TRIANGLE && !edition) strokeWeight(4); else strokeWeight(1);
  fill(196);
  rect (width-8-32, 8, 32, 32);
  strokeWeight(2);
  fill(255);
  triangle(width-8-32+5, 8+5,
           width-8-32+26, 8+12,
           width-8-32+12, 8+27);
           
  if (currentShape == RECT && !edition) strokeWeight(4); else strokeWeight(1);
  fill(196);
  rect (width-8-32, 8*2+32*1, 32, 32);
  strokeWeight(2);
  fill(255);
  rect(width-8-32+5, 8*2+32*1+7, 22, 16);
  
  // Dessin de la case polygone
  if (currentShape == POLYGON && !edition) strokeWeight(4); else strokeWeight(1);
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
    // On veut que le mode edition mette en currentColor la couleur du polygone
    if(mouseX>8 && mouseX<8+32 && mouseY>8*(i+1)+32*i && mouseY<8*(i+1)+32*(i+1)){
      
      currentColor = colors.get(i);
      // Si on est en mode édition et que la currentSelected n'est pas null alors on modifie la couleur
      if(edition && currentSelected != null){
        currentSelected.col = currentColor;
      
      }
    }
  }
  
  // Vérifier si on est sur le btn add
  if(mouseX>8 && mouseX<8+32 && mouseY>8*(colors.size()+1)+32*colors.size() && mouseY<8*(colors.size()+1)+32*(colors.size()+1) && !edition)
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
    // On vérifie que l'on est pas en mode édition
    if(!edition){
    
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

        Polygon triangle = new Polygon();
        triangle.isTriangle = true;
        triangle.col = currentColor;
        triangle.p1 = new PVector(mouseX, mouseY);
        triangle.points.add(triangle.p1);
        selectedShape = triangle;
      
      // si on a deja un triangle en cours de creation 
      // Pas besoin de vérification sur le 256 car on le fait déjà lors de la création du triangle.
      } else if(currentShape == TRIANGLE && selectedShape!=null){
        Polygon t = (Polygon) selectedShape;
        t.points.add(new PVector(mouseX, mouseY));
        if(t.points.size() == 3){
          t.points.add(t.points.get(0)); // Le dernier point est forcément le premier
          t.isEditing = false;
        }
    
        }
      
      
      // On commence un polygone
      else if(currentShape == POLYGON && selectedShape==null && currentColor != pipette){
      
        Polygon p = new Polygon();
        p.col = currentColor;
        p.p1 = new PVector(mouseX, mouseY);
        p.points.add(p.p1);
        selectedShape = p;
  
      }
      
      // Si un polygone est déjà en cours de création
      else if(currentShape == POLYGON && selectedShape!=null){
        Polygon p = (Polygon)selectedShape;
        if(dist(mouseX, mouseY, p.points.get(0).x, p.points.get(0).y) <= 10){
          // Si on est proche de notre point de départ alors on ferme la forme
          p.points.add(new PVector(p.points.get(0).x, p.points.get(0).y));
          p.isEditing = false;
        }
        else
          p.points.add(new PVector(mouseX, mouseY));
      } 
      
      // On vérifie si currentColor == 256, si oui on est en mode pipette.
      else if(currentColor == pipette){
        color currentPixelColor = get(mouseX, mouseY);
        colors.add(currentPixelColor);
      }
      
     }else{
    
      for(Shape obj: objs){
        
        if(obj.isPointIn(new PVector(mouseX, mouseY))){
          currentSelected = obj;
          currentColor = obj.col;
        }   
      }
    }
    
    if(edition){
  
      for(Shape forme: objs){
        if(forme instanceof Polygon){ 
        for(PVector pts: forme.points){
          
              if(dist(mouseX, mouseY, pts.x, pts.y) <= 15 && !deplace){
                deplace = true;
                ptsDeplace = pts;
                formeDeplace = forme;
                println("déplacement");
                break;
              
              }  
            
          }
        }else{
          
          Rectangle r = (Rectangle) forme;
          if(dist(mouseX, mouseY, r.p1.x+r.dims.x, r.p1.y+r.dims.y) <= 15 && !deplace){
            resize = true;
            ptsDeplace = new PVector(r.p1.x+r.dims.x, r.p1.y+r.dims.y);
            formeDeplace = forme;
            println("déplacement");
            break;
          }else if(dist(mouseX, mouseY, r.p1.x, r.p1.y) <= 15 && !deplace){
            deplace = true;
            ptsDeplace = new PVector(r.p1.x, r.p1.y);
            formeDeplace = forme;
            println("déplacement");
            break;
          }
          
        }
      
      }
     }
    
   }
   
}


void mouseDragged(){
  // uniquement pour les rectangles on met a jour les dimensions
  if(currentShape == RECT && selectedShape!=null){
    Rectangle r = (Rectangle)selectedShape;
    r.dims = new PVector(mouseX-r.p1.x,mouseY-r.p1.y);
  }
  
  if(edition && (deplace || resize)){
      if(formeDeplace instanceof Polygon){
        for(int i = 0; i<formeDeplace.points.size(); i++){
          if(dist(ptsDeplace.x, ptsDeplace.y, formeDeplace.points.get(i).x, formeDeplace.points.get(i).y) <= 0.1){
            formeDeplace.points.set(i, new PVector(mouseX, mouseY));
            ptsDeplace = new PVector(mouseX, mouseY);
            
              if(i == 0 || i == formeDeplace.points.size() - 1){
              
                formeDeplace.points.set(abs(i - (formeDeplace.points.size()-1)), new PVector(mouseX, mouseY));
              
              }
             
            }
          }
      
      }else{ // Si on est pas dans un polygone, on est dans un rectangle
          Rectangle fd = (Rectangle) formeDeplace;
          if(resize){
            fd.dims = new PVector(mouseX-fd.p1.x,mouseY-fd.p1.y);
          }else{
          
            fd.p1 = new PVector(mouseX, mouseY);
           
          }
      }
    
    }
  
}

void mouseReleased(){
  // dans mouseReleased (et selon ou on en est de la creation)
  // on fait passer la selectedShape dans la liste des objets "classiques" 
  if(currentShape == RECT && selectedShape!=null){
    objs.add(selectedShape);
    selectedShape = null;
  }
  if(currentShape == TRIANGLE && selectedShape!=null && !((Polygon)selectedShape).isEditing){ // && ((Triangle)selectedShape).ptToDraw==0
    objs.add(selectedShape);
    selectedShape = null;
  }
  
  if(currentShape == POLYGON && selectedShape!=null && !((Polygon)selectedShape).isEditing){
    objs.add(selectedShape);
    selectedShape = null;
  }
  
  if(deplace || resize){
    
    
     for(Shape obj: objs){
       if(obj != formeDeplace){
         if(obj instanceof Polygon){
           for(int i=0; i<obj.points.size(); i++){
             PVector currentPoint = obj.points.get(i);
             if(dist(ptsDeplace.x, ptsDeplace.y, currentPoint.x, currentPoint.y) <= 15){
               for(int j=0; j<formeDeplace.points.size(); j++){
                 if(dist(ptsDeplace.x, ptsDeplace.y, formeDeplace.points.get(j).x, formeDeplace.points.get(j).y) <= 0.1){
                    formeDeplace.points.set(j, new PVector(currentPoint.x, currentPoint.y)); 
                 }
               }
             }
           }
         }
       }
     }
     resize = false;
     deplace = false;
     ptsDeplace = null;
     formeDeplace = null;
    
  }
  
}

void keyPressed(){
  
    if(key == 32){ // Code 32 = touche espace
      if(!edition){
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
      }else{
        println("Impossible d'enregistrer : mode édition activé");
      }
    }
    
    else if(key == 98){ // Si b alors on affiche les bordures
      
      showBorder = !showBorder;
      print("Bordures modifiées !");
    
    }
    
    else if(key == 101){
    
      if(edition){
        edition = false;
        currentSelected = null;
        currentColor = ancienne;
        cursor(ARROW);
        println("Mode édition desactivé !");
      }else{
        edition = true;
        ancienne = currentColor;
        currentColor = 257;
        cursor(HAND);
        println("Mode édition activé !");
      }
    
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
