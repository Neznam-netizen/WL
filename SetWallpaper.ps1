# Cesta do Dokumentů
$docFolder = [Environment]::GetFolderPath("MyDocuments")
$path = Join-Path -Path $docFolder -ChildPath "tapeta.jpg"

# URL obrázku
$url = "https://images.pexels.com/photos/206359/pexels-photo-206359.jpeg"

# Ujisti se, že složka existuje
if (-not (Test-Path $docFolder)) {
    New-Item -ItemType Directory -Path $docFolder | Out-Null
}

try {
    # 1️⃣ Stáhnout obrázek (přepíše starý)
    Invoke-WebRequest -Uri $url -OutFile $path -UseBasicParsing -ErrorAction Stop

    # 2️⃣ Nastavit tapetu přes SystemParametersInfo (spolehlivější než registr)
    Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
  [DllImport("user32.dll", CharSet = CharSet.Auto)]
  public static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

    # SPI_SETDESKWALLPAPER = 20, SPIF_UPDATEINIFILE = 0x01, SPIF_SENDCHANGE = 0x02
    [Wallpaper]::SystemParametersInfo(20, 0, $path, 0x01 -bor 0x02)

}
catch {
    Write-Output "Nepodařilo se stáhnout nebo nastavit tapetu: $_"
}
