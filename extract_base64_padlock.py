import re
import base64

with open('assets/images/svg_images/metalic padlock.svg', 'r') as f:
    content = f.read()

# Find the base64 data
match = re.search(r'xlink:href="data:image/png;base64,([^"]+)"', content)
if match:
    b64_data = match.group(1)
    # Decode and save to png
    with open('assets/images/png_images/padlock_highres.png', 'wb') as out_f:
        out_f.write(base64.b64decode(b64_data))
    print("Successfully extracted padlock_highres.png")
else:
    print("Could not find base64 data")
