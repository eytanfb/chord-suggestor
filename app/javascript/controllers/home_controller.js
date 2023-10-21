import { Controller } from "@hotwired/stimulus"
import { Howl } from "howler"
import _ from "lodash"

export default class extends Controller {
  connect() {
    this.debouncedPlayChordSamples = _.debounce(this.playChordSamples, 500)
  }

  displayChordNotes({ currentTarget: { dataset: { chordNotes, mode }} }) {
    const chordNotesElement = document.getElementById('chord-notes')
    chordNotesElement.innerHTML = chordNotes

    const chordNotesElementParent = chordNotesElement.parentElement
    this.removeClass(chordNotesElementParent, 'mode-shadow-')

    chordNotesElementParent.classList.add(`mode-shadow-${mode}`)

    this.highlightChordNotes(chordNotes, mode)

    const isPlaying = document.getElementById('progression-container').dataset.playing
    const isHovering = document.getElementById('progression-container').dataset.hovering

    if (isHovering === 'false' || isPlaying === 'true') {
      if (isPlaying === 'true') {
        this.playChordSamples(chordNotes)
      } else {
        this.debouncedPlayChordSamples(chordNotes)
      }
    } else {
      document.getElementById('progression-container').dataset.hovering = false;
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

  selectChord({ currentTarget, currentTarget: { dataset: { chord, mode }} }) {
    currentTarget.classList.add(`mode-shadow-${mode}`)
    currentTarget.querySelector('div').classList.remove('text-white')
    currentTarget.querySelector('div').classList.add(`text-modes-${mode}`)

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
    document.getElementById('progression-container').dataset.hovering = true;

    if (!isSilence) {
      this.displayChordOnTable(event)
    }

    this.displayRemoveChordElement(event)
  }

  handleProgressionChordClick({ currentTarget: { dataset: { chord } }}) {
    const isSilence = chord.toLowerCase() === 'silence'

    if (!isSilence) {
      document.getElementById('progression-container').dataset.playing = true;
      this.displayChordOnTable(event)
      document.getElementById('progression-container').dataset.playing = false;
    }
  }

  displayChordOnTable({ currentTarget: { dataset: { chord, mode }} }) {
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

    const progressionChildren = targetParent.parentElement.children

    const progression = this.removeFromProgression(progressionChildren, targetParent)
    targetParent.remove()

    if (chord.toLowerCase() !== 'silence') {
      const chordInProgression = progression.some((chordInArray) => chordInArray.chord === chord && chordInArray.mode === mode)

      if (!chordInProgression) {
        const chordElement = document.querySelector(`[data-chord="${chord}"][data-mode="${mode}"]`)
        chordElement.classList.remove(`mode-shadow-${mode}`)
        chordElement.querySelector('div').classList.add('text-white')
        chordElement.querySelector('div').classList.remove(`text-modes-${mode}`)
      }
    }

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
        volume: 1,
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

  removeFromProgression(progressionChildren, targetParent) {
    let siblingIndex = 0
    for (let i = 0; i < progressionChildren.length; i++) {
      if (progressionChildren[i] === targetParent) {
        siblingIndex = i
      }
    }

    let progression = this.progression()
    progression = progression.filter((_, index) => index !== siblingIndex)
    this.progression(progression)
    return this.progression()
  }

  toggle7ths(event) {
    // make a call to the backend to toggle 7ths
    // to the home_controller#update action
    const target = event.currentTarget
    const isChecking = target.checked

    const url = '/home?is_seventh=' + isChecking
    fetch(url, { method: 'POST' })
  }
}
