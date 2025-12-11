class Rectangle extends Shape{
  PVector dims;
  
  void draw(){
    stroke(0);
    fill(col);
    rect(p1.x, p1.y, dims.x, dims.y);
  }
  
  boolean isPointIn(PVector pt){
  
    if(p1.x <= pt.x && pt.x <= p1.x + dims.x && p1.y <= pt.y && pt.y <= p1.y + dims.y)
      return true;
    
    else
      return false;
  
  }
  
}
