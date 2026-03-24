# Enhanced SB Design System Fix Script v3
# Handles all remaining compile errors

Write-Host "Starting enhanced SB Design System fixes v3..." -ForegroundColor Cyan

# ============================================================================
# PATTERN 1: Remove const from SbPadding static const references
# ============================================================================
Write-Host "`n[1/10] Fixing const SbPadding references..." -ForegroundColor Yellow

$patterns = @(
    @{ Old = 'const SbPadding\.allXs'; New = 'SbPadding.allXs' },
    @{ Old = 'const SbPadding\.allSm'; New = 'SbPadding.allSm' },
    @{ Old = 'const SbPadding\.allMd'; New = 'SbPadding.allMd' },
    @{ Old = 'const SbPadding\.allLg'; New = 'SbPadding.allLg' },
    @{ Old = 'const SbPadding\.allXl'; New = 'SbPadding.allXl' },
    @{ Old = 'const SbPadding\.allXxl'; New = 'SbPadding.allXxl' }
)

$files = Get-ChildItem -Path "lib" -Recurse -Include "*.dart"
foreach ($pattern in $patterns) {
    Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        if ($content -match [regex]::Escape($pattern.Old)) {
            $newContent = $content -replace [regex]::Escape($pattern.Old), $pattern.New
            Set-Content -Path $_.FullName -Value $newContent
            Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
        }
    }
}

# ============================================================================
# PATTERN 2: Remove const from SbPadding.symmetric
# ============================================================================
Write-Host "`n[2/10] Fixing const SbPadding.symmetric..." -ForegroundColor Yellow

Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match 'const\s+SbPadding\.symmetric') {
        $newContent = $content -replace 'const\s+SbPadding\.symmetric', 'SbPadding.symmetric'
        Set-Content -Path $_.FullName -Value $newContent
        Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
    }
}

# ============================================================================
# PATTERN 3: Remove const from Icon(SbIcons.xxx)
# ============================================================================
Write-Host "`n[3/10] Fixing const Icon(SbIcons.xxx)..." -ForegroundColor Yellow

Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match 'const\s+Icon\(SbIcons\.\w+') {
        $newContent = $content -replace 'const\s+Icon\(SbIcons\.(\w+)', 'Icon(SbIcons.$1'
        Set-Content -Path $_.FullName -Value $newContent
        Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
    }
}

# ============================================================================
# PATTERN 4: Remove const from const SnackBar(content: SbText.body)
# ============================================================================
Write-Host "`n[4/10] Fixing const SnackBar..." -ForegroundColor Yellow

Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match 'const\s+SnackBar\(content:\s+SbText\.body') {
        $newContent = $content -replace 'const\s+SnackBar\(content:', 'SnackBar(content:'
        Set-Content -Path $_.FullName -Value $newContent
        Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
    }
}

# ============================================================================
# PATTERN 5: Fix const Scaffold/SnackBar with SbText
# ============================================================================
Write-Host "`n[5/10] Fixing const Scaffold..." -ForegroundColor Yellow

Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match 'const\s+Scaffold\(') {
        # Remove const from Scaffold that might have SbText.body
        $newContent = $content -replace 'const\s+Scaffold\(', 'Scaffold('
        Set-Content -Path $_.FullName -Value $newContent
        Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
    }
}

# ============================================================================
# PATTERN 6: Fix const TextButton/ElevatedButton with child
# ============================================================================
Write-Host "`n[6/10] Fixing const buttons..." -ForegroundColor Yellow

Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match 'const\s+(TextButton|ElevatedButton|OutlinedButton|IconButton)\(') {
        $newContent = $content -replace 'const\s+(TextButton|ElevatedButton|OutlinedButton|IconButton)\(', '$1('
        Set-Content -Path $_.FullName -Value $newContent
        Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
    }
}

# ============================================================================
# PATTERN 7: Fix const Container with SbText
# ============================================================================
Write-Host "`n[7/10] Fixing const Container..." -ForegroundColor Yellow

Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match 'const\s+Container\(child:\s+SbText\.body') {
        $newContent = $content -replace 'const\s+Container\(child:', 'Container(child:'
        Set-Content -Path $_.FullName -Value $newContent
        Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
    }
}

