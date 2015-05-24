#!/usr/bin/env python

import requests
import os
import json

def getWeatherReports(lat=None, lon=None):
    if lat is None or lon is None:
        raise ValueError("need location to get weather")
    host = "api.openweathermap.org"
    path = "data/2.5/station/find?lat=%s&lon=%s" % ( lat, lon )
    url = "http://%s/%s" % (host, path)
    r = requests.get(url).json()
    return r

def main():
    reports = getWeatherReports(
        lat=os.environ.get('LOCATION_LATITUDE'),
        lon=os.environ.get('LOCATION_LONGITUDE')
    )
    print json.dumps(reports)

main()
