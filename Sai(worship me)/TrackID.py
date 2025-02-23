import spotipy
from spotipy.oauth2 import SpotifyClientCredentials

# Replace these with your own Spotify API credentials
client_id = 'f60b15a4cb87492a9009c1578e0948c4'
client_secret = '4c9621dbea9841c9828974510879d175'

# Authenticate with Spotify
auth_manager = SpotifyClientCredentials(client_id=client_id, client_secret=client_secret)
sp = spotipy.Spotify(auth_manager=auth_manager)

def get_track_id(track_name):
    results = sp.search(q=track_name, type='track', limit=1)
    if results['tracks']['items']:
        track_id = results['tracks']['items'][0]['id']
        return track_id
    else:
        return None

# Example usage
print(get_track_id("APT."))
