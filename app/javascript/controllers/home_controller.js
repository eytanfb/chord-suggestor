import { Controller } from "@hotwired/stimulus"
import { Howl } from "howler"
import _ from "lodash"

export default class extends Controller {
  connect() {
    this.debouncedPlayChordSamples = _.debounce(this.playChordSamples, 1000)
  }

  displayChordNotes({ currentTarget: { dataset: { chordNotes, mode }} }) {
    const chordNotesElement = this.chordNotesElement()
    chordNotesElement.innerHTML = chordNotes

    this.highlightChordNotes(chordNotes, mode)
    console.log('displayChordNotes')
    this.playChords(chordNotes)
  }

  cancelChordPlay() {
    this.debouncedPlayChordSamples.cancel()
  }

  highlightChordNotes(chordNotes, mode) {
    const notes = chordNotes.split(' - ')
    const keys = document.querySelectorAll('.key')

    const chordNotesElementParent = this.chordNotesElement().parentElement
    this.removeClass(chordNotesElementParent, 'mode-shadow-')

    chordNotesElementParent.classList.add(`mode-shadow-${mode}`)

    keys.forEach((key) => {
      this.highlightKey(notes, key, mode)
    });
  }

  removeClass(element, classNamePrefix) {
    element.classList.forEach((className) => {
      if (className.includes(classNamePrefix)) {
        element.classList.remove(className)
      }
    })
  }

  selectChord({ currentTarget, currentTarget: { dataset: { chordGroup, mode }} }) {
    currentTarget.classList.add(`mode-shadow-${mode}`)
    currentTarget.querySelector('div').classList.remove('text-white')
    currentTarget.querySelector('div').classList.add(`text-modes-${mode}`)

    this.displayProgression(chordGroup, mode)
  }

  displayProgression(chord, mode) {
    this.makeProgressionRequest(chord, mode)
  }

  makeProgressionRequest(chord, mode) {
    const progression = this.progression()
    const progressionParam = encodeURIComponent(JSON.stringify(progression))
    const chordParam = encodeURIComponent(chord)
    const modeParam = encodeURIComponent(mode)

    const url = `/progression?progression=${progressionParam}&&chord_group=${chordParam}&&mode=${modeParam}`
    fetch(url, { method: 'POST' })
      .then(response => response.text())
      .then(html => {
        this.progressionContainer().innerHTML = html
      })
  }

  handleProgressionChordHover(event) {
    const isSilence = event.currentTarget.dataset.chord.toLowerCase() === 'silence'
    this.progressionContainer().dataset.hovering = true;

    if (!isSilence) {
      this.displayChordOnTable(event)
    }

    this.displayRemoveChordElement(event)
  }

  handleProgressionChordClick(event) {
    const isSilence = event.currentTarget.dataset.chord.toLowerCase() === 'silence'

    if (!isSilence) {
      this.progressionContainer().dataset.playing = true;
      this.displayChordOnTable(event)
      this.progressionContainer().dataset.playing = false;
    }
  }

  displayChordOnTable({ currentTarget: { dataset: { chord, mode }} }) {
    const chordElement = this.chordElement(chord, mode)

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

  displayAlternativeChords(event) {
    const target = event.currentTarget

    const alternativeChords = target.querySelectorAll('.alternative-chord')

    alternativeChords.forEach((alternativeChord) => {
      alternativeChord.classList.remove('hidden')
    });

    target.addEventListener('mouseleave', () => {
      alternativeChords.forEach((alternativeChord) => {
        alternativeChord.classList.add('hidden')
      });
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
        const chordElement = this.chordElement(chord, mode)
        chordElement.classList.remove(`mode-shadow-${mode}`)
        chordElement.querySelector('div').classList.add('text-white')
        chordElement.querySelector('div').classList.remove(`text-modes-${mode}`)
      }
    }

    this.makeProgressionRequest('', '')
  }

  progression(progression) {
    const element = this.progressionElement()

    if (!element) {
      return []
    }

    if (progression) {
      element.dataset.progression = JSON.stringify(progression)
      return;
    }
    return JSON.parse(element.dataset.progression)
  }

  playChords(chordNotes) {
    const isProgressionPlaying = this.progressionContainer().dataset.playing
    const isHovering = this.progressionContainer().dataset.hovering
    const isMuted = this.mutePreviewElement().checked

    if (isHovering === 'false' || isProgressionPlaying === 'true') {
      if (!isMuted) {
        if (isProgressionPlaying === 'true') {
          this.playChordSamples(chordNotes)
        } else {
          this.debouncedPlayChordSamples(chordNotes)
        }
      }
    } else {
      this.progressionContainer().dataset.hovering = false;
    }
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
    const progressionElement = this.progressionContainer()
    progressionElement.innerHTML = ''


    progression.forEach(({ chord_group: { primary_chord: { name } }, mode }) => {
      if (name.toLowerCase() !== 'silence') {
        const chordElement = this.chordElement(name, mode)
        chordElement.classList.remove(`mode-shadow-${mode}`)
        chordElement.querySelector('div').classList.add('text-white')
        chordElement.querySelector('div').classList.remove(`text-modes-${mode}`)
      }
    })

    this.progression([])
    this.progressionContainer().dataset.playing = false;
    this.bpmElement().disabled = false;
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
    const target = event.currentTarget
    const isChecking = target.checked

    const url = '/home?is_seventh=' + isChecking
    fetch(url, { method: 'POST' })
  }

  updateScaleOrder(event) {
    const target = event.currentTarget
    const scaleOrder = target.value

    const split = window.location.href.split('?')
    const base = split[0]
    const key = split[1].split('&')[0]

    const redirectUrl = base + `?${key}&order_by=${scaleOrder}`
    window.location.href = redirectUrl
  }

  progressionContainer() {
    return document.getElementById('progression-container')
  }

  progressionElement() {
    return document.getElementById('progression')
  }

  chordElement(chord, mode) {
    return document.querySelector(`[data-chord="${chord}"][data-mode="${mode}"]`)
  }

  chordNotesElement() {
    return document.getElementById('chord-notes')
  }

  bpmElement() {
    return document.getElementById('bpm')
  }

  mutePreviewElement() {
    return document.getElementById('mute-preview')
  }

  highlightKey(notes, key, mode) {
    this.removeClass(key, 'highlighted-note-')

    if (notes.includes(key.dataset.note)) {
      key.classList.add(`highlighted-note-${mode}`)
    }
  }
}

