# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby on Rails 7 web application that suggests chord progressions based on musical theory. Users can:
- Select a key and view all available chords organized by musical mode (Ionian, Dorian, Phrygian, Lydian, Mixolydian, Aeolian, Locrian)
- Build chord progressions by selecting chords from different modes
- Toggle between triads and seventh chords
- Sort chords by mode (brightness) or scale degree

The application uses **Hotwire** (Turbo + Stimulus) for interactive features without writing traditional JavaScript, and **TailwindCSS** for styling.

## Development Commands

### Running the Application
```bash
# Start development server (runs Rails server on port 3000 + TailwindCSS watcher)
bin/dev

# Or run individually:
bin/rails server -p 3000    # Rails server
bin/rails tailwindcss:watch # TailwindCSS compiler
```

### Testing
```bash
# Run all tests
bundle exec rspec

# Run a specific test file
bundle exec rspec spec/classes/chord_spec.rb

# Run a specific test by line number
bundle exec rspec spec/classes/chord_spec.rb:25
```

### Other Commands
```bash
# Install dependencies
bundle install

# Database setup (if needed)
bin/rails db:create
bin/rails db:migrate

# Rails console
bin/rails console

# Run linter (if configured)
bundle exec rubocop
```

## Architecture & Core Concepts

### Music Theory Domain Model

The application is built around a rich domain model representing music theory concepts. All core domain classes are in `app/classes/`:

**Core Building Blocks:**
- `Note` - Represents musical notes (C, D, E, etc.) with support for sharps/flats and semitone calculations
- `ChordShape` - Defines chord qualities (Major, Minor, Diminished, etc.) via interval patterns
- `Chord` - Combines a root Note with a ChordShape to create a specific chord (e.g., "Cmaj7")
- `ChordGroup` - Groups a primary chord with alternative substitution chords

**Musical Modes:**
- `Mode` (base class) - Defines intervals and chord shapes for a mode
- Seven concrete modes: `Ionian`, `Dorian`, `Phrygian`, `Lydian`, `Mixolydian`, `Aeolian`, `Locrian`
- Each mode defines:
  - Scale intervals (e.g., Ionian: [0, 2, 4, 5, 7, 9, 11])
  - Chord shapes for each scale degree
  - Separate shapes for triads vs seventh chords

**Scale & Progression:**
- `Scale` - Generates all seven notes and chords for a given key + mode combination
  - Handles enharmonic spelling (sharps vs flats) to ensure proper note names
  - Adds alternative chords (secondary dominants, diminished approaches)
- `Progression` - Manages a sequence of selected chords with their modes
- `ChordsForKeyHandler` - Orchestrates generation of all seven modes for a given key

### Data Flow

1. **User selects a key** → `HomeController#index`
   - `ChordsForKeyHandler` generates all seven modes for the key
   - `ChordsPresenter` sorts results by mode brightness or scale degree
   - Renders chord grid view with all possibilities

2. **User toggles seventh chords** → `HomeController#update` (via Turbo)
   - Stores preference in Rails cache
   - Page reloads to regenerate chords with new shapes

3. **User builds progression** → `ProgressionController#update` (via Turbo)
   - Receives chord selection + mode via Stimulus controller
   - Updates progression in Rails cache
   - Renders updated progression partial

### Frontend Architecture

**Hotwire Integration:**
- Turbo Frames/Streams handle dynamic updates without full page reloads
- Stimulus controllers in `app/javascript/controllers/`:
  - `home_controller.js` - Handles chord selection, seventh toggle, sorting
  - `progression_controller.js` - Manages progression building and playback
  - Uses Web Audio API for chord playback

**Views Structure:**
- `app/views/home/index.html.erb` - Main chord selection interface
- `app/views/shared/_progression.html.erb` - Progression display partial
- Server-side rendered with Turbo for updates

### Alternative Chord Generation

The `Scale` class adds chord substitutions for non-tonic scale degrees:
- **Secondary Dominants**: For scale degrees 2-6, adds the V7/X chord (dominant 7th a fifth above)
- **Diminished Approaches**: Adds diminished 7th chord a half-step below target chord
- Scale degrees 1, 5, and 7 don't get alternatives (in `Scale#alternative_chords_for`)

This is generated in `Scale#add_alternatives` at lines 65-73.

### Note Naming & Enharmonics

The `Note` class handles complex enharmonic logic:
- Uses semitone values (0-11) for interval calculations
- Converts between sharp/flat equivalents (`Note.sharp_version`, `Note.flat_version`)
- `Scale` ensures proper note spelling for readability:
  - Checks if scale uses sharps or flats based on key
  - Ensures no duplicate letter names in a scale
  - Ensures notes are successive in the musical alphabet

This logic is in `Scale#get_current_note_for_interval` (lines 32-45).

### State Management

The application uses **Rails.cache** for ephemeral state:
- `is_seventh` - Boolean for triad vs seventh chord preference
- `progression` - JSON representation of current chord progression

This avoids database persistence for user session data.

## Testing Conventions

Tests use RSpec with the following structure:
- `spec/classes/` - Domain model unit tests
- `spec/controllers/` - Controller integration tests
- Configuration in `spec/rails_helper.rb` and `spec/spec_helper.rb`

Test files mirror the structure of `app/` directory.

## Key Files Reference

- `app/classes/chords_for_key_handler.rb` - Entry point for generating all chords in a key
- `app/classes/scale.rb` - Core scale generation and alternative chord logic
- `app/classes/mode.rb` - Base class for all seven modes
- `app/presenters/chords_presenter.rb` - Sorting logic for chord display
- `app/controllers/home_controller.rb` - Main UI controller
- `app/controllers/progression_controller.rb` - Progression building controller
- `config/routes.rb` - Application routes

## Dependencies

- **Ruby**: 3.2.0
- **Rails**: 7.0.8
- **Database**: MySQL (`mysql2` gem)
- **Frontend**: Hotwire (Turbo + Stimulus), TailwindCSS, Importmap
- **Testing**: RSpec, Capybara, FactoryBot, Faker
- **Server**: Puma
- **Cache**: Redis
