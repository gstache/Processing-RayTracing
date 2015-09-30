//Vector Math Library
//Copy this .pde file into any future project directory to take this code with you!

//2x1 vector class
class Vec2{
  float x,y;
  
  //Constructors
  Vec2() {x=0; y=0;}
  Vec2(float _x, float _y){    x = _x; y = _y;  }
  Vec2(Vec2 v){    x=v.x; y=v.y;  }
  
  //Trivial math
  Vec2 plus(Vec2 v){     return new Vec2(x+v.x, y+v.y);  }
  Vec2 minus(Vec2 v){    return new Vec2(x-v.x, y-v.y);  }
  Vec2 mult(float s){    return new Vec2(x*s, y*s);      }
  Vec2 div(float s){     return new Vec2(x/s, y/s);      }
  
  //Vector math functions
  float dot(Vec2 v){
    float out = ((x*v.x)+(y*v.y));
    return out;
  }
  
  float norm(){
    float out = sqrt(dot(this));
    return out;
  }
  
  float sqNorm(){
    float out = dot(this);
    return out;
  }
  
  void normalize(){
    float factor = norm();
    if (factor != 0) {
      x = x / factor;
      y = y / factor;
    }  
  }
  
  Vec2 normalized(){
    Vec2 ret = new Vec2(x,y);
    ret.normalize();
    return ret;
  }
  
  //other trivial utilities
  String toString(){    return ("["+x+","+y+"]");  }
  boolean equalTo(Vec2 v){  return (x==v.x && y==v.y);  }
}


//3x1 vector class
class Vec3{
  float x,y,z;
  
  //Constructors
  Vec3() {x=0; y=0; z=0;}
  Vec3(float _x, float _y, float _z){    x = _x; y = _y; z = _z;  }
  Vec3(Vec3 v){    x=v.x; y=v.y; z=v.z; }
  
  //Trivial math
  Vec3 plus(Vec3 v){     return new Vec3(x+v.x, y+v.y, z+v.z);  }
  Vec3 minus(Vec3 v){    return new Vec3(x-v.x, y-v.y, z-v.z);  }
  Vec3 mult(float s){    return new Vec3(x*s, y*s, z*s);      }
  Vec3 div(float s){     return new Vec3(x/s, y/s, z/s);      }
  
  float dot(Vec3 v){
    float out = ((x*v.x)+(y*v.y)+(z*v.z));
    return out;
  }
  
  Vec3 cross(Vec3 v){
    float newX = (y*v.z)-(z*v.y);
    float newY = (z*v.x)-(x*v.z);
    float newZ = (x*v.y)-(y*v.x);
    Vec3 ret = new Vec3(newX, newY, newZ);
    return ret;
  }
  
  float norm(){
    float out = sqrt(dot(this));
    return out;
  }
  
  float sqNorm(){
    float out = dot(this);
    return out;
  }
  
  void normalize(){
    float factor = norm();
    if (factor != 0) {
      x = x / factor;
      y = y / factor;
      z = z / factor;
    }
  }
  
  Vec3 normalized(){
    Vec3 ret = new Vec3();
    ret.x = x;
    ret.y = y;
    ret.z = z;
    ret.normalize();
    return ret;
  }
  
  //other trivial utilities
  String toString(){    return ("["+x+","+y+","+z+"]");  }
  boolean equalTo(Vec3 v){  return (x==v.x && y==v.y && z==v.z);  }
}

class Mat3{
  private float[][] m;
  
  //constructors
  Mat3(){
    m = new float[3][3];
    for(int r=0; r<3; r++)
      for(int c=0; c<3; c++)
        m[r][c] = r==c ? 1 : 0;
  }
  
  Mat3(Mat3 m0){
    m = new float[3][3];
    for(int r=0; r<3; r++)
      for(int c=0; c<3; c++)
        m[r][c] = m0.get(r,c);
  }
  
  Mat3(float f0, float f1, float f2, float f3, float f4, float f5, float f6, float f7, float f8){
    m = new float[3][3];
    m[0][0] = f0; m[0][1] = f1; m[0][2] = f2;
    m[1][0] = f3; m[1][1] = f4; m[1][2] = f5;
    m[2][0] = f6; m[2][1] = f7; m[2][2] = f8;
  }
  
  //trivial math functions
  Mat3 mult(float s){
    Mat3 ret = new Mat3();
    for(int r=0; r<3; r++)
      for(int c=0; c<3; c++)
        ret.set(r, c, m[r][c]*s);
    return ret;
  }
  Mat3 div(float s){
    Mat3 ret = new Mat3();
    for(int r=0; r<3; r++)
      for(int c=0; c<3; c++)
        ret.set(r, c, m[r][c]/s);
    return ret;
  }
  
  //non-trivial math functions
  Mat3 transpose(){
    Mat3 ret = new Mat3();
    for (int r=0; r<3; r++)
      for (int c=0; c<3; c++)
        ret.m[c][r] = m[r][c];
    return ret;
  }
  
