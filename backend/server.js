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

app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});