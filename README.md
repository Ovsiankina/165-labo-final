# Labo 165 - NoSQL

## Serveur standalone MongoDB

### Les données

#### Lien d'origine des données opendata

**Site web de la collection**
[Site MTG json](https://mtgjson.com/)

**Deck de cartes choisi (Set "Adventures in the Forgotten Realms" abrv. "AFR"")**
[Set AFR (Adventures of the Forgotten Realms)](https://mtgjson.com/api/v5/AFR.json)

#### Description

Une liste exhaustive de toutes les cartes de la série "Adventures of the Forgotten Realms".
Une collaboration unique entre "Magic The Gathering" et "Dungeons and Dragons".

#### Fichier des données originales
[AFP.json](./data/AFR.json)

### Serveur standalone

#### Créez une BD appelée my_data

##### Commandes docker
```bash
docker cp data/AFR.json mongodb-165-labo:/tmp/AFR.json
docker exec -it mongodb-165-labo mongosh
```

##### Commande mongosh
```bash
use my_data;
```
#### Importez les données dans la collection avec nom open_data
##### Commandes docker
```bash
docker cp data/AFR.json mongodb-165-labo:/tmp/AFR.json
docker exec -it mongodb-165-labo bash
```

##### Commandes mongoimport
```bash
mongoimport --db my_data --collection open_data --file /tmp/AFR.json
```
##### Commandes mongosh

###### Modifier 3 documents
**Modifie les deux cartes qui ont "Jarel Threat" comme artiste**
```js
db.open_data.updateMany(
  { "data.cards.artist": "Jarel Threat" },
  [
    {
      $set: {
        "data.cards": {
          $map: {
            input: "$data.cards",
            as: "card",
            in: {
              $cond: [
                { $eq: ["$$card.artist", "Jarel Threat"] },
                { $mergeObjects: ["$$card", { artist: "Jamel Debbouze" }] },
                "$$card"
              ]
            }
          }
        }
      }
    }
  ]
)
```

Verification de la modification
```js
db.open_data.aggregate([
  {
    $unwind: "$data.cards"
  },
  {
    $match: {
      "data.cards.artist": "Jamel Debbouze"
    }
  },
  {
    $project: {
      _id: 0,
      artist: "$data.cards.artist",
      uuid: "$data.cards.uuid"
    }
  }
])
```
**Modifie l'artiste de la 12ème carte**
```js
db.open_data.updateMany(
  { "data.cards.12.artist": { $exists: true } },
  {
    $set: {
      "data.cards.12.artist": "Nicolas Hulot"
    }
  }
)
```
Verification de la modification
```js
db.open_data.aggregate([
  {
    $project: {
      _id: 0,
      card: { $arrayElemAt: ["$data.cards", 12] }
    }
  },
  {
    $project: {
      artist: "$card.artist",
      uuid: "$card.uuid"
    }
  }
])
```

###### Ajouter 3 documents
```js
db.open_data.updateMany(
  {},
  {
    $set: {
      "data.cards.424": {
        artist: "Jamel Debbouze",
        availability: ["arena", "mtgo", "paper"],
        colors: ["W", "R"],
        finishes: ["nonfoil", "foil"],
        flavorText: "Forged in the heart of the fiery pits, this weapon burns with the fury of a dragon's breath.",
        language: "English",
        manaCost: "{2}{R}",
        manaValue: 3,
        name: "Flameforged Mace",
        number: "424",
        rarity: "uncommon",
        text: "Equipped creature gets +3/+1. \nEquip {3} ({3}: Attach to target creature you control. Equip only as a sorcery.)",
        type: "Artifact — Equipment",
        uuid: "42442442-aaaa-bbbb-cccc-424242424242"
      },
      "data.cards.425": {
        artist: "Adrien Wavelet",
        availability: ["arena", "mtgo", "paper"],
        colors: ["W", "G"],
        finishes: ["nonfoil", "foil"],
        flavorText: "Blessed by the ancient druids, this weapon channels the power of the forest.",
        language: "English",
        manaCost: "{1}{G}",
        manaValue: 2,
        name: "Verdant Mace",
        number: "425",
        rarity: "rare",
        text: "Equipped creature gets +2/+2. \nEquip {2} ({2}: Attach to target creature you control. Equip only as a sorcery.)",
        type: "Artifact — Equipment",
        uuid: "42442442-aaaa-bbbb-cccc-425242424242"
      },
      "data.cards.426": {
        artist: "David Mostoslavski",
        availability: ["arena", "mtgo", "paper"],
        colors: ["W", "B"],
        finishes: ["nonfoil", "foil"],
        flavorText: "A cursed relic, whose power demands the soul of its wielder.",
        language: "English",
        manaCost: "{1}{B}",
        manaValue: 2,
        name: "Soulrender Mace",
        number: "426",
        rarity: "mythic",
        text: "Equipped creature gets +2/+2. \nEquip {3} ({3}: Attach to target creature you control. Equip only as a sorcery.)",
        type: "Artifact — Equipment",
        uuid: "42442442-aaaa-bbbb-cccc-426242424242"
      }
    }
  }
)
```

##### Ajoutez une collection avec nom my_team 
```js
db.my_team.insertMany([
  { name: "Adrien Wavelet" },
  { name: "David Mostoslavski" },
])
```
##### Exporter les collections
Exporter les collections
```js
// Export MTG AFP collection as 'open_data.json'
mongoexport --db=my_data --collection=open_data --out=open_data.json

// Export 'my_team' collection as 'my_team.json'
mongoexport --db=my_data --collection=my_team --out=my_team.json
```

Extraire les exportations de docker
```bash
docker cp mongodb-165-labo:/open_data.json .
docker cp mongodb-165-labo:/my_team.json .
```

importan : il faut dir le por de comment on connect lappllcatioin

``` se connecter en s'identifiant
docker exec -it mongodb-165-labo mongosh --authenticationDatabase my_data -u "userModify" -p
