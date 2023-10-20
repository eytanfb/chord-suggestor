import { Controller } from "@hotwired/stimulus"
import { Howl } from "howler"
import _ from "lodash"

export default class extends Controller {
  connect() {
    this.debouncedPlayChordSamples = _.debounce(this.playChordSamples, 500)
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

    const isPlaying = document.getElementById('progression-container').dataset.playing
    if (isPlaying === 'true') {
      this.playChordSamples(chordNotes)
    } else {
      this.debouncedPlayChordSamples(chordNotes)
    }
  }

  highlightChordNotes(chordNotes, mode) {
    const notes = chordNotes.split(' - ')
    const keys = document.querySelectorAll('.key')

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

    target.classList.add(`mode-shadow-${mode}`)
    target.querySelector('div').classList.remove('text-white')
    target.querySelector('div').classList.add(`text-modes-${mode}`)

    this.displayProgression(chord, mode)
  }

  displayProgression(chord, mode) {
    this.makeProgressionRequest(chord, mode)
  }

  makeProgressionRequest(chord, mode) {
    const progression = this.progression()
    const progressionParam = encodeURIComponent(JSON.stringify(progression))
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
    const progressionElement = document.getElementById('progression-container')
    return progressionElement;
  }

  handleProgressionChordHover(event) {
    const isSilence = event.currentTarget.dataset.chord.toLowerCase() === 'silence'

    if (!isSilence) {
      this.displayChordOnTable(event)
    }

    this.displayRemoveChordElement(event)
  }

  displayChordOnTable(event) {
    const chord = event.currentTarget.dataset.chord
    const mode = event.currentTarget.dataset.mode

    const chordElement = document.querySelector(`[data-chord="${chord}"][data-mode="${mode}"]`)

    chordElement.classList.add('animate-pulse-quick')
    chordElement.dispatchEvent(new Event('mouseover'))

    setTimeout(() => {
      chordElement.classList.remove('animate-pulse-quick')
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

    if (chord.toLowerCase() !== 'silence') {
      const chordElement = document.querySelector(`[data-chord="${chord}"][data-mode="${mode}"]`)
      chordElement.classList.remove(`mode-shadow-${mode}`)
      chordElement.querySelector('div').classList.add('text-white')
      chordElement.querySelector('div').classList.remove(`text-modes-${mode}`)
    }

    const progressionChildren = targetParent.parentElement.children

    let siblingIndex = 0
    for (let i = 0; i < progressionChildren.length; i++) {
      if (progressionChildren[i] === targetParent) {
        siblingIndex = i
      }
    }

    let progression = this.progression()
    progression = progression.filter((_, index) => index !== siblingIndex)
    this.progression(progression)
    targetParent.remove()

    this.makeProgressionRequest('', '')
  }

  progression(progression) {
    const element = document.getElementById('progression')

    if (!element) {
      return []
    }

    if (progression) {
      element.dataset.progression = JSON.stringify(progression)
      return;
    }
    return JSON.parse(element.dataset.progression)
  }

  playChordSamples(chordNotes) {
    const notes = chordNotes.split(' - ')
    const keys = document.querySelectorAll('.key')
    const samples = []

    keys.forEach((key) => {
      if (notes.includes(key.dataset.note)) {
        samples.push(key.dataset.sample)
      }
    });

    samples.forEach((sample) => {
      const sound = new Howl({
        src: [sample],
        volume: 0.5,
      })

      sound.play();
    })
  }

  addSilenceToProgression() {
    this.makeProgressionRequest('Silence', 'Silence')
  }

  clearProgression() {
    const progression = this.progression()
    const progressionElement = document.getElementById('progression-container')
    progressionElement.innerHTML = ''

    progression.forEach((chord) => {
      if (chord.chord.toLowerCase() !== 'silence') {
        const chordElement = document.querySelector(`[data-chord="${chord.chord}"][data-mode="${chord.mode}"]`)
        chordElement.classList.remove(`mode-shadow-${chord.mode}`)
        chordElement.querySelector('div').classList.add('text-white')
        chordElement.querySelector('div').classList.remove(`text-modes-${chord.mode}`)
      }
    })

    this.progression([])

    document.getElementById('progression-container').dataset.playing = false;
  }
}
