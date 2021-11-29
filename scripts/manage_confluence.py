from requests import HTTPError
from atlassian import Confluence
import os

class ManageConfluence:

    url = "https://amway.codefactori.com/confluence"
    space_key = 'SFDTDT'

    def __init__(self, user, password):
        self.user = user
        self.password = password
        if os.environ['environment'] == "test":
            self.parent_page_id = 150287031
        elif os.environ['environment'] == "prod":
            self.parent_page_id = 150287423
        else:
            print('environment variable not set in codebuild. hence throwing error. '+ os.environ['environment'])
            raise ValueError('Please set enviornment-variable with name `environment` in codebuild.') 

    def delete_page(self, team_name):
        page_title = team_name
        try:
            confluence = Confluence(
                url=self.url,
                username=self.user,
                password=self.password,
                api_version='cloud'
            )
            page_exist_resp = confluence.get_page_by_title(space=self.space_key,
                                                title=page_title)
            if page_exist_resp is not None:
                curr_page_id = page_exist_resp["id"]
                confluence.remove_page(page_id=curr_page_id)
                print("Confluence Page deleted successfully. curr_page_id==> ", curr_page_id)
            else:
                print("No page found on confluence with page_name: ", page_title)            
        except HTTPError as e :
            print("Error occur:", e)
            raise        

    def create_update_page(self, team_name, page_html):
        page_title = team_name
        try:
            confluence = Confluence(
                url=self.url,
                username=self.user,
                password=self.password,
                api_version='cloud'
            )
            page_exist_resp = confluence.get_page_by_title(space=self.space_key,
                                                title=page_title)
            if page_exist_resp is not None:
                old_page_id = page_exist_resp["id"]
                print("old_page_id==>", old_page_id)
                status = confluence.update_page(
                    parent_id=self.parent_page_id,
                    page_id=old_page_id,
                    title=page_title,
                    body=page_html,
                )
                print("Page Updated Successfully.")
            else:
                status = confluence.create_page(
                    space=self.space_key,
                    title=page_title,
                    parent_id=self.parent_page_id,
                    body=page_html)
                print("Page Created Successfully.")
        except HTTPError as e :
            print("Error occur:", e)
            raise
    