  Mat3 mult(Mat3 m0){
    Mat3 ret = new Mat3();
    Vec3 mRow = new Vec3();
    Vec3 m0Col = new Vec3();
    int r;
    for (r =0; r<3; r++) {
      mRow.x = m[r][0];
      mRow.y = m[r][1];
      mRow.z = m[r][2];
      int c;
      for (c=0; c<3; c++) {
        m0Col.x = m0.m[0][c];
        m0Col.y = m0.m[1][c];
        m0Col.z = m0.m[2][c];
        ret.m[r][c] = mRow.dot(m0Col);
      }
    }
    return ret;
  }
  
  Vec3 mult(Vec3 v){
    Vec3 ret = new Vec3();
    Vec3 row0 = new Vec3(m[0][0],m[0][1],m[0][2]);
    Vec3 row1 = new Vec3(m[1][0],m[1][1],m[1][2]);
    Vec3 row2 = new Vec3(m[2][0],m[2][1],m[2][2]);
    ret.x = v.dot(row0);
    ret.y = v.dot(row1);
    ret.z = v.dot(row2);
    
    return ret;
  }
  
  //other trivial utilities
  float get(int row, int col){ return m[row][col]; }
  void set(int row, int col, float val){ m[row][col] = val; }
  Vec3 getCol(int col){return new Vec3(m[0][col], m[1][col], m[2][col]);}
  Vec3 getRow(int row){return new Vec3(m[row][0], m[row][1], m[row][2]);}
  void setCol(int col, Vec3 v){m[0][col] = v.x; m[1][col] = v.y;  m[2][col] = v.z;}
  void setRow(int row, Vec3 v){m[row][0] = v.x; m[row][1] = v.y;  m[row][2] = v.z;}
  String toString(){    
    String s = "";
    for(int r=0; r<3; r++){
      s += "[";
      for(int c=0; c<3; c++){
        s+=m[r][c];
        if(c<2) s+= ",";
      }
      s += "]\n";
    }
    return s;
  }
  boolean equalTo(Mat3 m0){  
    for(int r=0; r<3; r++)
      for(int c=0; c<3; c++)
        if(m[r][c] != m0.get(r,c))
          return false;
    return true;
  }
}

class Mat4{
  private float[][] m;
  
  //constructors
  Mat4(){
    m = new float[4][4];
    for(int r=0; r<4; r++)
      for(int c=0; c<4; c++)
        m[r][c] = r==c ? 1 : 0;
  }
  
  Mat4(Mat4 m0){
    m = new float[4][4];
    for(int r=0; r<4; r++)
      for(int c=0; c<4; c++)
        m[r][c] = m0.get(r,c);
  }
  
  Mat4(float f0, float f1, float f2, float f3, float f4, float f5, float f6, float f7, float f8, float f9, float f10, float f11, float f12, float f13, float f14, float f15){
    m = new float[4][4];
    m[0][0] = f0; m[0][1] = f1; m[0][2] = f2; m[0][3] = f3;
    m[1][0] = f4; m[1][1] = f5; m[1][2] = f6; m[1][3] = f7;
    m[2][0] = f8; m[2][1] = f9; m[2][2] = f10; m[2][3] = f11;
    m[3][0] = f12; m[3][1] = f13; m[3][2] = f14; m[3][3] = f15;
  }
  
  //trivial math functions
  Mat4 mult(float s){
    Mat4 ret = new Mat4();
    for(int r=0; r<4; r++)
      for(int c=0; c<4; c++)
        ret.set(r, c, m[r][c]*s);
    return ret;
  }
  Mat4 div(float s){
    Mat4 ret = new Mat4();
    for(int r=0; r<4; r++)
      for(int c=0; c<4; c++)
        ret.set(r, c, m[r][c]/s);
    return ret;
  }
  
  //non-trivial math functions
  Mat4 transpose(){
    Mat4 ret = new Mat4();
    for (int r=0; r<4; r++)
      for (int c=0; c<4; c++)
        ret.m[c][r] = m[r][c];
    return ret;
  }
  
  Mat4 mult(Mat4 m0){
    Mat4 ret = new Mat4();
    int r;
    for (r =0; r<4; r++) {
      float x = m[r][0];
      float y = m[r][1];
      float z = m[r][2];
      float zz = m[r][3];
      int c;
      for (c=0; c<4; c++) {
        float a = m0.m[0][c];
        float b = m0.m[1][c];
        float d = m0.m[2][c];
        float e = m0.m[3][c];
        ret.m[r][c] = (x*a)+(y*b)+(z*d)+(zz*e);
      }
    }
    return ret;
  }
  
  Vec3 mult(Vec3 v){
    Vec3 ret = new Vec3();
    float[] rectemp = new float[4];
    float[] vec4 = new float[4];
    vec4[0] = v.x;
    vec4[1] = v.y;
    vec4[2] = v.z;
    vec4[3] = 1;
    for (int r = 0; r <4; r++){
      rectemp[r]= m[r][0]*vec4[0] + m[r][1]*vec4[1] + m[r][2]*vec4[2] + m[r][3]*vec4[3];
    }
    ret.x = rectemp[0]/rectemp[3];
    ret.y = rectemp[1]/rectemp[3];
    ret.z = rectemp[2]/rectemp[3];
    return ret;
  }
  
