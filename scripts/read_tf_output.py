#!/usr/bin/env python

import json
import os
import sys
from json2html import *
from manage_confluence import ManageConfluence

def main():
    try:
        print("Passed argument is:", sys.argv[1])
        print("CF_PAGE_NAME is ==> ",os.environ['CF_PAGE_NAME'])
        conf = ManageConfluence(os.environ['CF_USER'], os.environ['CF_PASSD'])
        if sys.argv[1] and sys.argv[1].lower() == "destroy" :
            conf.delete_page(os.environ['CF_PAGE_NAME'])
        else:
            with open(os.environ['CODEBUILD_SRC_DIR']+'/tf_output.json') as f:
                json_contain = f.read()
                if("null" in json_contain):
                    print("file contain null!")
                    sys.exit(0)
                else:
                    output_html = json2html.convert(json = json_contain)
                    conf.create_update_page(os.environ['CF_PAGE_NAME'], output_html)
                    print("Execution completed.")
    except Exception as e:
        print("Error occur ==> ", e)
        sys.exit(1)

if __name__ == '__main__':
    main()