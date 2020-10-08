function love.load()
   
   love.graphics.setFont(love.graphics.newFont(11))

   love.physics.setMeter( 32 )
   myWorld = love.physics.newWorld(0, 9.81*32, true)  -- updated Arguments for new variant of newWorld in 0.8.0
   gravity="down"

   gravityguyBody = love.physics.newBody( myWorld, 300, 400 ,"dynamic" )
   gravityguyShape = love.physics.newRectangleShape( 0, 0,50,50 )
   gravityguyFixture = love.physics.newFixture(gravityguyBody, gravityguyShape)
   gravityguyImage = love.graphics.newImage("gravity-guy-d.png")
   gravityguyBody:setMassData(0,0,1,0)
   gravityguyFixture:setUserData("ball")


   myEdgeBody1 = love.physics.newBody( myWorld, 0,0 ,"static")
   myEdgeShape1 = love.physics.newEdgeShape( 10,10, 790,10  )
   myEdgeFixture1 = love.physics.newFixture(myEdgeBody1, myEdgeShape1)
   myEdgeFixture1:setUserData("edge1")

   myEdgeBody2 = love.physics.newBody( myWorld, 0,0 ,"static")
   myEdgeShape2 = love.physics.newEdgeShape( 790,10, 790,590  )
   myEdgeFixture2 = love.physics.newFixture(myEdgeBody2, myEdgeShape2)
   myEdgeFixture2:setUserData("edge2")
   
   myEdgeBody3 = love.physics.newBody( myWorld, 0,0 ,"static")
   myEdgeShape3 = love.physics.newEdgeShape( 10,590, 790,590  )
   myEdgeFixture3 = love.physics.newFixture(myEdgeBody3, myEdgeShape3)
   myEdgeFixture3:setUserData("edge3")

   myEdgeBody4 = love.physics.newBody( myWorld, 0,0 ,"static")
   myEdgeShape4 = love.physics.newEdgeShape( 10,10, 10,590  )
   myEdgeFixture4 = love.physics.newFixture(myEdgeBody4, myEdgeShape4)
   myEdgeFixture4:setUserData("edge4")
   coins={}
   spikes={}
end
q=0
z=0
b=0
score=0
start=0
name=""
len=0
function love.update( dt )
   if start==1 then
   	for i,v in pairs(coins) do
		if math.ceil(math.sqrt((v.body:getX()-gravityguyBody:getX())^2 + (v.body:getY()-gravityguyBody:getY())^2))<55 then
			table.remove(coins,i)
			score=1+score
			v.body:destroy()
			src1 = love.audio.newSource("ding.mp3", "stream")
			src1:play()
		end
	end
   	for i,v in pairs(spikes) do
		if math.ceil(math.sqrt((v.body:getX()-gravityguyBody:getX())^2 + (v.body:getY()-gravityguyBody:getY())^2))<55 then
			src1 = love.audio.newSource("end.mp3", "stream")
			src1:play()
			k=io.open("scores_g.txt","a+")
			io.input(k)
			a=k:read("*all")
			io.output(k)
			if a=="" then
				io.write("name score".."\n")
			end
			io.write(name.." "..tostring(score).."\n")
			k:seek("set")
			a=k:read("*all")
			k:close()
			start=2
			break
		end
   	end
   	if math.ceil(os.clock()-t)==3 then
		len=len+1
		coin={}
		spike={}
		math.randomseed(os.time())
		coin.body = love.physics.newBody(myWorld, math.random(360,780),math.random(20,1000/2))
		coin.image = love.graphics.newImage("coin.png")
		coin.body:setAngle(math.random(0,math.pi))
		coin.shape = love.physics.newCircleShape(10)
		coin.fixture = love.physics.newFixture(coin.body, coin.shape)
		table.insert(coins,coin)
		spike.body = love.physics.newBody(myWorld, math.random(360,780),math.random(20,1000/2))
		spike.image = love.graphics.newImage("spike.png")
		spike.body:setAngle(math.random(0,math.pi))
		spike.shape = love.physics.newRectangleShape(10,10)
		spike.fixture = love.physics.newFixture(spike.body, spike.shape)
		table.insert(spikes,spike)		
		t=os.clock()
   	end
	if table.getn(coins)==1 then
		z=os.clock()
	end
	if math.ceil(os.clock()-z)==1 then
		for i,v in pairs(coins) do
			v.body:setX(v.body:getX()-1.0)
		end
		for i,v in pairs(spikes) do
			v.body:setX(v.body:getX()-1.0)
			v.body:setAngle(v.body:getAngle()+5)
		end	
		z=os.clock()
	end
   end
   myWorld:update( dt )
end

function love.draw()
   if start==1 then
   	love.graphics.print("score = "..tostring(score),10,10)
   	love.graphics.line(myEdgeBody1:getWorldPoints(myEdgeShape1:getPoints()))
   	love.graphics.line(myEdgeBody2:getWorldPoints(myEdgeShape2:getPoints()))
   	love.graphics.line(myEdgeBody3:getWorldPoints(myEdgeShape3:getPoints()))
   	love.graphics.line(myEdgeBody4:getWorldPoints(myEdgeShape4:getPoints()))
   	love.graphics.draw(gravityguyImage,gravityguyBody:getX(),gravityguyBody:getY(),gravityguyBody:getAngle(),1,1,gravityguyImage:getWidth()/2,gravityguyImage:getHeight()/2)
   	if table.getn(coins)>0 then
		for i,v in pairs(coins) do
			love.graphics.draw(v.image,v.body:getX(),v.body:getY(),v.body:getAngle(),1,1,v.image:getWidth()/2,v.image:getHeight()/2)
		end
	end
   	if table.getn(spikes)>0 then
		for i,v in pairs(spikes) do
			love.graphics.draw(v.image,v.body:getX(),v.body:getY(),v.body:getAngle()+1,1,1,v.image:getWidth()/2,v.image:getHeight()/2)
		end
	end
   elseif start==0 then
	love.graphics.setColor(255,255,255)
	love.graphics.print("enter your username",10,30)
	love.graphics.print("your name:"..name,10,45)
   elseif start==2 then
	love.graphics.clear()
	love.graphics.print(a,100,100)
	love.graphics.print("press r to replay",100,50)
   end
end

function love.keypressed( key )
   if start==0 then
   	if string.len(key)==1 then
		name=name..key
   	end
   	if key=="backspace" then
		name=name:sub(1, #name - 1)
   	end
   	if key=="return" then	
		t=os.clock()
		z=os.clock()
		b=os.clock()
		start=1
   	end
   elseif start==1 then
   	if key == "up" then
      		gravityguyImage = love.graphics.newImage("gravity-guy-u.png")
      		myWorld:setGravity(0, -9.81*28)
      		gravityguyBody:setAwake(true)
   	elseif key == "down" then
      		gravityguyImage = love.graphics.newImage("gravity-guy-d.png")
      		myWorld:setGravity(0, 9.81*28)
      		gravityguyBody:setAwake(true)
   	end
   elseif start==2 then
	if key=="r" then
		start=0
		name=""
		score=0
		gravityguyBody:setPosition(300,400)
		myWorld:setGravity(0, 9.81*28)
		gravityguyBody:setAwake(true)
		gravityguyImage = love.graphics.newImage("gravity-guy-d.png")
		for i,v in pairs(coins) do
			v.body:destroy()
			table.remove(coins,i)
		end
		for i,v in pairs(spikes) do
			v.body:destroy()
			table.remove(spikes,i)
		end
	end
   end
end