// SOCHAJ MAUREL
import processing.video.*;
import milchreis.imageprocessing.*;
import milchreis.imageprocessing.utils.*;



void setup() {
  
    // On va creer la fenetre est passé en espace HSB pour les couleurs
    
    size(1000, 800,P3D);
    colorMode(HSB,360,100,100);
    
    
    // on charge l'objet 3D du chat
    
    myCat=loadShape("../data/cat.obj");
    
   
   // On creer notre camera et recupere notre webcam


  //PImage myImage= loadImage("../data/synthetic1.png");
 // PImage myImage= loadImage("../data/synthetic2.png");
  PImage myImage= loadImage("../data/synthetic3.png");
  
  image(myImage,0,0);
  
  int dim = myImage.width * myImage.height;
  for (int i=0;i<dim;i++){
      if (hue(myImage.pixels[i])<260 && hue(myImage.pixels[i])>200){
        nbBlue++;
      }
      else if((hue(myImage.pixels[i])<85 && hue(myImage.pixels[i])>45)){
        if(saturation(myImage.pixels[i])+brightness(myImage.pixels[i])>90) //eviter le gris
        nbYellow++;
      }
      else if((hue(myImage.pixels[i])<40 || hue(myImage.pixels[i])>320)){
       nbRed++;
      }
      else if((hue(myImage.pixels[i])<280 && hue(myImage.pixels[i])>242)){
        nbMagenta++;
      }
      else if((hue(myImage.pixels[i])<160 && hue(myImage.pixels[i])>110)){
        nbGreen++;
      }
   }
   int moy=nbBlue+nbYellow+nbRed;
    moy=moy/3;
  launchProg(myImage);
  
  shapeMode(CORNER);

}

void draw() {
  

}


