#!/bin/bash

set -e

setup_macos_defaults() {

    log "Setting up macOS defaults"

    # Ask for sudo upfront
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until script has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    #================================================
    # *                TEST ENVIROMENT
    #================================================

    # Mac Hardware Model
    osx_hardware_model=$(sysctl -n hw.model)

    # Which version and build of macOS are we executing under?

    read osx_product_version osx_vers_major osx_vers_minor osx_vers_patch <<< $(sw_vers -productVersion | awk -F. '{print $0 " " $1 " " $2 " " $3}')
    osx_build_version="$(sw_vers -buildVersion)"

    printf "Running $osx_distro inside of $osx_hardware_model.\n"

    # What is the human-readable codename for this macOS?

    case "$osx_product_version" in
    "10.4"*) osx_codename="Mac OS X Tiger" ;;
    "10.5"*) osx_codename="Mac OS X Leopard" ;;
    "10.6"*) osx_codename="Mac OS X Snow Leopard" ;;
    "10.7"*) osx_codename="Mac OS X Lion" ;;
    "10.8"*) osx_codename="OS X Mountain Lion" ;;
    "10.9"*) osx_codename="OS X Mavericks" ;;
    "10.10"*) osx_codename="OS X Yosemite" ;;
    "10.11"*) osx_codename="OS X El Capitan" ;;
    "10.12"*) osx_codename="macOS Sierra" ;;
    "10.13"*) osx_codename="macOS High Sierra" ;;
    "10.14"*) osx_codename="macOS Mojave" ;;
    "10.15"*) osx_codename="macOS Catalina" ;;
    "11."*) osx_codename="macOS Big Sur" ;;
    "12."*) osx_codename="macOS Monterey" ;;
    "13."*) osx_codename="macOS Ventura" ;;
    "14."*) osx_codename="macOS Sonoma" ;;
    "15."*) osx_codename="macOS Sequoia" ;;
    *) osx_codename="macOS" ;;
    esac

    osx_distro="$osx_codename $osx_product_version ($osx_build_version)"

    printf "Running $osx_distro inside of $osx_hardware_model.\n"

    #================================================
    # *      TEST TERMINAL FOR FULL DISK ACCESS
    #================================================


    # Test if Terminal has Full Disk Access, and if it doesn't, prompt user to set
    # it and start over.
    # ? A number of preferences now require Terminal.app to have Full
    # ? Disk Access, in particular Safari.app.
    # ? https://lapcatsoftware.com/articles/containers.html
    # TODO: Wrap with $osx_product_version tests

    printf "Testing for Full Disk Access:\n\n"
    errstr=$( /bin/ls /Users/admin/Library/Containers/com.apple.Safari 3>&1 1>&2 2>&3 3>&- )
    # ? Full disk access has only been in since Mojave, but which files were protected first?
    # TODO: Research if there is an older file to test.

    if [[ $errstr == *"Operation not permitted" ]]; then
    printf "Terminal.app needs Full Disk Access permission\n"

        # Prompt user to give Terminal Full Disk Access
        # ! This worked earlier in VMware Montery, but failed on M1 MacBook Pro (14-inch 2021)
        # TODO: Investigate

        osascript   -e "tell application \"System Preferences\" to activate " \
                    -e "tell application \"System Preferences\" to reveal anchor \"Privacy_AllFiles\" of pane id \"com.apple.preference.security\" " \
                    -e "display dialog \"Before continuing:\n\nUnlock and check the box next to Terminal to give it full disk access.\n\nThen quit Terminal and run this script again.\" buttons {\"OK\"} default button 1 with icon caution "
        exit # as we can't proceed until Terminal has been granted full Disk Access
    else
    printf "Terminal.app has permission to continue\n"
    fi

    #================================================
    # *           CLOSE SYSTEM PREFERENCES
    #================================================

    # Close any open System Preferences panes, to prevent them from overriding
    # settings we’re about to change
    osascript -e 'tell application "System Preferences" to quit'

    #================================================
    # *               TEXT EDITING
    #================================================

    # Disable smart quotes:
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    # Disable autocorrect:
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Disable auto-capitalization:
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

    # Disable smart dashes:
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Diable automatic period substitution:
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

    #================================================
    # *               ACTIVITY MONITOR
    #================================================

    # Show the main window when launching Activity Monitor
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

    # Visualize CPU usage in the Activity Monitor Dock icon
    defaults write com.apple.ActivityMonitor IconType -int 5

    # Show all processes in Activity Monitor
    defaults write com.apple.ActivityMonitor ShowCategory -int 0

    #================================================
    # *               DOCK
    #================================================

    # Turn off Spaces auto-switching
    defaults write com.apple.dock workspaces-auto-swoosh -bool false

    # Show only open applications in the Dock
    defaults write com.apple.dock static-only -bool true

    # Wipe all (default) app icons from the Dock. Keep Mail app.
    defaults write com.apple.dock persistent-apps -array

    # Don't show recent applications in Dock
    defaults write com.apple.dock show-recents -bool false

    # Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate
    defaults write com.apple.dock tilesize -int 36

    # Set Dock to auto-hide and remove the auto-hiding delay.
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0

    # Set Dock orientation to left
    defaults write com.apple.dock orientation -string "left"

    # Hot corners
    # Possible values:
    #  0: no-op
    #  2: Mission Control
    #  3: Show application windows
    #  4: Desktop
    #  5: Start screen saver
    #  6: Disable screen saver
    #  7: Dashboard
    # 10: Put display to sleep
    # 11: Launchpad
    # 12: Notification Center
    # 13: Lock Screen

    # Top left screen corner
    defaults write com.apple.dock wvous-tl-corner -int 0
    defaults write com.apple.dock wvous-tl-modifier -int 0

    # Top right screen corner
    defaults write com.apple.dock wvous-tr-corner -int 0
    defaults write com.apple.dock wvous-tr-modifier -int 0

    # Bottom left screen corner
    defaults write com.apple.dock wvous-bl-corner -int 0
    defaults write com.apple.dock wvous-bl-modifier -int 0

    # Bottom right screen corner
    defaults write com.apple.dock wvous-br-corner -int 0
    defaults write com.apple.dock wvous-br-modifier -int 0

    #================================================
    # *               FINDER GENERAL
    #================================================

    # Disable Window animations and Get Info animations (default: false)
    defaults write com.apple.finder DisableAllAnimations -bool true

    # File extension change warning
    # defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Writing of .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Disk image verification
    defaults write com.apple.frameworks.diskimages skip-verify        -bool true
    defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
    defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

    # Automatically open a new Finder window when a volume is mounted
    defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool false
    defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool false
    defaults write com.apple.finder OpenWindowForNewRemovableDisk    -bool false

    # AirDrop over Ethernet and on unsupported Macs running Lion
    defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

    # Warning before emptying Trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false

    # Empty Trash securely
    defaults write com.apple.finder EmptyTrashSecurely -bool false

    #================================================
    # *               FINDER WINDOWS
    #================================================

    # Visibility of hidden files (default: false)
    # I lately use `⌘-.` to switch between showing hidden files manually
    # defaults write com.apple.finder AppleShowAllFiles -bool true

    # Filename extensions (default: false)
    # See my applescript for showing and hiding extensions
    # defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Status bar (default: false)
    defaults write com.apple.finder ShowStatusBar -bool true

    # Full POSIX path as window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool false

    # Path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Text selection in Quick Look
    defaults write com.apple.finder QLEnableTextSelection -bool true

    # Search scope
    # This Mac       : `SCev`
    # Current Folder : `SCcf`
    # Previous Scope : `SCsp`
    # I prefer current folder
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Arrange by
    # Kind, Name, Application, Date Last Opened,
    # Date Added, Date Modified, Date Created, Size, Tags, None
    defaults write com.apple.finder FXPreferredGroupBy -string "Name"

    # Spring loaded directories
    defaults write NSGlobalDomain com.apple.springing.enabled -bool true

    # Delay for spring loaded directories
    defaults write NSGlobalDomain com.apple.springing.delay -float 0.3

    # Preferred view style
    # Icon View   : `icnv`
    # List View   : `Nlsv`
    # Column View : `clmv`
    # Cover Flow  : `Flwv`
    defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

    # After configuring preferred view style, clear all `.DS_Store` files
    # to ensure settings are applied for every directory
    find . -name '.DS_Store' -type f -delete

    # Keep folders on top when sorting by name
    # defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # View Options
    # ! This no longer works in Monterey 12.0.1
    # ColumnShowIcons    : Show preview column
    # ShowPreview        : Show icons
    # ShowIconThumbnails : Show icon preview
    # ArrangeBy          : Sort by
    #   dnam : Name
    #   kipl : Kind
    #   ludt : Date Last Opened
    #   pAdd : Date Added
    #   modd : Date Modified
    #   ascd : Date Created
    #   logs : Size
    #   labl : Tags
    # /usr/libexec/PlistBuddy \
    #     -c "Set :StandardViewOptions:ColumnViewOptions:ColumnShowIcons bool    false" \
    #     -c "Set :StandardViewOptions:ColumnViewOptions:FontSize        integer 11"    \
    #     -c "Set :StandardViewOptions:ColumnViewOptions:ShowPreview     bool    true"  \
    #     -c "Set :StandardViewOptions:ColumnViewOptions:ArrangeBy       string  dnam"  \
    #     ~/Library/Preferences/com.apple.finder.plist

    # New window target
    # Computer     : `PfCm`
    # Volume       : `PfVo`
    # $HOME        : `PfHm`
    # Desktop      : `PfDe`
    # Documents    : `PfDo`
    # All My Files : `PfAF`
    # Other…       : `PfLo`
    defaults write com.apple.finder NewWindowTarget -string 'PfHm'
    #defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

    # Expand the following File Info panes:
    # “General”, “Open with”, and “Sharing & Permissions”
    defaults write com.apple.finder FXInfoPanesExpanded -dict \
        General -bool true \
        OpenWith -bool true \
        Privileges -bool true

    # show full POSIX path as Finder window title, default false
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool false

    # show status bar in Finder windows
    defaults write com.apple.finder ShowStatusBar -bool true

    # show path bar in Finder windows
    defaults write com.apple.finder ShowPathBar -bool true
    ## later versions use "ShowPathbar"

    # Always use expanded save dialog:
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Maximize windows on double clicking them:
    defaults write -g AppleActionOnDoubleClick 'Maximize'

    #================================================
    # *              FINDER SIDE BAR
    #================================================

    # size of Finder sidebar icons, small=1, default=2, large=3
    # (TBD: maybe for Catalina 10.15+ only?)
    defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "1"

    #================================================
    # *              FINDER DESKTOP
    #================================================

    # Desktop Enabled
    defaults write com.apple.finder CreateDesktop -bool true

    # Quitting via ⌘ + Q; doing so will also hide desktop icons
    # defaults write com.apple.finder QuitMenuItem -bool true

    # Icons for hard drives, servers, and removable media on the desktop (default: false)
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowHardDrivesOnDesktop         -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop     -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop     -bool true

    # Size of icons on the desktop and in other icon views (default: 64)
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 32" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

    # Grid spacing for icons on the desktop and in other icon views (default: 54)
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist

    # Show item info near icons on the desktop and in other icon views (default: false)
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist

    # Show item info about the icons on the desktop (default: false)
    /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

    # Enable snap-to-grid for icons on the desktop and in other icon views
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist

    # Use Stack view
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:GroupBy Kind" ~/Library/Preferences/com.apple.finder.plist

    #================================================
    # *              SCREENSHOTS
    #================================================

    # Configure screenshot settings
    # Check defaults write "com.apple.screencapture" "target" in case of issues
    defaults write com.apple.screencapture location "~/Screenshots"
    defaults write com.apple.screencapture type -string "png"

    #================================================
    # *               MENU BAR
    #================================================

    # Don't show Spotlight in Menu Bar
    defaults write com.apple.Spotlight "NSStatusItem Visible Item-0" -bool false

    # Don't show Siri in Menu Bar
    defaults write com.apple.Siri StatusMenuVisible -bool false

    # Set clock to analog (disables clutters)
    defaults write com.apple.menuextra.clock IsAnalog -bool true

    # Always show Sound in Menu Bar
    defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

    #================================================
    # *               APPEARANCE
    #================================================

    # size of sidebar icons, small=1, default=2, large=3
    defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "2"


    # Show Scrollbars
    # Possible values: `WhenScrolling`, `Automatic` and `Always`
    defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

    # Click in the scrollbar to: Jump to the spot that's clicked
    # true = Jump to the spot that's clicked, false = Jump to the next page
    defaults write -g AppleScrollerPagingBehavior -bool true

    #================================================
    # *               TRACKPAD
    #================================================

    # Enable tap to click
    # 1 = enabled, 0 = disabled
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

    # Enable haptic feedback for clicking
    # 1 = enabled, 0 = disabled
    defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 1

    # Disable drag lock
    # 1 = enabled, 0 = disabled
    defaults write com.apple.AppleMultitouchTrackpad DragLock -int 0

    # Disable dragging
    # 1 = enabled, 0 = disabled
    defaults write com.apple.AppleMultitouchTrackpad Dragging -int 0

    # Set first click pressure threshold
    # 0 = light, 1 = medium, 2 = firm
    defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 1

    # Allow force touch and haptic feedback
    defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool false

    # Set second click pressure threshold
    # 0 = light, 1 = medium, 2 = firm
    defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 1

    # Disable corner secondary click
    # 0 = disabled, 1 = bottom right corner, 2 = bottom left corner
    defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0

    # Configure five finger pinch gesture
    # 0 = disabled, 1 = enabled, 2 = enabled with additional options
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2

    # Configure four finger horizontal swipe
    # 0 = disabled, 1 = enabled, 2 = enabled with additional options
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2

    # Configure four finger pinch
    # 0 = disabled, 1 = enabled, 2 = enabled with additional options
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2

    # Configure four finger vertical swipe
    # 0 = disabled, 1 = enabled, 2 = enabled with additional options
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2

    # Enable palm rejection
    defaults write com.apple.AppleMultitouchTrackpad TrackpadHandResting -bool true

    # Enable horizontal scrolling
    # 1 = enabled, 0 = disabled
    defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -int 1

    # Enable momentum scrolling
    defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -bool true

    # Enable pinch to zoom
    # 1 = enabled, 0 = disabled
    defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -int 1

    # Enable right click
    defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

    # Enable rotate gesture
    # 1 = enabled, 0 = disabled
    defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -int 1

    # Enable scrolling
    defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -bool true

    # Disable three finger drag
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false

    # Configure three finger horizontal swipe
    # 0 = disabled, 1 = enabled, 2 = enabled with additional options
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2

    # Disable three finger tap
    # 0 = disabled, 1 = enabled
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0

    # Configure three finger vertical swipe
    # 0 = disabled, 1 = enabled, 2 = enabled with additional options
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2

    # Enable two finger double tap
    # 0 = disabled, 1 = enabled
    defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1

    # Configure two finger swipe from right edge
    # 0 = disabled, 1 = navigate, 2 = notification center, 3 = mission control
    defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3

    # Disable USB mouse from stopping trackpad
    # 1 = enabled, 0 = disabled
    defaults write com.apple.AppleMultitouchTrackpad USBMouseStopsTrackpad -int 0

    # Enable user preferences
    defaults write com.apple.AppleMultitouchTrackpad UserPreferences -bool true

    # Set trackpad settings version
    defaults write com.apple.AppleMultitouchTrackpad version -int 12

    ###############################################################################
    # Kill affected applications                                                   #
    ###############################################################################

    for app in "Dock" "Finder" "SystemUIServer" "ActivityMonitor" "cfprefsd"; do
        execute "killall \"${app}\" &> /dev/null"
    done

    log "macOS defaults have been set. Some changes require a logout/restart to take effect."
}

# Main execution
setup_macos_defaults
