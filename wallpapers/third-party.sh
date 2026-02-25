#!/usr/bin/env bash

# Download third-party wallpapers from URLs
# Usage: third-party.sh [URL...]

set -euo pipefail

TARGET_DIR="$HOME/.local/share/wallpapers"
MAX_RETRIES="${MAX_RETRIES:-3}"
TEMP_DIR=$(mktemp -d)

# Cleanup function
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Build GitHub raw content URL
# Args: user repo path [branch]
# Example: github_raw_url dharmx walls cherry/image.png main
github_raw_url() {
    local user="$1"
    local repo="$2"
    local path="$3"
    local branch="${4:-main}"  # Default to main branch
    echo "https://raw.githubusercontent.com/${user}/${repo}/${branch}/${path}"
}

# Download with retry mechanism
# Args: url target_path retries
download_with_retry() {
    local url="$1"
    local target_path="$2"
    local max_retries="${3:-$MAX_RETRIES}"
    local filename=$(basename "$url")
    local attempt=1

    while (( attempt <= max_retries )); do
        if curl -fsSL --max-time 10 -o "$target_path" "$url"; then
            echo "  ✓ Saved: $filename"
            return 0
        else
            if (( attempt < max_retries )); then
                echo "  ⚠ Retry $attempt/$max_retries for $filename..." >&2
                sleep 1  # Brief delay before retry
            fi
        fi
        ((attempt++))
    done

    echo "  ✗ Failed: $filename (after $max_retries attempts)" >&2
    rm -f "$target_path"
    return 1
}

if ! mkdir -p "$TARGET_DIR"; then
    echo "Error: Failed to create target directory '$TARGET_DIR'" >&2
    exit 1
fi

# Default wallpapers if no URLs provided
declare -a DEFAULT_URLS=(
    "$(github_raw_url dharmx walls abstract/a_white_building_with_balconies.jpg)"
    "$(github_raw_url dharmx walls aerial/a_rocky_beach_with_trees_and_water.jpg)"
    "$(github_raw_url dharmx walls anime/a_person_standing_on_a_broken_object_in_a_field_with_a_large_white_moon.png)"
    "$(github_raw_url dharmx walls apocalypse/a_cartoon_of_a_vehicle_with_a_monster_on_it.jpg)"
    "$(github_raw_url dharmx walls architecture/a_train_tracks_in_a_tunnel.jpg)"
    "$(github_raw_url dharmx walls basalt/a_road_with_a_road_in_the_middle_of_a_river.jpg)"
    "$(github_raw_url dharmx walls calm/a_road_leading_to_mountains.jpg)"
    "$(github_raw_url dharmx walls centered/a_rocket_launching_in_the_sky.png)"
    "$(github_raw_url dharmx walls cherry/a_painting_of_a_tree_branch_with_pink_flowers.png)"
    "$(github_raw_url dharmx walls chillop/a_cartoon_of_a_space_ship_and_a_man_standing_on_a_rocky_surface.jpg)"
    "$(github_raw_url dharmx walls cold/a_mountain_with_snow_and_clouds.jpg)"
    "$(github_raw_url dharmx walls decay/a_rusty_van_parked_on_the_side_of_a_road.jpg)"
    "$(github_raw_url dharmx walls digital/a_house_in_the_snow.png)"
    "$(github_raw_url dharmx walls evangelion/a_cartoon_of_a_monster.png)"
    "$(github_raw_url dharmx walls flowers/a_small_glass_vase_with_a_plant_in_it.jpg)"
    "$(github_raw_url dharmx walls fogsmoke/a_bridge_with_clouds_in_the_sky.jpg)"
    "$(github_raw_url dharmx walls gruvbox/a_cartoon_of_a_man_standing_in_space.png)"
    "$(github_raw_url dharmx walls interior/a_room_with_a_wooden_cabinet_and_a_picture_frame.jpg)"
    "$(github_raw_url dharmx walls m-26.jp/a_group_of_people_running_on_a_concrete_wall_next_to_a_lighthouse.jpg)"
    "$(github_raw_url dharmx walls minimal/a_cartoon_of_a_island_with_a_bridge_and_trees.jpg)"
    "$(github_raw_url dharmx walls monochrome/a_black_and_white_building_with_a_fire_escape.jpg)"
    "$(github_raw_url dharmx walls mountain/a_mountain_with_snow_on_top_and_a_body_of_water.jpg)"
    "$(github_raw_url dharmx walls nature/a_body_of_water_with_a_lit_up_tower_in_the_middle.png)"
    "$(github_raw_url dharmx walls nord/a_cartoon_of_a_woman_on_a_balcony.png)"
    "$(github_raw_url dharmx walls outrun/a_street_with_buildings_and_signs.png)"
    "$(github_raw_url dharmx walls painting/a_pool_with_chairs_and_palm_trees.jpg)"
    "$(github_raw_url dharmx walls poly/a_green_mountains_with_pink_and_blue_sky.jpg)"
    "$(github_raw_url D3Ext aesthetic-wallpapers images/acrylic.jpg)"
    "$(github_raw_url D3Ext aesthetic-wallpapers images/astronaut.jpg)"
    "$(github_raw_url D3Ext aesthetic-wallpapers images/manga.png)"
    "$(github_raw_url D3Ext aesthetic-wallpapers images/neocity.png)"
    "$(github_raw_url D3Ext aesthetic-wallpapers images/red-forest.jpg)"
)

# Use provided URLs or defaults
URLS=("${@:-${DEFAULT_URLS[@]}}")

# Create results directory for atomic counting
mkdir -p "$TEMP_DIR/results"

echo "Downloading third-party wallpapers to $TARGET_DIR (using $(nproc) parallel jobs)..."

skipped_counter=0
for url in "${URLS[@]}"; do
    filename=$(basename "$url")
    target_path="$TARGET_DIR/$filename"

    # Skip if file already exists
    if [[ -f "$target_path" ]]; then
        echo "  ⊝ Skipping (already exists): $filename"
        skipped_counter=$((skipped_counter + 1))
        continue
    fi

    echo "  Downloading: $filename"
    # Use background jobs for parallel download
    (
        if download_with_retry "$url" "$target_path"; then
            touch "$TEMP_DIR/results/success.$BASHPID"
        else
            touch "$TEMP_DIR/results/failed.$BASHPID"
        fi
    ) &
    # Limit parallel jobs to CPU count
    if (( $(jobs -r | wc -l) >= $(nproc) )); then
        wait -n
    fi
done
wait

# Count results
count=$(ls "$TEMP_DIR/results"/success.* 2>/dev/null | wc -l || true)
failed=$(ls "$TEMP_DIR/results"/failed.* 2>/dev/null | wc -l || true)
skipped=$skipped_counter

echo "✓ Complete: $count wallpaper(s) downloaded, $skipped skipped, $failed failed"
