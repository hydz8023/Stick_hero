local GameOver = class("GameOver", function()
    return display.newScene("GameOver")
end)

function GameOver:ctor()
  self.layer=self:MyLayer()
  self:HomeButton()
  self:returnGame()
end
--背景
function GameOver:MyLayer()
  local layer=display.newLayer()
  local bg=display.newSprite("image/bg/bg4.jpg")
  bg:setPosition(display.cx,display.cy)
  self:addChild(layer)
  layer:addChild(bg,1)
  return layer
end
--回到主页按钮
function GameOver:HomeButton()
   local images={
      normal="image/uires_8.png",
      pressed="image/uires_8.png",
      disabled="image/uires_8.png"
    }
   local button=cc.ui.UIPushButton.new(images)
   button:setPosition(display.cx-200,display.cy)
   button:setScale(1.5)
   self.layer:addChild(button,2)
   button:onButtonClicked(function (event) 
    	                   app:enterScene("MainScene", nil, "moveInT", 1.0)
    	                   end)
end
--回到游戏按钮
function  GameOver:returnGame()
    local images={
      normal="image/uires_5.png",
      pressed="image/uires_5.png",
      disabled="image/uires_5.png"
    }
   local button=cc.ui.UIPushButton.new(images)
   button:setPosition(display.cx+200,display.cy)
   button:setScale(1.5)
   self.layer:addChild(button,2)
   button:onButtonClicked(function (event) 
                         app:enterScene("GameScene", nil, "moveInT", 1.0)
                         end)
end

return GameOver