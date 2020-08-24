
try
(
	--Create a DotNet Form
	hForm = dotNetObject "System.Windows.Forms.Form"
	
	-- Define functions that handle events in the WPF control
	fn OnTextTool1 data =
	(
		print (data.ToString())
	)
	
	fn OnTextTool2 data =
	(
		print (data.ToString())
	)
	
	fn OnOkay data =
	(
		-- get the image source and the opacity from the tool and display it
		image = data.ImageSource
		opacity = data.ImageOpacity
		imageBitmap = openBitMap image.UriSource.AbsolutePath
		
		-- create a plane, create a material with opacity, and apply to the Plane
		newPlane = Plane length:image.Height width:image.Width pos:[0,0,0] isSelected:on
		newMaterial = Standardmaterial()
		newMaterial.opacity = opacity * 100.0
		newMaterial.diffuseMap = bitmapTexture bitmap:imageBitmap
		showTextureMap newMaterial on
		newPlane.material = newMaterial
		
		-- close the window, because we pressed "okay"
		hForm.Close()
	)
	
	fn OnCancel =
	(
		-- just close the window
		hForm.Close()
	)
	
	fn startFocus arg =
	(
		enableAccelerators = false
	)
	
	fn stopFocus arg = 
	(
		enableAccelerators = true
	)
	
	-- Load the assembly from the WPF exe (a .dll will work as well)
	thisScript = getThisScriptFilename() 
	scriptDir = pathConfig.removePathLeaf(getFilenamePath thisScript)
	samplePath = pathConfig.appendPath scriptDir @"Wpf_Max_Sample\Wpf_Max_Sample\bin\Debug\Wpf_Max_Sample.exe"
	
	assembly = dotNetClass "System.Reflection.Assembly"
	assembly.loadfrom samplePath
	
	-- load the main WPF control and subscribe to its events
	mainControl = dotNetObject "Wpf_Max_Sample.MainControl"
	dataContext = mainControl.DataContext
	
	dotNet.addEventHandler mainControl "TextTool1Event" OnTextTool1
	dotNet.addEventHandler mainControl "TextTool2Event" OnTextTool2
	dotNet.addEventHandler mainControl "OkayEvent" OnOkay
	dotNet.addEventHandler mainControl "CancelEvent" OnCancel
	
	-- turn off accelerators and set lifetime so that we can type into the WPF textbox
	dotNet.addEventHandler mainControl "GotFocus" startFocus
	dotNet.addEventHandler mainControl "LostFocus" stopFocus
	dotNet.setLifetimeControl mainControl #dotNet
	
	-- Define the forms WPF ElementHost, which will host the WPF element
	elementHost = dotnetObject "System.Windows.Forms.Integration.ElementHost"
	elementHost.Dock = (dotnetClass "System.Windows.Forms.DockStyle").Fill
	elementHost.Child = mainControl --add the wpf control to the Form
	
	-- set properties on the form
	hForm.topmost = true
	hForm.Width = 1400
	hForm.Height = 900
	
	-- add the ElementHost to the form
	hForm.Controls.Add elementHost
	
	--show the Form
	hForm.show()
)
catch
(
	format "%\n" (getCurrentException())
)