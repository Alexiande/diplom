const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.updateUserProfile = functions.https.onRequest(async (req, res) => {
  if (req.method !== "POST") {
    return res.status(405).send("Method Not Allowed");
  }

  const {userEmail, name, bio} = req.body;

  if (!userEmail || !name || !bio) {
    return res.status(400).send("Invalid request data");
  }

  try {
    const db = admin.firestore();
    const userRef = db.collection("users").doc(userEmail);

    await userRef.set(
        {name, bio},
        {merge: true}, // Обновление без перезаписи
    );

    res.status(200).send("Profile updated successfully");
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
});
