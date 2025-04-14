const express = require("express");
const bodyParser = require("body-parser");
const { twiml } = require("twilio");
require("dotenv").config();

const app = express();

// ✅ Add both parsers
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Root route
app.get("/", (req, res) => {
  res.send("Twilio Transcription Server is Running");
});

const twilioClient = require("twilio")(
  process.env.TWILIO_ACCOUNT_SID,
  process.env.TWILIO_AUTH_TOKEN
);
app.post("/make-call", (req, res) => {
  const toPhone = req.body.phone;

  if (!toPhone) {
    return res.status(400).json({ error: "Phone number is required" });
  }

  const response = new twiml.VoiceResponse();

  response.say("Please leave your feedback after the beep.");
  response.record({
    maxLength: 120,
    transcribe: true,
    transcribeCallback: `${process.env.NGROK_URL}/transcription`,
  });

  twilioClient.calls
    .create({
      twiml: response.toString(),
      to: toPhone,
      from: process.env.TWILIO_PHONE_NUMBER,
    })
    .then((call) => {
      console.log(`✅ Call initiated: ${call.sid}`);
      res.json({ message: "Call initiated", sid: call.sid });
    })
    .catch((error) => {
      console.error("❌ Error initiating call:", error);
      res.status(500).json({ error: "Failed to make call" });
    });
});

// Handle incoming call
app.post("/voice", (req, res) => {
  console.log("🚨 Incoming call hit /voice route");
  const response = new twiml.VoiceResponse();

  response.say("Please leave your feedback after the beep.");
  response.record({
    maxLength: 120,
    transcribe: true,
    transcribeCallback: `${process.env.NGROK_URL}/transcription`,
  });

  res.type("text/xml");
  res.send(response.toString());
});

// Handle transcription callback
let latestTranscription = ""; // Global variable for demo

app.post("/transcription", (req, res) => {
  console.log("📞 Transcription endpoint hit");
  const text = req.body.TranscriptionText;
  latestTranscription = text; // store it
  console.log("📝 Transcription:", text);
  res.sendStatus(200);
});

// New endpoint for Flutter to fetch transcription
app.get("/get-transcription", (req, res) => {
  res.json({ transcription: latestTranscription });
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
