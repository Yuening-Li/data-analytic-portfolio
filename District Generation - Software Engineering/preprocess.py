import json
import csv
import sys
csv.field_size_limit(100*1024*1024)
from shapely.geometry import MultiPolygon, Polygon
from shapely.ops import unary_union

def make_polygon(feature):
    geometry = feature['geometry']
    coordinates = geometry['coordinates']
    if geometry['type'] == 'MultiPolygon':
        coordinates = coordinates[0][0]
    elif geometry['type'] == "Polygon":
        coordinates = coordinates[0]
    p = []
    for coordinate in coordinates:
        p.append(tuple(coordinate))
    precinct = Polygon(p)
    return precinct

def find_neighbor_precincts(data):
    f = open("CO_Neighbor_Precincts.txt","w+")
    features = data['features']    
    for i in range(0, len(features)):
        polygonA = make_polygon(features[i])
        for j in range(0, len(features)):
            if i == j:
                continue
            else:
                polygonB = make_polygon(features[j])
                if polygonA.touches(polygonB):
                    f.write(features[i]['properties']['GEOID10'] + ", " + features[j]['properties']['GEOID10'] +"\n")
    f.close()

def find_neighbor_districts(num_district):
    f = open("CO_Neighbor_Districts.txt","w+")
    for i in range(1,num_district+1):
        filename = 'district' + str(i) + '.geojson'
        with open(filename) as file:
            district_data = json.load(file)
        districtA = make_polygon(district_data)
        for j in range(1,num_district+1):
            if i == j:
                continue
            else:
                filename = 'district' + str(j) + '.geojson'
                with open(filename) as file:
                    district_data = json.load(file)
                districtB = make_polygon(district_data)
                if districtA.touches(districtB):
                    f.write(str(i)  + ", " + str(j) + "\n")
    f.close()

def find_border_precincts(num_district):
    f = open("CO_Border_Precincts.json","w+")
    for i in range(1,num_district+1):
        filename = 'district' + str(i) + '.geojson'
        with open(filename) as file:
            district_data = json.load(file)
        district = make_polygon(district_data)
        file.close()
        filename = 'IA_CD' + str(i) + '.json'
        with open(filename) as file:
            precinct_data = json.load(file)
        features = precinct_data['features']
        for j in range(0, len(features)):
            precinct = make_polygon(features[j])
            if precinct.overlaps(district):
                f.write(str(i) + ", " + features[j]['properties']['GEOID10'] +"\n")
    f.close()

def distribute_precincts(data, num_district):
    f = open("IA_District_Precincts.json","w+")
    features = data['features']
    for i in range(1,num_district+1):
        filename = 'district' + str(i) + '.geojson'
        with open(filename) as file:
            district_data = json.load(file)
        district = make_polygon(district_data)
        for j in range(0, len(features)):
            precinct = make_polygon(features[j])
            centroid = precinct.centroid
            if centroid.within(district):
                f.write(str(i) + ", " + features[j]['properties']['GEOID10'] +"\n")
    f.close()

def divide_precincts_by_district(data, num_district):
    features = data['features']
    for i in range(1,num_district+1):
        f = open("IA_CD"  + str(i) + ".json", "w+")
        filename = 'district' + str(i) + '.geojson'
        with open(filename) as file:
            district_data = json.load(file)
        district = make_polygon(district_data)
        f.write("var cd" + str(i) + " = {\"type\":\"FeatureCollection\", \"features\": [" + "\n")
        for feature in features:
            precinct = make_polygon(feature)
            centroid = precinct.centroid
            if centroid.within(district):
                population = feature['properties']['POP100']
                f.write('{\"type\": \"Feature\", \"geometry\": ')
                f.write(json.dumps(feature['geometry']) + ", ")
                f.write("\"properties\":{")
                f.write("\"GEOID10\":" + "\"" + feature['properties']['GEOID10'] + "\",")
                f.write("\"POP100\":" + '{:d}'.format(population) + ", ")
                f.write("\"DISTRICT\":" + '{:d}'.format(i))
                f.write("}},\n")
        f.write("]}")
        f.close
        
def get_boundary_precinct(data):
    features = data['features']
    with open("az_boundry.csv","w",newline='') as out_file:
        writer = csv.writer(out_file)
        for feature in features:
            writer.writerow([[feature['properties']['GEOID10'],feature['geometry']['coordinates']]])


    
def get_boundary_district(num_district):    
    f = open("IA_boundary_districts.json","w+")
    for i in range(1,num_district+1):
        filename = 'district' + str(i) + '.geojson'
        with open(filename) as file:
            district_data = json.load(file)
        f.write(str(i) + ", " + json.dumps(district_data['geometry']['coordinates']))
        f.write("\n")
    f.close()

def get_boundary_state():
    f = open("IA_boundary_state.json","w+")
    filename = 'IA.geojson'
    with open(filename) as file:
            data = json.load(file)
    f.write(str(19) + ', ' + json.dumps(data['coordinates']))
    f.close()


with open('az_final.json') as file:
    data = json.load(file)
get_boundary_precinct(data)

