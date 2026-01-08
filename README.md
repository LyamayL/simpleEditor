# simpleEditor

### 🇫🇷 — Éditeur de Mosaïque (Processing) 
#### Projet d’Introduction à l’Informatique Graphique (L1, Université Paris-Saclay, Professeur : Frédéric Vernier)

## PRÉSENTATION -

Dans le cadre de mon cours d’introduction à l’informatique graphique (INFO112) en L1 à l’Université Paris-Saclay, j’ai développé un éditeur graphique en 2D inspiré des outils de création de mosaïques et de vitraux. À partir d’un éditeur minimaliste fourni par l’enseignant, j’ai fait évoluer le logiciel pour en faire un outil de création visuelle interactif,plus complet, permettant de transformer une image en mosaïqu.

### Fonctionnalités implémentées :

#### - Palette de couleurs & style général :

Passage d’un système de couleurs fixe à une liste dynamique extensible avec sélection de couleur possible grâce a une pipette. Possibilité de modifier les bordures voire de les supprimer.

#### - Nouvelles formes et polygones personnalisés :
Création d’un système de polygones à nombre de points variable, détection automatique de fermeture du polygone. Les triangles sont aussi (désormais) considèrés par le programme comme des polygones et sont gérés automatiquemen. Création des cercles.

#### - Modes d’affichage avancés :
Possibilité de changer les bordures/supprimer les bordures. Déplacement des formes, retaillage et changement de couleurs possibles grâce au mode édition. Mode aimant pour les polygones (et donc triangles) : lors du déplacement, si deux points sont proches, alors ils fusionneront.

## UTILISATION -

#### General :
Au lancement de l'application, il est possible de choisir une image de fond. Choisir une image carrée est recommandé car sinon celle ci sera écrasée.

Pour choisir une couleur ou une forme, il suffit de clicker sur les carrés disposés à gauche et à droite de l'écran. Pour utiliser le mode pipette, il faut clicker sur le bouton "+" a gauche puis sélectionner sur la fenêtre la couleur à rajouter.

### Dessin :

Pour dessiner un polygone/un triangle, il suffit de placer les points en clickant sur la zone de dessin. Le triangle se ferme automatiquement, cependant le polygone se ferme lorsque vous placez un point proche du premier

Pour les cercles et les rectangles, il faut laisser appuyé sur la souris pour gérer la taille.

### Autre :
- `e` : entrer / sortir du mode édition  
- `b` : afficher / masquer les bordures  
- `m` : augmenter l’épaisseur des bordures (1px à 15px)  
- `f` : afficher / masquer l’image de fond  
- `espace` : enregistrer la mosaïque (hors mode édition)  
- `backspace` :
  - en mode édition → supprimer la forme sélectionnée  
  - hors mode édition → supprimer la couleur sélectionnée

## Note :
Tout le code qui n'est pas issu de moi (la fonction isPointIn()) est mentionné en commentaire avec la source.

Bonne création !

---

# simpleEditor

### 🇬🇧 — Mosaic Editor (Processing)  
#### Introduction to Computer Graphics Project (L1, Université Paris-Saclay — Instructor: Frédéric Vernier)

---

## PRESENTATION

As part of the *Introduction to Computer Graphics* course (INFO112) during my first year (L1) at Université Paris-Saclay, I developed a 2D graphical editor inspired by mosaic and stained-glass creation tools.

Starting from a minimal editor provided by the instructor, I extended the software into a more complete and interactive visual creation tool, allowing users to transform an image into a mosaic.

### Implemented Features

#### Color Palette & General Style
- Transition from a fixed color system to a dynamic and extensible color list  
- Color selection using a pipette tool  
- Ability to modify border thickness or completely remove borders  

#### New Shapes & Custom Polygons
- Implementation of polygons with a variable number of vertices  
- Automatic detection of polygon closure  
- Triangles are now treated as polygons and handled automatically  
- Circle creation support  

#### Advanced Display & Editing Modes
- Toggleable borders and adjustable border thickness  
- Shape movement, resizing, and color modification through an edit mode  
- Magnet mode for polygons (and triangles): when moving shapes, nearby vertices automatically snap together  

---

## USAGE

### General
When launching the application, a background image can be selected.  
Using a square image is recommended; otherwise, the image will be stretched.

To select a color or a shape, simply click on the squares displayed on the left and right sides of the screen.  
To use the pipette tool, click on the **“+”** button on the left, then select a color directly from the drawing area.

### Drawing
- To draw a polygon or a triangle, place points by clicking in the drawing area.  
  - Triangles close automatically  
  - Polygons close when a point is placed near the first one  

- For circles and rectangles, click and hold the mouse button to control the size.

### Other Controls
- `e` : enter / exit edit mode  
- In edit mode, click on a shape to select it. You can then move its vertices, resize it (for rectangles and circles), or change its color.  
  - Press `Backspace` to delete the selected shape  

- `b` : show / hide borders  
- `m` : increase border thickness (from 1px to 15px)  
- `f` : show / hide the background image (if selected)  
- `Space` : save the mosaic (edit mode must be disabled)  
- `Backspace` (outside edit mode) : delete the currently selected color  

---

## Notes
All code not originally written by me (such as the `isPointIn()` function) is explicitly mentioned in comments along with its source.

Enjoy creating!