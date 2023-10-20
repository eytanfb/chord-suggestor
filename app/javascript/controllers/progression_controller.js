import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progression"
export default class extends Controller {
  playProgression() {
    const bpm = document.getElementById('bpm').value;
    const chords = Array.from(document.querySelectorAll('.progression-chord'));
    const playButton = document.getElementById('progression-controls');
    const icon = playButton.firstElementChild;

    icon.classList.add('fa-stop');
    icon.classList.remove('fa-play');

    chords.forEach((chord, index) => {
      setTimeout(() => {
        this.highlightChord(chord, bpm);

        if (index === chords.length - 1) {
          icon.classList.add('fa-play');
          icon.classList.remove('fa-stop');
        }
      }, 60000 / bpm * index);
    });
  }

  updateBpm({ currentTarget: { value } }) {
    const bpmLabel = document.getElementById('bpm-label');
    bpmLabel.innerText = `${value}`;
  }

  highlightChord(chord, bpm) {
    chord.dispatchEvent(new Event('mouseover'));
    const mode = chord.dataset.mode;
    chord.classList.add(`border-${mode}`);

    const mouseOutInterval = setInterval(() => {
      this.unhighlightChord(chord);
      clearInterval(mouseOutInterval);
    }, 60000 / bpm);
  }

  unhighlightChord(chord) {
    chord.dispatchEvent(new Event('mouseleave'));
    const mode = chord.dataset.mode;
    chord.classList.remove(`border-${mode}`);
  }
}
