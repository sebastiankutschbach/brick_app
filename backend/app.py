from flask.wrappers import Response
from db import get_db
from flask import Flask, jsonify
import json

def create_app():
    app = Flask(__name__)
    # existing code omitted

    import db
    db.init_app(app)

    return app

app = create_app()

def query_db(query):
    print(query)
    cursor = get_db().execute(query)
    result = cursor.fetchall()
    return result

#######################################
## colors
#######################################
@app.route("/colors")
def get_colors():
    return jsonify(query_db("select * from colors"))

@app.route("/colors/<int:color_id>")
def get_color_by_id(color_id):
    result = query_db("select * from colors where id = '{}'".format(color_id))
    return jsonify(result[0]) if len(result) == 1 else Response(status=404)

#######################################
## elements
#######################################
@app.route("/elements")
def get_elements():
    return jsonify(query_db("select * from elements"))

@app.route("/elements/<int:element_id>")
def get_element_by_id(element_id):
    result = query_db("select * from elements where element_id = '{}'".format(element_id))
    return jsonify(result[0]) if len(result) == 1 else Response(status=404)

#######################################
## inventories
#######################################
@app.route("/inventories")
def get_inventories():
    return jsonify(query_db("select * from inventories"))

@app.route("/inventories/<int:inventory_id>")
def get_inventory_by_id(inventory_id):
    result = query_db("select * from inventories where id = '{}'".format(inventory_id))
    return jsonify(result[0]) if len(result) == 1 else Response(status=404)

## inventory - minfigs
@app.route("/inventories/<int:inventory_id>/minifigs")
def get_minifigs_for_inventory(inventory_id):
    return jsonify(query_db("select * from inventory_minifigs where inventory_id = '{}'".format(inventory_id)))

## inventory - parts
@app.route("/inventories/<int:inventory_id>/parts")
def get_parts_for_inventory(inventory_id):
    return jsonify(query_db("select * from inventory_parts where inventory_id = '{}'".format(inventory_id)))

## inventory - sets
@app.route("/inventories/<int:inventory_id>/sets")
def get_sets_for_inventory(inventory_id):
    return jsonify(query_db("select * from inventory_sets where inventory_id = '{}'".format(inventory_id)))

#######################################
## minifigs
#######################################
@app.route("/minifigs")
def get_minifigs():
    return jsonify(query_db("select * from minifigs"))

@app.route("/minifigs/<fig_num>")
def get_minifig_by_fig_num(fig_num):
    result = query_db("select * from minifigs where fig_num = '{}'".format(fig_num))
    return jsonify(result[0]) if len(result) == 1 else Response(status=404)

#######################################
## parts
#######################################
@app.route("/parts")
def get_parts():
    return jsonify(query_db("select * from parts"))

@app.route("/parts/<part_num>")
def get_part_by_part_num(part_num):
    result = query_db("select * from parts where part_num = '{}'".format(part_num))
    return jsonify(result[0]) if len(result) == 1 else Response(status=404)

#######################################
## sets
#######################################
@app.route("/sets")
def get_sets():
    return jsonify(query_db("select * from sets"))

@app.route("/sets/<set_num>")
def get_set_by_set_num(set_num):
    result = query_db("select * from sets where set_num = '{}'".format(set_num))
    return jsonify(result[0]) if len(result) == 1 else Response(status=404)

#######################################
## themes
#######################################
@app.route("/themes")
def get_themes():
    return jsonify(query_db("select * from themes"))

@app.route("/themes/<theme_num>")
def get_theme_by_theme_num(theme_num):
    result = query_db("select * from themes where id = '{}'".format(theme_num))
    return jsonify(result[0]) if len(result) == 1 else Response(status=404)

