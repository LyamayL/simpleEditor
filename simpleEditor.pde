// Création de la liste d'objets
ArrayList<Shape> objs = new ArrayList<Shape>();

// Initialisation des couleurs
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

// Création de l'img background
PImage img;

// Création de la liste de couleurs
ArrayList<Integer> colors = new ArrayList<Integer>();

// Variables globales
color currentColor = color1;

int TRIANGLE = 0;
int RECT = 1;
int CIRCLE = 2;
int POLYGON = 3;
int currentShape = TRIANGLE;
Shape selectedShape = null;

// Création des paramètres "toggle-ables"
boolean showBg = true; // Enlevable avec f
boolean showBorder = true; // Enlevable avec b
int weight = 3; // modifiable avec m (entre 1 et 15)
boolean edition = false; // passage en mode édition avec e

// Variable globale sur la forme actuellement séléctionnée en mode édition
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
     return (weight%15) + 1 ; // Weight%10 + 1 car on ne veut jamais retomber à 0.
  }else
    return 0;
}

// Permet à l'utilisateur de choisir un fichier en fond
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
    // Si on est en mode édition...
    if(edition){
       // on ne met des bordures qu'a l'élément séléctionné.
       if(currentSelected == obj)
         strokeWeight(3);
       else strokeWeight(0);
    }else{
      // Sinon on met à tous
      strokeWeight(getCurrentStrokeWeight());
    }
      
    obj.draw();    
    // Si on est en mode édition, on dessine des points plus gros sur les sommets
    if(edition){
      obj.drawPoints();
    }
    
  }
  
  // On redéssine par dessus si un objet est séléctionné
  if(currentSelected != null){
    strokeWeight(3);
    currentSelected.draw();
    currentSelected.drawPoints();
  }
  
  // on dessine par dessus la forme encours ou selectionnee
  strokeWeight(getCurrentStrokeWeight());
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
  
  // Dessin de la case du cercle
  if (currentShape == CIRCLE && !edition) strokeWeight(4); else strokeWeight(1);
  fill(196);
  rect (width-8-32, 8*4+32*3, 32, 32);
  strokeWeight(2);
  fill(255);
  ellipse(width - 23, 8*4+32*3.5, 20, 20);
  
}


