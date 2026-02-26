#!/usr/bin/env bash

# Download third-party wallpapers from URLs
# Usage: third-party.sh [URL[#name]...]
#   URL        - Download URL
#   URL#name   - Download URL with custom filename (e.g., "http://example.com/img.jpg#my-name.jpg")

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

# Pixiv URL
# Example: pixiv_url https://i.pximg.net/img-original/img/2013/06/25/20/32/44/36633503_p0.jpg
pixiv_url() {
    echo "$1"
}

# Download with retry mechanism
# Args: url target_path retries [referer] [display_name]
download_with_retry() {
    local url="$1"
    local target_path="$2"
    local max_retries="${3:-$MAX_RETRIES}"
    local referer="${4:-}"
    local display_name="${5:-$(basename "$url")}"
    local attempt=1
    local curl_opts=(-fsSL --max-time 10)

    # Auto-detect pixiv URLs if referer not provided
    if [[ -z "$referer" ]]; then
        # Extract domain and check if it's pixiv's image server
        local domain="${url#*//}"
        domain="${domain%%/*}"
        # Check for pximg.net (pixiv's image domain)
        local check="${domain//p*x*m*g.net/XXX}"
        if [[ "$check" != "$domain" ]]; then
            referer="https://www.pixiv.net"
        fi
    fi

    [[ -n "$referer" ]] && curl_opts+=(-H "Referer: $referer")

    while (( attempt <= max_retries )); do
        if curl "${curl_opts[@]}" -o "$target_path" "$url"; then
            echo "  ✓ Saved: $display_name"
            return 0
        else
            if (( attempt < max_retries )); then
                echo "  ⚠ Retry $attempt/$max_retries for $display_name..." >&2
                sleep 1  # Brief delay before retry
            fi
        fi
        ((attempt++))
    done

    echo "  ✗ Failed: $display_name (after $max_retries attempts)" >&2
    rm -f "$target_path"
    return 1
}

if ! mkdir -p "$TARGET_DIR"; then
    echo "Error: Failed to create target directory '$TARGET_DIR'" >&2
    exit 1
fi

