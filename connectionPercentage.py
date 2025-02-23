from flask import Flask, request, jsonify
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
from flask_cors import CORS
import json 
import psycopg2
from dotenv import load_dotenv
import os

app = Flask(__name__)
CORS(app)

# Connect to the database
connection = psycopg2.connect(
    user="postgres.nxnrgycurrpxzkskcecz",
    password="FMbKhvwpXpAhFnf9",
    host="aws-0-us-east-2.pooler.supabase.com",
    port=5432,
    dbname="postgres"
)

# Create a cursor to execute SQL queries
cursor = connection.cursor()

# Sørensen-Dice Similarity Function
def sorensen_dice_similarity(list1, list2):
    set1 = set(list1)
    set2 = set(list2)
    intersection = len(set1.intersection(set2))
    return (2 * intersection) / (len(set1) + len(set2)) if (len(set1) + len(set2)) > 0 else 0

# Jaccard Similarity Function
def jaccard_similarity(list1, list2):
    set1 = set(list1)
    set2 = set(list2)
    intersection = set1.intersection(set2)
    union = set1.union(set2)
    return len(intersection) / len(union) if len(union) > 0 else 0

# API endpoint for matching
@app.route("/match", methods=["POST"])
def match():
    data = request.get_json()
    user1_id = data["user1_id"]

    cursor = connection.cursor()
    query = """
        SELECT match_params FROM profiles WHERE id = %s;
    """
    cursor.execute(query, (user1_id,))
    result = cursor.fetchall()

    tracks = pd.DataFrame(result[0][0]["top_tracks"])
    tracks_data = tracks[1:]["name"][:]

    artists = pd.DataFrame(result[0][0]["top_artists"])
    artists_data = artists[1:]["name"][:]
    
    genres_data = pd.DataFrame(result[0][0]["top_genres"])
    
    genres_data_top5 = pd.DataFrame(result[0][0]["top_genres"][:5])
    
    tracks_top5 = pd.DataFrame(result[0][0]["top_tracks"])
    tracks_data_top5 = tracks[1:]["name"][:5]

    artists_top5 = pd.DataFrame(result[0][0]["top_artists"])
    artists_data_top5 = artists[1:]["name"][:5]
    
    #TODO - user1 genres go here

    # User 2 comparison
    query2 = """
    SELECT id, match_params FROM profiles WHERE id <> %s;
    """
    cursor.execute(query2, (user1_id,))
    result = cursor.fetchall()

    persons = {}

    for id, match_params in result:
        if(len(pd.DataFrame(match_params["top_tracks"][1:])) == 0):
            return "Error"
        tracks2 = pd.DataFrame(match_params["top_tracks"])
        tracks2_data = tracks2[1:]["name"][:]

        artists2 = pd.DataFrame(match_params["top_artists"])
        artists2_data = artists2[1:]["name"][:]
        
        tracks2_top5 = pd.DataFrame(match_params["top_tracks"])
        tracks2_data_top5 = tracks2[1:]["name"][:5]

        artists2_top5 = pd.DataFrame(match_params["top_artists"])
        artists2_data_top5 = artists2[1:]["name"][:5]
        
        genres2_data = pd.DataFrame(match_params["top_genres"])
    
        genres2_data_top5 = pd.DataFrame(match_params["top_genres"][:5])

        #TODO - get Genres for both users, user 2 goes here
        
        # Similarities
        artist_jaccard = jaccard_similarity(artists_data, artists2_data)
        song_jaccard = jaccard_similarity(tracks_data, tracks2_data)
        artist_dice = sorensen_dice_similarity(artists_data, artists2_data)
        song_dice = sorensen_dice_similarity(tracks_data, tracks2_data)
        artist_jaccard_top5 = jaccard_similarity(artists_data_top5, artists2_data_top5)
        song_jaccard_top5 = jaccard_similarity(tracks_data_top5, tracks2_data_top5)
        artist_dice_top5 = sorensen_dice_similarity(artists_data_top5, artists2_data_top5)
        song_dice_top5 = sorensen_dice_similarity(tracks_data_top5, tracks2_data_top5)
        genres_dice = sorensen_dice_similarity(genres_data, genres2_data)
        genres_dice_top5 = sorensen_dice_similarity(genres_data_top5, genres2_data_top5)
        genres_jaccard = jaccard_similarity(genres_data, genres2_data)
        genres_jaccard_top5 = jaccard_similarity(genres_data_top5, genres2_data_top5)
        #TODO - add comparison between user1 and 2 genres using the methods above.

        # Weights
        weight_artist_jaccard = 0.1
        weight_song_jaccard = 0.1
        weight_artist_dice = 0.1
        weight_song_dice = 0.1
        weight_artist_jaccard_top5 = 0.25
        weight_song_jaccard_top5 = 0.25
        weight_artist_dice_top5 =0.25
        weight_song_dice_top5 = 0.25
        weight_genres_dice = 0.1
        weight_genres_dice_top5 = 0.275
        weight_genres_jaccard = 0.1
        weight_genres_jaccard_top5 = 0.275

        # Match Percentage Calculation
        match_percentage = (
            (artist_jaccard * weight_artist_jaccard) +
            (song_jaccard * weight_song_jaccard) +
            (artist_dice * weight_artist_dice) +
            (song_dice * weight_song_dice) +
            (artist_jaccard_top5 * weight_artist_jaccard_top5) +
            (song_jaccard_top5 * weight_song_jaccard_top5) +
            (artist_dice_top5 * weight_artist_dice_top5) +
            (song_dice_top5 * weight_song_dice_top5)+
            (genres_dice * weight_genres_dice)+
            (genres_dice_top5 * weight_genres_dice_top5)+
            (genres_jaccard * weight_genres_jaccard)+
            (genres_jaccard_top5 * weight_genres_jaccard_top5)
        ) * 100
        if(match_percentage >= 100):
            persons[id] = 100
            continue
        persons[id] = match_percentage
    #TODO - hardcoded the age, needs to get age from database for user 1 and 2
    # Define age range rules based on user1_age
    
    # Filter users within the age range and calculate their match percentage
    filtered_users = []
    for user in persons:
        match_percentage = persons[user]  # Get match percentage (already defined)
        # Check if age is within the allowed range
        filtered_users.append({
            "id": user ,
            "match_percentage": match_percentage
        })

    # Sort filtered users by match percentage in descending order
    filtered_users.sort(key=lambda x: x["match_percentage"], reverse=True)

    # Separate users with match percentage above the threshold (90)
    above_threshold = [user for user in filtered_users if user["match_percentage"] >= 90]
    below_threshold = [user for user in filtered_users if user["match_percentage"] < 90]

    # If there are users above the threshold, return the top 5
    if above_threshold:
        matches = [{"id": user, "match_percentage": user["match_percentage"]} for user in above_threshold[:5]]

    # If no users above the threshold, return the next 10 highest below the threshold
    elif below_threshold:
        matches = [{"id": user, "match_percentage": user["match_percentage"]} for user in below_threshold[:10]]

    # If no matches at all, return an empty list
    else:
        matches = []


    
    return persons

# Run the Flask app
if __name__ == "__main__":
    app.run(debug=True)


    