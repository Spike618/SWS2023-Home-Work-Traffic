import requests
import json
import urllib
from geopy.geocoders import Nominatim

date_time = '2023-07-13T09:00:00'
data_url = 'https://api.data.gov.sg/v1/transport/traffic-images/'
tomtom_rev_geocoding_url = 'https://api.tomtom.com/search/2/reverseGeocode/crossStreet/%s.json'
tomtom_geocoding_url = 'https://api.tomtom.com/search/2/structuredGeocode.json'

geolocator = Nominatim(user_agent='BuyiXiao')


def tomtom_rev_geocoding(latitude, longitude):
    params = {'key': 'ze8YSxPAewmBAh4GbX0coKQz6Yuib3Bz', }
    url = tomtom_rev_geocoding_url % urllib.parse.quote_plus('%s,%s' % (latitude, longitude))
    res = requests.get(url=url, params=params)
    content = json.loads(res.text)
    if content['summary']['numResults'] != 0:
        street = content['addresses'][0]['address']
        return street['street'], street['crossStreet']
    return None, ''


def tomtom_geocoding(street_name, cross_street):
    params = {'key': 'ze8YSxPAewmBAh4GbX0coKQz6Yuib3Bz',
              'countryCode': 'SG',
              'streetName': street_name,
              'crossStreet': cross_street}
    res = requests.get(url=tomtom_geocoding_url, params=params)
    content = json.loads(res.text)
    cnt = content['summary']['numResults']
    points = []
    for i in range(cnt):
        result = content['results'][i]
        points.append({'latitude': result['position']['lat'],
                       'longitude': result['position']['lon']})
    street_detail = {'cnt': cnt, 'points': points}
    return street_detail


def main():
    data_params = {'date_time': date_time}
    data_res = requests.get(url=data_url, params=data_params)
    cameras = json.loads(data_res.text)['items'][0]['cameras']

    data = []
    for camera in cameras:
        location = geolocator.reverse("%s %s" % (camera['location']['latitude'], camera['location']['longitude'])).raw
        street_name, cross_street = tomtom_rev_geocoding(camera['location']['latitude'], camera['location']['longitude'])
        if street_name is None:
            try:
                street_name = location['address']['road']
            except:
                street_name = location['address']['suburb']
        street_detail = tomtom_geocoding(street_name, cross_street)

        data.append({'camera_id': camera['camera_id'],
                     'camera_latitude': camera['location']['latitude'],
                     'camera_longitude': camera['location']['longitude'],
                     'street_name': street_name,
                     'free_form_address': location['display_name'],
                     'postcode': '%06s' % location['address']['postcode'],
                     'street_detail': street_detail})

    with open('camera_location.json', 'w') as f:
        json.dump(data, f)


if __name__ == '__main__':
    main()

''' geolocator.reverse(lat_lon).raw 的格式
{'place_id': 97107631, 
 'licence': 'Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright',
 'osm_type': 'node',
 'osm_id': 9708507381, 
 'lat': '1.2953205',
 'lon': '103.8711456',
 'display_name': 'KPE/ECP, East Coast Parkway, Tanjong Rhu, Kallang, Southeast, 437440, Singapore',
 'address': {'man_made': 'KPE/ECP',
             'road': 'East Coast Parkway',
             'quarter': 'Tanjong Rhu',
             'suburb': 'Kallang',
             'county': 'Southeast',
             'ISO3166-2-lvl6': 'SG-04',
             'postcode': '437440',
             'country': 'Singapore',
             'country_code': 'sg'}, 
 'boundingbox': ['1.2952705','1.2953705','103.8710956','103.8711956']}
 
 {'place_id': 223428868, 
  'licence': 'Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright', 
  'osm_type': 'way',
  'osm_id': 539518181, 
  'lat': '1.3474126659585601', 
  'lon': '103.6366151316512', 
  'display_name': 'Tuas, Southwest, 639937, Singapore', 
  'address': {'suburb': 'Tuas',
              'county': 'Southwest',
              'ISO3166-2-lvl6': 'SG-05',
              'postcode': '639937',
              'country': 'Singapore',
              'country_code': 'sg'},
  'boundingbox': ['1.347377', '1.347466', '103.6364604', '103.6367789']}
'''
