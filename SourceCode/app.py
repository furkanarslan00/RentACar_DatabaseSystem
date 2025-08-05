from flask import Flask, render_template, request, jsonify
import pyodbc

app = Flask(__name__)

# Veritabanı bağlantısı
conn = pyodbc.connect('DRIVER={SQL Server};SERVER=DESKTOP-NN1IHSR\\SQLEXPRESS;DATABASE=Seng306;UID=sa;PWD=q')

# SQL sorgusu işleme fonksiyonu
def execute_query(query):
    cursor = conn.cursor()
    cursor.execute(query)
    columns = [column[0] for column in cursor.description]
    results = []
    for row in cursor.fetchall():
        results.append(dict(zip(columns, row)))
    return results

def insert_data(table, data):
    cursor = conn.cursor()
    columns = ', '.join(data.keys())
    values = ', '.join(['?'] * len(data))
    query = f"INSERT INTO {table} ({columns}) VALUES ({values})"
    cursor.execute(query, list(data.values()))
    conn.commit()

def update_data(table, data, condition):
    cursor = conn.cursor()
    updates = ', '.join([f"{key} = ?" for key in data.keys()])
    condition_str = ' AND '.join([f"{key} = ?" for key in condition.keys()])
    query = f"UPDATE {table} SET {updates} WHERE {condition_str}"
    cursor.execute(query, list(data.values()) + list(condition.values()))
    conn.commit()

def delete_data(table, condition):
    cursor = conn.cursor()
    condition_str = ' AND '.join([f"{key} = ?" for key in condition.keys()])
    query = f"DELETE FROM {table} WHERE {condition_str}"
    cursor.execute(query, list(condition.values()))
    conn.commit()

def custom_query(query, params):
    cursor = conn.cursor()
    cursor.execute(query, params)
    if query.strip().upper().startswith("SELECT"):
        columns = [column[0] for column in cursor.description]
        results = []
        for row in cursor.fetchall():
            results.append(dict(zip(columns, row)))
        return results
    else:
        conn.commit()
        return None

def execute_custom_query(query):
    cursor = conn.cursor()
    cursor.execute(query)
    columns = [column[0] for column in cursor.description]
    results = []
    for row in cursor.fetchall():
        results.append(dict(zip(columns, row)))
    return results

# Ana sayfa
@app.route('/')
def index():
    return render_template('index.html')

# Sorgu işleme endpoint'i
@app.route('/api/query', methods=['POST'])
def handle_query():
    data = request.json
    query = data['query']
    result = execute_query(query)
    return jsonify(result)

# Veri ekleme endpoint'i
@app.route('/api/insert', methods=['POST'])
def handle_insert():
    data = request.json
    table = data['table']
    values = data['values']
    insert_data(table, values)
    return jsonify({"status": "success"})

# Veri güncelleme endpoint'i
@app.route('/api/update', methods=['POST'])
def handle_update():
    data = request.json
    table = data['table']
    values = data['values']
    condition = data['condition']
    update_data(table, values, condition)
    return jsonify({"status": "success"})

# Veri silme endpoint'i
@app.route('/api/delete', methods=['POST'])
def handle_delete():
    data = request.json
    table = data['table']
    condition = data['condition']
    delete_data(table, condition)
    return jsonify({"status": "success"})

# Özel sorgu endpoint'i
@app.route('/api/custom', methods=['POST'])
def handle_custom_query():
    data = request.json
    query = data['query']
    params = data['params']
    result = custom_query(query, params)
    return jsonify(result)

# Custom query işleme endpoint'i
@app.route('/api/customquery', methods=['POST'])
def handle_customquery():
    data = request.json
    query = data['query']
    result = execute_custom_query(query)
    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)
