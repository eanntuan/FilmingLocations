# Netflix Filming Locations App
### Eann Tuan

## How to run the project
1. Download/Clone from github
2. Open NetflixFilmingLocationsApp.xcodeproj in Xcode
3. Press run!

## High Level Overview
This project reminded me of a combination of geo-caching and a Yelp for film locations. With that in mind, I imagined myself as a movie-fanatic user, trying to explore where my favorite films were filmed relative to my current location. I'm able to sort from a list of movies by distance closest to me, movie title, newest, and oldest, use a map to see how close I am to a filming location, and get directions there as well. I'm also able to find out more details about a film, including the plot, any fun facts about the location, and other filming locations.

Keeping Netflix's UI and brand in mind, I intentionally chose a permanent dark mode with rounded movie poster images and a Collection View in the FilmDetailsCollectionViewController, as I would anticipate future versions would include much more detail to include orthogonal scrolling (i.e. "Other films you might like").

This were assumptions I made, but would have asked more questions to the PM to better understand the user profile.

## Focus Areas and Trade-Offs
1. Performance - On app load, there's quite a bit of data to get. We need to parse the response from the Netflix api, then for each film, fetch additional information from the OMDB api, such as the poster url, ratings, etc. In the future, I would consider a splash screen that hides some of the processing time, much like Netflix's iOS app does.
2. Some images aren't able to be loaded because some of the film titles were episode names or "special editions" of a film (i.e. "Looking Season 2 ep 210," "Looking "Special""). As a trade-off, I added a "Coming soon" image.

## Copied in code, dependencies
1. ImageCache - from a previous project that caches images using NSCache
2. NibLoadedView - from a previous project that allows view controllers to more easily access nibs

## Data Structures/Models
1. Film.swift - the data structure from the Netflix api given in the project. I wanted to keep this separate from the model we get from the OMDB Api
2. ImdbFIlm.swift - film data structure from the OMDB api that contains more information about each film.
3. filmsDict - because the response from the Netflix api displays all of the locations for all films in separate entities, I created a separate dictionary of film titles (key) to an array of their locations, sorted by the closest distance. This would allow us to create the distinctFilms array to display in the FilmListViewController.swift. It didn't make sense to show 8 of the same movie but at different locations - rather just show the closest one. This is a question I would've asked product.
4. distinctFilms - an array of distinct Films, selecting the closest film location. If the user wanted to view more locations, they could select the film to view the Film Details.
5. imdbFilmsDict - similar to the filmsDict, this is the same idea but with the separate ImdbFilm.swift model
6. cachedFilms - an array of cached Films stored on the user's device
7. cachedImdbFilms - an array of cached ImdbFilms stored on the user's device
8. FilmTitleToLocationsCache - a potentially unnecessary cache, but one that would store a dictionary of Films indexed by their film title (for O(1) quick access), plus the date that it was cached. In future iterations, I would set a window of time that this data is still valid, and check against that date before deciding the cache is too old to be relevant.


## Time spent
About 4 - 5 hours over multiple days (about an hour or so each day in the morning this past week). The last hour was mostly spent doing documentation, code cleanup, etc.

## Questions I would've asked
1. How do we want to display a film that has more than 1 location? Should we consolidate into one cell?
2. Will users want to sort their list of films by any criteria? I assumed that they might want to sort by distance, title, newest, oldest.
3. Do we want to default to the Map or List view on load?
4. What search criteria do we want to provide? For now, I allowed the user to search by the film title and actor. Maybe they wanted to see all of the movies with Jennifer Aniston in them, but I'm sure there are other uses cases!
5. How often is this data being refreshed? I'm assuming not very often, otherwise I would've put a pull to refresh spinner.

## Refactors
1. Setup pagination and lazy loading to improve performance. This would also include infinite scrolling and animations on the poster image, similar to how Netflix does it in their iOS app.
2. Make sure we're not fetching multiple of the same API calls, potentially using a isFetchingData flag.
3. Combine Map and List into segmented control on one view instead of TabBar
4. Automatic cell resizing in FilmDetailsViewController
5. Only display "Find other locations" header if there are actually other locations
6. Put the Segmented Controller in List view under the search bar (where you can sort by distance, title, newest, oldest)
7. Use Xcode instruments to test performance on first-app load. Make sure it complies with Apple's HIG.

## Code Organization
1. FilmManager.swift - main manager that gets the film data, read/write to cache, stores the data structures used in the view controllers
2. FilmsMapViewController.swift - displays each of the locations as a red pin. The user can interact with this view by searching for a specific film title or actor, zoom in and out, tap on a pin and get directions to there. For now, I've hard coded the current location to be in San Francisco due to a XCode simulator location services issue.
3. FilmsListViewController.swift - displays the list of distinct films in a TableView. I would've asked the PM the future roadmap for this page, wondering if there were other designs, extra rows to be added, etc, and likely have changed this to a UICollectionView, but I wanted to show both a TableView and a CollectionView in code.
4. FilmDetailsCollectionViewController.swift - a UICollectionView that displays the film details for each film.

## Enhancements
1. Leverage OMDB api more to display more info (i.e. different ratings, search by genre, etc)
2. UI enhancements on Film Details page - maybe include a trailer of the movie on auto play, like Netflix's app
3. Use colors to display the rating system - right now the app is very black and white. I'd like to add some more color and visuals, such as green for good rating, red for bad rating.

## Testing
1. Bad network - what happens when there is no internet connection? Right now the app doesn't display anything, but some sort of safeguard for refetching the film data.
2. Error handling - adding support for different error states like loading, empty, error, etc
3. 
