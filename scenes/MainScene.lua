local gamescene = require("app.scenes.GameScene")


local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	self:picture()
	self:myButton()
end

function MainScene:picture()
	local layout = display.newColorLayer(cc.c4b(0,0,255,255))
	self:addChild(layout, 1)

	local sprite_bg = display.newSprite("image/bg/bg1.jpg")
	layout:addChild(sprite_bg,1)
	sprite_bg:setPosition(display.cx,display.cy)
	
	local sprite_uires_1 = display.newSprite("image/uires_1.png")
	layout:addChild(sprite_uires_1, 2)
	sprite_uires_1:setPosition(display.width/2,display.top-400)

	-- local sprite_uires_2 = display.newSprite("image/uires_2.png")
	-- layout:addChild(sprite_uires_2,2)
	-- sprite_uires_2:setPosition(display.cx,display.cy)

	local sprite_empty2 = display.newSprite("image/btnbg2.png")
	layout:addChild(sprite_empty2,3)
	sprite_empty2:setAnchorPoint(0.5,0)
	sprite_empty2:setPositionX(display.cx)
	sprite_empty2:setScaleY(4)

	local sprite_hero = display.newSprite("image/hero1.png")
	layout:addChild(sprite_hero,3)
	sprite_hero:setScale(2)
	sprite_hero:setAnchorPoint(0.5,0)
	sprite_hero:setPosition(display.cx, display.cy-550)



end

function MainScene:myButton()
	local images = {
		normal = "image/uires_2.png",
		pressed = "image/uires_2.png",
		disabled= "image/uires_2.png",
	}
	local button = cc.ui.UIPushButton.new(images)
	self:addChild(button,5)
	button:setPosition(display.width/2,display.top/2)
	button:setButtonEnabled(true)
	button:onButtonClicked(
		function (event)
		-- self.clickedCounts=self.clickedCounts+1
		-- self.label:setString("clicked Counts:" .. self.clickedCounts)
		self:GameScene()
	end)
end


function MainScene:GameScene()

	local gamescene = gamescene:new()
	
	display.replaceScene(gamescene,"turnOffTiles",1)
	-- body
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
