#!/usr/bin/env python

from bs4 import BeautifulSoup
from datetime import datetime, date, timedelta
import cookielib
import getpass
import os
import re
import requests
import sys

cookie_jar = cookielib.LWPCookieJar(os.path.join(os.environ['HOME'], '.nez-session-cookie.txt'))
top_level_url = "https://batsint.bats.com"

def authenticate():
    print "Need to re-authenticate"

    if not sys.stdout.isatty():
        sys.exit(1)

    try:
        response = requests.get(top_level_url, cookies=cookie_jar, auth=(getpass.getuser(), getpass.getpass()))
    except KeyboardInterrupt:
        sys.exit(1)

    for cookie in response.cookies:
        cookie_jar.set_cookie(cookie)

    cookie_jar.save()

def get_next_lunch_dates(today, now):
    today_date = datetime.combine(today, datetime.min.time())
    today_weekday = today_date.weekday()
    monday = today_date - timedelta(days=today_weekday)
    if now > today_date + timedelta(hours=12):
        if today_weekday >= 4:
            today_date += timedelta(days=(7 - today_weekday))
            monday = today_date
        else:
            today_date += timedelta(days=1)

    return (monday, today_date)

def main():
    try:
        cookie_jar.load()
    except:
        authenticate()

    response = requests.get(top_level_url, cookies=cookie_jar)
    while response.status_code != 200:
        cookie_jar.clear()
        authenticate()
        response = requests.get(top_level_url, cookies=cookie_jar)

    monday, today = get_next_lunch_dates(date.today(), datetime.now())
    monday = str(monday.day)
    today = today.strftime('%a')

    html = BeautifulSoup(response.content, 'html.parser')
    for item in html.find_all('td', text=re.compile(r'Week of .+' + monday)):
        day_label = item.parent.parent.find('th', text=re.compile(today))
        if day_label and day_label.next_sibling.next_sibling.text != '':
            lunch = day_label.next_sibling.next_sibling
            if len(sys.argv) == 1:
                print lunch.text
            elif lunch.a:
                print lunch.a['href']
            break
    else:
        print 'No lunch found'

if __name__ == "__main__":
    main()
