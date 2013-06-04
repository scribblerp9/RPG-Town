-----------------------------------------------------------------------------------------
--
-- loadTown.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

require "sqlite3"
local Wrapper = require("wrapper")

--------------------------------------------

-- 'onRelease' event listeners for buttons
local function onBackBtnRelease()
	storyboard.gotoScene( "mainMenu", "fade", 500 )
	return true	-- indicates successful touch
end

--------------------------------------------

-- event listeners for text fields
local function textFieldListener(event)
	if event.phase == "began" then
		event.text = ""
	end
end

function scene:createScene( event )
	local group = self.view
	
	-- create/position logo/title image on upper-half of the screen
	local title = Wrapper:newParagraph({

		text = "Create your town",
		width = 250,
		height = 110, 			-- fontSize will be calculated automatically if set 
		--font = "helvetica", 	-- make sure the selected font is installed on your system
		--fontSize = 16,			
		lineSpace = 2,
		alignment  = "center",

		-- Parameters for auto font-sizing
		fontSizeMin = 8,
		fontSizeMax = 40,
		incrementSize = 2
	})	
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth * 0.5
	title.y = 60
	
	-- create text fields for entering town name and size
	local townName = native.newTextField(0,0,150,24)
	townName:setReferencePoint(display.CenterReferencePoint)
	townName.x = display.contentWidth * 0.5
	townName.y = (display.contentHeight * 0.5) - 60
	townName.text = "Enter Town Name"
	townName.align = "center"
	local townSize = native.newTextField(0,0,110,24)
	townSize:setReferencePoint(display.CenterReferencePoint)
	townSize.x = display.contentWidth * 0.5
	townSize.y = display.contentHeight * 0.5
	townSize.text = "Enter Town Size"
	townSize.align = "center"
	townSize.inputType = "number"
		
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
	backBtn.y = display.contentHeight - 50
	
	group:insert( title )
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