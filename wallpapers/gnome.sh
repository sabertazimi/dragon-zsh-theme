#!/usr/bin/env bash

# Copy GNOME wallpapers (.jxl) and convert to .png
# Source: /usr/share/backgrounds/gnome/

set -euo pipefail

SOURCE_DIR="/usr/share/backgrounds/gnome"
TARGET_DIR="$HOME/.local/share/wallpapers"
TEMP_DIR=$(mktemp -d)

# Cleanup function
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Create target directory if it doesn't exist
if ! mkdir -p "$TARGET_DIR"; then
    echo "Error: Failed to create target directory '$TARGET_DIR'" >&2
    exit 1
fi

# Check if source directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Warning: Source directory '$SOURCE_DIR' not found. Skipping." >&2
    exit 0
fi

# Check if ImageMagick is available
if ! command -v magick &> /dev/null; then
    echo "Warning: ImageMagick 'magick' command not found. Please install imagemagick." >&2
    echo "  Skipping .jxl to .png conversion." >&2
    exit 0
fi

# Copy .jxl files to temp directory
echo "Copying GNOME .jxl wallpapers from $SOURCE_DIR..."
count=0
file=""
while IFS= read -r -d '' file || [[ -n "$file" ]]; do
    filename=$(basename "$file")
    if cp -n "$file" "$TEMP_DIR/$filename"; then
        count=$((count + 1))
        echo "  Copied: $filename"
    else
        echo "  Warning: Failed to copy $filename" >&2
    fi
done < <(command find "$SOURCE_DIR" -maxdepth 1 -type f -iname "*-d.jxl" -print0)

if [[ $count -eq 0 ]]; then
    echo "No .jxl files found in $SOURCE_DIR"
    exit 0
fi

echo "Converting $count .jxl file(s) to .png (using $(nproc) parallel jobs)..."
# Convert all .jxl files to .png in parallel
cd "$TEMP_DIR"
converted=0
for jxl_file in *.jxl; do
    [[ -f "$jxl_file" ]] || continue
    basename="${jxl_file%.jxl}"
    echo "  Converting: $jxl_file"
    # Use background jobs for parallel conversion
    (
        if magick "$jxl_file" "${basename}.png" 2>/dev/null; then
            echo "  ✓ Converted: $jxl_file -> ${basename}.png"
            rm -f "$jxl_file"
        else
            echo "  ✗ Failed: $jxl_file" >&2
        fi
    ) &
    # Limit parallel jobs to CPU count
    if (( $(jobs -r | wc -l) >= $(nproc) )); then
        wait -n
    fi
done
wait
# Count converted files
converted=$(ls -1 *.png 2>/dev/null | wc -l)

# Move .png files to target directory
echo "Moving $converted .png file(s) to $TARGET_DIR..."
moved=0
for png_file in *.png; do
    [[ -f "$png_file" ]] || continue
    if cp -n "$png_file" "$TARGET_DIR/$png_file"; then
        moved=$((moved + 1))
        echo "  Moved: $png_file"
    else
        echo "  Warning: Failed to move $png_file" >&2
    fi
done

echo "Complete: $moved wallpaper(s) copied to $TARGET_DIR"
