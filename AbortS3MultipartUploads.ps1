$outstandingMultiPartUploads = 0;

Do
{
    $content = scripts\aws s3api list-multipart-uploads --bucket <bucket-name> | ConvertFrom-Json 
    $uploads = $content.Uploads
    $outstandingMultiPartUploads = $uploads.Count

    Write-Host $(Get-Date -Format u): --- Recieved $outstandingMultiPartUploads outstanding uploads to abort ---


    $uploads | ForEach-Object{
        scripts\aws s3api abort-multipart-upload --bucket <bucket-name> --key $_.Key --upload-id $_.UploadId 
        Write-Host $(Get-Date -Format u): Done: $_.Key
    }

    Write-Host $(Get-Date -Format u): --- Aborted $outstandingMultiPartUploads outstanding uploads ---

} Until($outstandingMultiPartUploads -eq 0)