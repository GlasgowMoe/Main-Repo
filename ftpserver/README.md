# Windows FTP Server Automation

## Intro
This Module allows you to install Windows FTP Server on the following Operating systems. 

- Windows Server 2012
- Windows Server 2016
- Windows Server 2019 

## Usage
In the property JSON of a Windows Server in VCAMP you use the following format: 

```
{
  "software": {
    "ftpserver": {
      "dir": "C:\\FTProot",
      "ssl": true,
      "sitename": "Automated-ftp-1"
    }
  }
}
```
HINT: There is no need to select any Vcamp role. 

The Double "\\\\" is an escape character used in the file path. Make sure to create the directory manually in the server first then include the double backsalsh in the JSON e.g. "C:\\Test\\FTPServer"

The Directory will have "CustomerCode\FTPUsers" with FULL READ/Write permissions. 

"ssl": true <- This tag enables secure SSL communiction (This is optional)

## Contributors
Moe Kandi
Version 2.0 