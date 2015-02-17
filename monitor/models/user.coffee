###
{
  "_id": ObjectId,
  "profile": {
    "name": String,
    "avatar": String, // URL of the image
    "decksId": [ObjectId]
  }
  "emails": [
    { // each email address can only belong to one user.
      "address": String,
      "verified": Boolean
    }
  ],
  "services": {
    "facebook": {
      "id": String, // facebook id
      "accessToken": String
    },
    "resume": {
      "loginTokens": [
        {
          "token": String,
          "when": Timestamp
        }
      ]
    }
  }
  "createdAt": Date,
  "password": String
}
###
