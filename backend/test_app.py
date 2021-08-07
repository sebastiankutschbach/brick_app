import json

import pytest
from flask.helpers import url_for

from app import app
from db import init_db


@pytest.fixture
def client():
    with app.test_client() as client:
        with app.app_context():
            init_db()
            yield client
    
#######################################
## colors
#######################################
def test_get_colors(client):
    response = client.get('/colors')
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert len(json_data) > 1

def test_get_color_by_id(client):
    id = 1
    response = client.get('/colors/{}'.format(id))
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert json_data['id'] == id
    assert json_data['is_trans'] == 'f'
    assert json_data['name'] == "Blue"
    assert json_data['rgb'] == "0055BF"

#######################################
## elements
#######################################
def test_get_elements(client):
    response = client.get('/elements')
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert len(json_data) > 1

def test_get_element_by_id(client):
    id = "4658279"
    response = client.get('/elements/{}'.format(id))
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert json_data['element_id'] == id
    assert json_data['color_id'] == 9999
    assert json_data['part_num'] == "74815"

#######################################
## inventories
#######################################
def test_get_inventories(client):
    response = client.get('/inventories')
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert len(json_data) > 1

def test_get_inventory_by_id(client):
    id = 1
    response = client.get('/inventories/{}'.format(id))
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert json_data['id'] == id
    assert json_data['set_num'] == "7922-1"
    assert json_data['version'] == 1


## inventory - minfigs
def test_get_minifigs_for_inventory(client):
    id = 233
    response = client.get('/inventories/{}/minifigs'.format(id))
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert len(json_data) == 1
    assert json_data[0]['inventory_id'] == id
    assert json_data[0]['fig_num'] == "fig-002161"
    assert json_data[0]['quantity'] == 1

## inventory - parts
def test_get_parts_for_inventory(client):
    id = 233
    response = client.get('/inventories/{}/parts'.format(id))
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert len(json_data) == 19
    assert json_data[0]['inventory_id'] == id
    assert json_data[0]['color_id'] == 72
    assert json_data[0]['is_spare'] == 'f'
    assert json_data[0]['part_num'] == '2412b'
    assert json_data[0]['quantity'] == 1


## inventory - sets
def test_get_sets_for_inventory(client):
    id = 233
    response = client.get('/inventories/{}/sets'.format(id))
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert len(json_data) == 0


#######################################
## minifigs
#######################################
def test_get_minifigs(client):
    response = client.get('/minifigs')
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert len(json_data) > 1

def test_get_minifig_by_id(client):
    id = "fig-002161"
    response = client.get('/minifigs/{}'.format(id))
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert json_data['fig_num'] == id
    assert json_data['name'] == "Wyldstyle in black jumpsuit"
    assert json_data['num_parts'] == 5

#######################################
## parts
#######################################
def test_get_parts(client):
    response = client.get('/parts')
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert len(json_data) > 1

def test_get_part_by_id(client):
    id = "003381"
    response = client.get('/parts/{}'.format(id))
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert json_data['part_num'] == id
    assert json_data['part_material_id'] == "Plastic"
    assert json_data['part_cat_id'] == 58
    assert json_data['name'] == "Sticker Sheet for Set 663-1"

#######################################
## sets
#######################################
def test_get_sets(client):
    response = client.get('/sets')
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert len(json_data) > 1

def test_get_set_by_id(client):
    id = "001-1"
    response = client.get('/sets/{}'.format(id))
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert json_data['set_num'] == id
    assert json_data['theme_id'] == 1
    assert json_data['num_parts'] == 43
    assert json_data['name'] == "Gears"
    assert json_data['year'] == 1965

#######################################
## themes
#######################################
def test_get_themes(client):
    response = client.get('/themes')
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert len(json_data) > 1

def test_get_theme_by_id(client):
    id = 1
    response = client.get('/themes/{}'.format(id))
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert json_data['id'] == id
    assert json_data['parent_id'] == ""
    assert json_data['name'] == "Technic"
