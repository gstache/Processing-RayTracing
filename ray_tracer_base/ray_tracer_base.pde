String gCurrentFile = new String("i1.cli"); // A global variable for holding current active file name.
//@author: Garrett Stache
//Global variables
float fov = PI/3;
color background = color(0.0, 0.0, 0.0);
Vec3 backVec = new Vec3(0.0,0.0,0.0);
boolean debug = false;
boolean distribution = false;
float time = 0;
ArrayList<Surface> surfaces;
ArrayList<Light> lights;
ArrayList<Vec3> V;
float specTest;
Vec3 Ltest;
Vec3 Norm;
void keyPressed() {
  switch(key) {
    case '1':  gCurrentFile = new String("i1.cli"); interpreter(); break;
    case '2':  gCurrentFile = new String("i2.cli"); interpreter(); break;
    case '3':  gCurrentFile = new String("i3.cli"); interpreter(); break;
    case '4':  gCurrentFile = new String("i4.cli"); interpreter(); break;
    case '5':  gCurrentFile = new String("i5.cli"); interpreter(); break;
    case '6':  gCurrentFile = new String("i6.cli"); interpreter(); break;
    case '7':  gCurrentFile = new String("i7.cli"); interpreter(); break;
    case '8':  gCurrentFile = new String("i8.cli"); interpreter(); break;
    case '9':  gCurrentFile = new String("i9.cli"); interpreter(); break;
    //case '0':  gCurrentFile = new String("d1.cli"); interpreter(); break;
    case 'd':  distribution = !distribution;
  }
}

void mouseClicked() {
  debug = true;
 int x = mouseX;
 int y = mouseY; 
 println("mouse Pressed at: " + mouseX+","+mouseY);
 
 float Vpx = (2*x)/((float)width) - 1;
      float Vpy = (2*(((float)height-y)))/((float)height) - 1;
      float n = -1/tan(fov/2);
      
      Vec3 Vp = new Vec3(Vpx, Vpy, n);
      println("Vp: "+Vp);
      Ray eyeRay = new Ray(new Vec3(0,0,0), Vp, 0);
      println("Direction: "+eyeRay.direction);
      println("Length: "+eyeRay.direction.norm());
      Surface s = surfaces.get(0);
      println("Number of Spheres: "+surfaces.size());
      Hit h = s.collide(eyeRay);
      float t = h.time;
      Hit theHit = h;
      
      for (int i =1; i < surfaces.size(); i++) {
          float newT;
          s = surfaces.get(i);
          
          h = s.collide(eyeRay);
          //println(h.time);  
          newT = h.time;
          if(newT < t && newT > 0 || t <= 0 && newT > 0) {
            theHit = h;
            
            t = newT;
          }
      }
       
      println("Hit Time"+theHit.time);
      println("Hit surf");
      theHit.surface.mString();      
      Vec3 col = RayColor(theHit, 5);
      
      //pixels[y*width + x] = color(col.x,col.y,col.z);
      
}

float get_float(String str) { return float(str); }

