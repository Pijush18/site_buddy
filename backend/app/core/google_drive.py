from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
from app.core.config import settings
import os

def get_drive_service():
    """
    Initialize Google Drive API client using service account credentials.
    """
    if not settings.GOOGLE_APPLICATION_CREDENTIALS:
        raise Exception("GOOGLE_APPLICATION_CREDENTIALS environment variable not set")
    
    # Path to the service account JSON file
    creds_path = settings.GOOGLE_APPLICATION_CREDENTIALS
    
    scopes = ['https://www.googleapis.com/auth/drive.file']
    creds = service_account.Credentials.from_service_account_file(
        creds_path, scopes=scopes
    )
    
    service = build('drive', 'v3', credentials=creds)
    return service

def upload_file_to_drive(file_path: str, folder_id: str = None):
    """
    Upload a file to Google Drive and return file info.
    """
    service = get_drive_service()
    
    file_name = os.path.basename(file_path)
    file_metadata = {'name': file_name}
    
    if folder_id or settings.GOOGLE_DRIVE_FOLDER_ID:
        target_folder = folder_id or settings.GOOGLE_DRIVE_FOLDER_ID
        file_metadata['parents'] = [target_folder]
        
    media = MediaFileUpload(file_path, resumable=True)
    
    file = service.files().create(
        body=file_metadata,
        media_body=media,
        fields='id, webViewLink'
    ).execute()
    
    return {
        "file_id": file.get('id'),
        "file_url": file.get('webViewLink'),
        "file_name": file_name
    }
