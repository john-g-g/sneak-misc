#!/Users/sneak/dev/venv-2.7/bin/python
# shouts to @AskAmex for being a replicant and 
# David Bartle for making a very difficult-to-use ofxclient library
# 2013 jeffrey paul <sneak@datavibe.net>
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2

from pprint import pformat
import os
import re
import json
from ofxclient.request import Builder as OFXClientBuilder
from scraper import FinancialScraper, MockInstitution

class AmexScraper(FinancialScraper):
    def isBank(self):
        return False
    def isCC(self):
        return True
    def getInstitution(self):
        return MockInstitution(
            user=self.user,
            password=self.password,
            url='https://online.americanexpress.com/myca/ofxdl/desktop/' +
                'desktopDownload.do?request_type=nl_ofxdownload',
            org='AMEX',
            fid='3101'
        )
       
def main():
    s = AmexScraper(
        user=os.environ['AMEXUSERNAME'],
        password=os.environ['AMEXPASSWORD']
    )
    print json.dumps(s.scrape())

if __name__=="__main__":
    main()
