import { Controller } from "@hotwired/stimulus"
import { Howl } from "howler"
import _ from "lodash"

export default class extends Controller {
  connect() {
    this.debouncedPlayChordSamples = _.debounce(this.playChordSamples, 1000)
  }

  displayChordNotes({ currentTarget: { dataset: { chordNotes, mode, chord }} }) {
    const chordNotesElement = this.chordNotesElement()

    // Split chord name and notes for better display
    const notes = chordNotes.split(' - ')
    const chordName = chord || notes[0]

    // Update the visualizer with chord name and notes separately
    chordNotesElement.innerHTML = `
      <div class="text-4xl font-bold text-white mb-2">${chordName}</div>
      <div class="text-lg text-gray-400">${chordNotes}</div>
    `

    this.highlightChordNotes(chordNotes, mode)
    this.playChords(chordNotes)
  }

  cancelChordPlay() {
    this.debouncedPlayChordSamples.cancel()
  }

  highlightChordNotes(chordNotes, mode) {
    const notes = chordNotes.split(' - ')
    const keys = document.querySelectorAll('.mini-key')

    const chordNotesElementParent = this.chordNotesElement().closest('.note-visualizer')
    if (chordNotesElementParent) {
      this.removeClass(chordNotesElementParent, 'mode-shadow-')
      chordNotesElementParent.classList.add(`mode-shadow-${mode}`)
    }

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

    if (!chordElement) {
      console.warn(`Chord element not found for chord: ${chord}, mode: ${mode}`)
      return
    }

    // Add pulse animation
    chordElement.classList.add('animate-pulse-quick')

    // Directly call displayChordNotes instead of dispatching event to avoid infinite recursion
    const chordNotes = chordElement.dataset.chordNotes
    const chordDataset = {
      chordNotes: chordNotes,
      mode: mode,
      chord: chord
    }

    if (chordNotes) {
      this.displayChordNotes({ currentTarget: { dataset: chordDataset } })
    }

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
    const keys = document.querySelectorAll('.mini-key')
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

  async toggle7ths(event) {
    const target = event.currentTarget
    const isChecking = target.checked

    // Get current key from URL
    const urlParams = new URLSearchParams(window.location.search)
    const currentKey = urlParams.get('key')

    console.log('[toggle7ths] Current key:', currentKey, 'isChecking:', isChecking)

    if (!currentKey) {
      console.error('No key selected')
      return
    }

    const url = `/home/update?key=${currentKey}&is_seventh=${isChecking}`
    console.log('[toggle7ths] Fetching URL:', url)

    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      console.log('[toggle7ths] Response status:', response.status)

      if (response.ok) {
        const html = await response.text()
        console.log('[toggle7ths] Response length:', html.length)
        console.log('[toggle7ths] Response HTML:', html.substring(0, 200))

        // Let Turbo handle the stream response automatically
        Turbo.renderStreamMessage(html)
      }
    } catch (error) {
      console.error('[toggle7ths] Error:', error)
    }
  }

