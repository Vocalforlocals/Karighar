Add-Type -AssemblyName System.Drawing

$srcPath = 'C:\Users\bhask\.gemini\antigravity\brain\eb1a8ff8-7628-4807-85dd-7401bb9f6ffe\.user_uploaded\media_1789302394662.jpg'
$img = [System.Drawing.Image]::FromFile($srcPath)

function Save-ResizedPng($targetPath, $w, $h) {
    $dir = Split-Path -Path $targetPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($img, 0, 0, $w, $h)
    $bmp.Save($targetPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Generated $targetPath ($w x $h)"
}

Save-ResizedPng 'web/favicon.png' 64 64
Save-ResizedPng 'web/favicon.ico' 64 64
Save-ResizedPng 'web/icons/Icon-192.png' 192 192
Save-ResizedPng 'web/icons/Icon-512.png' 512 512
Save-ResizedPng 'web/icons/Icon-maskable-192.png' 192 192
Save-ResizedPng 'web/icons/Icon-maskable-512.png' 512 512

Save-ResizedPng 'build/web/favicon.png' 64 64
Save-ResizedPng 'build/web/favicon.ico' 64 64
Save-ResizedPng 'build/web/icons/Icon-192.png' 192 192
Save-ResizedPng 'build/web/icons/Icon-512.png' 512 512
Save-ResizedPng 'build/web/icons/Icon-maskable-192.png' 192 192
Save-ResizedPng 'build/web/icons/Icon-maskable-512.png' 512 512

Save-ResizedPng 'assets/images/karighar_logo.png' 512 512

$img.Dispose()
Write-Host "All Karighar favicons and web icons successfully generated as genuine PNGs!"