# Default wallpapers if no URLs provided
declare -a DEFAULT_URLS=(
    "$(github_raw_url dharmx walls abstract/a_drawing_of_a_sun_and_a_ball.png)#abstract_sun.png"
    "$(github_raw_url dharmx walls aerial/a_rocky_beach_with_trees_and_water.jpg)#rocky_beach.jpg"
    "$(github_raw_url dharmx walls anime/a_person_standing_on_a_broken_object_in_a_field_with_a_large_white_moon.png)#anime_moon.png"
    "$(github_raw_url dharmx walls architecture/a_train_tracks_in_a_tunnel.jpg)#train_station.jpg"
    "$(github_raw_url dharmx walls basalt/a_road_with_a_road_in_the_middle_of_a_river.jpg)#river_road.jpg"
    "$(github_raw_url dharmx walls centered/a_rocket_launching_in_the_sky.png)#launch_rocket.png"
    "$(github_raw_url dharmx walls cherry/a_painting_of_a_tree_branch_with_pink_flowers.png)#cherry_blossom.png"
    "$(github_raw_url dharmx walls chillop/a_cartoon_of_a_space_ship_and_a_man_standing_on_a_rocky_surface.jpg)#space_ship.jpg"
    "$(github_raw_url dharmx walls decay/a_rusty_van_parked_on_the_side_of_a_road.jpg)#rusty_van.jpg"
    "$(github_raw_url dharmx walls digital/a_house_in_the_snow.png)#digital_house.png"
    "$(github_raw_url dharmx walls evangelion/a_cartoon_of_a_monster.png)#evangelion_monster.png"
    "$(github_raw_url dharmx walls flowers/a_small_glass_vase_with_a_plant_in_it.jpg)#flower_vase.jpg"
    "$(github_raw_url dharmx walls fogsmoke/a_bridge_with_clouds_in_the_sky.jpg)#fogsmoke_bridge.jpg"
    "$(github_raw_url dharmx walls gruvbox/a_mountain_range_with_snow.png)#gruvbox_mountain.png"
    "$(github_raw_url dharmx walls interior/a_room_with_a_wooden_cabinet_and_a_picture_frame.jpg)#interior_room.jpg"
    "$(github_raw_url dharmx walls minimal/a_train_crossing_a_bridge_over_a_bridge_with_mountains_in_the_background.png)#train_bridge.png"
    "$(github_raw_url dharmx walls monochrome/a_black_and_white_building_with_a_fire_escape.jpg)#monochrome_building.jpg"
    "$(github_raw_url dharmx walls nature/a_stone_stairs_in_a_forest.jpg)#nature_forest.jpg"
    "$(github_raw_url dharmx walls nord/an_astronaut_playing_a_piano.png)#nord_astronaut.png"
    "$(github_raw_url dharmx walls outrun/a_street_with_buildings_and_signs.png)#outrun_street.png"
    "$(github_raw_url dharmx walls painting/a_white_helmet_with_a_gun_and_fruit_on_a_table.png)#painting_helmet.png"
    "$(github_raw_url dharmx walls poly/a_small_town_with_many_houses.png)#poly_town.png"
    "$(github_raw_url dharmx walls solarized/a_moon_over_a_spaceship.png)#solarized_moon.png"
    "$(github_raw_url D3Ext aesthetic-wallpapers images/cute-town.png)#cute_town.png"
    "$(github_raw_url D3Ext aesthetic-wallpapers images/neocity.png)#neo_city.png"
    "$(github_raw_url D3Ext aesthetic-wallpapers images/manga.png)#samurai_manga.png"
    "$(pixiv_url https://i.pximg.net/img-original/img/2009/08/02/00/05/54/5435590_p0.jpg)#summer_station.jpg"
    "$(pixiv_url https://i.pximg.net/img-original/img/2013/06/25/20/32/44/36633503_p0.jpg)#starlit_sea.jpg"
    "$(pixiv_url https://i.pximg.net/img-original/img/2013/08/17/00/19/26/37855635_p0.jpg)#galaxy_sky.jpg"
    "$(pixiv_url https://i.pximg.net/img-original/img/2013/08/31/00/06/27/38183202_p0.jpg)#sky_miku.jpg"
    "$(pixiv_url https://i.pximg.net/img-original/img/2014/06/30/00/20/02/44403643_p0.png)#summer_sky.png"
    "$(pixiv_url https://i.pximg.net/img-original/img/2014/07/23/00/02/21/44873217_p0.jpg)#cormorant_fishing.jpg"
    "$(pixiv_url https://i.pximg.net/img-original/img/2016/03/06/02/28/13/55647411_p0.jpg)#fantasy_lake.jpg"
    "$(pixiv_url https://i.pximg.net/img-original/img/2018/01/26/12/52/04/50140585_p0.jpg)#rainy_day.jpg"
    "$(pixiv_url https://i.pximg.net/img-original/img/2018/09/25/00/00/01/70858371_p0.jpg)#sunset_miku.jpg"
    "$(pixiv_url https://i.pximg.net/img-original/img/2019/05/27/19/00/40/74932889_p0.jpg)#sea_surface.jpg"
    "$(pixiv_url https://i.pximg.net/img-original/img/2019/08/31/03/09/04/76542723_p0.jpg)#firework_miku.jpg"
    "$(pixiv_url https://i.pximg.net/img-original/img/2019/09/18/06/05/15/76841597_p0.png)#kyogre_pokemon.png"
    "$(pixiv_url https://i.pximg.net/img-original/img/2019/10/14/00/00/02/77277379_p0.png)#groudon_pokemon.png"
    "$(pixiv_url https://i.pximg.net/img-original/img/2020/05/07/00/00/13/81363134_p0.png)#volcarona_pokemon.png"
)

# Use provided URLs or defaults
URLS=("${@:-${DEFAULT_URLS[@]}}")

# Create results directory for atomic counting
mkdir -p "$TEMP_DIR/results"

echo "Downloading third-party wallpapers to $TARGET_DIR (using $(nproc) parallel jobs)..."

skipped_counter=0
for entry in "${URLS[@]}"; do
    # Parse URL and optional custom name (url#name format)
    if [[ "$entry" == *'#'* ]]; then
        url="${entry%#*}"
        custom_name="${entry##*#}"
        filename="$custom_name"
    else
        url="$entry"
        filename=$(basename "$url")
    fi
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
        if download_with_retry "$url" "$target_path" "$MAX_RETRIES" "" "$filename"; then
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
