# ♟️ RacketChess

A fully functional chess game implemented in **Racket**, demonstrating the power and elegance of **pure functional programming**. This project is an experimental prototype designed as an educational tool to explore how pure functional paradigms can implement complex logic without resorting to traditional imperative loops.

## 📋 Table of Contents

- [Overview](#-overview)
  - [Why Racket?](#why-racket)
- [Features](#-features)
  - [✅ Fully Implemented](#-fully-implemented)
  - [❌ Not Implemented](#-not-implemented-known-limitations)
- [Prerequisites](#-prerequisites)
  - [Required File Structure](#required-file-structure)
- [Installation](#-installation)
  - [Step 1: Install Racket](#step-1-install-racket)
  - [Step 2: Clone the Repository](#step-2-clone-the-repository)
  - [Step 3: Verify the Structure](#step-3-verify-the-structure)
  - [Step 4: Run the Game](#step-4-run-the-game)
- [How to Play](#-how-to-play)
  - [Controls](#controls)
  - [Important Rules](#important-rules)
  - [Example Game](#example-game)
- [Functional Architecture](#-functional-architecture)
  - [Design Philosophy](#design-philosophy)
  - [Data Flow](#data-flow)
  - [Key Data Structures](#key-data-structures)
- [Code Structure](#-code-structure)
  - [Main Functions](#main-functions)
  - [Move Validation](#move-validation)
  - [Path Verification](#path-verification)
  - [Check/Checkmate Detection](#checkcheckmate-detection)
  - [Input Handling and Updates](#input-handling-and-updates)
- [Functional Paradigms Used](#-functional-paradigms-used)
  - [1. Pure Recursion (No Loops)](#1-pure-recursion-no-loops)
  - [2. Data Immutability](#2-data-immutability)
  - [3. Higher-Order Functions](#3-higher-order-functions)
  - [4. Implicit Lazy Evaluation](#4-implicit-lazy-evaluation)
  - [5. Function Composition](#5-function-composition)
- [Known Limitations](#-known-limitations)
  - [Not Implemented](#not-implemented)
  - [Fully Functional Features](#fully-functional-features)
- [Contributing](#-contributing)
  - [How to Contribute](#how-to-contribute)
  - [Suggested Improvement Areas](#suggested-improvement-areas)
- [References](#-references)
  - [Official Documentation](#official-documentation)
  - [Educational Resources on Functional Programming](#educational-resources-on-functional-programming)
  - [Chess Information](#chess-information)
- [Author](#-author)
- [License](#-license)
- [Educational Note](#-educational-note)

---

## 🎯 Overview

**RacketChess** is much more than just a chess game. It's a practical demonstration of how **pure functional programming**, based on recursion instead of imperative loops, can manage:

- Complex game logic
- Interactive graphical interface
- Chess rule validation
- Check and checkmate detection
- Immutable state manipulation

This project is ideal for:
- **Students** who want to learn functional programming in real-world contexts
- **Developers** curious about paradigms alternative to imperative programming
- **Open Source enthusiasts** interested in exploring the Racket community
- **Academic researchers** in programming languages and functional paradigms

### Why Racket?

Racket is a modern dialect of Lisp that provides an excellent balance between:
- Pure functional features
- Integrated graphics tools (graphics library)
- Active community and comprehensive documentation
- Ease of expressing abstract concepts concretely

For more information, check the [Official Racket Documentation](https://docs.racket-lang.org/).

---

## ✨ Features

### ✅ Fully Implemented

- **Basic Movements for All Pieces**
  - Pawns: single and double advance, diagonal capture movement
  - Rooks: unlimited horizontal and vertical movement
  - Knights: L-shaped movement (2+1 squares)
  - Bishops: unlimited diagonal movement
  - Queens: combination of rook and bishop
  - Kings: movement to any adjacent square

- **Piece Capture**: Capture logic implemented for all pieces
- **Pawn Promotion**: Transformation to Rook, Bishop, Knight, or Queen upon reaching the end of the board
- **Check Detection**: Verifies if the king is under attack
- **Checkmate Detection**: Identifies when a player has lost
- **Move Validation**: Blocks invalid moves and moves that would leave the king in check
- **Interactive Graphical Interface**: Based on Racket's graphics library
- **Turn System**: Automatic alternation between players

### ❌ Not Implemented (Known Limitations)

- **Castling**: Special movement combining king and rook
- **En Passant**: Special pawn capture
- Other specialized chess variants

Despite these limitations, the game works completely for standard matches.

---

## 🛠️ Prerequisites

To run **RacketChess**, you need:

1. **Operating System**: Windows (versions after Windows 7)
2. **Racket**: Version 8.16 or higher (tested up to Racket 9.0)
   - Download from: https://racket-lang.org/
3. **DrRacket or Compatible Editor**: To edit and run the code
   - Included with Racket installation
4. **Assets Folder**: Graphical images needed for the interface

### Required File Structure

```
RacketChess/
├── ChessGameEngine.rkt
└── assets/
    ├── LoadingScreen.png
    ├── ChessTableBackground.png
    ├── MenuForWhitePlayer.png
    ├── MenuForBlackPlayer.png
    └── [piece image files]
```

**Important Note**: The `assets/` folder with images is **essential** for the program to work. File names and pixel dimensions must match exactly what is specified in the code.

---

## 🚀 Installation

### Step 1: Install Racket

1. Download Racket from [racket-lang.org](https://racket-lang.org/)
2. Run the installer and follow the instructions
3. Verify the installation by opening PowerShell and running:
   ```powershell
   racket --version
   ```
   You should see: `Welcome to Racket v8.16+`

### Step 2: Clone the Repository

```powershell
git clone https://github.com/yourusername/RacketChess.git
cd RacketChess
```

### Step 3: Verify the Structure

Ensure the `assets/` folder is present with all necessary images:
- `LoadingScreen.png`
- `ChessTableBackground.png`
- `MenuForWhitePlayer.png`
- `MenuForBlackPlayer.png`
- Pieces

### Step 4: Run the Game

**Option A: With DrRacket (Recommended for beginners)**

1. Open DrRacket
2. Open the `ChessGameEngine.rkt` file
3. Click the **Run** button (or press Ctrl+Shift+R)

**Option B: From the Command Line**

```powershell
cd C:\path\to\RacketChess
racket ChessGameEngine.rkt
```

---

## 🎮 How to Play

### Controls

**Everything is controlled with the mouse:**

1. **Select a piece**: Click on the piece you want to move
   - A rectangle will appear around the selected piece
2. **Move the piece**: Click on the destination square
   - The move will be validated automatically
   - If invalid, an "Invalid move" message will appear

### Important Rules

- **Alternating turns**: The game automatically alternates between white and black players
- **Move validation**: Only legal moves according to chess rules are allowed
- **King Protection**: You cannot make a move that puts your king in check
- **Checkmate**: The game ends when a player is in checkmate

### Example Game

1. White player starts
2. Clicks on a white pawn
3. Clicks on the destination square
4. The board updates and it's the black player's turn
5. Repeat until checkmate

---

## 🏗️ Functional Architecture

### Design Philosophy

**RacketChess** is built following the fundamental principles of **pure functional programming**:

1. **No State Mutation**: All data (board, turns, etc.) is **immutable**
2. **Pure Recursion**: Instead of `while` or `for` loops, everything is implemented through **recursion**
3. **Pure Functions**: Functions always return the same result for the same inputs, with no side effects
4. **Function Composition**: Small, specialized functions combine to create complex behaviors

### Data Flow

```
Initialization
     ↓
Display Loading Screen
     ↓
Initialize Board Graphics
     ↓
Create Board (64 Squares)
     ↓
Place Pieces
     ↓
Main Loop: ProcessClicks
     ├── Wait for Player Click
     ├── Validate Move
     ├── Update State (Board + Arrays)
     ├── Check for Check/Checkmate
     └── Next Turn
```

### Key Data Structures

1. **Visual Arrangement** (String)
   - Visual representation of piece positions
   - Format: 2 characters per square (color + type)
   - Example: `"BRBHBB...  "` (BR = Black Rook, space = empty square)

2. **Logical Arrangement** (String)
   - Logical representation identical to visual in this game
   - Used to validate moves and detect check
   - Updated with each valid move

3. **Turn Count** (Number)
   - Simple counter to alternate turns
   - Even numbers = black's turn, odd = white's turn

---

## 💻 Code Structure

### Main Functions

| Function | Purpose |
|----------|---------|
| `StartGame()` | Main function that initiates the entire game |
| `ShowLoadingScreen()` | Displays loading screen for 2 seconds |
| `InitializeBoardGraphics()` | Sets up the basic board graphics |
| `CreateChessBoard()` | Recursively draws the 64 squares |
| `PlacePieces()` | Recursively places all initial pieces |

### Move Validation

| Function | Responsibility |
|----------|-----------------|
| `MovePawn()` | Validates pawn movements |
| `MoveRook()` | Validates rook movements |
| `MoveKnight()` | Validates knight movements |
| `MoveBishop()` | Validates bishop movements |
| `MoveQueen()` | Validates queen movements |
| `MoveKing()` | Validates king movements |

### Path Verification

| Function | Responsibility |
|----------|-----------------|
| `IsVerticalPathClear()` | Verifies vertical path is unobstructed |
| `IsHorizontalPathClear()` | Verifies horizontal path is unobstructed |
| `IsDiagonalPathClear()` | Verifies diagonal path is unobstructed |

### Check/Checkmate Detection

| Function | Responsibility |
|----------|-----------------|
| `IsPositionUnderAttack()` | Verifies if a square is under attack |
| `IsKingInCheck()` | Detects if king is in check |
| `IsCheckmate()` | Detects checkmate |
| `ExistsMoveToEscapeCheck()` | Verifies if there's a move to escape check |

### Input Handling and Updates

| Function | Responsibility |
|----------|-----------------|
| `ProcessClicks()` | Main loop waiting for player clicks |
| `ProcessSecondClick()` | Processes second click (destination square) |
| `ExecuteMove()` | Executes a validated move |
| `UpdateBoardSquares()` | Updates visually affected squares |

---

## 🔄 Functional Paradigms Used

### 1. **Pure Recursion (No Loops)**

Instead of imperative loops, everything is implemented recursively:

```racket
; Example: Search for a king on the board
(define (SearchKing position)
  (if (> position 64)
      #f  ; King not found
      (if (is-the-king? position)
          position
          (SearchKing (+ position 1)))))  ; Recursion
```

**Advantage**: Each call is independent, facilitating formal code analysis.

### 2. **Data Immutability**

Boards are never modified "in-place". Instead, new strings are created:

```racket
; Instead of mutation:
(set! board "...")

; We use string composition:
(string-append 
  (substring old-board 0 start-pos)
  "  "  ; Space where the piece was
  (substring old-board end-pos))
```

**Advantage**: State history is easily traceable.

### 3. **Higher-Order Functions**

Functions accept and return other functions:

```racket
; The (draw-pixmap) function returns a function
; that is then applied to the viewport
((draw-pixmap viewport) "image.png" (make-posn 0 0))
```

**Advantage**: More flexible and reusable code.

### 4. **Implicit Lazy Evaluation**

Through nested conditionals, unnecessary branches are avoided:

```racket
(cond
  [(invalid-move? move) #f]
  [(would-leave-king-in-check?) #f]
  [else (execute-move)])
```

**Advantage**: Efficiency and fine-grained control of execution flow.

### 5. **Function Composition**

Small functions combine to create complex behaviors:

```racket
; MoveRook = (ValidateRookMove + CheckPathClear + ExecuteMove)
(define (MoveRook ...)
  (cond
    [(and (valid-rook-pattern?) (path-clear?))
     (ExecuteMove ...)]))
```

---

## ⚠️ Known Limitations

### Not Implemented

1. **Castling**
   - Special movement combining king and rook
   - Would require additional state tracking (previous moves)

2. **En Passant**
   - Special pawn capture
   - Would require context from the previous move

### Fully Functional Features

- ✅ All basic movements
- ✅ Piece capture
- ✅ Pawn promotion
- ✅ Check and checkmate
- ✅ King protection

---

## 🤝 Contributing

**Contributions are welcome!** This project is open for improvements and new features.

### How to Contribute

1. **Fork** this repository on GitHub
2. **Create a branch** for your feature:
   ```powershell
   git checkout -b feature/new-feature
   ```
3. **Make commits** with descriptive messages:
   ```powershell
   git commit -m "Add castling for king and rook"
   ```
4. **Push** to your branch:
   ```powershell
   git push origin feature/new-feature
   ```
5. **Open a Pull Request** describing your changes

### Suggested Improvement Areas

- [ ] Implement castling
- [ ] Implement en passant
- [ ] Add piece promotion UI (currently visual only)
- [ ] Create compiled executable version (.exe)
- [ ] Add sound and visual effects
- [ ] Game save system
- [ ] Computer opponent with AI
- [ ] Improved UI and visual themes

---

## 📚 References

### Official Documentation

- **[Racket Documentation](https://docs.racket-lang.org/)** - Complete language reference
- **[Racket Graphics Library](https://docs.racket-lang.org/graphics/index.html)** - Graphics API used

### Educational Resources on Functional Programming

- [How to Design Programs (HtDP)](https://htdp.org/) - Excellent introduction to Racket and functional paradigm
- [The Racket Guide](https://docs.racket-lang.org/guide/index.html) - Official Racket guide

### Chess Information

- [FIDE Official Chess Rules](https://www.fide.com/FIDE/handbook/LawsOfChess.pdf)

---

## 👨‍💼 Author

**Ing.(C) Andrés David Rincón Salazar**

- Code Version: 12.5
- Publication Date: January 2026
- Language: Racket 9.0

---

## 📄 License

This project is licensed under the **MIT License** - see the `LICENSE` file for details.

Copyright (c) 2026 Andrés David Rincón Salazar

---

## 🎓 Educational Note

This project demonstrates that **pure functional programming is not just theoretical** or limited to academic problems. You can build **real, interactive, and complete applications** without abandoning functional principles.

If you're learning about functional programming, this code is an excellent starting point to explore:
- How to manage complex state functionally
- How to build interactive interfaces without mutation
- How recursion can completely replace loops
- How to maintain clean, predictable, and maintainable code

I hope you enjoy exploring RacketChess! 🎉

---

**Last Update**: January 7, 2026