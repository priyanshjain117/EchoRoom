const express = require('express');
const admin = require("firebase-admin");
const cors = require('cors');

require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

admin.initializeApp({
    credential: admin.credential.cert({
        projectId: process.env.PROJECT_ID,
        clientEmail: process.env.CLIENT_EMAIL,
        privateKey: process.env.PRIVATE_KEY?.replace(/\\n/g, '\n'),
    })
});

const db=admin.firestore();

app.post('/send-room-notification',async (req,res)=>{
    const { roomId, senderUid, title, body } = req.body;
    const roomDoc=await db.collection('rooms').doc(roomId).get();
    const roomData=roomDoc.data();
    if (!roomData || !roomData.members) return res.status(404).send("Room not found");

    const members = roomData.members.filter(uid => uid !== senderUid);
    const tokens = [];

    for(const uid in members){
        const uid = await db.collection('users').doc(uid).get();
        if (userDoc.exists && userDoc.data().fcmToken){
            tokens.push(userDoc.data().fcmToken);
        }
    }

    if (tokens.length === 0) return res.status(200).send("No tokens to send");


});

app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});