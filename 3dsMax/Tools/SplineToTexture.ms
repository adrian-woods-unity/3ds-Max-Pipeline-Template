try
(
	if (_unitySplineToTextureRollout != undefined) then
	(
		DestroyDialog _unitySplineToTextureRollout
	)
	else
	(
		global  _unitySplineToTextureRollout
	)
	
	rollout _unitySplineToTextureRollout "Spline To Texture"
	(
		fn splineFilter obj = classof obj == SplineShape
		
		group "Spline Info"
		(
			pickbutton pb_spline "Choose Spline" autoDisplay:true filter:splineFilter align:#left width:630
		)
		
		group "Texture Info"
		(
			label lbl_texturesizelabel "Texture Size:" align:#left across:2
			dropdownList ddl_texturesize items:#("32", "64", "128", "256", "512", "1024", "2048", "4096", "8192") align:#left
			
			edittext txt_filepath "Texture filepath:" align:#left width:590 across:2
			button btn_browse "..." align:#right offset:[0,-2]
		)
		
		progressBar pb_progress
		button btn_savetexture "Go" align:#right width:60 offset:[0,10]
		
		on splineToTextureRollout open do
		(
			filename = getFilenameFile maxFileName + ".tif"
			filepath = pathConfig.appendPath maxFilePath filename
			
			if (filepath == undefined) do
			(
				filepath = pathConfig.GetDir #scene
			)
			
			txt_filepath.text = filepath
		)
		
		on btn_browse pressed do
		(
			fileName = getSaveFileName caption:"Please choose a location to save to..." types:"Tif(*.tif)|*.tif|All|*.*|" filename:txt_filepath.text
			
			if (fileName != undefined) do
			(
				txt_filePath.text = fileName
			)
		)
		
		on btn_savetexture pressed do
		(
			success = true
			pb_progress.value = 0
			
			if pb_spline.object == undefined do
			(
				messageBox "Please choose a valid line object ro generate a texture from."
				success = false
			)
			
			if success do
			(
				success = makeDir (getFilenamePath txt_filePath.text)
				
				if success then
				(
					spline = pb_spline.object
					
					divisor = spline.max - spline.min
					
					textureSize = ddl_texturesize.selected as integer
					
					newTexture = bitmap textureSize 4 filename:txt_filePath.text color:black hdr:true
					
					y = -1
					pixelRow = #()
					
					for i = 0 to textureSize - 1 do
					(
						percentage = (i as float) / textureSize
						splinePos = lengthInterp spline percentage
						
						ratio = splinePos / (length divisor)
						pixelVector = 127.0 + (ratio * 127.0)
						
						-- we need to swizzle since Unity is Y up
						pixelColor = pixelVector as color
						pixelRow[i + 1] = color pixelColor.r pixelColor.b pixelColor.g
						
						pb_progress.value = percentage * 100.0
					)
					
					for j = 0 to 3 do
					(
						setPixels newTexture [0,j] pixelRow
					)
					
					save newTexture
				)
				else
				(
					messageBox "The filepath for the texture is not valid. Please choose a valid filepath."
				)
			)
		)
	)
	
	CreateDialog _unitySplineToTextureRollout 650 195
)
catch
(
	format "% :\n%\n" "Export Library failed" (getCurrentException())
)