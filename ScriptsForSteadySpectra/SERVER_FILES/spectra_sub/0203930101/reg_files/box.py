from shapely.geometry import Polygon, Point
import math

def parse_region_file(filepath):
    """
    Parses a .reg file to extract box definitions.
    Each box is defined as (x_center, y_center, width, height, rotation).
    """
    boxes = []
    with open(filepath, 'r') as file:
        for line in file:
            line = line.strip()
            if line.startswith('box'):
                # Correctly remove 'box' keyword and surrounding characters
                cleaned_line = line[4:].strip('()')
                parts = cleaned_line.split(',')
                box_data = tuple(float(part.strip()) for part in parts)
                boxes.append(box_data)
    return boxes

def rotate_point(cx, cy, angle, px, py):
    """ Rotate a point around a given center cx, cy """
    s = math.sin(math.radians(angle))
    c = math.cos(math.radians(angle))
    # translate point back to origin:
    px -= cx
    py -= cy
    # rotate point
    xnew = px * c - py * s
    ynew = px * s + py * c
    # translate point back:
    px = xnew + cx
    py = ynew + cy
    return px, py

def box_corners(x, y, width, height, rotation):
    """ Calculate the corners of the box based on center, width, height, and rotation """
    half_width = width / 2
    half_height = height / 2
    corners = [
        (x - half_width, y - half_height),
        (x + half_width, y - half_height),
        (x + half_width, y + half_height),
        (x - half_width, y + half_height)
    ]
    return [rotate_point(x, y, rotation, *corner) for corner in corners]

def get_intersection_area(inner_box, outer_box):
    """ Calculate the intersection of the inner box with the outer box considering rotation """
    inner_poly = Polygon(box_corners(*inner_box))
    outer_poly = Polygon(box_corners(*outer_box))

    intersection = outer_poly.intersection(inner_poly)
    return intersection

# Paths to your .reg files
filepath1 = 'box_mask_pn_det.reg'  # Path to the file with the outer box
filepath2 = 'reg_det_pn.reg'  # Path to the file with the inner boxes
output_file = 'contained_boxes.reg'

# Parse the region files
outer_boxes = parse_region_file(filepath1)
inner_boxes = parse_region_file(filepath2)

# Assuming the first file contains only one box that defines the outer boundary
if outer_boxes:
    outer_box = outer_boxes[0]  # Use the first box as the outer box
    intersections = [get_intersection_area(box, outer_box) for box in inner_boxes]

    # Writing the intersection areas to a new file
    with open(output_file, 'w') as file:
        file.write("# Region file format: DS9 version 4.1\n")
        file.write("global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n")
        file.write("detector\n")
        for intersection in intersections:
            if not intersection.is_empty:
                x, y = intersection.centroid.x, intersection.centroid.y
                minx, miny, maxx, maxy = intersection.bounds
                width = maxx - minx
                height = maxy - miny
                rotation = 0  # Consider the rotation for accurate real representation if needed
                box_line = f"box({x}, {y}, {width}, {height}, {rotation})\n"
                file.write(box_line)
    print(f"Intersections written to {output_file}")
else:
    print("No outer box defined in the first file.")
