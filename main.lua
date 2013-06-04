-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true --purges every scene after a new scene is loaded, so the scene is reloaded if visited again

-- setup database
require "sqlite3"
--local path = system.pathForFile( "data.db", system.ResourceDirectory ) --will need to copy the db file to documents directory first then open it from there or wont be able to write to the file
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
-- Attach db to storyboard object so it is accessible everywhere
storyboard.db = db

-- create empty tables for loading selected town data and cell info
storyboard.townData = {}
storyboard.townCells = {}

-- load menu screen
storyboard.gotoScene( "mainMenu" )
--storyboard.gotoScene( "newTown" )