void mouseClicked(){
  
  // Lors d'un click, on vérifie pour chaque élément de la liste colors si 8 < mouseX < 32+8 && 8*(i+1)+32*i < mouseY < 8*(i+1)+32*(i+1)
  for(int i=0; i<colors.size(); i++){
    // On veut que le mode edition mette en currentColor la couleur du polygone
    if(mouseX>8 && mouseX<8+32 && mouseY>8*(i+1)+32*i && mouseY<8*(i+1)+32*(i+1)){
      // On change la couleur courrante grace à l'index obtenu
      currentColor = colors.get(i);
      // Si on est en mode édition et que la forme séléctionnée n'est pas null alors on modifie la couleur
      if(edition && currentSelected != null){
        currentSelected.col = currentColor;
      
      }
    }
  }
  
  // Vérifier si on est sur le btn add : même formule mais avec + 1 car on est a la case suivante
  if(mouseX>8 && mouseX<8+32 && mouseY>8*(colors.size()+1)+32*colors.size() && mouseY<8*(colors.size()+1)+32*(colors.size()+1) && !edition)
    currentColor = pipette;
  
  
  // chaque bouton a sa zone qui peut etre testee zone de dessin
  // pour savoir dans quel bouton l'utilisateurice a cliquee
  // On vérifie si currentColor != 256 puisque sinon, on est en mode "pipette"
  if(mouseX>width-8-32 && mouseX<width-8 && mouseY>8*1+0*32 && mouseY<8*1+1*32 && currentColor != 256)
    currentShape = TRIANGLE;
  
  else if(mouseX>width-8-32 && mouseX<width-8 && mouseY>8*2+1*32 && mouseY<8*2+2*32 && currentColor != 256)
    currentShape = RECT;
    
  else if(mouseX>width-8-32 && mouseX<width-8 && mouseY>8*3+2*32 && mouseY<8*2+3*32 && currentColor != 256)
    currentShape = POLYGON; 
  
  // On vérifie si on est sur le bouton poylgone
  else if(mouseX>width-8-32 && mouseX<width-8 && mouseY>8*4+3*32 && mouseY<8*3+4*32 && currentColor != 256)
    currentShape = CIRCLE; 
  
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
        // Utilisation de la class Polygon
        Polygon triangle = new Polygon();
        // On dit tout de meme que c'est un triangle pour après
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
        if(t.points.size() == 3){ // On vérifie le nombre de points qui doit être de 3 avant de refermer la forme
          t.points.add(t.points.get(0)); // Le dernier point est forcément le premier
          t.isEditing = false;
        }
    
        }
      
      
      else if(currentShape == CIRCLE && selectedShape == null && currentColor != pipette){
        // Création du cercle
        Circle c = new Circle();
        c.col = currentColor;
        c.p1 = new PVector(mouseX, mouseY);
        // On initialise le diamètre à 0
        c.diam = 0;
        selectedShape = c;
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
        if(dist(mouseX, mouseY, p.points.get(0).x, p.points.get(0).y) <= 15){
          // Si on est proche de notre point de départ alors on ferme la forme
          p.points.add(new PVector(p.points.get(0).x, p.points.get(0).y));
          p.isEditing = false;
        }
        else
          p.points.add(new PVector(mouseX, mouseY));
      } 
      
      // On vérifie si currentColor == 256, si oui on est en mode pipette.
      else if(currentColor == pipette){
        // On obtient la couleur sous le click
        color currentPixelColor = get(mouseX, mouseY);
        // On l'ajoute à notre liste
        colors.add(currentPixelColor);
      }
      
     }else{
    
      for(Shape obj: objs){
        // Vérification de la séléction
        if(obj.isPointIn(new PVector(mouseX, mouseY))){
          // On met à jour l'objet séléctionné et on dit que la couleur courrante est celle de l'objet
          currentSelected = obj;
          currentColor = obj.col;
        }   
      }
    }
    
    if(edition){
  
      for(Shape forme: objs){
        if(forme instanceof Polygon){ 
        for(PVector pts: forme.points){
              // On vérifie la distance de chaque point de chaque polygone a la souris
              if(dist(mouseX, mouseY, pts.x, pts.y) <= 15 && !deplace){
                // Si celle ci est inférieure à 15, on débute le mode déplacement
                deplace = true;
                ptsDeplace = pts;
                formeDeplace = forme;
                break;
              
              }  
            
          }
        }else if(forme instanceof Rectangle){
          // Idem pour le rectangle sauf que le rectangle n'a que 2 points modifiables (position et grandeur)
          // Donc on calcule manuellement pour ces deux points
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
          
        }else if(forme instanceof Circle){
            // Idem que pour le rectangle
            Circle c = (Circle) forme;
            if(dist(mouseX, mouseY, c.p1.x, c.p1.y) <= 15){
              deplace = true;
              ptsDeplace = new PVector(c.p1.x, c.p1.y);
              formeDeplace = forme;
              break;
            }else if (dist(mouseX, mouseY, c.p1.x+c.diam/2, c.p1.y) <= 15){
              resize = true;
              ptsDeplace = new PVector(c.p1.x, c.p1.y);
              formeDeplace = forme;
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
  
  
  if(currentShape == CIRCLE && selectedShape != null){
    // Si on bouge notre souris pendant la création d'un cercle, on actualise le diamètre
    Circle c = (Circle) selectedShape;
    c.diam = mouseX-c.p1.x; 
  }
  
  if(edition && (deplace || resize)){
      if(formeDeplace instanceof Polygon){
        // Si on déplace le point d'un polygone...
        for(int i = 0; i<formeDeplace.points.size(); i++){
          // On cherche quel point est déplacé dans sa liste de points (avec la distance car offre une tolérance)
          if(dist(ptsDeplace.x, ptsDeplace.y, formeDeplace.points.get(i).x, formeDeplace.points.get(i).y) <= 0.1){
            // Lorsque ce point est trouvé alors on le met a jour
            formeDeplace.points.set(i, new PVector(mouseX, mouseY));
            ptsDeplace = new PVector(mouseX, mouseY);
            
              if(i == 0 || i == formeDeplace.points.size() - 1){
                // Pour un polygone, le premier point est identique au dernier donc si un des deux bouge, on actualise l'autre.
                formeDeplace.points.set(abs(i - (formeDeplace.points.size()-1)), new PVector(mouseX, mouseY)); // abs(i - (formeDeplace.points.size()-1) car vaut 0 ou formeDeplace.size()-1 (soit le dernier element de la liste).
              
              }
             
            }
          }
      
      }else if (formeDeplace instanceof Rectangle){ 
          // Si on est dans un rectangle on fait de même avec les dimension ou la position (en fonction de si on resize ou déplace)
          Rectangle fd = (Rectangle) formeDeplace;
          if(resize){
            fd.dims = new PVector(mouseX-fd.p1.x,mouseY-fd.p1.y);
          }else{
          
            fd.p1 = new PVector(mouseX, mouseY);
           
          }
      }else if(formeDeplace instanceof Circle){
        // Idem que pour le rectangle
        Circle fd = (Circle) formeDeplace;
        if(resize){
          fd.diam = mouseX-fd.p1.x;
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
  
  if(currentShape == CIRCLE && selectedShape != null){
    objs.add(selectedShape);
    selectedShape = null;
  }
  
  if(deplace || resize){
    
    
     for(Shape obj: objs){
       if(obj != formeDeplace){
         if(obj instanceof Polygon){
           // Lorsqu'on termine le déplacement du point d'un polygone, 
           for(int i=0; i<obj.points.size(); i++){
             // Pour chaque point de chaque polygone...
             PVector currentPoint = obj.points.get(i);
             if(dist(ptsDeplace.x, ptsDeplace.y, currentPoint.x, currentPoint.y) <= 15){
               // Si la distance avec le ptsDeplace est inférieure a 15..
               for(int j=0; j<formeDeplace.points.size(); j++){
                 // Alors on cherche dans la liste des points du polygone déplacé le ptsDeplace pour obtenir son indice
                 if(dist(ptsDeplace.x, ptsDeplace.y, formeDeplace.points.get(j).x, formeDeplace.points.get(j).y) <= 0.1){
                   // Et on colle les deux points entre eux (effet aimant). 
                   formeDeplace.points.set(j, new PVector(currentPoint.x, currentPoint.y)); 
                 }
               }
             }
           }
         }
       }
     }
     // On réinitialise les variables globales de déplacement
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
      
      weight += 1;
      int calc = weight%15 + 1;
      println("Taille des bordures désormais à " + calc + " /15");
    
    }
    
    else if(key == BACKSPACE){

      if(currentSelected != null){
        objs.remove(currentSelected);
        currentSelected = null;
      }else if(!edition && currentColor != 256){
        println(currentColor);
        // Note : il existe array.remove(Obj o) et array.remove(int indx) or, ici on utilise un int donc il utilise la deuxième fonction et essaye donc de retirer un index, 
        //on doit donc convertir l'int en objet Integer de sorte à ce que la première fonction soit appelée.
        // Integer.valueOf(...) trouvé sur https://www.youtube.com/watch?v=BcHxqXI8wm8
        colors.remove(Integer.valueOf(currentColor));
        if(colors.size() != 0){
          currentColor = colors.get(0);
        }else{
          currentColor = 256;
        }
        println("Couleur supprimée!");
      
      }
      
      else{
        println("Il faut d'abord séléctionner un objet à supprimer");
      }
    }
} 
