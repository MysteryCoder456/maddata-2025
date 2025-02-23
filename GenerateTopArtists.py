import requests
from StreamGen import get_track_streams


def top():
    response = requests.get('https://charts-spotify-com-service.spotify.com/public/v0/charts')

    data = response.json()
    stream=[]
    tracks=[]
    pics=[]
    for entry in response.json()["chartEntryViewResponses"][0]["entries"]:
        meta = entry["trackMetadata"]
        entry = entry["chartEntryData"]
    
        track = meta['trackName']
        pic=meta["displayImageUri"]
        #artists = ", ".join([artist["name"] for artist in meta["artists"]])
    
        #print(f"{entry['currentRank']:3} | {track:50} | {artists}")
        track=track.split("\n")
        pic=pic.split("\n")
        print(track)
        for x in track:
            #print(x,": ",get_track_streams(x))
            stream.append(get_track_streams(x))
            tracks.append(x)
        for x in pic:
            print(x)
            pics.append(x)

    return(tracks,stream,pic)
    

            