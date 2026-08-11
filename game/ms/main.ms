init = function()
  
  speed = 0.5
  grav = 1
  
  
  
  pen = object
    rot = 0
    x = 0
    y = -24
    vel = 12
    length = 60
    acc = 100
  end
  
  points = object
    list = []
    
    add = function(rot)
      local tempobj = new point(rot)
      tempobj.parent = this
      this.list.push(tempobj)
    end
    
    del = function(obj)
      this.list.removeElement(obj)
    end
    
  end
  
  point = class
    constructor = function(rot)
      this.rot = rot
      this.x = pen.length*-sin((this.rot+180)/180*PI)
      this.y = pen.length*cos((this.rot+180)/180*PI)
    end
    draw = function()
      screen.drawSprite( "point", this.x, this.y, 32, 32 )
    end
    update = function()
      this.x = pen.length*-sin((this.rot+180)/180*PI)
      this.y = pen.length*cos((this.rot+180)/180*PI)
    end
    selfdel = function()
      this.parent.del(this)
    end  
  end
  
  points.add(40)
  
  
end

update = function()
  
  local rad = pen.rot * PI / 180
  pen.acc = (-grav / pen.length) * sin(rad) * 180/PI
  
  /*
  if pen.vel < 1 then 
    pen.vel += 0.1 
  else
    pen.vel = 1
  end
  */

  //pen.vel *= 0.995 

  pen.vel += pen.acc * speed
  pen.rot += pen.vel * speed
  // pen.rot >= 360 then pen.rot = 0 end
  penrot = pen.rot
  penvel = pen.vel
  penacc =  (-grav / pen.length) * sin(rad) * 180/PI
  
  for el in points.list
    el.update()
  end
end

draw = function()
  screen.clear("rgb(65,92,147)")
  
  for el in points.list
    el.draw()
  end
  
  screen.setRotation(pen.rot)
  screen.fillRect(pen.x,pen.y,7,60,"rgb(20,2,2)")
  screen.setRotation(0)
  screen.setTranslation(0,0)
  screen.fillRound(0,0,15,15,"rgb(79,79,79)")
  screen.fillRound(60*-sin((pen.rot+180)/180*PI),60*cos((pen.rot+180)/180*PI),18,18,"rgb(79,79,79)")
end  
  
  
  
  
  
  
  
