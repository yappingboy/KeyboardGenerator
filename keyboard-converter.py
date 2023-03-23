import json
import math

# Opening JSON file
with open('keyboard-layout.json') as keyboard_layout:
	file_contents = keyboard_layout.read()
	keyboard_layout.close()
#print(file_contents)
# returns JSON object as 
# a dictionary
data = json.loads(file_contents)
  
# Iterating through the json
# list
layout=[]
rot=0
xrot=0
yrot=0
zrot=0
xpos=0
ypos=0
zpos=0
fontSize=3
a=4
textAlignment=[[-1,-1],[-1,1],[1,-1],[1,1],[0,0],[0,-1],[-1,0],[1,0],[0,-1],[0,0],[0,1],[0,0]]
for rows in data:
	for columns in rows:
		if isinstance(columns,dict):
			for items in columns.keys():
				match items:
					case "f":
						fontSize=columns[items]
					case "a":
						a=columns[items]
					case "x":
						xpos+=columns[items]
					case "y":
						ypos+=columns[items]
					case "rx":
						xrot=columns[items]
					case "ry":
						yrot=columns[items]
					case "r":
						rot=columns[items]
						ypos=0
						xpos=0
		if isinstance(columns,str):
			legend=[]
			numicons=0
			for letter in columns.split():
				print(letter+" "+str(numicons))
				print(columns.find(letter)-numicons)
				location=textAlignment[columns.find(letter)-numicons]
				if a != 4:
					location = textAlignment[a];
				legend.append(['"{}"'.format(letter),fontSize,location])
				numicons+=1
			layout.append([[xpos,ypos,zpos],[xrot,yrot,zrot,rot],legend])
			xpos+=1
	ypos+=1
	xpos=0
outputstring=("keys=" + str(layout) + ";")
escapedBackslash=outputstring.replace('\\','\\\\')
removeSingleQuote=escapedBackslash.replace("'","")
print(removeSingleQuote)
with open("layout.scad", "w" ) as layoutscad:
	layoutscad.write(removeSingleQuote)
	layoutscad.close()
# Closing file
