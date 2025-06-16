const express = require('express');
const admin = require("firebase-admin");
const cors = require('cors');

const app=express();
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});