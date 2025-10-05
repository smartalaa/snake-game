# PowerShell script to generate simple WAV beep sounds using ffmpeg
# Requires ffmpeg to be installed: https://ffmpeg.org/download.html

$soundsDir = $PSScriptRoot

# Check if ffmpeg is available
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: ffmpeg is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install ffmpeg from: https://ffmpeg.org/download.html" -ForegroundColor Yellow
    exit 1
}

Write-Host "Generating retro game sounds..." -ForegroundColor Green

# Function to generate a beep sound
function Generate-Beep {
    param(
        [string]$filename,
        [string]$frequency,
        [string]$duration
    )
    
    $output = Join-Path $soundsDir $filename
    
    # Generate sine wave beep
    ffmpeg -f lavfi -i "sine=frequency=$frequency:duration=$duration" -ar 22050 -ac 1 -y $output 2>$null
    
    if ($?) {
        Write-Host "✓ Generated: $filename" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed: $filename" -ForegroundColor Red
    }
}

# Generate each sound with different frequencies and durations
Generate-Beep "eat.wav" "800" "0.1"              # High pitched short beep
Generate-Beep "crash.wav" "200" "0.3"            # Low pitched longer beep
Generate-Beep "menu_click.wav" "600" "0.05"      # Medium pitched very short
Generate-Beep "select.wav" "1000" "0.15"         # High pitched medium
Generate-Beep "move.wav" "400" "0.03"            # Low pitched very short
Generate-Beep "level_complete.wav" "1200" "0.5"  # Very high pitched long
Generate-Beep "achievement.wav" "900" "0.4"      # High pitched long
Generate-Beep "high_score.wav" "1500" "0.6"      # Highest pitched longest

Write-Host ""
Write-Host "Sound generation complete!" -ForegroundColor Cyan
Write-Host "Files created in: $soundsDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "Note: These are simple sine wave beeps." -ForegroundColor Yellow
Write-Host "For better quality, use Bfxr.net or download retro sounds." -ForegroundColor Yellow
