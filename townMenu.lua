-----------------------------------------------------------------------------------------
--
-- newTown.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- 'onRelease' event listeners for buttons
local function onPlannerBtnRelease()
	storyboard.gotoScene( "plannerView", "fade", 500 )
	return true	-- indicates successful touch
end
local function onTownBtnRelease()
	storyboard.gotoScene( "townView", "fade", 500 )
	return true	-- indicates successful touch
end
local function onBackBtnRelease()
		storyboard.purgeScene(scene)
	storyboard.gotoScene( "mainMenu", "fade", 500 )

	return true	-- indicates successful touch
end

function scene:createScene( event )	
	local group = self.view
	
	-- get town name from db
	local townName = "TownNotFound"
	for row in storyboard.db:nrows("SELECT * FROM towns WHERE id="..storyboard.townData["id"]) do
		townName = row.name
	end
		
	-- create/position title
	local title = display.newText(townName, 264, 42, native.systemFont, 40)
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth * 0.5
	title.y = 50
	
	-- create Planner View button
	local plannerBtn = widget.newButton{
		label="Planner View",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=160, height=40,
		onRelease = onPlannerBtnRelease	-- event listener function
	}
	plannerBtn:setReferencePoint( display.CenterReferencePoint )
	plannerBtn.x = display.contentWidth*0.5
	plannerBtn.y = display.contentHeight - 280
	
	-- create Town View button
	local townBtn = widget.newButton{
		label="Town View",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=140, height=40,
		onRelease = onTownBtnRelease	-- event listener function
	}
	townBtn:setReferencePoint( display.CenterReferencePoint )
	townBtn.x = display.contentWidth*0.5
	townBtn.y = display.contentHeight - 200
	
	-- create Back button
	local backBtn = widget.newButton{
		label="Return to Main Menu",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=240, height=40,
		onRelease = onBackBtnRelease	-- event listener function
	}
	backBtn:setReferencePoint( display.CenterReferencePoint )
	backBtn.x = display.contentWidth*0.5
	backBtn.y = display.contentHeight - backBtn.height
	
	group:insert( title )
	group:insert( plannerBtn )
	group:insert( townBtn )
	group:insert( backBtn )
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	if plannerBtn then
		plannerBtn:removeSelf()	-- widgets must be manually removed
		plannerBtn = nil
	end
	if townBtn then
		townBtn:removeSelf()	-- widgets must be manually removed
		townBtn = nil
	end
	if backBtn then
		backBtn:removeSelf()	-- widgets must be manually removed
		backBtn = nil
	end
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene