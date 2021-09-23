class Niveau {
  int num;
  
  public Niveau(int flockS) {
    flockSize = flockS;
    flockCreation();
    num = 1;
  }
  
  void nextLevel(){
    flockSize += 5;
    flockCreation();
    v.location.x = width / 2;
    v.location.y = height / 2;
    boidsDeleted = 0;
    num++;
  }
}
