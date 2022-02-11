// SOCHAJ MAUREL
//fonction qui va nous permettre de faire un seuil

PImage seuillage(PImage imageCourante,color ref){
  
  //creation d'une image qu'on va completer de pixel blanc
  PImage image = createImage(imageCourante.width, imageCourante.height, RGB);
  int dim = imageCourante.width * imageCourante.height;
  
  // on va parcourir toutes l'image courante, en passant l'espace de couleurs en HSV on va pouvoir limiter les faux pixels. C'est a dire plus ou moins sombre. Une couleur par exemple bleu peut etre compris dans un interval a l'aide de HUE entre 238 et 220.
  // Il suffit apres d'enlever ceux qu'on ne veut pas a l'aide de la Saturation et de la Brightness
  
  for (int i=0;i<dim;i++){
      if (hue(imageCourante.pixels[i])<260 && hue(imageCourante.pixels[i])>200 && ref==blue ){
        if(saturation(imageCourante.pixels[i])+brightness(imageCourante.pixels[i])>100)
          image.pixels[i] = color(0,0,100); 
      }
      else if((hue(imageCourante.pixels[i])<85 && hue(imageCourante.pixels[i])>45) && ref==yellow){
        if(saturation(imageCourante.pixels[i])+brightness(imageCourante.pixels[i])>90)
          image.pixels[i] = color(0,0,100);
      }
      else if((hue(imageCourante.pixels[i])<40 || hue(imageCourante.pixels[i])>320) && ref==red){
        if(saturation(imageCourante.pixels[i])+brightness(imageCourante.pixels[i])>120)
          image.pixels[i] = color(0,0,100);
      }
      else if((hue(imageCourante.pixels[i])<330 && hue(imageCourante.pixels[i])>280) && ref==magenta){
        if(saturation(imageCourante.pixels[i])+brightness(imageCourante.pixels[i])>110)
          image.pixels[i] = color(0,0,100);
      }
      else if((hue(imageCourante.pixels[i])<160 && hue(imageCourante.pixels[i])>110) && ref==green){
        if(saturation(imageCourante.pixels[i])+brightness(imageCourante.pixels[i])>80)
          image.pixels[i] = color(0,0,100);
      }
   }
   return image;
}

// fonction qui va nous permettre de calculer un centre de gravité d'une image avec des pixels blanc et noir

PVector centerOfGravity(PImage imageCourante){
    ArrayList<Integer> indices = new ArrayList<Integer>();
    int nbValue=0;
  //ON AJOUTE LES INDICES DES POINTS BLANCS
  for(int i=0;i<imageCourante.height;i++){
       for(int j=0;j<imageCourante.width;j++){
      if(imageCourante.pixels[j+imageCourante.width*i]>0){
        nbValue++;
        indices.add(i);
        indices.add(j);
      }
    }
  }
  if(nbValue==0){
    PVector result=new PVector(-1,-1);
   return result;
  }
// CALCUL DE LA MOYENNE DES INDICES
  int moyI=0;
  int moyJ=0;
  for(int i=0;i<indices.size()-1;i+=2){
    moyI+=indices.get(i);
    moyJ+=indices.get(i+1);
  }
  //calcul du centre de gravite
 int gravityCenterI=moyI/nbValue;
 int gravityCenterJ=moyJ/nbValue;
 PVector result=new PVector(gravityCenterI,gravityCenterJ);
 return result;
 }
 
 
// fonction qui va rechercher une face d'un cube de couleurs colorRef et renvoyer les indices i,j correspondant aux numero de pixels

int[] rechercherFaceDuCube(PImage imgDeBase,color colorRef){
  int nbValue=0;

  // on va dans un premeir temps effectuer un seuillage afin d'avoir une image noir et blanche
  PImage seuillage=seuillage(imgDeBase,colorRef);
  
  // on va effectuer une Erosion afin d'enlever le bruit
  
  PImage onTraitement= Erosion.apply(seuillage,5);
  
 
  PVector gravityCenter=centerOfGravity(onTraitement);
  
  //si on a pas de centre de gravité alors on peut arreter la fonction
  if(gravityCenter.x==-1){
    int[] result={-1,-1};
    return result;
}

  int gravityCenterI=int(gravityCenter.x);
  int gravityCenterJ=int(gravityCenter.y);
  int moyDist=0;
  
  //on va maintenant calculer la distance moyenne entre les pixels blancs restants
  for(int i=0;i<onTraitement.height;i++){
     for(int j=0;j<onTraitement.width;j++){
      if(onTraitement.pixels[j+onTraitement.width*i]>0){
          moyDist+=dist(gravityCenterI,gravityCenterJ,i,j);
          nbValue++;
      }
    }
  }
  
  // encore un test si on a pas trouver de pixel blancs
  if(nbValue==0){
  int[] result={-1,-1};
  return result;
}

  //calcul de la distance moyenne
  moyDist=moyDist/nbValue;

//A l'aide de ces boucles for et de la distance moyenne calculer precedement on peut enlever les points blancs trop loin du centre de gravité
  for(int i=0;i<onTraitement.height;i++){
    for(int j=0;j<onTraitement.width;j++){
      if(onTraitement.pixels[j+onTraitement.width*i]>0){
        if(dist(i,j,gravityCenterI,gravityCenterJ)>moyDist*2.5){
          onTraitement.pixels[j+onTraitement.width*i]=black;
        }
      }
    }
  }
    // on va appliquer une dilatation au cas ou on a enlever trop de points blanc
    
    PImage traiter= Dilation.apply(onTraitement,10);

  // on va que l'image a etait correctement traité on peut calculer un nouveau centre de graivit"
  
  gravityCenter=centerOfGravity(traiter);
  
  // si il y en a plus on return -1
  if(gravityCenter.x==-1){
  int[] result={-1,-1};
  return result;
}

   gravityCenterI=int(gravityCenter.x);
   gravityCenterJ=int(gravityCenter.y);
  int nbPixelsBlanc=0;
  
  // cette boucle for vous nous permettre de calculer le % de zone blanche sur l'image, pour savoir le % de la zone colorié
    for(int i=0;i<traiter.height;i++){
       for(int j=0;j<traiter.width;j++){
      if(traiter.pixels[j+traiter.width*i]>0){
        nbPixelsBlanc++;
      }
    }
  }
  float ratio=(float(nbPixelsBlanc)/float((traiter.width*traiter.height)))*100.0;

  // on affecte a la bonne variable ce ration
  
  if(colorRef==yellow){
    pourcentageYellowVisible=ratio;
  }
  else if(colorRef==blue){
    pourcentageBlueVisible=ratio;
  }
  else if(colorRef==magenta){
    pourcentageMagentaVisible=ratio;
  }
  else if(colorRef==green){
    pourcentageGreenVisible=ratio;
  }
  else{
   pourcentageRedVisible=ratio;
  }
  
  // si tout se passe bien on return le resultat 
  int[] result={gravityCenterJ,gravityCenterI};
  return result;
}
