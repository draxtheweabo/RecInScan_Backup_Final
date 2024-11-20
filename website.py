import argparse
import pymysql
import cv2
from flask import Flask, render_template, request, Response, session,redirect
from werkzeug.utils import  send_from_directory
import os
import base64
from datetime import datetime
from ultralytics import YOLO


app = Flask(__name__)
app.secret_key = 'supersecretkey'

#Folder Directory Stuff
base_save_dir = 'static/assets/img/runs/detect'
os.makedirs(base_save_dir, exist_ok=True)
def get_incremented_folder(base_dir, prefix="scanned_image"):
    existing_folders = [
        folder for folder in os.listdir(base_dir)
        if os.path.isdir(os.path.join(base_dir, folder)) and folder.startswith(prefix)
    ]
    # Extract the numbers from the folder names and find the max
    max_number = 0
    for folder in existing_folders:
        try:
            number = int(folder[len(prefix):])  # Get the number after the prefix
            if number > max_number:
                max_number = number
        except ValueError:
            continue
    # Increment max number for the new folder
    return os.path.join(base_dir, f"{prefix}{max_number + 1}")
def normalize_path(path):
    return path.replace("\\", "/")
#Database Stuff
def get_db_connection():
    return pymysql.connect(
        host='localhost',  # e.g., 'localhost'
        user='root',
        password='',
        db='recinscan',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )
def get_dishes_from_db():
    # Establish database connection
    connection = pymysql.connect(
        host='localhost',
        user='root',
        password='',
        database='recinscan'
    )
    try:
        cursor = connection.cursor()
        # Fetch dishes with additional fields: author, serving, cook_time, and link
        cursor.execute("""
            SELECT d.id AS dish_id, d.dish_name, d.instructions, d.image_path, d.author, d.serving, d.cook_time, d.link, 
                   r.ingredient_name, r.category, r.measurement
            FROM dishes d
            JOIN recipe r ON d.id = r.dish_id
            WHERE d.availability = 1
        """)

        # Process the results into a structured format
        dishes = {}
        for row in cursor.fetchall():
            dish_id = row[0]
            dish_name = row[1]
            instructions = row[2]
            image_path = row[3]
            author = row[4]
            serving = row[5]
            cook_time = row[6]
            link = row[7]
            ingredient_name = row[8]
            category = row[9]
            measurement = row[10]

            if dish_id not in dishes:
                dishes[dish_id] = {
                    "dish_name": dish_name,
                    "instructions": instructions.splitlines(),
                    "image": image_path,
                    "author": author,
                    "serving": serving,
                    "cook_time": cook_time,
                    "link": link,
                    "ingredients": {"main": [], "secondary": [], "common": []}
                }

            # Add ingredient with measurement to the relevant category
            ingredient_details = {
                "name": ingredient_name,
                "measurement": measurement
            }

            if category == 'main':
                dishes[dish_id]["ingredients"]["main"].append(ingredient_details)
            elif category == 'secondary':
                dishes[dish_id]["ingredients"]["secondary"].append(ingredient_details)
            elif category == 'common':
                dishes[dish_id]["ingredients"]["common"].append(ingredient_details)

        return list(dishes.values())
    finally:
        cursor.close()
        connection.close()

#Blur Function Stuff
def blur_outside_boxes(img, boxes, save_dir, filename="blurred_output.jpg", blur_intensity=(151, 151), margin=20):
    # Create a copy of the image to apply blur
    blurred_img = img.copy()

    # Blur the entire image first
    blurred_img = cv2.GaussianBlur(blurred_img, blur_intensity, 0)

    # Overlay the original image in the regions of the detected boxes
    for box in boxes:
        # Extract and convert bounding box coordinates to integers
        x1, y1, x2, y2 = map(int, box.xyxy[0])  # xyxy format bounding box
        margintop = 100
        # Define the region around the bounding box to leave unblurred
        # Extend the bounding box by the margin to create an unblurred region
        x1_margin = max(0, x1 - margin)
        y1_margin = max(0, y1 - margintop)
        x2_margin = min(img.shape[1], x2 + margin)
        y2_margin = min(img.shape[0], y2 + margin)

        # Replace the blurred regions inside the bounding box with the original image content
        blurred_img[y1_margin:y2_margin, x1_margin:x2_margin] = img[y1_margin:y2_margin, x1_margin:x2_margin]

    # Save the result
    os.makedirs(save_dir, exist_ok=True)
    output_path = os.path.join(save_dir, filename)
    cv2.imwrite(output_path, blurred_img)
    print(f"Image saved to {output_path}")
    return output_path
