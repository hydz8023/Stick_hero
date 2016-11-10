--导入精灵表单
display.addSpriteFrames("image/anim/kick.plist","image/anim/kick.png")
display.addSpriteFrames("image/anim/stay.plist","image/anim/stay.png")
display.addSpriteFrames("image/anim/walk.plist","image/anim/walk.png")


local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end)

function GameScene:ctor()
	--随机数种子
	math.randomseed(os.time())
	local m = math.random() --没用
	local random = math.random(display.width/4,display.width/4*3)

	local random3 = math.random(5,30)


	self.onestage,self.onestagex,self.onestageX  = self:stage()
	self.twostage,self.twostagex,self.twostageX = self:stage(random,random3)

	self:picture()


	--调用英雄静止时的动画函数
	self.hero = self:stay(self.onestageX-40)
	--调用棍子
	self.onestick = self:createStick(self.onestageX)
	--调用触摸
	self:touch()

	self:update()


end

--创建背景图片
function GameScene:picture()
	local i=math.ceil(math.random()*3+1)
	local picture_bg = display.newSprite("image/bg/bg"..i..".jpg")
	self:addChild(picture_bg,1)
	local picture_moon = display.newSprite("image/bg/moon.png")
	self:addChild(picture_moon, 2)
	picture_moon:setPosition(display.cx, display.cy/2*3)
	picture_bg:setPosition(display.cx,display.cy)

end

--棍子
function GameScene:createStick(posX)
	local x = 3

	--棍子精灵
	local sprite = display.newSprite("image/stick1.png")
	self:addChild(sprite,2)
	sprite:setAnchorPoint(0.5,0)
	sprite:setPosition(posX,819)
	sprite:setScale(x)
	return sprite
end

--触摸事件
function GameScene:touch()
	self:setTouchEnabled(true)
	self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
		if event.name == "began" then
			self.stickScaleY = 1
			self:scheduleUpdate() --启用帧事件
			return true

		elseif event.name == "ended" then
			self:unscheduleUpdate()--停用帧事件
			--旋转棍子
			local rotateBy = cc.RotateBy:create(0.5, 90)
			self.onestick:runAction(rotateBy)
			--获取棍子长度
			local stick_x = self.onestick:getContentSize().height*self.stickScaleY
			--获取棍子右侧坐标
			self.stick_X = stick_x + self.onestick:getPositionX()
			--判断棍子长度是否合适，英雄是否掉落
			local drop = self:drop()
			--使英雄移动
			self:moveright(drop)
		
		end
	end)
	
end

--判断是否掉落
function GameScene:drop()
	if self.stick_X < self.twostageX and self.stick_X > self.twostagex then
		return 1
	else
		return 0
	end
end

--帧事件
function GameScene:update()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
			if self.stickScaleY<=1000 then
         	self.stickScaleY=self.stickScaleY+1.5
         else
         	self.stickScaleY=self.stickScaleY
         end
			self.onestick:setScaleY(self.stickScaleY)
	end)
end

--创建台阶
function GameScene:stage(random,random3)
	local random2 = random or 0

	local sprite_stage = display.newSprite("image/stage1.png")
	self:addChild(sprite_stage,3)

	sprite_stage:setAnchorPoint(0,0)
	sprite_stage:setScaleY(1.5)

	

	self.stage_scax = random3 or 20
 	sprite_stage:setScaleX(self.stage_scax)

	
	sprite_stage:setPositionX(random2)
	local stage_posx = sprite_stage:getPositionX()
	--获取台阶的右上角坐标
	local stageX = stage_posx+(self.stage_scax)*(sprite_stage:getContentSize().width)	

	

	return sprite_stage,stage_posx,stageX
	--stagex为台阶左侧的X坐标，stageX为台阶右侧的X坐标
end


-- end

--踢棍子动作
function GameScene:kick()
	local anim_kick = display.newSprite("#kick1.png")
	self:addChild(anim_kick, 5)
	anim_kick:setPosition(display.width / 2,860)



	--用一个table装精灵帧
	--参数("图片的名称", 其实编号, 结束编号)
	local frames = display.newFrames("kick%d.png", 1,4)
	--创建animation
	--参数(精灵帧数组, 每一帧的播放时间)
	local animation = display.newAnimation(frames, 0.1)
	--将animation转化为一个Action
	local animate = cc.Animate:create(animation)
	local action = cc.RepeatForever:create(animate)

	anim_kick:setScale(1.5)
	anim_kick:runAction(action)
	
	 
end

