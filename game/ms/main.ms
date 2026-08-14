init = function()
  
  speed = 0.25
  grav = 1
  menu = 1
  timer = 0
  bc = "rgb(65,92,147)"
  
  highscore = storage.get("highscore")
  
  colpoints = 0 // collected points
  
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
    
    add = function(rot,typ)
      local tempobj = new point(rot,typ)
      tempobj.parent = this
      this.list.push(tempobj)
    end
    
    del = function(obj)
      this.list.removeElement(obj)
    end
    
  end
  
  point = class
    constructor = function(rot,typ)
      this.rot = rot
      this.typ = typ
      this.x = pen.length*-sin((this.rot+180)/180*PI)
      this.y = pen.length*cos((this.rot+180)/180*PI)
    end
    draw = function()
      if this.typ == 1 then  
        screen.drawSprite( "point", this.x, this.y, 16, 16 )
      elsif this.typ == 2 then 
        screen.drawSprite( "bluepoint", this.x, this.y, 16, 16 )
      end
    end
    update = function()
      this.x = pen.length*-sin((this.rot+180)/180*PI)
      this.y = pen.length*cos((this.rot+180)/180*PI)
    end
    selfdel = function()
      this.parent.del(this)
    end  
  end
  
  points.add((random.nextInt(180)-90),1)
  
  
end

checkpoints = function()
  for p in points.list
    print(abs(pen.rot - p.rot)) 
    if abs(pen.rot - p.rot) < 10 then
      if p.typ == 2 then
        timer += 10
      end
      p.selfdel()
      colpoints += 1
      do
        sleep 100
        newpoint()
      end
      seteffect = [1,p.x,p.y]
      effecton = true
      currentbc = "green"
      after 100 do
        if currentbc == "green" then
          currentbc = "blue"
        end
      end
    else
      if colpoints > 0 then 
        colpoints -= 1
      end
      currentbc = "red"
      after 100 do
        if currentbc == "red" then
          currentbc = "blue"
        end
      end
    end
  end
end

newpoint = function()
  if nextblue then
    
  else
    randomtyp = random.nextInt(2)+1
  end  
    
  if randomtyp == 2 and not cdblue then //cdblue = cooldown bluepoints
    points.add(random.nextInt(180)-90,2)
    cdblue = true
    cdblue2 = 300
  else
    points.add(random.nextInt(180)-90,1)
  end
end

effect = function(id,x,y)
  if id == 1 then
    if alpha1 > 2 and not e1running then 
      alpha1 = 0 
      e1running = true
    elsif alpha1 > 2 and e1running then
      effecton = false
      e1running = false
    end 
    alpha1 += 1
  end
  
end

effectdraw = function(id,x,y)
  if id == 1 then
    screen.fillRound(x,y,10+alpha1*6,10+alpha1*6,"rgba(255,255,255,"+abs(alpha1/2)+")")
  end
end

drawpausebutton = function()
  if pause == 1 then
    screen.drawSprite( "play", screen.width/2-25, screen.height/2-28, 24, 24 )
  end
  if pause == 0 then
    screen.drawSprite( "pause", screen.width/2-25, screen.height/2-28, 24, 24 )
  end
end

update = function()
  
  if menu == 1 then
    if keyboard.press.SPACE or mouse.press and mouse.left then
      menu = 2
      mouse.press = 0
      keyboard.press.SPACE = 0
      timer = 30
      colpoints = 0
      cdblue = false
      currentbc = "blue"
    end
  end
  
  if menu == 2 then
    
    if currentbc == "blue" then
      bc = "rgb(65,92,147)"
    elsif currentbc == "red" then
      bc ="rgb(197,22,22)"
    elsif currentbc == "green" then
      bc ="rgb(49,147,0)"
    end
    
    if cdblue2 > 0 then
      cdblue2 -= 1 
    end
    
    if cdblue2 < 1 then
     cdblue = false  
    end
    
    if timer > 0 then
      ticks += 1
      if ticks >= 60 then
        ticks = 0
        timer -= 1
      end
    end
    
    if timer <= 0 then
      menu = 1
      if highscore < colpoints then
        highscore = colpoints
        storage.set("highscore",highscore)
      end
    end
    
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
    
    if keyboard.press.SPACE or mouse.press and mouse.left then checkpoints() end
    
    speed = 0.25 + colpoints/150
  
    pen.vel += pen.acc * speed
    pen.rot += pen.vel * speed
    // pen.rot >= 360 then pen.rot = 0 end
    penrot = pen.rot
    penvel = pen.vel
    penacc =  (-grav / pen.length) * sin(rad) * 180/PI
    
    for el in points.list
      el.update()
    end
    
    pause = 0
    if keyboard.press.P or 
      ((mouse.x > screen.width/2-35 and mouse.x < screen.width/2-15) and 
      (mouse.y > screen.height/2-35 and mouse.y < screen.height/2-15)) and
      mouse.press
    then
      menu = 3
      keyboard.press.P = 0
      mouse.press = 0
    end
    
    if effecton == true then
      effect(seteffect[0],seteffect[1],seteffect[2])
    end
  end
  
  if menu == 3 then
    pause = 1
    if keyboard.press.P or 
      ((mouse.x > screen.width/2-35 and mouse.x < screen.width/2-15) and 
      (mouse.y > screen.height/2-35 and mouse.y < screen.height/2-15)) and
      mouse.press
    then
      menu = 2
      
    end
  end
end

draw = function()
  screen.clear(bc)
  
  if menu == 1 then
    screen.drawText("Click on the screen", 0, 10, 20,"#fff")
    screen.drawText("or space to start", 0, -5, 20,"#fff")
    screen.drawText("Highscore: " + highscore, 0, -65, 20,"#fff")
    screen.drawText("Pendel Game",0,50,30,"#fff")
    screen.drawText("Controls: Space , P (Pause)",0,-30,15,"#fff")
    screen.drawText("or click (mouse , touch)",0,-42,15,"#fff")
  end
  
  if menu == 2 then
    for el in points.list
      el.draw()
    end
    screen.setRotation(pen.rot)
    screen.fillRect(pen.x,pen.y,7,60,"rgb(20,2,2)")
    screen.setRotation(0)
    screen.setTranslation(0,0)
    screen.fillRound(0,0,15,15,"rgb(79,79,79)")
    screen.fillRound(60*-sin((pen.rot+180)/180*PI),60*cos((pen.rot+180)/180*PI),18,18,"rgb(79,79,79)")
    screen.drawText("Points: "+ colpoints, 0, screen.height/2-20, 20,"#fff")
    screen.drawText("Time: "+ timer, 0, screen.height/2-35, 20,"#fff")
    
    drawpausebutton()
    
    if effecton == true then
      effectdraw(seteffect[0],seteffect[1],seteffect[2])
    end
  end
  
  if menu == 3 then
    for el in points.list
      el.draw()
    end
    screen.setRotation(pen.rot)
    screen.fillRect(pen.x,pen.y,7,60,"rgb(20,2,2)")
    screen.setRotation(0)
    screen.setTranslation(0,0)
    screen.fillRound(0,0,15,15,"rgb(79,79,79)")
    screen.fillRound(60*-sin((pen.rot+180)/180*PI),60*cos((pen.rot+180)/180*PI),18,18,"rgb(79,79,79)")
    screen.drawText("Points: "+ colpoints, 0, screen.height/2-20, 20,"#fff")
    screen.drawText("Time: "+ timer, 0, screen.height/2-35, 20,"#fff")
    
    drawpausebutton()
  end
end  
  
  
  
  
  
  
  
