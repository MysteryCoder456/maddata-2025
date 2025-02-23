import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
from TrackID import get_track_id
# Replace these with your actual Spotify API credentials
client_id = 'f60b15a4cb87492a9009c1578e0948c4'
client_secret = '4c9621dbea9841c9828974510879d175'

# Authenticate with Spotify
auth_manager = SpotifyClientCredentials(client_id=client_id, client_secret=client_secret)
sp = spotipy.Spotify(auth_manager=auth_manager)

# Function to get the number of streams for a specific track
def get_track_streams(name):
    track_id = get_track_id(name)
    track = sp.track(track_id)

    return track['popularity']


