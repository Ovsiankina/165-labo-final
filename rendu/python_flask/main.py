from flask import Flask, render_template
from pymongo import MongoClient
import random

app = Flask(__name__)

# Configuration
#MONGO_URI = 'mongodb://userModify:pwd@mongodb-165-labo:27017/my_data?authSource=admin'
MONGO_URI = 'mongodb://userModify:pwd@mongodb-165-labo:27017/?authSource=my_data'
DB_NAME = 'my_data'
COLLECTION = 'open_data'

# Initialize MongoDB client
client = MongoClient(MONGO_URI)
db = client[DB_NAME]
collection = db[COLLECTION]

@app.route('/')
def index():
    # 1. Select a random document
    sample_doc = next(collection.aggregate([{ '$sample': { 'size': 1 } }]))

    # 2. Count number of cards
    cards_list = sample_doc.get('data', {}).get('cards', [])
    num_cards  = len(cards_list)

    # 3. Choose a random card key
    chosen_card = random.choice(cards_list)

    # Prepare data for rendering
    doc_summary = {
        'num_cards': num_cards
    }

    # Convert chosen_card dict to list of tuples for display
    card_items = chosen_card.items()

    return render_template(
        'index.html',
        doc=doc_summary,
        card_items=card_items,
        chosen_card=chosen_card,
    )

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
