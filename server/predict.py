from ultralytics import YOLO
import sys
import json

# Load the YOLOv8 model
model = YOLO('train/weights/best.pt')

# Get image path from command line arguments
if len(sys.argv) < 2:
    print(json.dumps({"error": "No image path provided"}))
    sys.exit(1)

image_path = sys.argv[1]

# Run prediction
results = model.predict(image_path)

# Extract detected class names
detected_classes = []
for result in results:
    boxes = result.boxes
    class_indices = boxes.cls.cpu().numpy().astype(int)
    class_names = [result.names[i] for i in class_indices]
    detected_classes.extend(class_names)

# Prepare output
if detected_classes:
    output = {"detected": detected_classes}
else:
    output = {"detected": []}

# Print as JSON
print(json.dumps(output))
