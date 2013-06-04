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

-- make text fields available to all functions
local townName
local townSize

--------------------------------------------

-- 'onRelease' event listeners for buttons
local function onBackBtnRelease()
	storyboard.gotoScene( "mainMenu", "fade", 500 )
	return true	-- indicates successful touch
end
local function onCreateBtnRelease()
	
	-- check town name and size has been entered. if not, show message and  stop 
	if townName.text == "Enter Town Name" or townSize.text == "Enter Town Size" then
		print("town name or size not entered")
		alert = native.showAlert("Enter Name or Size", "Please enter a Town Name and Size before continuing")
		return true
	end
	
	-- verify town data is ok for db, and size is a number (needed?)
	
	-- insert town data into database
	insertTownQuery = "INSERT INTO towns VALUES (NULL, '"..townName.text.."', "..townSize.text..")"
	storyboard.db:exec(insertTownQuery)
	
	-- create cell table and fill with empty cells
	newTownID = storyboard.db:last_insert_rowid()
	newTownCellsTable = "cellsfor"..newTownID
	-- the next line contains the basic structure for all cell tables
	cellsQuery = "CREATE TABLE IF NOT EXISTS "..newTownCellsTable.." (id INTEGER PRIMARY KEY, row NUMERIC, column NUMERIC, building NUMERIC)"
	storyboard.db:exec(cellsQuery)
	for row=1, townSize.text do
		for col=1, townSize.text do
			insertCellQuery = "INSERT INTO "..newTownCellsTable.." VALUES (NULL, "..row..", "..col..", 1)"
			storyboard.db:exec(insertCellQuery)
		end
	end
	
	-- load this town data
	-- copied from loadTown - this should be put in its own module or something
	for row in storyboard.db:nrows("SELECT * FROM towns WHERE id="..newTownID) do
		storyboard.townData["id"] = row.id
		storyboard.townData["name"] = row.name
		storyboard.townData["size"] = row.size
	end
	
	--open town menu
	storyboard.gotoScene( "townMenu", "fade", 500 )
	return true
end

--------------------------------------------

-- event listeners for text fields
local function textFieldListener(event)
	textField = event.target
	
	--remove placeholder text if default still displayed for that field
	if event.phase == "began" then
		if textField.id == 1 and textField.text == "Enter Town Name" then
			textField.text = ""
		elseif textField.id == 2 and textField.text == "Enter Town Size" then
			textField.text = ""
		end
	end
	
	--insert placeholder text if field is empty
	if event.phase == "ended" and textField.text == "" then
		if textField.id == 1 then
			textField.text = "Enter Town Name"
		elseif textField.id == 2 then
			textField.text = "Enter Town Size"
		end
	end
end

--------------------------------------------

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
	townName = native.newTextField(0,0,150,24)
	townName:setReferencePoint(display.CenterReferencePoint)
	townName.x = display.contentWidth * 0.5
	townName.y = (display.contentHeight * 0.5) - 60
	townName.text = "Enter Town Name"
	townName.align = "center"
	townName.id = 1
	townSize = native.newTextField(0,0,110,24)
	townSize:setReferencePoint(display.CenterReferencePoint)
	townSize.x = display.contentWidth * 0.5
	townSize.y = display.contentHeight * 0.5
	townSize.text = "Enter Town Size"
	townSize.align = "center"
	townSize.inputType = "number"
	townSize.id = 2
	
	-- add listener to text fields
	townName:addEventListener("userInput", textFieldListener)
	townSize:addEventListener("userInput", textFieldListener)
		
	-- create Create Town button
	local createBtn = widget.newButton{
		label="Create Town",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=240, height=40,
		onRelease = onCreateBtnRelease	-- event listener function
	}
	createBtn:setReferencePoint( display.CenterReferencePoint )
	createBtn.x = display.contentWidth*0.5
	createBtn.y = display.contentHeight - 150	
	
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
	group:insert( createBtn )
	group:insert(townName)
	group:insert(townSize)
	
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
	if createBtn then
		createBtn:removeSelf()	-- widgets must be manually removed
		createBtn = nil
	end
	if townName then
		townName:removeSelf()	-- widgets must be manually removed
		townName = nil
	end
	if townSize then
		townSize:removeSelf()	-- widgets must be manually removed
		townSize = nil
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