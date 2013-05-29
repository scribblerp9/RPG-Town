-----------------------------------------------------------------------------------------
--
-- build.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- 'onRelease' event listeners for buttons
local function onBackBtnRelease()
	storyboard.gotoScene( "plannerView", "fade", 500 )
	return true	-- indicates successful touch
end

--------------------------------------------

-- Listen for tableView events
local function tableViewListener( event )
    local phase = event.phase
    print( event.phase )
end

-- Handle row rendering
local function onRowRender( event )
    local phase = event.phase
    local row = event.row
	local rowTitle = display.newText( row, " ", 0, 0, nil, 14 )
	for def in storyboard.db:nrows("SELECT * FROM building_defs WHERE id="..row.id) do
		rowTitle.text = def.name
	end
	rowTitle:setReferencePoint(display.CenterLeftReferencePoint)
    rowTitle.x = 10--row.x - (row.contentWidth * 0.5)+ ( rowTitle.contentWidth * 0.5 )
    rowTitle.y = row.contentHeight * 0.5
    rowTitle:setTextColor( 0, 0, 0 )
end

--[[
-- Handle row's becoming visible on screen
local function onRowUpdate( event )
    local row = event.row
    print( "Row:", row.index, " is now visible" )
end
--]]

-- Handle touches on the row
local function onRowTouch( event )
    local phase = event.phase
print(phase)
	local row = event.target
    if phase == "release" then
        -- Update database to place building in the touched cell
		storyboard.db:exec("UPDATE cellsfor"..storyboard.townData["id"].." SET building="..row.id.." WHERE id="..cellTapped.id)
		-- return to the planner view
		storyboard.gotoScene( "plannerView", "fade", 500 )
    end
end

--------------------------------------------

function scene:createScene( event )
	local group = self.view
	
	-- prepare data for cell that we are building
	cellTapped = event.params.cell
	local query = "SELECT * FROM cellsfor"..storyboard.townData["id"].." WHERE id="..cellTapped.id
	local titleText
	for cell in storyboard.db:nrows(query) do
		titleText = "Build on ("..cell.row..", "..cell.column..")"
	end
	
	-- create/position logo/title image on upper-half of the screen
	local title = display.newText(titleText, 264, 20, native.systemFont, 40)
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth * 0.5
	title.y = 25
	
	-- create Back button
	local backBtn = widget.newButton{
		label="Cancel",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=85, height=40,
		onRelease = onBackBtnRelease	-- event listener function
	}
	backBtn:setReferencePoint( display.CenterReferencePoint )
	backBtn.x = display.contentWidth*0.5
	backBtn.y = display.contentHeight - backBtn.height
	
	-- display buildings table
	local buildingTbl = widget.newTableView {
		top = title.y + title.height/2,
	    width = display.contentWidth, 
	    height = 360,
		maskFile = "Images/tableMask.png",
	    listener = buildingTblListener,
	    onRowRender = onRowRender,
	    onRowTouch = onRowTouch
	}

	-- Create enough rows for all building defs
	for def in storyboard.db:nrows("SELECT * FROM building_defs") do
		local id = def.id
		local isCategory = false
	    local rowHeight = 40
	    local rowColor = 
	    { 
	        default = { 255, 255, 255 },
	    }
	    local lineColor = { 220, 220, 220 }
	    -- Make some rows categories
--[[
	    if i == 5 or i == 10 or i == 15 then
	        isCategory = true
	        rowHeight = 24
	        rowColor = 
	        { 
	            default = { 150, 160, 180, 200 },
	        }
	    end
--]]
	    -- Insert the row into the tableView
	    buildingTbl:insertRow
	    {
	        id = id,
			isCategory = isCategory,
	        rowHeight = rowHeight,
	        rowColor = rowColor,
	        lineColor = lineColor,
	    }
	end
	
	group:insert( title )
	group:insert( backBtn )
	group:insert( buildingTbl )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
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