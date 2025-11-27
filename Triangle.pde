class Triangle extends Shape{
  PVector p2;
  PVector p3;
  int ptToDraw = 3;
  
  void draw(){
    if (p1!=null && p2!=null && p3!=null){
      stroke(0);
      fill(col);
      triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    } else if (p1!=null && p2!=null && p3==null){
      stroke(128);
      fill(red(col), green(col), blue(col), 128);
      triangle(p1.x, p1.y, p2.x, p2.y, mouseX, mouseY);
    }else if (p1!=null){
      stroke(128);
      line(p1.x, p1.y, mouseX, mouseY);
    }
  }
}