void launchProg(PImage img){ // Fonction qui va nous permettre de traiter les resultats afin d'afficher le chat

  
  
   // on remet les variables globales a -1 car la fonction est dans le draw donc se repete tout le temps
   pourcentageRedVisible=-1;
   pourcentageBlueVisible=-1;
   pourcentageYellowVisible=-1;
   pourcentageMagentaVisible=-1;

  //creation de variable qui vont nous permettre de garder les centres des faces
  int nbFaces=0;
  ArrayList<Integer> allGravityCenter=new ArrayList<Integer>();
  int[] centerYellow=new int[2];
  int[] centerBlue=new int[2];
  int[] centerRed=new int[2];
  int[] centerMagenta=new int[2];
  int[] centerGreen=new int[2];
  
// on va regarder si la face JAUNE est visible si elle l'est on l'ajoute au tableau

  centerYellow=rechercherFaceDuCube(img,yellow);
  if(centerYellow[0]!=-1){
    allGravityCenter.add(centerYellow[0]);
    allGravityCenter.add(centerYellow[1]);
    nbFaces++;
  }
  if(centerYellow[0]!=-1){
    // on va regarder si la face ROUGE est visible si elle l'est on l'ajoute au tableau

    centerRed=rechercherFaceDuCube(img,red);
    if(centerRed[0]!=-1){
      allGravityCenter.add(centerRed[0]);
      allGravityCenter.add(centerRed[1]);
    nbFaces++;
  }
  
  // on va regarder si la face BLUE est visible si elle l'est on l'ajoute au tableau

    centerBlue=rechercherFaceDuCube(img,blue);
    if(centerBlue[0]!=-1){
      allGravityCenter.add(centerBlue[0]);
      allGravityCenter.add(centerBlue[1]);
      nbFaces++;
    }
  
  // on va regarder si la face MAGENTA est visible si elle l'est on l'ajoute au tableau
  if(nbFaces<3){
    centerMagenta=rechercherFaceDuCube(img,magenta);
    if(centerMagenta[0]!=-1){
      allGravityCenter.add(centerMagenta[0]);
      allGravityCenter.add(centerMagenta[1]);
  }
}
    // on va regarder si la face GREEN est visible si elle l'est on l'ajoute au tableau
  if(nbFaces<3){
    centerGreen=rechercherFaceDuCube(img,green);
    if(centerGreen[0]!=-1){
      allGravityCenter.add(centerGreen[0]);
      allGravityCenter.add(centerGreen[1]);
  }
}
}
  if(nbFaces==0){
    return;
  }
    fill(color(255,0,0));
    ellipseMode(RADIUS);
    
    //on va creer plusieurs variable qui vont nous servir a avoir le centre de notre cube
    
  int sommeGravityCenterI=0,sommeGravityCenterJ=0,cubeGravityCenterJ=0,cubeGravityCenterI=0,nbValue=int(allGravityCenter.size()*0.5);
    
    //dans cette boucle on va faire deux choses, la premiere est de faire la somme de tous les X,Y des points afin de faire la moyenne, et la deuxieme d'afficher un petit cercle au milieu des faces
  for(int i=0;i<allGravityCenter.size()-1;i+=2){
        sommeGravityCenterI+=allGravityCenter.get(i);
        sommeGravityCenterJ+= allGravityCenter.get(i+1);
        circle(allGravityCenter.get(i), allGravityCenter.get(i+1), 3);
  }
  
  // si on a des valeurs ! (donc on a une face visible)  
  if(nbValue!=0){
    
    // on fait les moyennes des points afin d'avoir le centre du cube et on ajoute un petit point sur l'image
  cubeGravityCenterJ=sommeGravityCenterJ/nbValue;
  cubeGravityCenterI=sommeGravityCenterI/nbValue;
  circle(cubeGravityCenterI, cubeGravityCenterJ, 3);
  
  // on va creer un vecteur qui va etre le lien entre le centre du cube et le centre de la face jaune (on affiche une ligne aussi)
  
  PVector centerToYellow=new PVector(centerYellow[0]-cubeGravityCenterI,centerYellow[1]-cubeGravityCenterJ);
  line(centerYellow[0],centerYellow[1],cubeGravityCenterI,cubeGravityCenterJ);
      
      
      
      // ici on va mettre les pourcentages des faces visible qui sont par rapport a la l'image entiere, en pourcentage par rapport au cube
      
    float total=0,miseAEchelle=0;
    
    // il faut en premier temps faire un total de tous les pourcentage
    
    if(pourcentageYellowVisible!=-1){
        total+=pourcentageYellowVisible;
      }
    if(pourcentageBlueVisible!=-1){
        total+=pourcentageBlueVisible;
      }
    if(pourcentageRedVisible!=-1){
        total+=pourcentageRedVisible;
      }
    if(pourcentageMagentaVisible!=-1){
        total+=pourcentageMagentaVisible;
      }
    if(pourcentageGreenVisible!=-1){
        total+=pourcentageGreenVisible;
      }
  // on a donc un facteur d'echelle qui va nous permettre de mettre sur 100% du cube
  
  miseAEchelle=100.0/total;
  pourcentageYellowVisible*=miseAEchelle;
  pourcentageYellowVisible/=100;

  // on a donc un % de face jaune visible par rapport au cube
  
    // on va retrecir le chat ainsi que le deplacer au bon endroit sur l'image
    scale(0.5);
    translate(centerYellow[0]+centerToYellow.x+50,centerYellow[1]+centerToYellow.y*0.6,200);
    
    // on va ensuite avoir un facteur qui va nous permettre de savoir dans quel sens appliquer la rotation
      float distY,distX;
    
    if(cubeGravityCenterI<centerYellow[0])
        distY=1;
     else
       distY=-1;
     if(cubeGravityCenterJ<centerYellow[1])
        distX=1;
     else
       distX=-1;
       
     // on met le chat a la position de "base" seulement face jaune visible
     myCat.resetMatrix();
     myCat.rotateX(PI/2);
     
    // on va donc calculer la rotation en fonction du % de face jaune visible
    float difference=abs(pourcentageYellowVisible-1);

   myCat.rotateY(distY*difference*PI/2);
   //myCat.rotateX(distX*difference*PI/2);

     //et on affiche le chat
    shape(myCat, centerYellow[0]+centerToYellow.x*1.5, centerYellow[1]+centerToYellow.y*1.5);


  }
}