def cut_outside_boxes_with_margin(img, boxes, save_dir, filename="cut_output.jpg", cut_color=(0, 0, 0), margin=10):
    # Create a copy of the image
    output_img = img.copy()

    # Iterate through each bounding box
    for box in boxes:
        # Extract and convert bounding box coordinates to integers
        x1, y1, x2, y2 = map(int, box.xyxy[0])  # xyxy format bounding box

        # Define the region with the margin added around the bounding box
        x1_margin = max(0, x1 - margin)
        y1_margin = max(0, y1 - margin)
        x2_margin = min(img.shape[1], x2 + margin)
        y2_margin = min(img.shape[0], y2 + margin)

        # Fill the outside of the margin with the cut color
        output_img[:y1_margin, :] = cut_color  # Above the margin area
        output_img[y2_margin:, :] = cut_color  # Below the margin area
        output_img[:, :x1_margin] = cut_color  # Left of the margin area
        output_img[:, x2_margin:] = cut_color  # Right of the margin area

    # Save the result
    os.makedirs(save_dir, exist_ok=True)
    output_path = os.path.join(save_dir, filename)
    cv2.imwrite(output_path, output_img)
    print(f"Image saved to {output_path}")
    return output_path
#Admin Side Stuff
db_connection = pymysql.connect(
    host="localhost",
    user="root",
    password="",
    database="recinscan"
)
@app.route('/update_dish', methods=['GET', 'POST'])
def update_dish():
    if request.method == 'POST':
        dish_id = request.form['dish_id']
        availability = request.form['availability']
        
        # Update dish availability in the database
        with db_connection.cursor() as cursor:
            cursor.execute("""
                UPDATE dishes
                SET availability = %s
                WHERE id = %s
            """, (availability, dish_id))
        db_connection.commit()
    return render_template('Pages/admin.html')
@app.route('/admin')
def admin():
    return render_template('Pages/admin.html')
#User Side Stuff
@app.route('/')
def home():
    return render_template('index.html')

@app.route('/Scan')
def scan():
    return render_template('Pages/scan.html')

@app.route('/Recipes')
def recipes():
    dishes = get_dishes_from_db()
    return render_template('Pages/recipes.html',dishes=dishes)

@app.route('/About')
def about():
    return render_template('Pages/about.html')

@app.route('/clear_message', methods=['POST'])
def clear_message():
    session.pop('message', None)
    return '', 204  # Return a 'No Content' response

