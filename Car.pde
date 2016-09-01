public interface  Car {






    //have to check for collisions
 

  //each tick we apply physi{
 
  public void update();

public void accelerate();

public void turnRight();
public void turnLeft();
public void brake();

//determine the type of car and draw it
public void draw();

public boolean checkObstacles();

public void ability();
public void abilityOff();

public float getypos();
public float getxpos();
public void setxpos(float x);
public void setypos(float y);

public String name();

public float getAcceleration();
public float getTopSpeed();
public float getHandling();
public int getHealth();
public color getColor();

}