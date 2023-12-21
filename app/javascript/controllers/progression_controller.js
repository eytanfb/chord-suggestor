import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progression"
export default class extends Controller {
  playProgression() {
    const bpm = document.getElementById('bpm').value;
    const chords = Array.from(document.querySelectorAll('.progression-chord'));
    const playButton = document.getElementById('progression-controls-play');
    const stopButton = document.getElementById('progression-controls-stop');
    const isLoop = document.getElementById('progression-controls-loop').dataset.loop === 'true';

    document.getElementById('progression-container').dataset.playing = true;
    document.getElementById('progression-container').dataset.hovering = false;
    document.getElementById('bpm').disabled = true;

    if (chords.length) {
      playButton.classList.add('hidden');
      stopButton.classList.remove('hidden');

      if (!isLoop) {
        chords.forEach((chord, index) => {
          setTimeout(() => {
            this.highlightChord(chord, bpm);

            if (index === chords.length - 1) {
              setTimeout(() => {
                playButton.classList.remove('hidden');
                stopButton.classList.add('hidden');
                document.getElementById('progression-container').dataset.playing = false;
                document.getElementById('bpm').disabled = false;
              }, 60000 / bpm);
            }
          }, 60000 / bpm * index);
        });
      } else {
        const internalLoops = []
        const loopInterval = setInterval(() => {
          chords.forEach((chord, index) => {
            const loop = setTimeout(() => {
              this.highlightChord(chord, bpm);
            }, 60000 / bpm * index);

            internalLoops.push(loop);
          });
        }, 60000 / bpm * chords.length);

        stopButton.addEventListener('click', () => {
          clearInterval(loopInterval);
          internalLoops.forEach((loop) => {
            clearTimeout(loop);
          });
          this.stopProgression();
          stopButton.removeEventListener('click', () => {});
        })
      }
    } else {
      document.getElementById('progression-help').classList.remove('hidden');
      document.getElementById('progression-help').classList.add('animate-pulse-quick');

      setInterval(() => {
        document.getElementById('progression-help').classList.add('hidden');
        document.getElementById('progression-help').classList.remove('animate-pulse-quick');
      }, 5000);
    }
  }

  stopProgression() {
    const playButton = document.getElementById('progression-controls-play')
    const stopButton = document.getElementById('progression-controls-stop')

    document.getElementById('bpm').disabled = false

    stopButton.classList.add('hidden')
    playButton.classList.remove('hidden')

    document.getElementById('progression-container').dataset.playing = false
  }

  updateBpm({ currentTarget: { value } }) {
    const bpmLabel = document.getElementById('bpm-label');
    bpmLabel.innerText = `${value}`;
  }

  updateLoop(event) {
    const loop = event.currentTarget.dataset.loop;
    const icon = event.currentTarget.firstElementChild;

    if (loop === 'true') {
      event.currentTarget.dataset.loop = false;
      icon.classList.remove('fa-spin');
    } else {
      event.currentTarget.dataset.loop = true;
      icon.classList.add('fa-spin');
    }
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
