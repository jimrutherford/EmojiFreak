# EmojiFreak

Emoji freak is a simple proof-of-concept chat client for iOS that uses frequencies within the sound spectrum that is inaudible to most adults.  The project started as I was asked to speak to my 10 year old son's class about what I do for a career.  To demonstrate what I do, I made this project.

The app is only capable at this time of broadcasting the name of the user and an emoji character to all clients within listening range.

The app generates a sequence of tones (using core audio) to encode the message then uses core audio for pitch detection based on the [Pitch Detector](https://github.com/irtemed88/PitchDetector) open source project.  Incoming sounds are decoded and displayed within the connected clients.


My son's classmates loved the demonstration and thought it was very cool that you could use sound to transmit data between devices.  #DadWin!