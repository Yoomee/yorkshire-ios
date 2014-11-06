# Yorkshire Universities App

This app shows content about Yorkshire Universities

It works whilst offline.

## Development setup

```
git clone git@gitlab.yoomee.com:yoomee/yorkshire-ios.git
cd yorkshire-ios
git submodule init
git submodule update
```

Then open 'StudyInYorkshire.xcodeproj' in XCode.

##App Development Guide

###Storyboards

**Overview**

The app uses storyboards to create the basic structure and flow of the app, creating and linking screens through a TabViewController. There are two separate files for both iPhone and iPad, as the app functions slightly differently on both devices. These files (MainStoryboard_iPhone.storyboard and MainStoryboard_iPad.storyboard) should only need to change if there are any screens added to the overall functionality of the app. The storyboards contain very little in terms of custom layout, except the *“Tour de Yorkshire”* button found on the home page. Most of the layout is handled in code, therefore the storyboards should only be changed if there are changes to the structure of the app.

**Key Classes**

*AppDelegate*

The AppDelegate sets up the initialisation required for Core Data and the initial view controllers. It will also check to see if there have been any changes to the database using a version number and, if not, update accordingly. If the version number stored in NSUserDefaults isn’t the latest version then the SQLite database is replaced. Whilst doing this, it will attempt to keep all favourited pages as long as there is a matching page in the new data.

The process for updating the data in the app from the website CMS is as follows:

1. Generate a new SQLite file and copy in images, see the [Rails app README](https://gitlab.yoomee.com/yoomee/yorkshire/blob/master/README.md)
1. Increment the database version number in AppDelegate.m. The version number is currently 1.3 and is in three separate places in the code within the persistentStoreCoordinator method.

*YUTabBarController*

This is a standard TabBarController that adds a small bit of custom functionality to fetch the SplitViewController from the storyboard on the iPad. This is due to issues with the SplitViewController not being the rootViewController.

### App Data and CoreData

**Overview**

Data for the app is static and stored inside a CoreData SQLite database. This is copied from the CMS.

**Key Classes**

*Page*

The model object representing a page contained in the SQLite database. This can be one of two things: A navigation page or an information page. A navigation page contains a number of links to other pages and is defined by having at least one object contained within the children property. An information page contains information to display in the form of a title, text and an image.

*Photo*

This is the model object for a photo. It contains an identifier for the image which should reference one of the images contained within the assets folder, a position for sorting and a caption. It also has two accessor methods for fetching the image and a thumbnail of that image. These methods return the image at the correct resolution for the current device.

### Home Page / Pages

**Overview**

The home page provides the main navigation and display of information contained within the database.

**Key Classes**

*PageViewController*

The PageViewController contains all code to display a Page object. When one is loaded for display it determines if it is a navigation page or information page (see above) and displays its content accordingly. If it is a navigation page, it will create a button for each child contained within the children property and space it out on the screen. If it is an information page, it will create and render it accordingly to the current design. The text property of the Page object contains html text, which is then displayed in a WebView inside this class. It also contains the sharing functionality which can share any page using the inbuilt activity window (UIActivityWindow) to list all compatible methods of sharing. This class needs to remain robust as it is used in multiple places throughout the app.

*HomePageViewController (iPhone only)*

This is just a PageViewController with added functionality for the “Tour de Yorkshire” button found at the bottom of the page. The only thing of note here is that the “Tour de Yorkshire” page is found within the page database using the title. It will loop through each page and it’s children looking for any page which matches the title “Tour de Yorkshire”.

*IntelligentSplitViewController (iPad only)*

This is an iPad only class that handles the displaying of a navigation page along with an information page. It is set up inside the iPad storyboard, and from there you will see it is just two instances of PageViewController. There is additional code in here that sits on top of a SplitViewController as that was found to be buggy when contained within another view controller. The bugs in question refer to problems with refreshing the layout after a screen orientation change, and the containing page compensating for the tab bar twice. This may change with future releases of UKit, so it is probably worth checking this in the future to see if these issues have been fixed, as there is no other need to use this class.

*HomeViewController (iPad only)*

This is an iPad only class that renders the home page in a similar style to the iPhone version, as the rest of the home page uses the SplitViewController. This is also where the added functionality for the “Tour de Yorkshire” button is found and is identical to how it is done in the HomePageViewController (see above).

### Photos

**Overview**

The photo page contains a grid of photos from the database. Clicking on a photo, opens up that photo full screen with a caption.

**Key Classes**

*PhotosViewController*

The PhotosViewController uses an external library called “Nimbus” to list and display a grid of thumbnails from each of the photos contained with the database. When a photo is clicked, it opens it up in a PhotoViewController.

*PhotoViewController*

The PhotoViewController uses the external library called “Nimbus” (specifically the class NIPhotoAlbumScrollView) to display a sinlge photo as close to full screen as it can get, whilst keeping its aspect ratio, along with a caption that should be positioned at the bottom of the screen. It also contains code to swipe left and right to go to the next or previous photo in the order determined by the “position” value in the Photo object. Problems may arise with edits if the photo gets bigger than the screen space given to it as this will automatically add scrolling to the screen. This is something to keep in mind when editing the functionality of this screen.

### Map

**Overview**

The map page displays an interactive map (zooming, panning etc.) with a pin for each university in the database.

**Key Classes**

*MapViewController*

The map view uses the inbuilt “Apple Maps” functionality to show and display a map containing all the universities detailed inside the app along with a quick link to their respective page. University locations (ie. the pins) are determined by finding the page of each university within the database then using that Page’s longitude and latitude properties. Each pin then includes a link that opens up a PageViewController (see above) to display that university’s information page, similar to the way it’s displayed in the home page.

### Favourites

**Overview**

This displays a list of all pages that have been favourited by the user along with a quick link for access to that page. Whether or not a page is favourited is contained within the Page object within the database.

**Key Classes**

*FavouritesViewController*

Simply fetches a list of favourites from the database and displays them in a list on this page. If there are no favourites, it either displays a label informing the user (iPhone) or switches to the NoFavouritesViewController (iPad). Like the Home page, this also utilises the IntelligentSplitViewController on the iPad, displaying the list of favourites on the left of the screen, with a PageViewController showing the selected page on the right. For this reason, the FavouritesViewController must stay robust enough to displayed at any screen width and height.
