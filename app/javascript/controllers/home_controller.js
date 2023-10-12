import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  displayChordNotes(event) {
    const chordNotes = event.currentTarget.dataset.chordNotes
    const chordNotesElement = document.getElementById('chord-notes')
    chordNotesElement.innerHTML = chordNotes

    this.highlightChordNotes(chordNotes)
  }

  highlightChordNotes(chordNotes) {
    const notes = chordNotes.split(' - ')
    const keys = document.querySelectorAll('.key')

    keys.forEach((key) => {
      if (notes.includes(key.dataset.note)) {
        console.log("includes", notes.includes(key.dataset.note))
        key.classList.add('hignlighted-note')
      } else {
        key.classList.remove('hignlighted-note')
      }
    });
  }
}