#Button For Upload
@app.route("/Scan", methods=["GET", "POST"])
def predict_img():
    session.clear()
    if 'file' not in request.files:
        message = "No file uploaded. Please upload an image file."
        return render_template("Pages/scan.html", message=message)
    
    f = request.files['file']

    if f.filename == '':
        message = "No file selected. Please select an image file to upload."
        return render_template("Pages/scan.html", message=message)
    
    basepath = os.path.dirname(__file__)
    filepath = os.path.join(basepath, 'uploads', f.filename)
    f.save(filepath)

    # Load and process the image using YOLO
    file_extension = f.filename.rsplit('.', 1)[1].lower() if '.' in f.filename else ''
    if file_extension not in ['jpg', 'jpeg', 'png']:
        message = "Invalid file type. Please upload a valid image (jpg, jpeg, or png)."
        return render_template("Pages/scan.html", message=message)

    img = cv2.imread(filepath)
    detections = model(img)

    if not detections[0].boxes:
        message = "No Ingredients detected in the image."
        return render_template("Pages/scan.html", message=message)
    
    save_dir = get_incremented_folder(base_save_dir)
    os.makedirs(save_dir, exist_ok=True)

    for i, result in enumerate(detections):
        result_path = os.path.join(save_dir, f"result_{i + 1}.jpg")  # Save with unique names
        result.save(filename=result_path)

    img = cv2.imread(os.path.normpath(result_path))
    for result in detections:
        boxes = result.boxes  # Bounding boxes object
        output_path=blur_outside_boxes(img, boxes, save_dir)

    if 'scanned_image_paths' not in session:
            session['scanned_image_paths'] = []
    session['scanned_image_paths'].append(output_path)
    
    # Collect scanned ingredients from YOLO detections
    scanned_ingredients = {model.names[int(box.data[0][-1])].lower() for result in detections for box in result.boxes}

    # Save scanned ingredients in the session and render results
    session['scanned_ingredients'] = list(scanned_ingredients)
    
    return render_template('Pages/result.html', scanned_image_paths=session['scanned_image_paths'], ingredients=session['scanned_ingredients'])

@app.route("/ScanAgain", methods=["GET","POST"])
def scan_ingredients():
    # Check if file is present in request
    if 'file' not in request.files:
        message = "No file uploaded. Please upload an image file."
        return render_template("Pages/result.html", scanned_image_paths=session['scanned_image_paths'], ingredients=session['scanned_ingredients'], message=message)

    f = request.files['file']

    if f.filename == '':
        message = "No file selected. Please select an image file to upload."
        return render_template("Pages/result.html", scanned_image_paths=session['scanned_image_paths'], ingredients=session['scanned_ingredients'], message=message)
    
    basepath = os.path.dirname(__file__)
    filepath = os.path.join(basepath, 'uploads', f.filename)
    f.save(filepath)

    # Load and process the image using YOLO
    file_extension = f.filename.rsplit('.', 1)[1].lower() if '.' in f.filename else ''
    if file_extension not in ['jpg', 'jpeg', 'png']:
        message = "Invalid file type. Please upload a valid image (jpg, jpeg, or png)."
        return render_template("Pages/result.html", scanned_image_paths=session['scanned_image_paths'], ingredients=session['scanned_ingredients'], message=message)

    img = cv2.imread(filepath)
    detections = model(img)

    if not detections[0].boxes:
        message = "No objects detected in the image."
        return render_template("Pages/result.html", scanned_image_paths=session['scanned_image_paths'], ingredients=session['scanned_ingredients'], message=message)

    save_dir = get_incremented_folder(base_save_dir)
    os.makedirs(save_dir, exist_ok=True)

    # Save each detection result with a unique filename in the save directory
    scan_paths = []  # Temporary list to store paths for this scan
    for i, result in enumerate(detections):
        result_path = os.path.join(save_dir, f"result_{i + 1}.jpg")
        result.save(filename=result_path)
        scan_paths.append(result_path)  # Add this scan's path to the list
    
    img = cv2.imread(os.path.normpath(result_path))
    for result in detections:
        boxes = result.boxes  # Bounding boxes object
        output_path = blur_outside_boxes(img, boxes, save_dir)

    # Add all new paths from this scan to the session's scanned image paths
    session['scanned_image_paths'].append(output_path)
    # Update scanned ingredients set with new detections
    new_scanned_ingredients = set()
    for result in detections:
        for box in result.boxes:
            class_id = int(box.data[0][-1])
            ingredient_name = model.names[class_id]
            new_scanned_ingredients.add(ingredient_name.lower())

    # Retrieve previously scanned ingredients from session, add new ones, and save back
    scanned_ingredients = set(session.get('scanned_ingredients', []))
    scanned_ingredients.update(new_scanned_ingredients)
    session['scanned_ingredients'] = list(scanned_ingredients)  # Save as list for session compatibility
    print('Scanne File Path',session['scanned_image_paths'] )
    return render_template('Pages/result.html', scanned_image_paths=session['scanned_image_paths'], ingredients=list(scanned_ingredients))

