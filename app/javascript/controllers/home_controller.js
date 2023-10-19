import { Controller } from "@hotwired/stimulus"
import { Howl } from 'howler'

export default class extends Controller {
  initialize() {
    this.chords = []
    this.progression = []
  }

  displayChordNotes(event) {
    const chordNotes = event.currentTarget.dataset.chordNotes
    const mode = event.currentTarget.dataset.mode
    const chordNotesElement = document.getElementById('chord-notes')
    chordNotesElement.innerHTML = chordNotes

    const chordNotesElementParent = chordNotesElement.parentElement
    this.removeClass(chordNotesElementParent, 'mode-shadow-')

    chordNotesElement.parentElement.classList.add(`mode-shadow-${mode}`)

    this.highlightChordNotes(chordNotes, mode)
  }

  highlightChordNotes(chordNotes, mode) {
    const notes = chordNotes.split(' - ')
    const keys = document.querySelectorAll('.key,.piano-key')

    keys.forEach((key) => {
      this.removeClass(key, 'highlighted-note-')

      if (notes.includes(key.dataset.note)) {
        key.classList.add(`highlighted-note-${mode}`)
      }
    });
  }

  removeClass(element, classNamePrefix) {
    element.classList.forEach((className) => {
      if (className.includes(classNamePrefix)) {
        element.classList.remove(className)
      }
    })
  }

  selectChord(event) {
    const chord = event.currentTarget.dataset.chord
    const mode = event.currentTarget.dataset.mode

    this.chords.push({ chord, mode })

    event.currentTarget.classList.add(`mode-shadow-${mode}`)
    event.currentTarget.querySelector('div').classList.remove('text-white')
    event.currentTarget.querySelector('div').classList.add(`text-modes-${mode}`)

    this.displayProgression(chord, mode)
  }

  displayProgression(chord, mode) {
    const progressionElement = document.getElementById('progression')
    const progressionElementDiv = progressionElement.querySelector('div')

    progressionElementDiv.innerHTML = ''

    const progressionParam = encodeURIComponent(JSON.stringify(this.progression))
    const chordParam = encodeURIComponent(chord)
    const modeParam = encodeURIComponent(mode)

    const url = `/progression?progression=${progressionParam}&&chord=${chordParam}&&mode=${modeParam}`

    fetch(url, { method: 'POST' })
      .then(response => response.text())
      .then(html => {
        progressionElementDiv.innerHTML = html
        this.progression.push({ chord, mode })
      })
  }

  handleProgressionChordHover(event) {
    this.displayChordOnTable(event)
  }

  displayChordOnTable(event) {
    const chord = event.currentTarget.dataset.chord
    const mode = event.currentTarget.dataset.mode

    const chordElement = document.querySelector(`[data-chord="${chord}"][data-mode="${mode}"]`)

    chordElement.dispatchEvent(new Event('mouseover'))
    chordElement.classList.add('animate-[pulse_200ms_ease-in-out_3]')

    setTimeout(() => {
      chordElement.classList.remove('animate-[pulse_200ms_ease-in-out_3]')
    }, 800)
  }

  playChord(event) {
    const samples = event.currentTarget.dataset.samples

    const sound = new Howl({
      src: samples,
      onload: function() {
        sound.play();
      }
    });
  }

}
