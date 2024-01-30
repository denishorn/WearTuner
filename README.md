# Wear Tuner

A Flutter application that allows users to tune their musical instruments (currently guitar) from their smart watches.

## Description

This is a mobile application built with Flutter that should provide a convenient way for musicians to tune their instruments. The app uses the device's microphone to capture audio input and analyzes the sound frequencies to determine the tuning accuracy. ~~Currently uses fft algorithm to determine sound freqquency~~ Apparently Fast Fourier Transform algo gives too much noise data and im not good enough to make in run smoothly, so now pitchupdart lib is used as a port of [pitchup library for Kotlin](https://github.com/techpotatoes/pitchup?tab=readme-ov-file) which make things much easier

## Features

- Real-time audio input analysis
- Identifying current frequency in hertz and ~~notes~~
- Visual indicators for tuning accuracy
- Adjustable reference pitch
- User-friendly material design interface interface

## TODO

- [x] Frequency detection
- [X] Animated Material you tuning indicator
- [ ] Various instruments support
- [ ] Enchanche permission request
- [ ] Modifying design for rectangular watches
- [ ] Different tunings ?
- [ ] Settings screen
- [ ] Dimmed screen low fps mode for AOD