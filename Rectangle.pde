class Rectangle extends Shape{
  PVector dims;
  
  void draw(){
    stroke(0);
    fill(col);
    rect(p1.x, p1.y, dims.x, dims.y);
  }
}
