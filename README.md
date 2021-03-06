# xPluka
This app allows to the user to create Touristic places with its information and photos downloaded using the Flickr API.</br> 
Allows to register visits referenced to the created places.</br>
These places can be seen in the map.</br>
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
It shows the map where will be shown the Touristic Places.<br/>
![Main_Screen_Map](xpluka-map-1_1.png)

**Map instructions**<br/>
It shows a message where you can see the features of the view.<br/>
![Map_instructions](xpluka-map-instructions_1.png)

**Register Touristic Place**<br/>
This view allows to create a new place with the required fields:<br/>
* Name<br/>
* Description<br/>
* Type (you can selec from the list)<br/>
* Location (fixed when the view is shown)<br/>
* Qualification (validated from 1 to 10)<br/>
* Observations (Commentary of the Touristic Place)<br/>

![Register_touristic_place](xpluka-register-touristic-place_1.png)<br/>

**Save Touristic Place** <br/>
After filling all the required fields then the user can press the button save changes, it shows a message where the place is created<br/>

![Register_touristic_save](xpluka-register-touristic-place-save-changes_1.png)<br/>

**Touristic Place shown in the map**<br/>
After the creation of the Touristic place it shows the tp in the map.<br/> 

![map_show_touristic_places](xpluka-register-touristic-place-show-tp_1.png)<br/>

**Edit Touristic Place**<br/>
By pressing in the created place, it shows the register TP view with the last filled information, also allows to see the image gallery by pressing in the image gallery button.<br/>

![Register_touristic_update](xpluka-register-touristic-place-update-changes_1.png)<br/>

**Delete Touristic Place**<br/>
You can delete the touristic place by pressing the delete button, after that it shows a message to confirm the deletion.<br/>

![Register_touristic_delete](xpluka-register-touristic-place-delete_1.png)<br/>

**Show image gallery**<br/>
By pressing the gallery button it shows the loaded photos that belongs to the touristic place, by pressing the new collection button it starts downloading new photos using the Flickr API.

![Register_touristic_show_gallery](xpluka-photo-gallery_1.png)<br/>

**Show Visit List**<br/>
By pressing the visit button in the map view, then it shows a list of all the planned visits. Then you can see the plannification fate begin and end also an icon referred to its type.<br/>

![Show_visit_list](xpluka-visit-list_1.png)<br/>

**Add New Visit**<br/>
By pressing the + button then it shows the information of the visit to create.<br/>

![Add_new_visit](xpluka-register-visit_1.png)<br/>

**Save New Visit**<br/>
After pressing save button it shows a message for visit creation confirmation.<br/>

![Save_new_visit](xpluka-register-visit-save-changes_1.png)<br/>

**Visit List Instructions**<br/>
It shows a message where you can see the features of the view of the visit list.<br/>

![Visit_list_instructions](xpluka-visit-list-instructions_1.png)<br/>

**Visit Delete**<br/>
The visit can be deleted by sliding in one in the list, it shows a delete button, after pressing it the deletes the visit and reloads the list.<br/>

![Visit_list_delete](xpluka-visit-list-delete.png)<br/>


## Built With

* [XCode](https://developer.apple.com/xcode/) - The mobile framework used

## Versioning
Last version available 1.0

## Authors

* **Jonathan Lucero** - *Udacity Capstone Project* 

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
