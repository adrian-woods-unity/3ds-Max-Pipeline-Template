-- Load up the stuff we need and output the issues if we fail
try
(
	global Unity_CustomToolFloater
	
	-- close the window if it is already open so we don't spawn repeated windows
	if Unity_CustomToolFloater != undefined do
	(
		if Unity_CustomToolFloater.dialogBar do
		(
			cui.unRegisterDialogBar Unity_CustomToolFloater
		)
		closeRolloutFloater Unity_CustomToolFloater
	)
	
	Unity_CustomToolFloater = newRolloutFloater "Tool Window" 220 120
	
	-- import library scripts that any script can use, these should be in the form of a struct, followed by a global definition of that struct for use in any tool
	filein "ExportLibrary.ms"
	
	-- setup local variables used only in this script
	fileIO = dotNetClass "System.IO.Directory"
	
	-- load all the files in the tools folder and populate the tool window with each
	thisScript = getThisScriptFilename() 
	thisScriptDir = pathConfig.appendPath (pathConfig.removePathLeaf(getFilenamePath thisScript)) "Tools"
	toolFiles = fileIO.getFiles thisScriptDir "*.ms"
	
	-- build the UI for the tool floater using a rollout creator so that it can dynamically generate UI
	rci = rolloutCreator "toolRollout" "Custom Tools"
	rci.begin()
	
	-- Add custom export tool
	rci.addControl #button #ExportStatic "Export Static Objects" paramStr:"width:200"
	rci.addHandler #ExportStatic #pressed filter:on codeStr:"Unity_CustomExportLibrary.Export()"
		
	-- add the buttons for each tool programatically
	for toolFile in toolFiles do
	(
		toolFileName = getFilenameFile toolFile
		rci.addControl #button (toolFileName as name) toolFileName paramStr:"width:200"
		rci.addHandler (toolFileName as name) #pressed filter:on codeStr:("filein @" + toolFile + "@")
	)
	rci.end()
	
	-- use a unique name that no other tool will use for globals
	addRollout rci.def Unity_CustomToolFloater
	
	-- dock the rollout on the far left of the 3ds Max UI
	cui.RegisterDialogBar Unity_CustomToolFloater minSize:1 maxSize:-1 style:#(#cui_dock_all, #cui_floatable, #cui_handles)
	cui.dockDialogBar Unity_CustomToolFloater #cui_dock_left
)
catch
(
	format "Startup failed :\n%\n" (getCurrentException())
)
