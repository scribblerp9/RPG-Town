-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local newTownBtn
local loadTownBtn
local helpBtn
local settingsBtn

-- 'onRelease' event listeners for buttons
local function onNewTownBtnRelease()
	storyboard.gotoScene( "townMenu", "fade", 500 )
	return true	-- indicates successful touch
end
local function onLoadTownBtnRelease()
	storyboard.gotoScene( "loadTown", "fade", 500 )
	return true	-- indicates successful touch
end
local function onHelpBtnRelease()
	storyboard.gotoScene( "comingSoon", "fade", 500 )
	return true	-- indicates successful touch
end
local function onSettingsBtnRelease()
	storyboard.gotoScene( "comingSoon", "fade", 500 )
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	-- create/position logo/title image on upper-half of the screen
	local menuTitle = display.newText("RPG Town", 264, 42, native.systemFont, 40)
	menuTitle:setReferencePoint( display.CenterReferencePoint )
	menuTitle.x = display.contentWidth * 0.5
	menuTitle.y = 100
	
	-- create New Town button
	newTownBtn = widget.newButton{
		label="New Town",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=154, height=40,
		onRelease = onNewTownBtnRelease	-- event listener function
	}
	newTownBtn:setReferencePoint( display.CenterReferencePoint )
	newTownBtn.x = display.contentWidth*0.5
	newTownBtn.y = display.contentHeight - 280
	
	-- create Load Town button
	loadTownBtn = widget.newButton{
		label="Load Town",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=154, height=40,
		onRelease = onLoadTownBtnRelease	-- event listener function
	}
	loadTownBtn:setReferencePoint( display.CenterReferencePoint )
	loadTownBtn.x = display.contentWidth*0.5
	loadTownBtn.y = newTownBtn.y + loadTownBtn.height + 20
	
	-- create Help button
	helpBtn = widget.newButton{
		label="Help",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=154, height=40,
		onRelease = onHelpBtnRelease	-- event listener function
	}
	helpBtn:setReferencePoint( display.CenterReferencePoint )
	helpBtn.x = display.contentWidth*0.5
	helpBtn.y = loadTownBtn.y + helpBtn.height + 20
	
	-- create Settings button
	settingsBtn = widget.newButton{
		label="Settings",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=154, height=40,
		onRelease = onSettingsBtnRelease	-- event listener function
	}
	settingsBtn:setReferencePoint( display.CenterReferencePoint )
	settingsBtn.x = display.contentWidth*0.5
	settingsBtn.y = helpBtn.y + settingsBtn.height + 20
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( menuTitle )
	group:insert( newTownBtn )
	group:insert( loadTownBtn )
	group:insert( helpBtn )
	group:insert( settingsBtn )
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
	
	if newTownBtn then
		newTownBtn:removeSelf()	-- widgets must be manually removed
		newTownBtn = nil
	end
	if loadTownBtn then
		loadTownBtn:removeSelf()	-- widgets must be manually removed
		loadTownBtn = nil
	end
	if helpBtn then
		helpBtn:removeSelf()	-- widgets must be manually removed
		helpBtn = nil
	end
	if settingsBtn then
		settingsBtn:removeSelf()	-- widgets must be manually removed
		settingsBtn = nil
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