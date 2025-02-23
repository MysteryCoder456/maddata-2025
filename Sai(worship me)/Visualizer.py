import matplotlib.pyplot as plt
from GenerateTopArtists import top


songs,streams,pics=top()
print("YEAA")

songs=songs[:10]
songs=songs[::-1]
print(songs)
print("HHE")
print(streams)
streams=streams[:10]
streams=streams[::-1]
print(songs)
pics=pics[:10]
pics=pics[::-1]
fig, ax = plt.subplots()

# Change the background color of the entire plot
fig.patch.set_facecolor('black')

# Change the background color of the axes
ax.set_facecolor('black')
ax.spines['left'].set_color('blue')
ax.spines['bottom'].set_color('blue')
'''
[t.set_color('blue') for t in ax.yaxis.get_ticklabels()]
for label in ax.get_yticklabels():
    label.set_color('blue')
'''

# Plot some data
bars=ax.barh(songs,streams)

[t.set_color('blue') for t in ax.xaxis.get_ticklabels()]
c=9
for bar in bars:
    x = bar.get_x() + bar.get_width() / 2
    y = bar.get_height() / 2
    if(c==9):
        ax.text(x,c,songs[c],color="gold")
    elif (c==8):
        ax.text(x,c,songs[c],color="silver")
    elif(c==7):
        ax.text(x,c,songs[c],color="firebrick")
    else:
        ax.text(x,c,songs[c],color="white")
    c-=1

ax.set_title('Sample Plot', color='blue')
ax.set_xlabel('Popularity', color='red')

plt.savefig('figure.png', bbox_inches='tight')

