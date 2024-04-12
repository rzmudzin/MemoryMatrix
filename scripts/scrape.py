#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 12 10:05:49 2024

@author: rzmudzinski
"""
from __future__ import annotations
import sys
import os
import json
import argparse
import pathlib
import subprocess
import datetime
import requests
import mechanize
from requests.auth import HTTPBasicAuth
from bs4 import BeautifulSoup
from zipfile import ZipFile
from pathlib import Path
from typing import Callable
# from requests_ntlm import HttpNtlmAuth
from requests_ntlm2 import HttpNtlmAuth, NtlmCompatibility

class LogUpload:
    name: str
    date: str
    size: str

    def __init__(self, name: str, date: str, size: str) -> None:
        self.name = name
        self.date = date
        self.size = size


def isDebug():
    if sys.gettrace():
        return True
    return False

if __name__ == '__main__':
    if isDebug() == False:
        print("Run from terminal")
    else:
        print("Run from debugger")
        
    
    username = 'rzmudzinski'
    password = ''
    ntlm_compatibility = NtlmCompatibility.LM_AND_NTLMv1_WITH_ESS  # => level 1
    auth=HttpNtlmAuth(username, password, ntlm_compatibility=ntlm_compatibility)

    r = requests.get("https://drybook-mobile-tech-support.servpronet.io/admin/support/?pc=1000", auth=auth)
    print("Finished")
    print(r)
    soup = BeautifulSoup(r.content, 'html.parser')
    # print(soup.prettify())
    
    
    logUploads = []
    upload_elements = soup.find_all("tr")
    print("Uploads: " + str(len(upload_elements)))
    for upload_element in upload_elements:
        user_element = upload_element.find("td", class_="user-col")
        time_element = upload_element.find("td", class_="time-col")
        if user_element != None:
            # print(user_element.text + "    " + time_element.text)
            size_elements = upload_element.find_all("td", class_="host-col")
            logUpload = LogUpload(user_element.text, time_element.text, size_elements[1].text)
            logUploads.append(logUpload)
        
    for logUpload in logUploads:
        print(logUpload.name + "    " + logUpload.date + "    " + logUpload.size)
        
    print("Log Uploads: " + str(len(logUploads)))
    
    


  # <tr class="odd-row">
  #   <td class="user-col" style="white-space:nowrap;">
  #    dmz.servpro.int\F08245RG
  #   </td>
  #   <td class="host-col" style="white-space:nowrap;">
  #    logs
  #   </td>
  #   <td class="time-col" style="white-space:nowrap;">
  #    4/12/2024 7:02:40 AM
  #   </td>
  #   <td class="host-col" style="white-space:nowrap;">
  #    649897
  #   </td>
  #   <td class="time-col" style="white-space:nowrap;">
  #    <a href="/admin/support/b1f1b036-da63-4a98-b2fe-a02259310b76">
  #     Download
  #    </a>
  #   </td>
  #   <td class="time-col" style="white-space:nowrap;">
  #    <a class="deleteLink" href="/admin/support/delete/b1f1b036-da63-4a98-b2fe-a02259310b76">
  #     Delete
  #    </a>
  #   </td>