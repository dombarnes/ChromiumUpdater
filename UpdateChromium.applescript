-- UpdateChromium.applescript
-- Chromium Updater

-- Created by Dom Barnes on 24/12/2009.
-- Copyright 2009. All rights reserved.
-- Version 1.1
-- Last Updated 05/11/2010


script UpdateChromium
	property parent : class "NSObject"
	
	--Outlets
	property status_label : missing value
	property build_label : missing value
	property progress_bar : missing value
	property latest : missing value
	property curl_URL : missing value
	property start_Button : missing value
	property header_label : missing value
	property curVer : missing value
	property appPlist : missing value
	property appPath : missing value
	
	
	
	--Actions
	on updateChromium_(sender)
		header_label's setStringValue_("Checking for newer version")
		set curVer to 0
		delay 1
		set appPath to POSIX path of (path to applications folder) & "Chromium.app"
		log appPath
		set appPlist to appPath & "/Contents/Info.plist"
		log appPlist
		try
			tell application "System Events"
				set curVer to value of property list item "SVNRevision" of property list file appPlist
				log curVer
			end tell
		end try
		log "curver " & curVer
		set latest to do shell script "curl http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/LAST_CHANGE"
		build_label's setStringValue_(latest as number)
		log latest
        set curVer to curVer as number
        set latest to latest as number
		if curVer is greater than or equal to latest then
			status_label's setStringValue_("You have the latest build version " & latest)
			header_label's setStringValue_("")
			build_label's setStringValue_("")
			start_Button's setEnabled_(false)
			return
		end if
		start_Button's setEnabled_(false)
		progress_bar's setUsesThreadedAnimation_(true)
		progress_bar's setMinValue_(0)
		delay 1
		progress_bar's incrementBy_(5)
		progress_bar's incrementBy_(15)
		--download latest build using build number in latest
		header_label's setStringValue_("Updating. Please wait")
		status_label's setStringValue_("Downloading nightly build" as string)
		delay 1
		try
			do shell script "mkdir ~/.tmp"
		end try
		set curl_URL to "curl -L http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/" & latest & "/chrome-mac.zip -o  ~/.tmp/chrome-mac.zip"
		do shell script curl_URL
		progress_bar's incrementBy_(20)
		--unpack and copy
		status_label's setStringValue_("Extracting" as string)
		delay 1
		do shell script "unzip -o ~/.tmp/chrome-mac.zip -d ~/.tmp/"
		progress_bar's incrementBy_(20)
		--move existing Chromium and copy new
		try
			do shell script "cp -pR /Applications/Chromium.app /Applications/Chromium.old.app"
			do shell script "rm -R /Applications/Chromium.app"
		end try
		status_label's setStringValue_("Copying to /Applications" as string)
		delay 1
		do shell script "mkdir -p /Applications/Chromium.app"
		do shell script "mkdir -p /Applications/Chromium.app/Contents"
		do shell script "cp -pR ~/.tmp/chrome-mac/Chromium.app/Contents /Applications/Chromium.app"
		progress_bar's incrementBy_(20)
		--Cleanup folders and files
		status_label's setStringValue_("Cleaning up" as string)
		delay 1
		do shell script "rm -R ~/.tmp/chrome*"
		progress_bar's incrementBy_(20)
		delay 1
		try
			do shell script "rm -R /Applications/Chromium.old.app"
		end try
		status_label's setStringValue_("Completed! Installed build " & latest as string)
		build_label's setStringValue_(" ")
		--do shell script "echo " & latest & " > .tmp/current_chromium"
	end updateChromium_
	
	on QuitUpdater_(sender)
		quit
	end QuitUpdater_
	
	
end script