void interpreter() {
  Material m = new Material();
  reset_scene();
  String str[] = loadStrings(gCurrentFile);
  if (str == null) println("Error! Failed to read the file.");
  for (int i=0; i<str.length; i++) {
    
    String[] token = splitTokens(str[i], " "); // Get a line and parse tokens.
    if (token.length == 0) continue; // Skip blank line.
    
    if (token[0].equals("fov")) {
      fov = PI*get_float(token[1])/180.0;
    }
    else if (token[0].equals("background")) {
      float r =get_float(token[1]);
      float g =get_float(token[2]);
      float b =get_float(token[3]);
      background = color(r, g, b);
      backVec = new Vec3(r,g,b);
    }
    else if (token[0].equals("light")) {
      float x =get_float(token[1]);
      float y =get_float(token[2]);
      float z =get_float(token[3]);
      float r =get_float(token[4]);
      float g =get_float(token[5]);
      float b =get_float(token[6]);
      Vec3 Pos = new Vec3(x,y,z);
      Vec3 col = new Vec3(r,g,b);
      Light l = new PointLight(Pos, col);
      lights.add(l);
    }
    else if (token[0].equals("arealight")) {
      Vec3 c1 = new Vec3(get_float(token[1]), get_float(token[2]), get_float(token[3]));
      Vec3 c2 = new Vec3(get_float(token[4]), get_float(token[5]), get_float(token[6]));
      Vec3 c3 = new Vec3(get_float(token[7]), get_float(token[8]), get_float(token[9]));
      Vec3 col = new Vec3(get_float(token[10]), get_float(token[11]), get_float(token[12]));
      Light l = new AreaLight(c1, c2, c3, col);
      lights.add(l);
      
    }
    else if (token[0].equals("surface")) {
      float Cdr =get_float(token[1]);
      float Cdg =get_float(token[2]);
      float Cdb =get_float(token[3]);
      float Car =get_float(token[4]);
      float Cag =get_float(token[5]);
      float Cab =get_float(token[6]);
      float Csr =get_float(token[7]);
      float Csg =get_float(token[8]);
      float Csb =get_float(token[9]);
      float P =get_float(token[10]);
      float K =get_float(token[11]);
      Vec3 Cd = new Vec3(Cdr,Cdg,Cdb);
      Vec3 Ca = new Vec3(Car,Cag,Cab);
      Vec3 Cs = new Vec3(Csr,Csg,Csb);
      m = new Material(Ca, Cd, Cs, P, K);
    }    
    else if (token[0].equals("sphere")) {
      float r =get_float(token[1]);
      float x =get_float(token[2]);
      float y =get_float(token[3]);
      float z =get_float(token[4]);
      Vec3 Pos = new Vec3(x,y,z);
      Surface sphere = new Sphere(Pos, r, m);
      surfaces.add(sphere);
    }
    else if (token[0].equals("begin")) {
      
    }
    else if (token[0].equals("vertex")) {
      float x =get_float(token[1]);
      float y =get_float(token[2]);
      float z =get_float(token[3]);
      Vec3 vec = new Vec3(x, y, z);
      V.add(vec);
      if (V.size()%3 == 0 && V.size() > 0){
         int j = V.size() - 1;
         Surface s = new Triangle(V.get(j-2), V.get(j-1), V.get(j), m);
        surfaces.add(s); 
      }
    }
    else if (token[0].equals("end")) {
      
    }
    else if (token[0].equals("color")) {
      float r =get_float(token[1]);
      float g =get_float(token[2]);
      float b =get_float(token[3]);
      fill(r, g, b);
    }
    else if (token[0].equals("write")) {
      draw_scene();
      save(token[1]);  
    }
  }
}

void setup() {
  surfaces = new ArrayList<Surface>();
  lights = new ArrayList<Light>();
  V = new ArrayList<Vec3>();
  size(300, 300);  //your code should work if this is changed (Use height and width!!)
  noStroke();
  colorMode(RGB, 1.0);
  background(0, 0, 0);
  interpreter();
  
}

void reset_scene() {
  surfaces = new ArrayList<Surface>();
  lights = new ArrayList<Light>();
  V = new ArrayList<Vec3>();
  time = 0;
  
  background = color(0.0, 0.0, 0.0);
  backVec = new Vec3(0.0,0.0,0.0);
  debug = false;
  
}

