kwassa-ios
==========

Lists albums from Pitchfork's Best New Albums. You can browse by year and check out the album's songs using Spotify's iOS dev api's. That's the plan anyway. It need some work. 


Quick rundown:

AppDelegate authorizes a Spotify premium user and set up the token swap service. 

AlbumsCollectionViewController has album lists. 

ReviewServices uses kwassa_backend api to get a album list by year (currently only 2010, needs a picker) and allows playing indivudal songs. 

AlbumCell is cell used by AlbumsCollectionViewController. 

ViewController is used as a sandbox. It's rull dirty. Don't look. 