@app.route("/Recommend", methods=["POST"])
def recommend_dish():
    # Get the ingredients from the form submission
    ingredients_from_form = request.form.get("ingredients")
    input_ingredients = [ingredient.strip().lower() for ingredient in ingredients_from_form.split(',')]
    
    # Establish a database connection and fetch ingredients from the table
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            # Retrieve all ingredient names from the `ingredients` table
            cursor.execute("SELECT ingredient_name FROM ingredients")
            
            # Fetch results as a list of dictionaries
            db_ingredients = [row['ingredient_name'].lower() for row in cursor.fetchall()]
            
            # Check if any input ingredient is not in the database
            missing_ingredients = [ingredient for ingredient in input_ingredients if ingredient not in db_ingredients]
    finally:
        connection.close()
            
    # If ingredients are provided, process them
    if ingredients_from_form:
        entered_ingredients = [ingredient.strip().lower() for ingredient in ingredients_from_form.split(',')]
    else:
        entered_ingredients = []
    
    error_message="The following ingredients are not found in the database: " + ', '.join(missing_ingredients)
    if missing_ingredients:
        # Return to result.html and pass the missing ingredients list
        return render_template("Pages/result.html", scanned_image_paths=session['scanned_image_paths'], ingredients=entered_ingredients, message=error_message )

    if not entered_ingredients:
        return render_template('Pages/scan.html', scanned=None, ingredients=[], dishes=[])

    # Fetch all dishes from the database with full details
    dishes = get_dishes_from_db()

    # Filter dishes based on the entered ingredients
    possible_dishes = []
    matching_dishes = []

    common_ingredients = set()
    for dish in dishes:
        common_ingredients.update([ingredient['name'].lower() for ingredient in dish["ingredients"]["common"]])
    
    # Check if entered ingredients are exclusively from the common ingredients
    if all(ingredient in common_ingredients for ingredient in entered_ingredients):
        # If only common ingredients are entered, return an error message
        error_message = "Please include at least one main or secondary ingredient."
        return render_template("Pages/result.html", scanned_image_paths=session['scanned_image_paths'], ingredients=entered_ingredients, message=error_message)
    
    for dish in dishes:
        # Get the main and common ingredient names in lowercase
        main_ingredients = [ingredient['name'].lower() for ingredient in dish["ingredients"]["main"]]
        secondary_ingredients = [ingredient['name'].lower() for ingredient in dish["ingredients"]["secondary"]]
        common_ingredients = [ingredient['name'].lower() for ingredient in dish["ingredients"]["common"]]
        
        has_main = any(ingredient in entered_ingredients for ingredient in main_ingredients)
        has_secondary = any(ingredient in entered_ingredients for ingredient in secondary_ingredients)
        common_available_count = sum(1 for ingredient in common_ingredients if ingredient in entered_ingredients)
        has_enough_common = common_available_count >= (len(common_ingredients) * 0.5)

        if has_main and has_secondary and has_enough_common:
            possible_dishes.append(dish)

        # If the dish contains at least one of any of the entered ingredients, add it to matching_dishes
        all_ingredients = main_ingredients + secondary_ingredients 
        if any(ingredient in entered_ingredients for ingredient in all_ingredients):
            matching_dishes.append(dish)

        if not possible_dishes and not matching_dishes:
            message = "No dishes detected with the ingredients provided. Try adding more ingredients."
            return render_template("Pages/result.html", scanned_image_paths=session['scanned_image_paths'], ingredients=entered_ingredients, message=message)



    print('Entered Ingredients:', entered_ingredients)

    return render_template(
        'Pages/recommend.html', 
        scanned=session.get('scanned_image'),
        ingredients=entered_ingredients,
        dishes=possible_dishes,  # Dishes that match at least some ingredients
        matching_dishes=matching_dishes   # Dishes that match all the entered ingredients
    )
 
if __name__ == "__main__":
    model = YOLO('ModelV5.pt')
    app.run(host="0.0.0.0", port=5000,debug=True) 