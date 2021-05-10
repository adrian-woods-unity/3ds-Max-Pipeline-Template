try
(
	if (_unitySplineToDummyRollout != undefined) then
	(
		DestroyDialog _unitySplineToDummyRollout
	)
	else
	(
		global _unitySplineToDummyRollout
	)
	
	rollout _unitySplineToDummyRollout "Spline To Dummy Objects"
	(
		fn splineFilter obj = classof obj == Line
		
		group "Spline Info"
		(
			pickbutton pb_spline "Choose Spline" autoDisplay:true filter:splineFilter align:#left width:370
			
			spinner spn_dummysize "Dummy Count:" range:[1, 1024, 32] type:#integer align:#left width:410
		)
		
		progressBar pb_progress
		button btn_clear "Clear" align:#right across:2 width:60 offset:[120,10]
		button btn_go "Go" align:#right width:60 offset:[0,10]
		
		on btn_go pressed do
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
				spline = pb_spline.object
				dummycount = spn_dummysize.value
				
				for i = 0 to dummycount do
				(
					percentage = (i as float) / dummycount
					
					splinePos = lengthInterp spline percentage
					splineDir = pathTangent spline percentage 
					
					c = cone name:("dummy_" + i as string) position:splinePos dir:splineDir radius1:0.1 height:0.1
					
					c.parent = spline
					
					pb_progress.value = percentage * 100.0
				)
			)
		)
		
		on btn_clear pressed do
		(
			spline = pb_spline.object
			
			for child in spline.children do
			(
				delete child
			)
		)
	)
	
	CreateDialog _unitySplineToDummyRollout 400 140
)
catch
(
	format "% :\n%\n" "Export Library failed" (getCurrentException())
)