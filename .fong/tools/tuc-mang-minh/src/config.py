from pathlib import Path

# This file contains default configurations for the tool.

# We assume the script is run from the project's root directory.
# The .history folder is expected to be in this root.
# PROJECT_ROOT = Path(os.getcwd())

# Define the common paths for Local History directories.
# This makes the tool more robust across different machine setups.
# Updated: VSCode first since it has more complete history tracking
home_dir = Path.home()
COMMON_HISTORY_PATHS = [
    str(home_dir / ".config/Code/User/History"),    # [Priority 1] Standard for VS Code (most complete)
    str(home_dir / ".config/Cursor/User/History"),  # [Priority 2] Standard for Cursor (capital 'C')
    str(home_dir / ".config/cursor/User/History"),  # [Priority 3] Fallback for lowercase 'c'
]

# Maximum number of output files to keep in the tmp directory.
OUTPUT_FILE_LIMIT = 100 