  //other trivial utilities
  float get(int row, int col){ return m[row][col]; }
  void set(int row, int col, float val){ m[row][col] = val; }
  void setRotation(Mat3 rot){
    for(int r=0; r<3; r++)
      for(int c=0; c<3; c++)
        m[r][c] = rot.get(r,c);
  }
  Mat3 getRotation(){
    Mat3 ret = new Mat3();
    for(int r=0; r<3; r++)
      for(int c=0; c<3; c++)
        ret.set(r, c, m[r][c]);
    return ret;
  }
  String toString(){    
    String s = "";
    for(int r=0; r<4; r++){
      s += "[";
      for(int c=0; c<4; c++){
        s+=m[r][c];
        if(c<3) s+= ",";
      }
      s += "]\n";
    }
    return s;
  }
  boolean equalTo(Mat4 m0){  
    for(int r=0; r<4; r++)
      for(int c=0; c<4; c++)
        if(m[r][c] != m0.get(r,c))
          return false;
    return true;
  }
  
}

  Mat4 translateMat(float tx, float ty, float tz) {
    Mat4 ret = new Mat4(1,0,0,tx,0,1,0,ty,0,0,1,tz,0,0,0,1);
    return ret;
  }
  
  Mat4 scaleMat(float sx, float sy, float sz) {
    //return the 4x4 homogeneous scale matrix
    Mat4 ret = new Mat4(sx,0,0,0,0,sy,0,0,0,0,sz,0,0,0,0,1);
    return ret;
  }
  
  Mat4 rotateXMat(float theta) {
    //return the 4x4 homogeneous ratate matrix for X axis
    Mat4 ret = new Mat4();
    theta = radians(theta);
    ret = new Mat4(1,0,0,0,
                        0,cos(theta),-1*sin(theta),0,
                        0,sin(theta),cos(theta),0,
                        0,0,0,1);
    return ret;
  }
  
  Mat4 rotateYMat(float theta) {
    //return the 4x4 homogeneous ratate matrix for Y axis
    Mat4 ret = new Mat4();
    theta = radians(theta);
    ret = new Mat4(cos(theta),0,sin(theta),0,
                        0,1,0,0,
                        -1*sin(theta),0,cos(theta),0,
                        0,0,0,1);
    return ret;
}
  
  Mat4 rotateZMat(float theta) {
    //return the 4x4 homogeneous ratate matrix for Z axis
     Mat4 ret = new Mat4();
     theta = radians(theta);
    ret = new Mat4(cos(theta),-1*sin(theta),0,0,
                        sin(theta),cos(theta),0,0,
                        0,0,1,0,
                        0,0,0,1);
    return ret;
  }
  
  Mat4 rotateMat(float theta, float x, float y, float z) {
    //return the 4x4 arbitrary rotation matrix which will rotate a point theta degrees around
  //the vector (x,y,z). Remember that a homogeneous rotation matrix for 3D is a 3x3 rotation matrix in the
  //top left corner of a 4x4 identity matrix. Also note that theta is given to you in degrees, but the sin and
  //cos functions require an angle in radians. Refer to the class notes for details on how to implement
  //arbitrary axis rotation.
    Mat4 ret = new Mat4();
    theta = radians(theta);
    ret = new Mat4(cos(theta)+(x*x)*(1-cos(theta)),(x*y)*(1-cos(theta))-z*sin(theta),(x*z)*(1-cos(theta))-y*sin(theta),0,
                  (x*y)*(1-cos(theta))+z*sin(theta),cos(theta)+(y*y)*(1-cos(theta)),(y*z)*(1-cos(theta))-x*sin(theta),0,
                  (x*z)*(1-cos(theta))-y*sin(theta),(y*z)*(1-cos(theta))-x*sin(theta),cos(theta)+(z*z)*(1-cos(theta)),0,
                  0,0,0,1);
    return ret;
  }
  
class Ray {
  Vec3 origin;
  Vec3 direction;
  Ray (Vec3 orig, Vec3 destination, int signify){
    origin = new Vec3();
    direction = new Vec3(); 
    origin = orig;
    direction.x = destination.x - origin.x;
    direction.y = destination.y - origin.y;
    direction.z = destination.z - origin.z;
    float factor = sqrt(pow(direction.x,2)+pow(direction.y,2)+pow(direction.z,2));
    direction = new Vec3(direction.x/factor,direction.y/factor,direction.z/factor);
  }
  
  Ray (Vec3 orig, Vec3 direc) {
    origin = orig;
    direction = direc;
  }
 
  Vec3 parametric(float time) {
    Vec3 point = new Vec3();
    point.x = origin.x + direction.x*time;
    point.y = origin.y + direction.y*time;
    point.z = origin.z + direction.z*time;
    return point; 
  }
  
  float findTime(Vec3 point) {
    float time = (point.x - origin.x)/direction.x;
    return time;
  }
  
  void negate() {
    direction.x = direction.x*(-1);
    direction.y = direction.y*(-1);
    direction.z = direction.z*(-1);
  }
}

