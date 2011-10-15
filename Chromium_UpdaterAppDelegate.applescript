--  Chromium_UpdaterAppDelegate.applescript
--  Chromium Updater
--
--  Created by Dom Barne http://dombarnes.com 
--  Application Icon by Koen Punt http://www.koenpunt.nl
--  Copyright 2011. All rights reserved.

script Chromium_UpdaterAppDelegate
	property parent : class "NSObject"
	property build_label : missing value
	property latest : missing value
	
	on awakeFromNib()
		
	end awakeFromNib
	
	on applicationWillFinishLaunching_(aNotification)
		
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
	
	
	on FetchBuild()
		--obtain latest build number
		set latest to do shell script "curl http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/LAST_CHANGE"
		build_label's setStringValue_(latest as string)
	end FetchBuild
	
	
end script