# ============================================================================
# PATTERN 8: Fix Icon() wrapping IconData incorrectly
# ============================================================================
Write-Host "`n[8/10] Fixing Icon wrapping issues..." -ForegroundColor Yellow

Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    # Fix Icon(Icon(Icons.xxx)) pattern
    if ($content -match 'Icon\(Icon\(') {
        $newContent = $content -replace 'Icon\(Icon\(', 'Icon('
        Set-Content -Path $_.FullName -Value $newContent
        Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
    }
    # Fix icon: const Icon(Icons.xxx) where icon expects IconData
    if ($content -match 'icon:\s+const\s+Icon\(') {
        $newContent = $content -replace 'icon:\s+const\s+Icon\(', 'icon: Icon('
        Set-Content -Path $_.FullName -Value $newContent
        Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
    }
}

# ============================================================================
# PATTERN 9: Add SB import where missing (for SBIconButton usage)
# ============================================================================
Write-Host "`n[9/10] Ensuring SB imports..." -ForegroundColor Yellow

$sbImport = "import 'package:site_buddy/core/design_system/sb.dart';"

Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    # Check if file uses SB components but doesn't have the import
    if (($content -match 'SBIconButton|SBButton\.' -or $content -match 'SbPadding\.|SbText\.' -or $content -match 'SbGap\.|SbColors\.') -and $content -notmatch "site_buddy/core/design_system/sb\.dart") {
        # Check if it already imports sb_widgets.dart or individual sb files
        if ($content -notmatch "site_buddy/core/design_system/sb_widgets\.dart" -and $content -notmatch "site_buddy/core/design_system/sb_button\.dart" -and $content -notmatch "site_buddy/core/design_system/sb_padding\.dart") {
            # Add import after package imports
            if ($content -match "^import 'package:flutter") {
                $newContent = $content -replace "(^import 'package:flutter.*?;)", "`$1`n$sbImport"
                Set-Content -Path $_.FullName -Value $newContent
                Write-Host "  Added import to: $($_.FullName)" -ForegroundColor Green
            }
        }
    }
}

# ============================================================================
# PATTERN 10: Fix child: SbText.body in button factories
# ============================================================================
Write-Host "`n[10/10] Fixing SBButton child parameter..." -ForegroundColor Yellow

Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    # Fix child: SbText.body in SBButton factory calls
    if ($content -match 'child:\s+SbText\.body') {
        $newContent = $content -replace 'child:\s+SbText\.body\(([^)]+)\)', 'label: $1'
        if ($newContent -ne $content) {
            Set-Content -Path $_.FullName -Value $newContent
            Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
        }
    }
}

# ============================================================================
# FINAL: Fix any remaining patterns
# ============================================================================
Write-Host "`n[FINAL] Final cleanup..." -ForegroundColor Yellow

# Fix const SizedBox with SbText
Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match 'const\s+SizedBox\(child:\s+SbText') {
        $newContent = $content -replace 'const\s+SizedBox\(child:', 'SizedBox(child:'
        Set-Content -Path $_.FullName -Value $newContent
        Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
    }
}

# Fix const Padding with SbText
Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match 'const\s+Padding\(child:\s+SbText') {
        $newContent = $content -replace 'const\s+Padding\(child:', 'Padding(child:'
        Set-Content -Path $_.FullName -Value $newContent
        Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
    }
}

# Fix const Column/Row with SbText
Get-ChildItem -Path "lib" -Recurse -Include "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match 'const\s+(Column|Row)\([^)]*children:\s+\[\s*SbText') {
        $newContent = $content -replace 'const\s+(Column|Row)\(([^)]*children:)\s+\[', '$1(($2)['
        Set-Content -Path $_.FullName -Value $newContent
        Write-Host "  Fixed: $($_.FullName)" -ForegroundColor Green
    }
}

Write-Host "`nEnhanced fixes v3 complete!" -ForegroundColor Cyan
