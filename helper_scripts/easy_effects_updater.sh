# this script shell-agnostic and intended to be sourced, not executed directly
# examplue useage: source $HOME/.dotfiles/helper_scripts && update_all_presets()

# Define the output directories
output_json_dir="$HOME/.config/easyeffects/output"
irs_dir="$HOME/.config/easyeffects/irs"
input_dir="$HOME/.config/easyeffects/input"

# Function to handle output repositories
update_output_presets() {
    output_repos=(
        "https://github.com/p-chan5/EasyPulse"
        "https://github.com/Bundy01/EasyEffects-Presets"
        "https://github.com/EvoXCX/EasyEffect-Preset"
        "https://github.com/JackHack96/EasyEffects-Presets"
    )

    # Create directories if they don't exist
    mkdir -p "$output_json_dir"
    mkdir -p "$irs_dir"

    for repo in "${output_repos[@]}"; do
        repo_name=$(basename "$repo" .git)
        repo_dir="/tmp/$repo_name"

        if [ -d "$repo_dir" ]; then
            echo "Updating $repo_name..."
            git -C "$repo_dir" pull
        else
            echo "Cloning $repo_name..."
            git clone "$repo" "$repo_dir"
        fi

        # Copy JSON files to the output directory
        find "$repo_dir" -type f -name "*.json" -exec cp {} "$output_json_dir" \;

        # Copy IRS files to the IRS directory
        find "$repo_dir" -type f -name "*.irs" -exec cp {} "$irs_dir" \;
    done
}

# Function to handle input repository
update_input_presets() {
    input_repo="https://gist.github.com/jtrv/47542c8be6345951802eebcf9dc7da31"
    input_repo_dir="/tmp/$(basename "$input_repo" .git)"

    # Create directory if it doesn't exist
    mkdir -p "$input_dir"

    # Clone or update the input repository
    if [ -d "$input_repo_dir" ]; then
        echo "Updating input repository..."
        git -C "$input_repo_dir" pull
    else
        echo "Cloning input repository..."
        git clone "$input_repo" "$input_repo_dir"
    fi

    # Copy the input files to the input directory
    find "$input_repo_dir" -type f -name "*.json" -exec cp {} "$input_dir" \;
}

# Function to update all presets
update_all_presets() {
    update_output_presets
    update_input_presets
    echo "All presets update completed."
}
