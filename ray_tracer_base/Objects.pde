abstract class Light {
  Vec3 diffuse;
  Vec3 specular;
  abstract Vec3 getPos();
  abstract Vec3 lightColor(Hit h);
}

class AreaLight extends Light {
  Vec3 c1;
  Vec3 c2;
  Vec3 c3;
  Ray c12;
  Ray c13;
  float t12;
  float t13;
  float tX1;
  float tX2;
  AreaLight(Vec3 p1,Vec3 p2,Vec3 p3, Vec3 col) { 
    c1 = p1;
    c2 = p2;
    c3 = p2;
    c12 = new Ray(c1, c2,0);
    c13 = new Ray(c1, c3, 0);
    t12 = c12.findTime(c2);
    tX1 = t12 / 10.0;
    t13 = c13.findTime(c3);
    tX2 = t13 / 10.0;
    diffuse = col;
  }
  
  Vec3 getPos() {return c1;}
   
  Vec3 lightColor(Hit h){
    Material m = h.surface.m;
    Vec3 norm = h.normal;
    Vec3 point = h.ray.parametric(h.time);
    Vec3 lightSum = new Vec3(0,0,0);
    Vec3 R = new Vec3();
    Vec3 p2 = new Vec3();
    float t1 = 0;
    float t2 = 0;
    for(int i = 0; i  <10; i++){
      Vec3 newPos = c12.parametric(t1);
      t1 =t1 + tX1;
      c13.origin = newPos;
      t2 = 0;
      for(int j = 0; j < 10; j++){
        Vec3 thePos = c13.parametric(t2);
        t2 = t2 + tX2;  
        Ray lRay = new Ray(point, thePos, 0);
        Vec3 newPoint = lRay.parametric(.01);
        //Test for shadow collisions
        lRay.origin = newPoint;
        Hit theHit = collisions(lRay);
        p2 = theHit.ray.parametric(theHit.time);
        //get original distance of light intersect
        float lDist = distance(newPoint, thePos);
        float hDist = distance(newPoint, p2);
        R = new Vec3();
        if (theHit.time <= 0) { hDist = lDist;}
        if ( hDist < lDist){
          Vec3 lightCont = new Vec3(0,0,0);
          lightSum = lightSum.plus(lightCont);
        } else {
          Vec3 lightCont = new Vec3(0,0,0);
           Vec3 L = lRay.direction;
          float diffCont = max(0, norm.dot(L));
          L = lRay.direction;
          R = h.ray.direction;
          R = norm.mult(h.ray.direction.dot(norm)*-2).plus(h.ray.direction);
          float ndots = 2.0*L.dot(norm);
          float specCont =max(0,R.dot(L));
          specCont = pow(specCont, m.Ks);
          lightCont.x = (m.Cd.x*diffCont)*diffuse.x+(m.Cs.x*specCont)*diffuse.x;
          lightCont.y = (m.Cd.y*diffCont)*diffuse.y+(m.Cs.y*specCont)*diffuse.y;
          lightCont.z = (m.Cd.z*diffCont)*diffuse.z+(m.Cs.z*specCont)*diffuse.z;
          lightSum = lightSum.plus(lightCont);
        } 
      }
    }
   
   lightSum = lightSum.mult(.01); 
   return lightSum;
   }
}

class PointLight extends Light {
  Vec3 position;
  PointLight(Vec3 pos, Vec3 col) {
    diffuse = col;
    position = pos;
  }
  Vec3 getPos() {return position;}
  Vec3 lightColor(Hit h) {
    Material m = h.surface.m;
    Vec3 norm = h.normal;
    Vec3 point = h.ray.parametric(h.time);
    Vec3 lightSum = new Vec3(0,0,0);
    Vec3 lightCont = new Vec3(0,0,0);
    Vec3 R = new Vec3();
    Vec3 p2 = new Vec3();
    Ray lRay = new Ray(point, position, 0);
      Vec3 newPoint = lRay.parametric(.01);
      //Test for shadow collisions
      lRay.origin = newPoint;
      Hit theHit = collisions(lRay);
      p2 = theHit.ray.parametric(theHit.time);
      //get original distance of light intersect
      float lDist = distance(newPoint, position);
      float hDist = distance(newPoint, p2);
      R = new Vec3();
      if (theHit.time <= 0) { hDist = lDist;}
      if ( hDist < lDist){
        lightCont = new Vec3(0,0,0);
      } else {
         Vec3 L = lRay.direction;
        float diffCont = max(0, norm.dot(L));
        L = lRay.direction;
        R = h.ray.direction;
        R = norm.mult(h.ray.direction.dot(norm)*-2).plus(h.ray.direction);
        
        float ndots = 2.0*L.dot(norm);
        float specCont =max(0,R.dot(L));
        specCont = pow(specCont, m.Ks);
        lightCont.x = (m.Cd.x*diffCont)*diffuse.x+(m.Cs.x*specCont)*diffuse.x;
        lightCont.y = (m.Cd.y*diffCont)*diffuse.y+(m.Cs.y*specCont)*diffuse.y;
        lightCont.z = (m.Cd.z*diffCont)*diffuse.z+(m.Cs.z*specCont)*diffuse.z;
      } 
  return lightCont;
  }
}