  async updatePerspective(event) {
    const target = event.currentTarget
    const perspective = target.value

    // Get current key from URL
    const urlParams = new URLSearchParams(window.location.search)
    const currentKey = urlParams.get('key')

    console.log('[updatePerspective] Current key:', currentKey, 'perspective:', perspective)

    if (!currentKey) {
      console.error('[updatePerspective] No key selected')
      return
    }

    const url = `/home/update?key=${currentKey}&perspective=${perspective}`
    console.log('[updatePerspective] Fetching URL:', url)

    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      console.log('[updatePerspective] Response status:', response.status)

      if (response.ok) {
        const html = await response.text()
        console.log('[updatePerspective] Response length:', html.length)
        console.log('[updatePerspective] Response HTML:', html.substring(0, 200))

        // Let Turbo handle the stream response automatically
        Turbo.renderStreamMessage(html)
      }
    } catch (error) {
      console.error('[updatePerspective] Error:', error)
    }
  }

  async updateScaleOrder(event) {
    const target = event.currentTarget
    const orderBy = target.value

    // Get current key from URL
    const urlParams = new URLSearchParams(window.location.search)
    const currentKey = urlParams.get('key')

    console.log('[updateScaleOrder] Current key:', currentKey, 'orderBy:', orderBy)

    if (!currentKey) {
      console.error('[updateScaleOrder] No key selected')
      return
    }

    const url = `/home/update?key=${currentKey}&order_by=${orderBy}`
    console.log('[updateScaleOrder] Fetching URL:', url)

    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      console.log('[updateScaleOrder] Response status:', response.status)

      if (response.ok) {
        const html = await response.text()
        console.log('[updateScaleOrder] Response length:', html.length)
        console.log('[updateScaleOrder] Response HTML:', html.substring(0, 200))

        // Let Turbo handle the stream response automatically
        Turbo.renderStreamMessage(html)
      }
    } catch (error) {
      console.error('[updateScaleOrder] Error:', error)
    }
  }

  updateKey(event) {
    const target = event.currentTarget
    const selectedKey = target.value

    if (selectedKey) {
      const url = new URL(window.location.href)
      url.searchParams.set('key', selectedKey)
      window.location.href = url.toString()
    }
  }

  progressionContainer() {
    return document.getElementById('progression-container')
  }

  progressionElement() {
    return document.getElementById('progression')
  }

  chordElement(chord, mode) {
    // Only select chord box elements from the grid, not progression elements
    return document.querySelector(`.chord-box[data-chord="${chord}"][data-mode="${mode}"]`)
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

  // ===== SUPABASE SAVE/LOAD METHODS =====

  async saveProgression(event) {
    const progressionData = this.progression()
    const urlParams = new URLSearchParams(window.location.search)
    const currentKey = urlParams.get('key')

    if (!progressionData || progressionData.length === 0) {
      alert('No progression to save! Build a progression first by clicking on chords.')
      return
    }

    if (!currentKey) {
      alert('No key selected! Select a key first.')
      return
    }

    const name = prompt('Enter a name for this progression:')
    if (!name || name.trim() === '') return

    try {
      const { data, error } = await window.supabase
        .from('progressions')
        .insert([
          {
            name: name.trim(),
            key: currentKey,
            chord_groups: progressionData
          }
        ])
        .select()

      if (error) throw error

      console.log('Progression saved:', data)
      alert(`✅ Progression "${name}" saved successfully!`)
    } catch (error) {
      console.error('Error saving progression:', error)
      alert(`❌ Error saving progression: ${error.message}`)
    }
  }

  async loadProgressions(event) {
    try {
      const { data: progressions, error } = await window.supabase
        .from('progressions')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(20)

      if (error) throw error

      if (!progressions || progressions.length === 0) {
        alert('No saved progressions found. Save one first!')
        return
      }

      // Create a modal-style selection
      const list = progressions.map((p, i) =>
        `${i + 1}. ${p.name} (Key: ${p.key}) - ${new Date(p.created_at).toLocaleDateString()}`
      ).join('\n')

      const selection = prompt(`Select a progression to load:\n\n${list}\n\nEnter number (1-${progressions.length}):`)

      if (selection) {
        const index = parseInt(selection) - 1
        if (index >= 0 && index < progressions.length) {
          await this.loadProgression(progressions[index])
        } else {
          alert('Invalid selection!')
        }
      }
    } catch (error) {
      console.error('Error loading progressions:', error)
      alert(`❌ Error loading progressions: ${error.message}`)
    }
  }

  async loadProgression(progression) {
    console.log('Loading progression:', progression)

    // Clear current progression
    this.clearProgression()

    // Navigate to the correct key if different
    const urlParams = new URLSearchParams(window.location.search)
    const currentKey = urlParams.get('key')

    if (currentKey !== progression.key) {
      // Redirect to correct key
      window.location.href = `/?key=${progression.key}`
      // Store progression data in sessionStorage to rebuild after redirect
      sessionStorage.setItem('pendingProgression', JSON.stringify(progression))
      return
    }

    // Rebuild progression from saved data
    for (const item of progression.chord_groups) {
      await this.makeProgressionRequest(
        JSON.stringify(item.chord_group),
        item.mode
      )
      // Small delay to ensure requests process in order
      await new Promise(resolve => setTimeout(resolve, 50))
    }

    alert(`✅ Loaded progression "${progression.name}"`)
  }

  // Check for pending progression after key change
  connect() {
    super.connect()

    const pendingProgression = sessionStorage.getItem('pendingProgression')
    if (pendingProgression) {
      sessionStorage.removeItem('pendingProgression')
      const progression = JSON.parse(pendingProgression)

      // Wait for page to be fully loaded
      setTimeout(() => {
        this.loadProgression(progression)
      }, 500)
    }
  }
}

