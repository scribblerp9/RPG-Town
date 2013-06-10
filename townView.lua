-----------------------------------------------------------------------------------------
--
-- plannerView.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- useful variables
local screenW = display.contentWidth;
local screenH = display.contentHeight;

--------------------------------------------

-- 'onRelease' event listeners for buttons
local function onBackBtnRelease()
	storyboard.gotoScene( "townMenu", "fade", 500 )
	return true	-- indicates successful touch
end

function scene:createScene( event )
	local group = self.view
	
	-- create/position title
	local title = display.newText("Town View", 264, 42, native.systemFont, 40)
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth * 0.5
	title.y = 50
	
	halfScreenW = screenW * 0.5
	halfScreenH = screenH * 0.5
--[[
	-- display a dot in the centre of the screen for debugging purposes
	centre = display.newRect(0,0,5,5)
	centre.x = halfScreenW
	centre.y = halfScreenH
--]]

	numRowsAndCols = storyboard.townData["size"]
	cellWidth = 40
	cellHeight = cellWidth/2
	gridOriginX = halfScreenW --All cell X-coordinates based on this
	gridOriginY = halfScreenH - ((numRowsAndCols / 2)*cellHeight) --All cell Y-coordinates based on this
	
	for row=0, numRowsAndCols-1 do
		for col=0, numRowsAndCols-1 do
			-- create grid cells
			adjX = (cellWidth/2)*(col-row)
			adjY = (cellHeight/2)*(col+row)
--[[
			local cell = display.newLine(gridOriginX+adjX, gridOriginY+adjY, -- top coord
										gridOriginX+(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY) -- right coord
			cell:append(gridOriginX+adjX, gridOriginY+cellHeight+adjY) -- bottom coord
			cell:append(gridOriginX-(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY) -- left coord
			cell:append(gridOriginX+adjX, gridOriginY+adjY) -- back to top coord
--]]
			
			--debug put colored dots in middle of each cell corresponding to the building on that cell
--[[
			local dot = display.newRect(0, 0, 3, 3)
			dot:setReferencePoint( display.CenterReferencePoint )
			dot.x = gridOriginX+adjX
			dot.y = gridOriginY+adjY + (cellHeight * 0.5)
--]]
			--get centre point of cell
			local centreX = gridOriginX+adjX
			local centreY = gridOriginY+adjY + (cellHeight * 0.5)
			--get cell data
			query="SELECT * FROM cellsfor"..storyboard.townData["id"].." WHERE row="..(row+1).." AND column="..(col+1)
			for cellData in storyboard.db:nrows(query) do
				for buildingData in storyboard.db:nrows("SELECT * FROM building_defs WHERE id="..cellData.building) do -- get building colors
					--dot:setFillColor(buildingData.colorR,buildingData.colorG,buildingData.colorB)
					--cell:setColor(buildingData.colorR,buildingData.colorG,buildingData.colorB)
					local image = display.newImage("Images/"..buildingData.image)
					image:setReferencePoint( display.BottomCenterReferencePoint )
					image.x = centreX
					image.y = centreY + cellHeight/2
					group:insert(image)
					print("cell ("..(row+1)..","..(col+1)..") is "..buildingData.image)
				end
				--group:insert(1,cell)
			end
			
			--[[--figuring out how to draw the cells
			
			adjX = (cellWidth/2)*0 --row 1, col 1
			adjY = (cellHeight/2)*0
			local cell = display.newLine(gridOriginX, gridOriginY, 
										gridOriginX+(cellWidth/2), gridOriginY+(cellHeight/2))
			cell:append(gridOriginX, gridOriginY+cellHeight)
			cell:append(gridOriginX-(cellWidth/2), gridOriginY+(cellHeight/2))
			cell:append(gridOriginX, gridOriginY)

			adjX = (cellWidth/2)*1 --row 1, col 2
			adjY = (cellHeight/2)*1
			local cell2 = display.newLine(gridOriginX+adjX, gridOriginY+adjY, 
										gridOriginX+(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell2:append(gridOriginX+adjX, gridOriginY+cellHeight+adjY)
			cell2:append(gridOriginX-(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell2:append(gridOriginX+adjX, gridOriginY+adjY)

			adjX = (cellWidth/2)*2 --row 1, col 3
			adjY = (cellHeight/2)*2
			local cell3 = display.newLine(gridOriginX+adjX, gridOriginY+adjY, 
										gridOriginX+(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell3:append(gridOriginX+adjX, gridOriginY+cellHeight+adjY)
			cell3:append(gridOriginX-(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell3:append(gridOriginX+adjX, gridOriginY+adjY)


			adjX = (cellWidth/2)*-1 --row 2, col 1
			adjY = (cellHeight/2)*1
			local cell4 = display.newLine(gridOriginX+adjX, gridOriginY+adjY, 
										gridOriginX+(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell4:append(gridOriginX+adjX, gridOriginY+cellHeight+adjY)
			cell4:append(gridOriginX-(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell4:append(gridOriginX+adjX, gridOriginY+adjY)

			adjX = (cellWidth/2)*0 --row 2, col 2
			adjY = (cellHeight/2)*2
			local cell5 = display.newLine(gridOriginX+adjX, gridOriginY+adjY, 
										gridOriginX+(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell5:append(gridOriginX+adjX, gridOriginY+cellHeight+adjY)
			cell5:append(gridOriginX-(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell5:append(gridOriginX+adjX, gridOriginY+adjY)

			adjX = (cellWidth/2)*1 --row 2, col 3
			adjY = (cellHeight/2)*3
			local cell6 = display.newLine(gridOriginX+adjX, gridOriginY+adjY, 
										gridOriginX+(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell6:append(gridOriginX+adjX, gridOriginY+cellHeight+adjY)
			cell6:append(gridOriginX-(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell6:append(gridOriginX+adjX, gridOriginY+adjY)
			
			adjX = (cellWidth/2)*-2 --row 3, col 1
			adjY = (cellHeight/2)*2
			local cell7 = display.newLine(gridOriginX+adjX, gridOriginY+adjY, 
										gridOriginX+(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell7:append(gridOriginX+adjX, gridOriginY+cellHeight+adjY)
			cell7:append(gridOriginX-(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell7:append(gridOriginX+adjX, gridOriginY+adjY)

			adjX = (cellWidth/2)*-1 --row 3, col 2
			adjY = (cellHeight/2)*3
			local cell8 = display.newLine(gridOriginX+adjX, gridOriginY+adjY, 
										gridOriginX+(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell8:append(gridOriginX+adjX, gridOriginY+cellHeight+adjY)
			cell8:append(gridOriginX-(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell8:append(gridOriginX+adjX, gridOriginY+adjY)

			adjX = (cellWidth/2)*0 --row 3, col 3
			adjY = (cellHeight/2)*4
			local cell9 = display.newLine(gridOriginX+adjX, gridOriginY+adjY, 
										gridOriginX+(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell9:append(gridOriginX+adjX, gridOriginY+cellHeight+adjY)
			cell9:append(gridOriginX-(cellWidth/2)+adjX, gridOriginY+(cellHeight/2)+adjY)
			cell9:append(gridOriginX+adjX, gridOriginY+adjY)
			--]]
			
			--make the cells pretty
			--cell.width = 2;
			end
	end
	

	

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