void draw_scene() {
  loadPixels();
  Vec3 col = new Vec3();
  for(int y = 0; y < height; y++) {
    if(y%(height/10) == 0){println((y/(height/10))*10 + "% complete");}  
    for(int x = 0; x < width; x++) {
      float w = width*1.0;
      float v = height*1.0;
      float Vpx = (2*x)/w - 1;
      float Vpy = (2*(v-y))/v - 1;
       float n = -1/tan(fov/2);
      if(distribution){
        Vec3 avg = new Vec3();
        for (int k = 0; k < 10; k++){
           Vpy -= (1.0/(width*100.0))*k;
           for (int r = 0; r < 10; r++) {
            Vpx += (1.0/(height*100.0))*r;
            Vec3 Vp = new Vec3(Vpx, Vpy, n);
            if (( y == 250 ) && x == 250 ){println(Vp);}
            Ray eyeRay = new Ray(new Vec3(0,0,0), Vp, 0);
            Hit theHit = collisions(eyeRay);
            
            col = col.plus(RayColor(theHit, 10));
           } 
        }
        col =  col.mult(.01);
        if ((y == 100 || y == 200 || y == 400) && x == 250 ){println(col);}
      } else {
        Vec3 Vp = new Vec3(Vpx, Vpy, n);
        
        Ray eyeRay = new Ray(new Vec3(0,0,0), Vp, 0);
        if ((y == 100 || y == 200 || y == 400) && x == 250 ){debug = true;}
        Hit theHit = collisions(eyeRay);
        
        col =  RayColor(theHit, 10);
      }
      debug = false;
       pixels[y*width + x] = color(col.x,col.y,col.z);   
     }
   
    
  }
  updatePixels();
}

Hit collisions(Ray eyeRay) {
     Surface s = surfaces.get(0);
     
      Hit h = s.collide(eyeRay);
      h.surfaceID = 0;
      float t = h.time;
      Hit theHit = h;
      theHit.surfaceID = 0;
      for (int i =1; i < surfaces.size(); i++) {
          
          float newT;
          s = surfaces.get(i);
          h = s.collide(eyeRay);
          h.surfaceID = i;
          newT = h.time;
          if(newT < t && newT > 0 || t <= 0 && newT > 0) {
            theHit = h;
            t = newT;
             theHit.surfaceID = i;
          }
      }
     return theHit;
     
}

void draw() {
  time += 1/30.0;
}

float distance(Vec3 p1, Vec3 p2){
  Vec3 diff = p2.minus(p1);
  float dist = diff.norm();
  return dist; 
}

Vec3 RayColor( Hit h, int rec){
  if (h.time <= 0 || h.surface.m == null
  ) {return backVec;}
  if (h.surface.m.Kref == 0 || rec == 0) {
     Material m = h.surface.m;
    Vec3 norm = h.normal;
    Vec3 point = h.ray.parametric(h.time);
    Vec3 lightSum = new Vec3(0,0,0);
    Vec3 lightCont = new Vec3(0,0,0);
    Vec3 R = new Vec3();
    
    R = new Vec3();
    R = h.ray.direction;
    R = norm.mult(h.ray.direction.dot(norm)*-2).plus(h.ray.direction);
    for (int i = 0; i < lights.size(); i++) {
      Light light = lights.get(i);
      lightCont = light.lightColor(h);
      if(debug){println(lightCont);}
      lightSum = lightSum.plus(lightCont);    
    } 
      Vec3 colors = m.Ca.plus(lightSum);
      return colors;
  }
  Material m = h.surface.m;
  Vec3 norm = h.normal;
  Vec3 point = h.ray.parametric(h.time);
  Vec3 lightSum = new Vec3(0,0,0);
  Vec3 lightCont = new Vec3(0,0,0);
  Vec3 R = new Vec3();
  
  R = new Vec3();
  R = h.ray.direction;
  R = norm.mult(h.ray.direction.dot(norm)*-2).plus(h.ray.direction);
  for (int i = 0; i < lights.size(); i++) {
    Light light = lights.get(i);
    if(debug){println("light size: "+lights.size());}
    lightCont = light.lightColor(h);
    lightSum = lightSum.plus(lightCont);
  }
  Ray reflection = new Ray(point, R);
  Vec3 moveUp = reflection.parametric(.05);
  reflection.origin = moveUp;
  Hit reflectHit = collisions(reflection); 
  Vec3 colors = m.Ca.plus(lightSum).plus(RayColor(reflectHit, rec - 1).mult(h.surface.m.Kref));
  return colors;  
}  
