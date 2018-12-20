# xPluka
This app allows to the user to create Touristic places with its information and photos downloaded using the Flickr API. 
Allows to register visits referenced to the created places.
These places can be seen in the map.
## Getting Started
No Notes
### Prerequisites
To execute this app it is necesary to open it with Xcode 9 or superior and have and active account in Flickr.
### Installing
You need to follow the next steps:<br />
1.- Open the project using Xcode.<br />
2.- Go to the Helpers Directory and open the **Client+Extension.swift** file and go to the  **FlickrParameterValues** struct and set in the APIKey the value gotten in your Flickr Account.<br />
3.- Clean, Build and run the project, choosing an simulator or real device.<br />

**Executed Example**

**Main Screen**<br/>
It shows the map where will be shown the Touristic Places.
![Main_Screen_Map](xpluka-map-1.png)

**Map instructions**<br/>
It shows a message where you can see the features of the view.
![Map_instructions](xpluka-map-instructions.png)

**Register Touristic Place**<br/>
This view allows to create a new place with the required fields:<br/>
* Name<br/>
* Description<br/>
* Type (you can selec from the list)<br/>
* Location (fixed when the view is shown)<br/>
* Qualification (validated from 1 to 10)<br/>
* Observations (Commentary of the Touristic Place)<br/>

![Register_touristic_place](xpluka-register-touristic-place.png)

**Save Touristic Place** <br/>
After filling all the required fields then the user can press the button save changes, it shows a message where the place is created

![Register_touristic_save](xpluka-register-touristic-place-save-changes.png)

**Touristic Place shown in the map**<br/>
After the creation of the Touristic place it shows the tp in the map. 

![map_show_touristic_places](xpluka-register-touristic-place-show-tp.png)

**Edit Touristic Place**<br/>
By pressing in the created place, it shows the register TP view with the last filled information, also allows to see the image gallery by pressing in the image gallery button. 

![Register_touristic_update](xpluka-register-touristic-place-update-changes.png)

**Delete Touristic Place**<br/>
You can delete the touristic place by pressing the delete button, after that it shows a message to confirm the deletion.

![Register_touristic_delete](xpluka-register-touristic-place-delete.png)

**Show image gallery**<br/>
By pressing the gallery button it shows the loaded photos that belongs to the touristic place, by pressing the new collection button it starts downloading new photos using the Flickr API.

![Register_touristic_show_gallery](xpluka-photo-gallery.png)



## Built With

* [XCode](https://developer.apple.com/xcode/) - The mobile framework used

## Versioning
Last version available 1.0

## Authors

* **Jonathan Lucero** - *Udacity Capstone Project* 

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