--静止动作
function GameScene:stay(posX)
	local anim_stay = display.newSprite("#stay1.png")
	self:addChild(anim_stay, 5)
	anim_stay:setPosition(posX,860)



	--用一个table装精灵帧
	--超过10张,"E42_01" ~ "E42_20" , "E42_%02d.png"
	--参数("图片的名称", 其实编号, 结束编号)
	local frames = display.newFrames("stay%d.png", 1,5)
	--创建animation
	--参数(精灵帧数组, 每一帧的播放时间)
	local animation = display.newAnimation(frames, 0.1)
	--将animation转化为一个Action
	local animate = cc.Animate:create(animation)
	local action = cc.RepeatForever:create(animate)

	anim_stay:setScale(1.5)
	anim_stay:runAction(action)
	return anim_stay
end



--移动动作 beginX为英雄起始位置，endX为英雄最终位置
function GameScene:walk(beginX,endX)
	local anim_walk = display.newSprite("#walk1.png")
	
	self:addChild(anim_walk, 5)
	anim_walk:setAnchorPoint(1,0.5)
	anim_walk:setPosition(beginX+40, 860)

	

	--用一个table装精灵帧
	--超过10张,"E42_01" ~ "E42_20" , "E42_%02d.png"
	--参数("图片的名称", 其实编号, 结束编号)
	local frames = display.newFrames("walk%d.png", 1,5)
	--创建animation
	--参数(精灵帧数组, 每一帧的播放时间)
	local animation = display.newAnimation(frames, 0.1)
	--将animation转化为一个Action
	local animate = cc.Animate:create(animation)
	local action = cc.RepeatForever:create(animate)

	local run = cc.MoveTo:create(2,cc.p(endX,860))

	anim_walk:setScale(1.5)
	local action2 = cc.Spawn:create(run,action)

	self.hero:removeFromParent()
	self.hero = anim_walk

	return action2
end

--整体向左移动
function GameScene:moveright(drop)
	
	if drop ==1 then
		local action2 = self:walk(self.onestageX-40,self.twostageX,drop)
		local move = cc.CallFunc:create(function()
			self:moveleft(-(self.twostageX-display.cx/2),self.hero)
			self:moveleft(-(self.twostageX-display.cx/2),self.onestick)
			self:moveleft(-(self.twostageX-display.cx/2),self.onestage)
			self:moveleft(-(self.twostageX-display.cx/2),self.twostage)

		end)
		local time = cc.DelayTime:create(1.5)
		local time2 = cc.DelayTime:create(0.5)
		local removeonestage = cc.CallFunc:create(function()
				self.onestage:removeFromParent()
				self.onestage = nil
				self.onestage = self.twostage					
				
				--删除第一个台阶，将第二个赋给第一个
				self.onestagex = self.onestage:getPositionX()
				self.onestageX = self.onestage:getPositionX()+(self.stage_scax)*self.onestage:getContentSize().width
				--删除第一个棍子同时创建新的棍子
				self.onestick:removeFromParent()
				self.onestick = nil
				self.onestick = self:createStick(self.onestageX)	
			end)
		local removetwostage = cc.CallFunc:create(function()
				
				local random = math.random(display.width/4,display.width/4*3)
				local random3 = math.random(5,30)
				self.twostage,self.twostagex,self.twostageX = self:stage(random,random3)

				
		end)
		local moveend = cc.Sequence:create(time2,action2,move,time,removeonestage,removetwostage)
		self.hero:runAction(moveend)
		
	elseif drop == 0 then
		local time2 = cc.DelayTime:create(0.5)
		local drop_action = cc.MoveBy:create(0.5,cc.p(0,-900))
		local stick_right = self.onestick:getPositionX()+self.onestick:getContentSize().height*self.stickScaleY
		local movedorp = cc.MoveTo:create(1.5,cc.p(stick_right,860))
		local call = cc.CallFunc:create(function ()
		display.replaceScene(require("app.scenes.GameOver").new(self.score),"slideInB",0.5)
	end)
		local action3 = cc.Sequence:create(time2,movedorp,drop_action,call)


		self.hero:runAction(action3)
		--旋转棍子
		local rotateBy = cc.RotateBy:create(0.5, 90)
		self.onestick:runAction(rotateBy)

	end 
	print("onestagex",self.onestagex,"onestageX",self.onestageX,"twostagex",self.twostagex,"twostageX",self.twostageX,"stickx",self.onestick:getPositionX(),"stickX",self.onestick:getPositionX()+self.onestick:getContentSize().height*self.stickScaleY)
end

function GameScene:moveleft(Posx,sprite)
	local moveto = cc.MoveBy:create(1,cc.p(Posx,0))

	sprite:runAction(moveto)

end

return GameScene