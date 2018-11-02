# Google Photos Import

## What is this?
This is an attempt to import the photos I take with my Android phone, which uploads the photos to Google Photos, into iCloud Photos. Currently it is pretending to be an iOS application, but in the end I want this to run on both OSX and iOS.

I also might give 'the other way around' a try.

The whole project is written in Swift and I am **not affraid** to use dependencies, which I do a lot to keep this project moving forward. 

## Known issues
- Google Photos strips the location data from the images, before you download them through the API. Want location metadata to be supported? Make it clear to Google by commenting on [this issue](https://issuetracker.google.com/issues/80379228)!
- Need to keep a 'mapping' between Google Photos and iCloud Photos, so images won't be duplicated when reimporting the photos. I read cases where identifiers for iCloud photos are 'reset' between iOS updates.

## Todo
Just the basic classes and requests for Google Photo are currently implemented. There is so much to do, that it is too much to write down, but for example:

- Import photos from GP to IP and keep a clean administration.
- Option to remove copied photos from GP.
- Import by album.
- Interfaces for everything.

## Classes
Classes for Google Photos are kept in the [GooglePhotosAPI](https://github.com/depl0y/GooglePhotosImport/tree/master/ImportPhotos/GooglePhotosAPI) folder in this repository. The following classes contain functionality to communicate with the Google Photos API. Other classes are there to make sure we get the full metadata from the API.

### [Album](https://github.com/depl0y/GooglePhotosImport/blob/master/ImportPhotos/GooglePhotosAPI/Album.swift)
`Album` contains the following methods:

- `list`: Gets a list of albums. (static)
- `listAll`: Gets the full list of albums, if more than 20 it performs multiple requests.  (static)
- `get`: Gets the metadata of a single album. (static)
- `getMediaItems`: Gets the `MediaItem` objects for an album.

### [MediaItem](https://github.com/depl0y/GooglePhotosImport/blob/master/ImportPhotos/GooglePhotosAPI/MediaItem.swift)
`MediaItem` contains the following methods:

- `list`: Gets a list of MediaItem objects. (static)
- `listAll`: Gets the full list of MediaItem objects. (static)
- `get`: Gets the metdata of a single MediaItem object. (static)
- `search`: Perform a search over the MediaItem objects in the photo library. (static)
- `download`: Download the image belonging to the MediaItem object.

## Google API key
To use this project, you must create a file called `google.apikey` in the `ImportPhotos` folder. This is a simple textfile, containing nothing more than your Google API key. This file is read on run-time and the key is used to configure Google Signin.

## Examples
#### Search in `MediaItems` for selfies and animals.
```
let filter = Filters.create(category: .selfies)
filter.addContentCategory(category: .animals)

MediaItem.search(filters: filter, completed: { (response) in
    log.verbose("Found \(response.mediaItems?.count)")
}) { (error) in
    log.error(error)
}
```
#### Getting all `Albums` and get the `MediaItems` for the first album (if present).
```
Album.listAll(completed: { (albums) in
    if albums.count > 0 {
        if let album = albums.first {
            album.getAllMediaItems(completed: {
                log.verbose("Contains \(album.mediaItems.count) items")
            }, failed: { (error) in
                log.error(error)
            })
        }
    }
}) { (error) in
    log.error(error)
}
```

## Dependencies

Currently I use the following dependencies:
- GoogleSignIn
- Alamofire
- AlamofireObjectMapper
- ObjectMapper
- SwiftyBeaver
- RealmSwift
- PureLayout
- SwiftLint

This list might not be up-to-date, but you can check out the [Podfile](https://github.com/depl0y/GooglePhotosImport/blob/master/Podfile) for a more recent list.