import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  displayChordNotes(event) {
    const chordNotes = event.currentTarget.dataset.chordNotes
    const chordNotesElement = document.getElementById('chord-notes')
    chordNotesElement.innerHTML = chordNotes
  }
}

