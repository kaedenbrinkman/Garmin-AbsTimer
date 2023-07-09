import os
import subprocess
from PIL import Image
import csv

LAUNCHER_ICON = "./launcher_icon.png"
TOUCHSCREEN_ICON = "./launcher_icon2.png"
DRAWABLES_DIR = "../resources/drawables"
DEVICES_FILE = "./devices_diff.csv"

TOUCHSCREEN_DEVICES = ["venu", "venu2", "venu2plus", "venu2s", "venusq", "venusqm", "venud", "fr265", "fr265s", "fr965"]


def create_device_resources(device_id, icon_width, icon_height):
    # Create new directory for device resources
    new_dir = f"../resources-{device_id}"
    os.makedirs(new_dir, exist_ok=True)

    # Copy over drawables
    drawables_dir = os.path.join(new_dir, "drawables")
    os.makedirs(drawables_dir, exist_ok=True)
    for file_name in os.listdir(DRAWABLES_DIR):
        src_path = os.path.join(DRAWABLES_DIR, file_name)
        dst_path = os.path.join(drawables_dir, file_name)
        if os.path.isfile(src_path):
            os.link(src_path, dst_path)

    # Determine which icon to use
    if device_id in TOUCHSCREEN_DEVICES:
        icon_path = TOUCHSCREEN_ICON
    else:
        icon_path = LAUNCHER_ICON

    # Resize icon
    with Image.open(icon_path) as icon:
        if icon.size != (icon_width, icon_height):
            # Resize icon
            icon = icon.resize((icon_width, icon_height))
            # TODO: Add padding instead of stretching

        # Save resized icon
        icon_path = os.path.join(drawables_dir, "launcher_icon.png")
        # print("Saving new file at " + icon_path)
        if os.path.exists(icon_path):
            os.unlink(icon_path)
        icon.save(icon_path)


# Remove all resources-* folders
subprocess.run(["rm", "-rf", "../resources-*"])

# Read devices file
with open(DEVICES_FILE, newline="") as csvfile:
    reader = csv.reader(csvfile)
    next(reader)  # Skip header
    for row in reader:
        device_id, icon_height, icon_width = row
        create_device_resources(device_id, int(icon_width), int(icon_height))