abstract class Surface {
  Material m;
  abstract Hit collide(Ray r);
  abstract void mString(); 
}

class Sphere extends Surface {
  Vec3 center;
  float radius;
  Sphere(Vec3 pos, float r, Material mat) {
    center = pos;
    radius = r;
    m = mat;
  }
  Hit collide(Ray r) {
    float a = r.direction.x*r.direction.x 
      + r.direction.y*r.direction.y +r.direction.z*r.direction.z; 
    float b = 2*r.direction.x*(r.origin.x-center.x) 
      +2*r.direction.y*(r.origin.y-center.y) +2*r.direction.z*(r.origin.z-center.z); 
    float c = pow((r.origin.x-center.x),2)+pow((r.origin.y-center.y),2)+pow((r.origin.z-center.z),2) - radius*radius;
   
    float det = b*b - 4*a*c;
    if (det < 0) {
      Hit h = new Hit(0, null, r, null);
      return h;
    } else {
      float t = (-1*b-sqrt(det))/(2*a);
      Vec3 point  = r.parametric(t);
      Ray temp = new Ray(center, point, 0);
      Vec3 norm = temp.direction;
      Hit h = new Hit(t, norm, r, this);
      return h;
    } 
  }
  void mString() {
    println("Sphere "+center+" "+radius+" "+m);
  } 
  
}

class Triangle extends Surface {
  Vec3 a;
  Vec3 b;
  Vec3 c;
  Vec3 n;
  Triangle(Vec3 p1, Vec3 p2, Vec3 p3, Material mat){
     a = p1;
     b = p2;
     c = p3;
     m = mat;
     Vec3 AC= c.minus(a);
     Vec3 AB= b.minus(a);
     n = AC.cross(AB).normalized(); 
  } 
  Hit collide( Ray r){
    float t = (((a.x*n.x)+(a.y*n.y)+(a.z*n.z)) - ((n.x*r.origin.x)+(n.y*r.origin.y)+(n.z*r.origin.z)))
          /(n.x*r.direction.x + n.y*r.direction.y + n.z*r.direction.z);
    Vec3 point = r.parametric(t);
    Vec3 v1 = b.minus(a);
    Vec3 v2 = c.minus(b);
    Vec3 v3 = a.minus(c);
    Vec3 Vp1 = point.minus(a);
    Vec3 Vp2 = point.minus(b);
    Vec3 Vp3 = point.minus(c);
    Vec3 n1 = Vp1.cross(v1);
    Vec3 n2 = Vp2.cross(v2);
    Vec3 n3 = Vp3.cross(v3);
    float dot1 = n1.dot(n);
    float dot2 = n2.dot(n);
    float dot3 = n3.dot(n);
    if(dot1 >= 0 && dot2 >= 0 && dot3 >= 0) {
       Surface s = new Triangle(a,b,c,m);
       //if(debug){println(m);}
       Hit h = new Hit(t, n, r, s);
       return h;
    }
    else {
       Hit h = new Hit(0, null, r,null);
       return h;
    }
  }
  void mString() {
    println("Triangle "+a+" "+b+" "+c+" "+m.Ks);
  } 
}

class Hit{
  int surfaceID;
  float time;
  Vec3 normal;
  Ray ray;
  Surface surface;
  Hit(){}
  Hit(float t, Vec3 norm, Ray r, Surface s){
    time = t;
    normal = norm;
    ray = r;
    surface = s;
  }
  
}

class Material{
  Vec3 Ca; //ambient
  Vec3 Cd; //diffuse 
  Vec3 Cs; //specular
  float Ks; //specular
  float Kref; //reflection
  Material (Vec3 amb, Vec3 diff, Vec3 spec, float pow, float ref) {
    Ca = amb;
    Cd = diff;
    Cs = spec;
    Ks = pow;
    Kref = ref;
  }
  Material(){}
}
