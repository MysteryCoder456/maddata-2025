import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
from TrackID import get_track_id
# Replace these with your actual Spotify API credentials
client_id="d973327e65b04151bb818b08e93be92a"
client_secret= "996d45793d1f4ab2b97c93c02c9538ed"

# Authenticate with Spotify
auth_manager = SpotifyClientCredentials(client_id=client_id, client_secret=client_secret)
sp = spotipy.Spotify(auth_manager=auth_manager)

# Function to get the number of streams for a specific track
def get_track_streams(name):
    track_id = get_track_id(name)
    
    track = sp.track(track_id)


    return track['popularity']


