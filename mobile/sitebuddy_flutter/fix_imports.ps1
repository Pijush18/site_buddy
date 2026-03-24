# PowerShell script to add SB Design System imports to all files that need them
# This script finds all Dart files that use SbText, SbGap, SbPadding, or SbColors
# and adds the required imports if missing

$baseDir = "d:/My Development/site_buddy/mobile/sitebuddy_flutter/lib"

# Define the required imports
$requiredImports = @(
    "package:site_buddy/core/design_system/sb_text.dart",
    "package:site_buddy/core/design_system/sb_gap.dart",
    "package:site_buddy/core/design_system/sb_padding.dart",
    "package:site_buddy/core/design_system/sb_colors.dart"
)

# Get all Dart files that use SbText, SbGap, SbPadding, or SbColors
$files = Get-ChildItem -Path $baseDir -Filter "*.dart" -Recurse | Where-Object {
    $content = Get-Content $_.FullName -Raw
    $content -match "SbText" -or $content -match "SbGap" -or $content -match "SbPadding" -or $content -match "SbColors"
}

Write-Host "Found $($files.Count) files that use SB components"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Check which imports are missing
    $missingImports = @()
    foreach ($import in $requiredImports) {
        $importName = $import -replace ".*/", ""
        if ($content -match $importName -and $content -notmatch $import) {
            $missingImports += $import
        }
    }
    
    if ($missingImports.Count -gt 0) {
        Write-Host "File: $($file.Name) - Missing $($missingImports.Count) imports"
        
        # Read the file lines
        $lines = Get-Content $file.FullName
        $newLines = @()
        
        # Find the last import line
        $lastImportIndex = -1
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "^import ") {
                $lastImportIndex = $i
            }
        }
        
        # Insert imports after the last import line
        $importsToAdd = $missingImports | ForEach-Object { "import '$_';" }
        
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $newLines += $lines[$i]
            if ($i -eq $lastImportIndex) {
                foreach ($import in $importsToAdd) {
                    $newLines += $import
                }
            }
        }
        
        # Write back
        $newLines | Set-Content $file.FullName
    }
}

Write-Host "Done!"
