import { Controller } from "@hotwired/stimulus"
import { Howl } from 'howler'

export default class extends Controller {
  static values = ["chords", "progression"]

  initialize() {
    this.chordsValue = []
    this.progressionValue = []
  }

  connect() {
    console.log('connected')
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
    const target = event.currentTarget
    const chord = target.dataset.chord
    const mode = target.dataset.mode

    this.chordsValue.push({ chord, mode })

    target.classList.add(`mode-shadow-${mode}`)
    target.querySelector('div').classList.remove('text-white')
    target.querySelector('div').classList.add(`text-modes-${mode}`)

    this.displayProgression(chord, mode)
  }

  displayProgression(chord, mode) {
    this.progressionElementDiv().innerHTML = ''

    this.makeProgressionRequest(chord, mode)
    this.progression.push({ chord, mode })
  }

  makeProgressionRequest(chord, mode) {
    const progressionParam = encodeURIComponent(JSON.stringify(this.progression))
    const chordParam = encodeURIComponent(chord)
    const modeParam = encodeURIComponent(mode)

    const url = `/progression?progression=${progressionParam}&&chord=${chordParam}&&mode=${modeParam}`
    fetch(url, { method: 'POST' })
      .then(response => response.text())
      .then(html => {
        this.progressionElementDiv().innerHTML = html
      })
  }

  progressionElementDiv() {
    const progressionElement = document.getElementById('progression')
    return progressionElement.querySelector('div')
  }

  handleProgressionChordHover(event) {
    this.displayChordOnTable(event)
    this.displayRemoveChordElement(event)
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

  displayRemoveChordElement(event) {
    const removeChordElement = event.currentTarget.querySelector('.remove-chord')
    removeChordElement.classList.remove('hidden')

    event.currentTarget.addEventListener('mouseleave', () => {
      removeChordElement.classList.add('hidden')
    })
  }

  removeChord(event) {
    const target = event.currentTarget
    const targetParent = target.parentElement
    const chord = target.dataset.chord
    const mode = target.dataset.mode

    const chordElement = document.querySelector(`[data-chord="${chord}"][data-mode="${mode}"]`)
    chordElement.classList.remove(`mode-shadow-${mode}`)
    chordElement.querySelector('div').classList.add('text-white')
    chordElement.querySelector('div').classList.remove(`text-modes-${mode}`)

    const progressionChildren = targetParent.parentElement.children

    let siblingIndex = 0
    for (let i = 0; i < progressionChildren.length; i++) {
      if (progressionChildren[i] === targetParent) {
        siblingIndex = i
      }
    }

    this.progression = this.progression.filter((_, index) => index !== siblingIndex)
    targetParent.remove()

    this.makeProgressionRequest()
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
