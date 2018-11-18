<#   
.SYNOPSIS   
   Powershell script to download the dependency and configure the project for run
.DESCRIPTION 
   Downloads the dependencies from github and add them to folder for running simulation. 
.NOTES   
    Name: configure_ip
    Author: Farshad
    DateCreated: 17 Nov 2018 
.PARAMETER json
    path to ip_list.json file. Default is set to . (i.e. directory where the script is running)
.PARAMETER downloadonly
    When specified the script will download only the repository files in archieve format. 
    Useful when files are downloaded on a seperate computer and simulation is run on a different computer.
.PARAMETER downdir
    Specifies the download directory for the ips. Default is set to . (i.e. directory where the script is running)
    If you intent to change the default path then you should provide that path when the script is running
.PARAMETER config_only
    Configure the downloaded ips to their respective folders in current workspace.
.PARAMETER outputdir
    Path to where the ips will be extracted to be used in project.
.PARAMETER verilogonly
    download verilog files only into the path specified by outputdir          
.EXAMPLE
   configure_ip.ps1
.EXAMPLE
   configure_ip.ps1 [[-json] <path_to_ip_list.json>] [-downloadonly] [[-downdir] <path_to_download_folder>] [-config_only] [[-outputdir] <path_to_output_folder>]  
.EXAMPLE
   configure_ip.ps1 [-downloadly] [[-downdir] <path_to_download_folder>]      
#>

param(
    [string] $json = "ip_list.json",
    [switch] $downloadonly = $false,
    [string] $downdir = ".",
    [switch] $config_only = $false,
    [string] $outputdir = "..\ips",
    [switch] $verilogonly = $false
)

Add-Type -AssemblyName System.IO.Compression.FileSystem
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Check input aruments
#Write-Host $json
#Write-Host $downloadonly
#Write-Host $downdir
#Write-Host $config_only
#Write-Host $outputdir

# Extract the files from the downloaddir to outputdir
if($config_only){
    # list all the archieve files in downloaddir
    $zipfolderjson = Get-ChildItem $downdir\*.zip | ConvertTo-Json
    $zipfolders = ConvertFrom-Json $zipfolderjson
    foreach($zipfolder in $zipfolders.Name){
        # Resolve the relative path to absolute path
        $zip_file_path = Resolve-Path $outfile
        $abs_ip_dir_path = Resolve-Path $outputdir
        #Write-Host $zip_file_path 
        #Write-Host $abs_ip_dir_path
        # Extract Zip files and copy them in respective folder
        Write-Host "Extracting "$zip_file_path " to "$abs_ip_dir_path
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zip_file_path, $abs_ip_dir_path)
    }   
}
# check if ip_list.json file exists
elseif(Test-Path $json){
    # Read the Json file
    $jsondata = Get-Content -Raw -Path $json | ConvertFrom-Json
    # Download selected verilog/systemverilog files only
    if($verilogonly){
        foreach($ip in $jsondata.ips){
            foreach($verilogFile in $ip.'verilog-files'){
                Write-Host "Fetching "$verilogFile.url
                $req = [System.Net.HttpWebRequest]::Create($verilogFile.url)
                $req.Method = "HEAD"
                $response = $req.GetResponse()
                $fUri = $response.ResponseUri
                $filename = [System.IO.Path]::GetFileName($fUri.LocalPath); 
                $response.Close()
                $target = join-path $outputdir $filename 
                Invoke-WebRequest -Uri $verilogFile.url -OutFile $target 
                
            }
        }
    }
    # download the whole repository
    else{
        foreach($ip in $jsondata.ips){
            Write-Host "fetching files from:"
            Write-Host $ip.repo.'zip-url'
            $outfile = $downdir+"\"+$ip.name+".zip"
            Write-Host $outfile
            
            Invoke-WebRequest -Uri $ip.repo.'zip-url' -OutFile $outfile
            # do not extract and copy the files in ip folder if downloadonly flag is set 
            if(!$downloadonly){
                # Resolve the relative path to absolute path
                $zip_file_path = Resolve-Path $outfile
                $abs_ip_dir_path = Resolve-Path $outputdir
                #Write-Host $zip_file_path 
                #Write-Host $abs_ip_dir_path
                # Extract Zip files and copy them in respective folder
                Write-Host "Extracting "$zip_file_path " to "$abs_ip_dir_path
                [System.IO.Compression.ZipFile]::ExtractToDirectory($zip_file_path, $abs_ip_dir_path)
            }     
        }
    }
}
else {
    Write-Error "ip_list.json is not found. Script is exiting.."
}
