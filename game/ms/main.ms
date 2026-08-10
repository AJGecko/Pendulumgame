init = function()
  speed = 1
  grav = 1
  pen = object
    rot = 0
    x = 0
    y = -24
    vel = 0
  end
end

update = function()
  
  if pen.vel < 1 then 
    pen.vel += 0.1 
  else
    pen.vel = 1
  end
  
  pen.rot += pen.vel * speed
  if pen.rot >= 360 then pen.rot = 0 end
  penrot = pen.rot
end

draw = function()
  screen.clear("rgb(65,92,147)")
  screen.setRotation(pen.rot)
  screen.fillRect(pen.x,pen.y,7,60,"rgb(20,2,2)")
  screen.setRotation(0)
  screen.setTranslation(0,0)
  screen.fillRound(0,0,15,15,"rgb(79,79,79)")
  screen.fillRound(60*-sin((pen.rot+180)/180*PI),60*cos((pen.rot+180)/180*PI),18,18,"rgb(79,79,79)")
end