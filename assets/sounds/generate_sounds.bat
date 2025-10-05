@echo off
REM Batch script to generate simple WAV beep sounds using ffmpeg
REM Requires ffmpeg to be installed: https://ffmpeg.org/download.html

echo Checking for ffmpeg...
where ffmpeg >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: ffmpeg is not installed or not in PATH
    echo Please install ffmpeg from: https://ffmpeg.org/download.html
    pause
    exit /b 1
)

echo Generating retro game sounds...
echo.

REM Generate each sound with different frequencies and durations
echo Generating eat.wav...
ffmpeg -f lavfi -i "sine=frequency=800:duration=0.1" -ar 22050 -ac 1 -y eat.wav 2>nul

echo Generating crash.wav...
ffmpeg -f lavfi -i "sine=frequency=200:duration=0.3" -ar 22050 -ac 1 -y crash.wav 2>nul

echo Generating menu_click.wav...
ffmpeg -f lavfi -i "sine=frequency=600:duration=0.05" -ar 22050 -ac 1 -y menu_click.wav 2>nul

echo Generating select.wav...
ffmpeg -f lavfi -i "sine=frequency=1000:duration=0.15" -ar 22050 -ac 1 -y select.wav 2>nul

echo Generating move.wav...
ffmpeg -f lavfi -i "sine=frequency=400:duration=0.03" -ar 22050 -ac 1 -y move.wav 2>nul

echo Generating level_complete.wav...
ffmpeg -f lavfi -i "sine=frequency=1200:duration=0.5" -ar 22050 -ac 1 -y level_complete.wav 2>nul

echo Generating achievement.wav...
ffmpeg -f lavfi -i "sine=frequency=900:duration=0.4" -ar 22050 -ac 1 -y achievement.wav 2>nul

echo Generating high_score.wav...
ffmpeg -f lavfi -i "sine=frequency=1500:duration=0.6" -ar 22050 -ac 1 -y high_score.wav 2>nul

echo.
echo Sound generation complete!
echo Files created in: %~dp0
echo.
echo Note: These are simple sine wave beeps.
echo For better quality, use Bfxr.net or download retro sounds.
echo.
pause
