import requests

# Spotify API credentials
def gen_token():
    CLIENT_ID = 'f60b15a4cb87492a9009c1578e0948c4'
    CLIENT_SECRET = '4c9621dbea9841c9828974510879d175'
    
    # Step: Request an access token using the Client Credentials Flow
    token_url = 'https://accounts.spotify.com/api/token'
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
    }
    payload = {
        'grant_type': 'client_credentials',
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET
    }
    
    response = requests.post(token_url, headers=headers, data=payload)
    if response.status_code == 200:
        tokens = response.json()
        access_token = tokens['access_token']
        return(access_token)
    else:
        print(f'Failed to retrieve access token: {response.status_code}')
print(gen_token())