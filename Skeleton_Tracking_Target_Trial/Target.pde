class Target {
  int x, y, z, d;
  boolean triggered;
  
  public Target(int x, int y, int z, int d){
    this.x = x;
    this.y = y;
    this.z = z;
    this.d = d;
    triggered = false;
  }
  
  void checkCollision(PVector joint){
    
     if (joint.x > this.x && joint.x < this.x + d){
       if (joint.y > this.y && joint.y < this.y + d){
        // if (joint.z > this.z && joint.z < this.z + d){
           triggered = true; 
           //println("there it is!");
        // }
       }
     } else {
       triggered = false;
     } 
  }
  
}
