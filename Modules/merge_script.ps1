param([string]$workingDirectory, [string]$itext_sharp, [string]$output_file)

$pdfs = ls $workingDirectory -recurse | where {-not $_.PSIsContainer -and $_.Extension -imatch "^\.pdf$"};

[void] [System.Reflection.Assembly]::LoadFrom(
    [System.IO.Path]::Combine($workingDirectory, $itext_sharp)
);

$output = [System.IO.Path]::Combine($workingDirectory, $output_file);
$fileStream = New-Object System.IO.FileStream($output, [System.IO.FileMode]::OpenOrCreate);
$document = New-Object iTextSharp.text.Document;
$pdfCopy = New-Object iTextSharp.text.pdf.PdfCopy -ArgumentList ($document, $fileStream);
$document.Open();

foreach ($pdf in $pdfs) 
{

    $reader = New-Object iTextSharp.text.pdf.PdfReader($pdf.FullName);
    $pdfCopy.AddDocument($reader); 
    $reader.Dispose();  
}

$pdfCopy.Dispose();
$document.Dispose();
$fileStream.Dispose();