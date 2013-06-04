-----------------------------------------------------------------------------------------
--
-- plannerView.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--[[
-- debug (a way of skipping the load screen, comment out if you want to test different towns!)
for row in storyboard.db:nrows("SELECT * FROM towns WHERE id=2") do
	storyboard.townData["id"] = row.id
	storyboard.townData["name"] = row.name
	storyboard.townData["size"] = row.size
end
--]]

--------------------------------------------

-- 'onRelease' event listeners for buttons
local function onBackBtnRelease()
	if buildBorder then
		buildBorder:removeSelf()
		buildBorder = nil
	end
	if buildMessage then
		buildMessage:removeSelf()
		buildMessage = nil
	end
	storyboard.gotoScene( "townMenu", "fade", 500 )
	return true	-- indicates successful touch
end
local function onBuildBtnRelease()
	-- display "build where" message and enable touch on town cells
	if buildBtn.id == 1 then --i.e. button currently reads "Build"
		--show build message
		buildBorder = display.newRoundedRect(gridX, gridY, gridWidth+cellWidth, gridWidth+cellWidth, 12)
		buildBorder.strokeWidth = 3
		buildBorder:setStrokeColor(255,255,255)
		buildBorder:setFillColor(255,255,255,0)
		buildMessage = display.newText("Build Where?", 0, 0, native.systemFont, 20)
		buildMessage:setReferencePoint( display.BottomCenterReferencePoint )
		buildMessage.x = buildBorder.x+3
		buildMessage.y = buildBorder.y - (buildBorder.contentHeight*0.5) - 2
		--switch button to read "Cancel" and change id to 2
		buildBtn:setLabel("Cancel")
		--buildBtn.width = buildBtn.width + 15
		buildBtn.id = 2
	elseif buildBtn.id == 2 then --i.e. button currently reads "Build"
		--switch button to read "Build" and change id to 1
		buildBtn:setLabel("Build")
		--buildBtn.width = buildBtn.width - 15
		buildBtn.id = 1
		-- disable touch for grid
		-- remove buildborder and message
		buildBorder:removeSelf()
		buildBorder = nil
		buildMessage:removeSelf()
		buildMessage = nil
		lastCellTouched = 0
		cellTouchMask.isVisible = false
	else
		print("Build button has an id that is not 1 or 2! Argh!")
	end
	return true	-- indicates successful touch
end
local function townCellTouched(event)
	 --if we are not in build mode, do nothing
	if event.phase == "ended" then
		if buildBtn.id == 1 then
			return true
		end
		local cell = event.target
		-- if the cell has already been touched, then go to build menu
		if lastCellTouched == cell.id then 		-- same cell touched twice
			-- go to build menu, send which cell was touched
			-- Remove build message
			buildBorder:removeSelf()
			buildBorder = nil
			buildMessage:removeSelf()
			buildMessage = nil
			cellTouchMask:removeSelf()
			cellTouchMask = nil
			storyboard.gotoScene("build", {
				effect = "fade",
				time = 200,
				params = {
					cell = cell
				}
			})	
		else 									-- cell has only been touched once
			lastCellTouched = cell.id
			cellTouchMask:setReferencePoint(display.CenterReferencePoint)
			cellTouchMask.x = cell.x
			cellTouchMask.y = cell.y
			cellTouchMask:setFillColor(100,10,200,150)
			cellTouchMask.isVisible = true
		end

		return true
	end
end
--------------------------------------------

function scene:createScene( event )
	local group = self.view
	
	-- create/position title
	local title = display.newText("Planner View", 264, 42, native.systemFont, 40)
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth * 0.5
	title.y = 50
	
	-- prepare to display town cells
	numRowsAndCols = storyboard.townData["size"]
	cellWidth = 30
	gridWidth = numRowsAndCols * cellWidth
	gridX = (display.contentWidth * 0.5) - (gridWidth / 2) - (cellWidth / 2) --subtract cellWidth/2 otherwise first cell drawn thinks there is one next to it when there isnt
	gridY = (display.contentHeight * 0.5) - 30 - (gridWidth / 2) - (cellWidth / 2)
	
	-- display town cells
	for row=1, numRowsAndCols do
		for col=1, numRowsAndCols do
			-- create grid cells
			local cell = display.newRect(0, 0, cellWidth, cellWidth)
			cell:setReferencePoint( display.CenterReferencePoint )
			cell.x = gridX + col*cellWidth
			cell.y = gridY + row*cellWidth
			-- find building type and change fill color based on color
			local query = "SELECT * FROM cellsfor"..storyboard.townData["id"].." WHERE row="..row.." AND column="..col
			for cellData in storyboard.db:nrows(query) do
				cell.id = cellData.id
				for building in storyboard.db:nrows("SELECT * FROM building_defs WHERE id="..cellData.building) do
					cell:setFillColor(building.colorR,building.colorG,building.colorB)
				end
			end
--[[
			-- alternate fill colors
			if (math.fmod(col,2) == 0) and (math.fmod(row,2) == 0) then
				cell:setFillColor(130)
			elseif (math.fmod(col,2) > 0) and (math.fmod(row,2) > 0) then
				cell:setFillColor(130)
			end
--]]
			-- add event listener and add to display group
			cell:addEventListener("touch",townCellTouched)
			group:insert( cell )
		end
	end
	
	-- create Build button
	buildBtn = widget.newButton{
		label="Build",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=80, height=40,
		onRelease = onBuildBtnRelease	-- event listener function
	}
	buildBtn:setReferencePoint( display.CenterReferencePoint )
	buildBtn.x = display.contentWidth*0.5
	buildBtn.y = display.contentHeight - 130
	buildBtn.id = 1
	
	-- setup touch mask and last cell touched tracker for building
	cellTouchMask = display.newRect(0, 0, cellWidth, cellWidth)
	cellTouchMask.isVisible = false
	lastCellTouched = 0
	
	-- create Back button
	local backBtn = widget.newButton{
		label="Return to Town Menu",
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
	group:insert( backBtn )
	group:insert( buildBtn )
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
	if buildBorder then
		buildBorder:removeSelf()
		buildBorder = nil
	end
	if buildMessage then
		buildMessage:removeSelf()
		buildMessage = nil
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