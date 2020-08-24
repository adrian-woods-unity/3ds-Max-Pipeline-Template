
try
(
	struct CustomExportLibrary
	(
		-- will iterate through the supplied array and add an editable poly modifer, collapse the stack and reset xForm
		mapped fn ExportStaticObjects obj =
		(
			format "Processing %\n" obj.name
					
			-- geometry specific processing goes here, other classes can be processed in other specific ways
			if superClassOf obj == GeometryClass do
			(
				-- add an edit poly modifier so we convert to usable quads
				-- NOTE: we collapse in between each to make sure there are no stack artifacts (sometimes reset XForm can be funky on an uncollapsed stack)
				addModifier obj (Edit_Poly())
				maxOps.CollapseNode obj off
					
				-- reset XForm
				Reset_Xform obj
				maxOps.CollapseNode obj off
			)
		),
		
		mapped fn ExportDynamicObjects obj =
		(
			format "Processing %\n" obj.name
					
			-- geometry specific processing goes here, other classes can be processed in other specific ways
			if superClassOf obj == GeometryClass do
			(
				-- add custom mesh / skinning export logic logic here
			)
			
			-- adjust what to export accordingly
			if classOf obj == Bone or classOf obj == dummy do
			(
				-- add custom bone export logic here
			)
		),
		
		mapped fn ExportCameraObjects obj =
		(
			format "Processing %\n" obj.name
					
			-- geometry specific processing goes here, other classes can be processed in other specific ways
			if superClassOf obj == Camera do
			(
				-- add custom camera export logic here
			)
		),
		
		fn Export exportStatic:true exportCameras:false =
		(
			-- if we haven't saved this file yet, then prompt for export location
			fileName = maxFileName
			if fileName == "" do
			(
				fileName = getSaveFileName caption:"Please choose a location to save to..."
			)
			
			-- if we have a valid export path, then export, otherwise do nothing
			if fileName != undefined do
			(
				-- first hold the file in its current state so that it can be fetched if something goes awry
				holdMaxFile()
				
				-- export preset will be built up and match an existing preset name
				exportPreset = "Meters.fbxexportpreset"
				
				-- mapped functions will loop through everything in the scene that meets the criteria for their export
				-- static and dynamic / animated geometry should be mutually exclusive
				if exportStatic then
				(
					ExportStaticObjects $*
					exportPreset = "NoAnim" + exportPreset
				)
				else
				(
					ExportDynamicObjects $*
				)
				
				if exportCameras then
				(
					ExportCameraObjects $*
				)
				else
				(
					exportPreset = "NoCamera" + exportPreset
				)
				
				-- export the file to .fbx
				pluginManager.loadClass FbxExporter
				
				-- setup the settings as desired
				thisScript = getThisScriptFilename()
				exportPreset = pathConfig.appendPath (pathConfig.appendPath (getFilenamePath thisScript) "fbx_presets") exportPreset
				print exportPreset
				FBXExporterSetParam "LoadExportPresetFile" exportPreset
				
				fbxPath = pathConfig.appendPath (getFilenamePath fileName) (getFilenameFile fileName + ".fbx")
				
				format "Exporting % with preset %\n" fbxPath exportPreset
				exportFile fbxPath #noprompt

				-- fetch the max file to preserve all of the working max info
				fetchMaxFile quiet:true	
			)
		)
	)
	
	-- MaxScript doesn't really have the concept of namespaces, so globals need to be unique names (usually StudioName_Variable will suffice)
	-- ideally you should use structs to contain data and functions so that you only have a few globals (which reduces the risk of name conflicts with other tools)
	global Unity_CustomExportLibrary = CustomExportLibrary()
)
catch
(
	format "% :\n%\n" "Export Library failed" (getCurrentException())
)