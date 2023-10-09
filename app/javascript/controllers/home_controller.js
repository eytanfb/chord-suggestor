import { Controller } from "@hotwired/stimulus"

const keys = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

const chordsWithSharps = ['C', 'G', 'D', 'A', 'E', 'B']
const chordsWithFlats = ['F', 'Bb', 'Eb', 'Ab', 'Db', 'Gb']

const intervals = {
  'I': 0,       // Unison or Root
  'ii': 1,      // Minor 2nd
  'II': 2,      // Major 2nd
  'iii': 3,     // Minor 3rd
  'III': 4,     // Major 3rd
  'IV': 5,      // Perfect 4th
  '#iv': 6,     // Augmented 4th or Tritone (some might use 'bV' instead)
  'V': 7,       // Perfect 5th
  'vi': 8,      // Minor 6th
  'VI': 9,      // Major 6th
  'vii': 10,    // Minor 7th
  'VII': 11,    // Major 7th
  'VIII': 12    // Octave (same as 'I' but an octave higher)
};

export default class extends Controller {
  static values = {
    selectedKey: String
  }

  connect() {
    this.selectedKey = ""
  }

  selectKey(event) {
    const clickedDiv = event.target

    this.selectedKey = clickedDiv.innerText

    // toggle all sibling divs off
    const siblings = Array.from(clickedDiv.parentElement.children)
    siblings.forEach(sibling => {
      if (sibling !== clickedDiv) {
        sibling.classList.remove("selected")
      }
    })

    clickedDiv.classList.add("selected")

    this.replaceRomanNumberalsWithChords()
  }

  replaceRomanNumberalsWithChords() {
    const romanNumberals = document.querySelectorAll(".chord-box")
    let previousChord = ""

    romanNumberals.forEach((romanNumeral, index) => {
      const romanNumeralText = romanNumeral.dataset.chord
      const chord = this.getChord(this.selectedKey, romanNumeralText, previousChord)

      romanNumeral.querySelector("div").innerText = chord

      if (index % 7 === 6) {
        previousChord = ""
      } else {
        previousChord = chord
      }
    })
  }

  getChord(key, romanNumeralText, previousChord) {
    let chord = ""
    const isMinor = romanNumeralText.toLowerCase() === romanNumeralText
    const isDiminished = romanNumeralText.includes("°")
    const isAugmented = romanNumeralText.includes("+")
    const isFlat = romanNumeralText.includes("b")
    const isSharp = romanNumeralText.includes("#")

    romanNumeralText = romanNumeralText.replace("°", "").replace("+", "").replace("b", "").replace("#", "").trim()

    switch (romanNumeralText) {
      case "I":
        chord = key
        break
      case "i":
        chord = key
        break
      case "ii":
        chord = this.getInterval(key, 2)
        break
      case "II":
        chord = this.getInterval(key, 2)
        break
      case "iii":
        chord = this.getInterval(key, 4)
        break
      case "III":
        chord = this.getInterval(key, 4)
        break
      case "IV":
        chord = this.getInterval(key, 5)
        break
      case "iv":
        chord = this.getInterval(key, 5)
        break
      case "#iv":
        chord = this.getInterval(key, 6)
        break
      case "V":
        chord = this.getInterval(key, 7)
        break
      case "v":
        chord = this.getInterval(key, 7)
        break
      case "vi":
        chord = this.getInterval(key, 9)
        break
      case "VI":
        chord = this.getInterval(key, 9)
        break
      case "vii":
        chord = this.getInterval(key, 11)
        break
      case "VII":
        chord = this.getInterval(key, 11)
        break
      default:
        chord = ""
    }

    if (isFlat) {
      chord += 'b'
      if (chord === 'Cb') {
        chord = 'B'
      } else if (chord === 'Fb') {
        chord = 'E'
      }
    }

    if (isSharp) {
      chord += '#'
      if (chord === 'B#') {
        chord = 'C'
      } else if (chord === 'E#') {
        chord = 'F'
      }
    }

    if (isMinor) {
      chord += "m"
    }

    if (isDiminished) {
      chord += "°"
    }

    if (isAugmented) {
      chord += "+"
    }

    return chord
  }

  getInterval(key, interval) {
    const keyIndex = keys.indexOf(key)
    const intervalIndex = (keyIndex + interval) % 12
    return keys[intervalIndex]
  }

  clearChordNotes() {
    const chordNotesContainer = document.querySelector("#chord-notes")
    chordNotesContainer.innerText = ""
  }

  displayChordNotes(event) {
    const selectedKey = document.querySelector(".selected")

    if (!selectedKey || selectedKey.innerText === "") return

    const chordBox = event.target
    const chord = chordBox.innerText
    const chordNotesContainer = document.querySelector("#chord-notes")
    const chordNotes = this.getChordNotes(chord)
    chordNotesContainer.innerText = chordNotes
  }

  getChordNotes(chord) {
    const chordNotes = []
    const originalRootNote = this.sanitizeChord(chord);

    const rootNote = this.getRootNote(chord)
    const rootNoteIndex = keys.indexOf(rootNote)

    chordNotes.push(keys[rootNoteIndex])
    chordNotes.push(this.getSecondNoteForChord(chord, rootNoteIndex))
    chordNotes.push(this.getThirdNoteForChord(chord, rootNoteIndex))

    chordNotes[0] = originalRootNote
    return chordNotes.join(" - ")
  }

  getRootNote(chord) {
    return this.sanitizeChord(chord).replace("G#", "Ab").replace("A#", "Bb").replace('D#', 'Eb')
  }

  sanitizeChord(chord) {
    return chord.replace("m", "").replace("°", "").replace("+", "")
  }

  getSecondNoteForChord(chord, rootNoteIndex) {
    if (chord.includes("m") || chord.includes("°")) {
      return keys[(rootNoteIndex + 3) % 12]
    }

    return keys[(rootNoteIndex + 4) % 12]
  }

  getThirdNoteForChord(chord, rootNoteIndex) {
    if (chord.includes("°")) {
      return keys[(rootNoteIndex + 6) % 12]
    } else if (chord.includes("+")) {
      return keys[(rootNoteIndex + 8) % 12]
    }

    return keys[(rootNoteIndex + 7) % 12]
  }
}

