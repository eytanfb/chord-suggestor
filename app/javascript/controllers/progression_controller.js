import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progression"
export default class extends Controller {
  playProgression() {
    const bpm = document.getElementById('bpm').value;
    const chords = Array.from(document.querySelectorAll('.progression-chord'));
    const playButton = document.getElementById('progression-controls');
    const icon = playButton.firstElementChild;

    if (chords.length) {
      icon.classList.add('fa-stop');
      icon.classList.remove('fa-play');

      chords.forEach((chord, index) => {
        setTimeout(() => {
          this.highlightChord(chord, bpm);

          if (index === chords.length - 1) {
            setTimeout(() => {
              playButton.firstElementChild.classList.add('fa-play');
              playButton.firstElementChild.classList.remove('fa-stop');
            }, 60000 / bpm);
          }
        }, 60000 / bpm * index);
      });
    } else {
      document.getElementById('progression-help').classList.remove('hidden');
      document.getElementById('progression-help').classList.add('animate-pulse-quick');

      setInterval(() => {
        document.getElementById('progression-help').classList.add('hidden');
      document.getElementById('progression-help').classList.remove('animate-pulse-quick');
      }, 5000);
    }
  }

  updateBpm({ currentTarget: { value } }) {
    const bpmLabel = document.getElementById('bpm-label');
    bpmLabel.innerText = `${value}`;
  }

  highlightChord(chord, bpm) {
    chord.dispatchEvent(new Event('mouseover'));
    const mode = chord.dataset.mode;
    chord.classList.add(`border-modes-${mode}`);

    const mouseOutInterval = setInterval(() => {
      this.unhighlightChord(chord);
      clearInterval(mouseOutInterval);
    }, 60000 / bpm);
  }

  unhighlightChord(chord) {
    chord.dispatchEvent(new Event('mouseleave'));
    const mode = chord.dataset.mode;
    chord.classList.remove(`border-modes-${mode}`);
  }
}
