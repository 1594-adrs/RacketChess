#lang racket

;; ========================== CHESS GAME IMPLEMENTATION =========================
#|
Publication date: January 2026
Code version: 12.5 
Author: Ing.(C) Andrés David Rincón Salazar
Programming language: Racket
Language version: 9.0
|#

;; ========================== GRAPHICS INITIALIZATION =========================

(require graphics/graphics)
(open-graphics)

;; ========================== MAIN GAME FUNCTION =========================

(define (StartGame)
  ;; ========================== LOADING SCREEN =========================
  (define (ShowLoadingScreen)
    ;; loadingScreen: Viewport for loading screen display
    ;; Returns: Void, displays loading screen for 2 seconds
    (define loadingScreen (open-viewport "Loading..." 1000 700))
    ((draw-pixmap loadingScreen) "assets/LoadingScreen.png" (make-posn 0 0))
    (sleep 2)
    (close-viewport loadingScreen)
  ); end function definition: ShowLoadingScreen
  
  (ShowLoadingScreen)
  
  ;; ========================== GAME BOARD SETUP =========================
  (define chessWindow (open-viewport "Chess" 1000 700))
  
  (define (InitializeBoardGraphics)
    ;; Returns: Void, sets up the basic chess board graphics
    ((draw-solid-rectangle chessWindow) (make-posn 0 0) 1000 700 "Black")
    (((draw-pixmap-posn "assets/ChessTableBackground.png") chessWindow) (make-posn 0 0))
    ((draw-pixmap chessWindow) "assets/MenuForWhitePlayer.png" (make-posn 700 0))
    ((draw-rectangle chessWindow) (make-posn 49 49) 602 602 "Black")
  ); end function definition: InitializeBoardGraphics
  
  ;; ========================== BOARD CREATION =========================
  (define (CreateChessBoard startX startY currentRow currentColumn counter end)
    ;; startX: Starting X position for board drawing
    ;; startY: Starting Y position for board drawing
    ;; currentRow: Current row being processed
    ;; currentColumn: Current column being processed
    ;; counter: Iteration counter
    ;; end: Total number of squares to draw
    ;; Returns: Void, recursively draws chess board squares
    (if (<= counter end)
        (if (= (remainder counter 8) 0)
            (if (= (remainder (+ currentRow currentColumn) 2) 0)
                (begin
                  ((draw-solid-rectangle chessWindow) (make-posn startX startY) 75 75 "white")
                  (CreateChessBoard 50 (+ startY 75) (+ 1 currentRow) 1 (+ counter 1) end)
                ); end begin
            ; else
                (begin
                  ((draw-solid-rectangle chessWindow) (make-posn startX startY) 75 75 "Gray")
                  (CreateChessBoard 50 (+ startY 75) (+ 1 currentRow) 1 (+ counter 1) end)
                ); end begin
            ); end if
        ; else
            (if (= (remainder (+ currentRow currentColumn) 2) 0)
                (begin
                  ((draw-solid-rectangle chessWindow) (make-posn startX startY) 75 75 "white")
                  (CreateChessBoard (+ startX 75) startY currentRow (+ currentColumn 1) (+ counter 1) end)
                ); end begin
            ; else
                (begin
                  ((draw-solid-rectangle chessWindow) (make-posn startX startY) 75 75 "Gray")
                  (CreateChessBoard (+ startX 75) startY currentRow (+ currentColumn 1) (+ counter 1) end)
                ); end begin
            ); end if
        ); end if
    ; else
        (void)
    )
  ); end function definition: CreateChessBoard

  ;; ========================== PIECE PLACEMENT =========================
  (define initialPieceArrangement "BRBHBBBQBKBBBHBRBPBPBPBPBPBPBPBP                                                                WPWPWPWPWPWPWPWPWRWHWBWQWKWBWHWR")
  (define initialLogicalArrangement "BRBHBBBQBKBBBHBRBPBPBPBPBPBPBPBP                                                                WPWPWPWPWPWPWPWPWRWHWBWQWKWBWHWR")
  
  (define (GetPiecePosition row column)
    ;; row: Row number (1-8)
    ;; column: Column number (1-8)
    ;; Returns: Position for piece placement
    (make-posn (+ 55 (* 75 (- column 1))) (+ 55 (* 75 (- row 1))))
  ); end function definition: GetPiecePosition
  
  (define (PlacePieces visualArrangement currentRow currentColumn counter end)
    ;; visualArrangement: String representing piece positions
    ;; currentRow: Current row being processed
    ;; currentColumn: Current column being processed
    ;; counter: Current position in arrangement string
    ;; end: End position in arrangement string
    ;; Returns: Void, places pieces on the board
    (cond
      [(> counter end) (void)]
      [(equal? (string-ref (substring visualArrangement (- counter 2) counter) 0) #\space)
       (if (= (remainder counter 16) 0)
           (PlacePieces visualArrangement (+ currentRow 1) 1 (+ counter 2) end)
           (PlacePieces visualArrangement currentRow (+ currentColumn 1) (+ counter 2) end))]
      [(equal? (string-ref (substring visualArrangement (- counter 2) counter) 0) #\B)
       (((draw-pixmap-posn (string-append "assets/B" (substring visualArrangement (- counter 1) counter) ".png")) chessWindow) 
        (GetPiecePosition currentRow currentColumn))
       (if (= (remainder counter 16) 0)
           (PlacePieces visualArrangement (+ currentRow 1) 1 (+ counter 2) end)
           (PlacePieces visualArrangement currentRow (+ currentColumn 1) (+ counter 2) end))]
      [(equal? (string-ref (substring visualArrangement (- counter 2) counter) 0) #\W)
       (((draw-pixmap-posn (string-append "assets/W" (substring visualArrangement (- counter 1) counter) ".png")) chessWindow) 
        (GetPiecePosition currentRow currentColumn))
       (if (= (remainder counter 16) 0)
           (PlacePieces visualArrangement (+ currentRow 1) 1 (+ counter 2) end)
           (PlacePieces visualArrangement currentRow (+ currentColumn 1) (+ counter 2) end))]
    )
  ); end function definition: PlacePieces
  
  ;; ========================== BOARD UTILITIES =========================
  (define (UpdateBoardSquares startRow endRow startCol endCol)
    ;; startRow: Starting row of move
    ;; endRow: Ending row of move
    ;; startCol: Starting column of move
    ;; endCol: Ending column of move
    ;; Returns: Void, updates board squares after move
    (if (= (remainder (+ startRow startCol) 2) 0)
        ((draw-solid-rectangle chessWindow) (GetSquarePosition startRow startCol) 75 75 "white")
    ; else
        ((draw-solid-rectangle chessWindow) (GetSquarePosition startRow startCol) 75 75 "Gray"))
  
    (if (= (remainder (+ endRow endCol) 2) 0)
        ((draw-solid-rectangle chessWindow) (GetSquarePosition endRow endCol) 75 75 "white")
    ; else
        ((draw-solid-rectangle chessWindow) (GetSquarePosition endRow endCol) 75 75 "Gray"))
  ); end function definition: UpdateBoardSquares

  (define (DeselectSquare row column)
    ;; row: Row of square to deselect
    ;; column: Column of square to deselect
    ;; Returns: Void, removes selection highlight from square
    (if (= (remainder (+ row column) 2) 0)
        ((draw-rectangle chessWindow) (GetSquarePosition row column) 75 75 "white")
    ; else
        ((draw-rectangle chessWindow) (GetSquarePosition row column) 75 75 "Gray"))
  ); end function definition: DeselectSquare

  (define (PlacePieceByColor visualArrangement position endRow endCol)
    ;; visualArrangement: Current visual piece arrangement
    ;; position: Position in arrangement string
    ;; endRow: Destination row
    ;; endCol: Destination column
    ;; Returns: Void, places piece of appropriate color
    (cond
      [(equal? (string-ref (substring visualArrangement (- (* position 2) 2) (* position 2)) 0) #\B)
       (((draw-pixmap-posn (string-append "assets/B" (substring visualArrangement (- (* position 2) 1) (* position 2)) ".png")) chessWindow) 
        (GetPiecePosition endRow endCol))]
      [(equal? (string-ref (substring visualArrangement (- (* position 2) 2) (* position 2)) 0) #\W)
       (((draw-pixmap-posn (string-append "assets/W" (substring visualArrangement (- (* position 2) 1) (* position 2)) ".png")) chessWindow) 
        (GetPiecePosition endRow endCol))]
    )
  ); end function definition: PlacePieceByColor
  
  ;; ========================== MOVE HANDLING =========================
  (define (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
    ;; startPos: Starting position index
    ;; endPos: Ending position index
    ;; startRow: Starting row
    ;; endRow: Ending row
    ;; startCol: Starting column
    ;; endCol: Ending column
    ;; visualArrangement: Current visual piece arrangement
    ;; logicalArrangement: Current logical piece arrangement
    ;; turnCount: Current turn count
    ;; Returns: Void, executes forward move and updates game state
    (UpdateBoardSquares startRow endRow startCol endCol)
    (PlacePieceByColor visualArrangement startPos endRow endCol)
    (if (= (remainder (+ turnCount 1) 2) 0)
        ((draw-pixmap chessWindow) "assets/MenuForBlackPlayer.png" (make-posn 700 0))
    ; else
        ((draw-pixmap chessWindow) "assets/MenuForWhitePlayer.png" (make-posn 700 0)))
    (ShowCheckStatus (string-append (substring logicalArrangement 0 (- (* startPos 2) 2))
                                    "  "
                                    (substring logicalArrangement (* startPos 2) (- (* endPos 2) 2))
                                    (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2))
                                    (substring logicalArrangement (* endPos 2) (string-length logicalArrangement)))
                     (+ turnCount 1))
    (ProcessClicks (GetClickPosition)
                   (string-append (substring visualArrangement 0 (- (* startPos 2) 2))
                                  "  "
                                  (substring visualArrangement (* startPos 2) (- (* endPos 2) 2))
                                  (substring visualArrangement (- (* startPos 2) 2) (* startPos 2))
                                  (substring visualArrangement (* endPos 2) (string-length logicalArrangement)))
                   (string-append (substring logicalArrangement 0 (- (* startPos 2) 2))
                                  "  "
                                  (substring logicalArrangement (* startPos 2) (- (* endPos 2) 2))
                                  (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2))
                                  (substring logicalArrangement (* endPos 2) (string-length logicalArrangement)))
                   (+ turnCount 1))
  ); end function definition: ExecuteForwardMove

  (define (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
    ;; Parameters same as ExecuteForwardMove
    ;; Returns: Void, executes backward move and updates game state
    (UpdateBoardSquares startRow endRow startCol endCol)
    (PlacePieceByColor visualArrangement startPos endRow endCol)
    (if (= (remainder (+ turnCount 1) 2) 0)
        ((draw-pixmap chessWindow) "assets/MenuForBlackPlayer.png" (make-posn 700 0))
    ; else
        ((draw-pixmap chessWindow) "assets/MenuForWhitePlayer.png" (make-posn 700 0)))
    (ShowCheckStatus (string-append (substring logicalArrangement 0 (- (* endPos 2) 2))
                                    (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2))
                                    (substring logicalArrangement (* endPos 2) (- (* startPos 2) 2))
                                    "  "
                                    (substring logicalArrangement (* startPos 2) (string-length logicalArrangement)))
                     (+ turnCount 1))
    (ProcessClicks (GetClickPosition)
                   (string-append (substring visualArrangement 0 (- (* endPos 2) 2))
                                  (substring visualArrangement (- (* startPos 2) 2) (* startPos 2))
                                  (substring visualArrangement (* endPos 2) (- (* startPos 2) 2))
                                  "  "
                                  (substring visualArrangement (* startPos 2) (string-length visualArrangement)))
                   (string-append (substring logicalArrangement 0 (- (* endPos 2) 2))
                                  (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2))
                                  (substring logicalArrangement (* endPos 2) (- (* startPos 2) 2))
                                  "  "
                                  (substring logicalArrangement (* startPos 2) (string-length logicalArrangement)))
                   (+ turnCount 1))
  ); end function definition: ExecuteBackwardMove

  (define (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)
    ;; startRow: Row of invalid move
    ;; startCol: Column of invalid move
    ;; visualArrangement: Current visual arrangement
    ;; logicalArrangement: Current logical arrangement
    ;; turnCount: Current turn count
    ;; Returns: Void, handles invalid move attempt
    (DeselectSquare startRow startCol)
    (ShowCheckStatus logicalArrangement turnCount)
    ((draw-string chessWindow) (make-posn 796 417) "Invalid move" "black")
    (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount)
  ); end function definition: HandleInvalidMove

  ;; ========================== PAWN PROMOTION =========================
  (define (PromotePawn pawnColor visualArrangement logicalArrangement startPos endPos endRow endCol turnCount)
    ;; pawnColor: Color of pawn being promoted ('B' or 'W')
    ;; visualArrangement: Current visual arrangement
    ;; logicalArrangement: Current logical arrangement
    ;; startPos: Starting position index
    ;; endPos: Ending position index
    ;; endRow: Ending row
    ;; endCol: Ending column
    ;; turnCount: Current turn count
    ;; Returns: Void, handles pawn promotion
    (define promotionWindow (open-viewport "Promote Pawn" 350 125))
    ((draw-solid-rectangle promotionWindow) (make-posn 25 25) 75 75 "Gray")
    ((draw-solid-rectangle promotionWindow) (make-posn 100 25) 75 75 "White")
    ((draw-solid-rectangle promotionWindow) (make-posn 175 25) 75 75 "Gray")
    ((draw-solid-rectangle promotionWindow) (make-posn 250 25) 75 75 "White")
    (cond
      [(equal? pawnColor #\B)
       (((draw-pixmap-posn "assets/BQ.png") promotionWindow) (make-posn 30 30))
       (((draw-pixmap-posn "assets/BH.png") promotionWindow) (make-posn 105 30))
       (((draw-pixmap-posn "assets/BR.png") promotionWindow) (make-posn 180 30))
       (((draw-pixmap-posn "assets/BB.png") promotionWindow) (make-posn 255 30))]
      [(equal? pawnColor #\W)
       (((draw-pixmap-posn "assets/WQ.png") promotionWindow) (make-posn 30 30))
       (((draw-pixmap-posn "assets/WH.png") promotionWindow) (make-posn 105 30))
       (((draw-pixmap-posn "assets/WR.png") promotionWindow) (make-posn 180 30))
       (((draw-pixmap-posn "assets/WB.png") promotionWindow) (make-posn 255 30))]
    )
    ((draw-rectangle promotionWindow) (make-posn 25 25) 75 75 "Black")
    ((draw-rectangle promotionWindow) (make-posn 100 25) 75 75 "Black")
    ((draw-rectangle promotionWindow) (make-posn 175 25) 75 75 "Black")
    ((draw-rectangle promotionWindow) (make-posn 250 25) 75 75 "Black")
    promotionWindow

    (define (GetPromotionChoicePosition)
      (define click (get-mouse-click promotionWindow))
      (mouse-click-posn click))
    
    (define (DeterminePromotionPiece position)
      (cond
        [(ClickInArea? position 26 99 26 99)
         "Q"]
        [(ClickInArea? position 101 174 26 99)
         "H"]
        [(ClickInArea? position 176 249 26 99)
         "R"]
        [(ClickInArea? position 251 324 26 99)
         "B"]
        [else
         ((clear-string promotionWindow) (make-posn 9 10) "███████████████████████████████████████████")
         ((draw-string promotionWindow) (make-posn 10 10) "Click on the desired piece correctly")
         (DeterminePromotionPiece (GetPromotionChoicePosition))]
      ))
    
    (define newPiece (DeterminePromotionPiece (GetPromotionChoicePosition)))
    (cond
      [(equal? pawnColor #\B)
       (close-viewport promotionWindow)
       (if (= (remainder (+ turnCount 1) 2) 0)
           ((draw-pixmap chessWindow) "assets/MenuForBlackPlayer.png" (make-posn 700 0))
           ; else
           ((draw-pixmap chessWindow) "assets/MenuForWhitePlayer.png" (make-posn 700 0)))
       (((draw-pixmap-posn (string-append "assets/B" newPiece ".png")) chessWindow) (GetPiecePosition endRow endCol))
       (ShowCheckStatus (string-append (substring logicalArrangement 0 (- (* startPos 2) 2))
                                       "  "
                                       (substring logicalArrangement (* startPos 2) (- (* endPos 2) 2))
                                       (string-append "B" newPiece)
                                       (substring logicalArrangement (* endPos 2) (string-length logicalArrangement)))
                        (+ turnCount 1))
       (ProcessClicks (GetClickPosition)
                      (string-append (substring visualArrangement 0 (- (* startPos 2) 2))
                                     "  "
                                     (substring visualArrangement (* startPos 2) (- (* endPos 2) 2))
                                     (string-append "B" newPiece)
                                     (substring visualArrangement (* endPos 2) (string-length logicalArrangement)))
                      (string-append (substring logicalArrangement 0 (- (* startPos 2) 2))
                                     "  "
                                     (substring logicalArrangement (* startPos 2) (- (* endPos 2) 2))
                                     (string-append "B" newPiece)
                                     (substring logicalArrangement (* endPos 2) (string-length logicalArrangement)))
                      (+ turnCount 1))]
      [(equal? pawnColor #\W)
       (if (= (remainder (+ turnCount 1) 2) 0)
           ((draw-pixmap chessWindow) "assets/MenuForBlackPlayer.png" (make-posn 700 0))
       ; else
           ((draw-pixmap chessWindow) "assets/MenuForWhitePlayer.png" (make-posn 700 0)))
       (close-viewport promotionWindow)
       (((draw-pixmap-posn (string-append "assets/W" newPiece ".png")) chessWindow) (GetPiecePosition endRow endCol))
       (ShowCheckStatus (string-append (substring logicalArrangement 0 (- (* endPos 2) 2))
                                       (string-append "W" newPiece)
                                       (substring logicalArrangement (* endPos 2) (- (* startPos 2) 2))
                                       "  "
                                       (substring logicalArrangement (* startPos 2) (string-length logicalArrangement)))
                        (+ turnCount 1))
       (ProcessClicks (GetClickPosition)
                      (string-append (substring visualArrangement 0 (- (* endPos 2) 2))
                                     (string-append "W" newPiece)
                                     (substring visualArrangement (* endPos 2) (- (* startPos 2) 2))
                                     "  "
                                     (substring visualArrangement (* startPos 2) (string-length logicalArrangement)))
                      (string-append (substring logicalArrangement 0 (- (* endPos 2) 2))
                                     (string-append "W" newPiece)
                                     (substring logicalArrangement (* endPos 2) (- (* startPos 2) 2))
                                     "  "
                                     (substring logicalArrangement (* startPos 2) (string-length logicalArrangement)))
                      (+ turnCount 1))]
    )
  ); end function definition: PromotePawn
  
  ;; ========================== PIECE MOVEMENT RULES =========================
  (define (MovePawn startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
    ;; startPos: Starting position index
    ;; endPos: Ending position index
    ;; startRow: Starting row
    ;; endRow: Ending row
    ;; startCol: Starting column
    ;; endCol: Ending column
    ;; visualArrangement: Current visual arrangement
    ;; logicalArrangement: Current logical arrangement
    ;; turnCount: Current turn count
    ;; Returns: Void, handles pawn movement according to chess rules
    (cond
      [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 0) #\B)
       (cond
         [(and (= startRow 2) (= endRow 4) (= startCol endCol)
               (string=? (substring logicalArrangement (- (* (+ (* (- 3 1) 8) startCol) 2) 2) 
                                        (* (+ (* (- 3 1) 8) startCol) 2)) "  ")
               (string=? (substring logicalArrangement (- (* (+ (* (- 4 1) 8) startCol) 2) 2) 
                                        (* (+ (* (- 4 1) 8) startCol) 2)) "  "))
          (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
         [(and (= startRow 7) (= endRow 8))
          (cond
            [(and (or (= startCol (- endCol 1)) (= startCol (+ endCol 1)))
                   (not (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  ")))
             (UpdateBoardSquares startRow endRow startCol endCol)
             (PromotePawn #\B visualArrangement logicalArrangement startPos endPos endRow endCol turnCount)]
            [(and (= startCol endCol)
                   (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  "))
             (UpdateBoardSquares startRow endRow startCol endCol)
             (PromotePawn #\B visualArrangement logicalArrangement startPos endPos endRow endCol turnCount)]
            [else (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)]
          )]
         [(and (= endRow (+ startRow 1)) (= startCol endCol)
                   (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  "))
          (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
         [(and (= endRow (+ startRow 1))
                   (or (= startCol (- endCol 1)) (= startCol (+ endCol 1)))
                   (not (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  ")))
          (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
         [else (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)]
       )]
      [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 0) #\W)
       (cond
         [(and (= startRow 7) (= endRow 5) (= startCol endCol)
               (string=? (substring logicalArrangement (- (* (+ (* (- 6 1) 8) startCol) 2) 2) 
                                        (* (+ (* (- 6 1) 8) startCol) 2)) "  ")
               (string=? (substring logicalArrangement (- (* (+ (* (- 5 1) 8) startCol) 2) 2)
                                        (* (+ (* (- 5 1) 8) startCol) 2)) "  "))
          (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
         [(and (= startRow 2) (= endRow 1))
          (cond
            [(and (or (= startCol (- endCol 1)) (= startCol (+ endCol 1)))
                   (not (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  ")))
             (UpdateBoardSquares startRow endRow startCol endCol)
             (PromotePawn #\W visualArrangement logicalArrangement startPos endPos endRow endCol turnCount)]
            [(and (= startCol endCol)
                   (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  "))
             (UpdateBoardSquares startRow endRow startCol endCol)
             (PromotePawn #\W visualArrangement logicalArrangement startPos endPos endRow endCol turnCount)]
            [else (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)]
          )]
         [(and (= endRow (- startRow 1)) (= startCol endCol)
                   (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  "))
          (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
         [(and (= endRow (- startRow 1))
                   (or (= startCol (- endCol 1)) (= startCol (+ endCol 1)))
                   (not (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  ")))
          (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
         [else (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)]
       )]
    )
  ); end function definition: MovePawn
  
  ;; ========================== PATH CHECKING =========================
  (define (IsVerticalPathClear startRow endRow column logicalArrangement playerColor)
    ;; startRow: Starting row
    ;; endRow: Ending row
    ;; column: Column being checked
    ;; logicalArrangement: Current logical arrangement
    ;; playerColor: Color of current player
    ;; Returns: Boolean indicating if vertical path is clear
    (cond
      [(= startRow endRow) #t] ; Same position
      [(< startRow endRow)
       (CheckVerticalPath (+ startRow 1) endRow column logicalArrangement playerColor #t)]
      [else
       (CheckVerticalPath (- startRow 1) endRow column logicalArrangement playerColor #t)])
  ); end function definition: IsVerticalPathClear
  
  (define (CheckVerticalPath currentRow endRow column logicalArrangement playerColor isIntermediate)
    ;; currentRow: Current row being checked
    ;; endRow: Target row
    ;; column: Column being checked
    ;; logicalArrangement: Current logical arrangement
    ;; playerColor: Color of current player
    ;; isIntermediate: Boolean indicating if checking intermediate squares
    ;; Returns: Boolean indicating if path is clear
    (define position (+ (* (- currentRow 1) 8) column))
    (define content (substring logicalArrangement (- (* position 2) 2) (* position 2)))
    
    (cond
      [(= currentRow endRow)
       (or (string=? content "  ")
           (not (equal? (string-ref content 0) playerColor)))]
      [(string=? content "  ")
       (if (< currentRow endRow)
           (CheckVerticalPath (+ currentRow 1) endRow column logicalArrangement playerColor #t)
           (CheckVerticalPath (- currentRow 1) endRow column logicalArrangement playerColor #t))]
      [else #f])
  ); end function definition: CheckVerticalPath
  
  ;; ========================== HORIZONTAL PATH CHECKING =========================
  (define (IsHorizontalPathClear row startCol endCol logicalArrangement playerColor)
    ;; row: Row being checked
    ;; startCol: Starting column
    ;; endCol: Ending column
    ;; logicalArrangement: Current logical arrangement
    ;; playerColor: Color of current player
    ;; Returns: Boolean indicating if horizontal path is clear
    (cond
      [(= startCol endCol) #t] ; Same position
      [(< startCol endCol)
       (CheckHorizontalPath row (+ startCol 1) endCol logicalArrangement playerColor #t)]
      [else
       (CheckHorizontalPath row (- startCol 1) endCol logicalArrangement playerColor #t)])
  ); end function definition: IsHorizontalPathClear
  
  (define (CheckHorizontalPath row currentCol endCol logicalArrangement playerColor isIntermediate)
    ;; row: Row being checked
    ;; currentCol: Current column being checked
    ;; endCol: Target column
    ;; logicalArrangement: Current logical arrangement
    ;; playerColor: Color of current player
    ;; isIntermediate: Boolean indicating if checking intermediate squares
    ;; Returns: Boolean indicating if path is clear
    (define position (+ (* (- row 1) 8) currentCol))
    (define content (substring logicalArrangement (- (* position 2) 2) (* position 2)))
    
    (cond
      [(= currentCol endCol)
       (or (string=? content "  ")
           (not (equal? (string-ref content 0) playerColor)))]
      [(string=? content "  ")
       (if (< currentCol endCol)
           (CheckHorizontalPath row (+ currentCol 1) endCol logicalArrangement playerColor #t)
           (CheckHorizontalPath row (- currentCol 1) endCol logicalArrangement playerColor #t))]
      [else #f])
  ); end function definition: CheckHorizontalPath
  
  ;; ========================== ROOK MOVEMENT =========================
  (define (MoveRook startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
    ;; startPos: Starting position index
    ;; endPos: Ending position index
    ;; startRow: Starting row
    ;; endRow: Ending row
    ;; startCol: Starting column
    ;; endCol: Ending column
    ;; visualArrangement: Current visual arrangement
    ;; logicalArrangement: Current logical arrangement
    ;; turnCount: Current turn count
    ;; Returns: Void, handles rook movement according to chess rules
    (define playerColor (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 0))
    
    (cond
      [(and (= startCol endCol) 
            (IsVerticalPathClear startRow endRow startCol logicalArrangement playerColor))
       (if (or (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  ")
               (not (equal? playerColor
                            (string-ref (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) 0))))
           (if (< startRow endRow)
               (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
               (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount))
           (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount))]
      
      [(and (= startRow endRow) 
            (IsHorizontalPathClear startRow startCol endCol logicalArrangement playerColor))
       (if (or (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  ")
               (not (equal? playerColor
                            (string-ref (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) 0))))
           (if (< startCol endCol)
               (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
               (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount))
           (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount))]
      
      [else (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)])
  ); end function definition: MoveRook
  
  ;; ========================== KNIGHT MOVEMENT =========================
  (define (MoveKnight startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
    ;; Parameters same as other movement functions
    ;; Returns: Void, handles knight movement according to chess rules
    (cond
      [(and (= endCol (+ startCol 1)) (= endRow (- startRow 2)))
       (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= endCol (- startCol 1)) (= endRow (- startRow 2)))
       (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= endCol (+ startCol 1)) (= endRow (+ startRow 2)))
       (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= endCol (- startCol 1)) (= endRow (+ startRow 2)))
       (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= endCol (+ startCol 2)) (= endRow (- startRow 1)))
       (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= endCol (- startCol 2)) (= endRow (- startRow 1)))
       (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= endCol (- startCol 2)) (= endRow (+ startRow 1)))
       (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= endCol (+ startCol 2)) (= endRow (+ startRow 1)))
       (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [else (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)]
    )
  ); end function definition: MoveKnight

  ;; ========================== BISHOP MOVEMENT =========================
  (define (IsDiagonalPathClear startRow endRow startCol endCol logicalArrangement playerColor)
    ;; startRow: Starting row
    ;; endRow: Ending row
    ;; startCol: Starting column
    ;; endCol: Ending column
    ;; logicalArrangement: Current logical arrangement
    ;; playerColor: Color of current player
    ;; Returns: Boolean indicating if diagonal path is clear
    (cond
      [(and (= startRow endRow) (= startCol endCol)) #t] ; Same position
      [(and (< startRow endRow) (< startCol endCol))
       (CheckDiagonalPath (+ startRow 1) endRow (+ startCol 1) endCol logicalArrangement playerColor #t)] ; Lower-right
      [(and (< startRow endRow) (> startCol endCol))
       (CheckDiagonalPath (+ startRow 1) endRow (- startCol 1) endCol logicalArrangement playerColor #t)] ; Lower-left
      [(and (> startRow endRow) (< startCol endCol))
       (CheckDiagonalPath (- startRow 1) endRow (+ startCol 1) endCol logicalArrangement playerColor #t)] ; Upper-right
      [else ; Upper-left
       (CheckDiagonalPath (- startRow 1) endRow (- startCol 1) endCol logicalArrangement playerColor #t)])
  ); end function definition: IsDiagonalPathClear
  
  (define (CheckDiagonalPath currentRow endRow currentCol endCol logicalArrangement playerColor isIntermediate)
    ;; currentRow: Current row being checked
    ;; endRow: Target row
    ;; currentCol: Current column being checked
    ;; endCol: Target column
    ;; logicalArrangement: Current logical arrangement
    ;; playerColor: Color of current player
    ;; isIntermediate: Boolean indicating if checking intermediate squares
    ;; Returns: Boolean indicating if path is clear
    (define position (+ (* (- currentRow 1) 8) currentCol))
    (define content (substring logicalArrangement (- (* position 2) 2) (* position 2)))
    
    (cond
      [(and (= currentRow endRow) (= currentCol endCol))
       (or (string=? content "  ")
           (not (equal? (string-ref content 0) playerColor)))]
      
      [(string=? content "  ")
       (cond
         [(and (< currentRow endRow) (< currentCol endCol))
          (CheckDiagonalPath (+ currentRow 1) endRow (+ currentCol 1) endCol logicalArrangement playerColor #t)]
         [(and (< currentRow endRow) (> currentCol endCol))
          (CheckDiagonalPath (+ currentRow 1) endRow (- currentCol 1) endCol logicalArrangement playerColor #t)]
         [(and (> currentRow endRow) (< currentCol endCol))
          (CheckDiagonalPath (- currentRow 1) endRow (+ currentCol 1) endCol logicalArrangement playerColor #t)]
         [else
          (CheckDiagonalPath (- currentRow 1) endRow (- currentCol 1) endCol logicalArrangement playerColor #t)])]
      
      [else #f])
  ); end function definition: CheckDiagonalPath
  
  (define (MoveBishop startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
    ;; Parameters same as other movement functions
    ;; Returns: Void, handles bishop movement according to chess rules
    (define playerColor (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 0))
    
    (cond
      [(and (= (abs (- startRow endRow)) (abs (- startCol endCol)))
            (IsDiagonalPathClear startRow endRow startCol endCol logicalArrangement playerColor))
       (if (or (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  ")
               (not (equal? playerColor
                            (string-ref (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) 0))))
           (if (< startPos endPos)
               (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
               (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount))
           (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount))]
      [else (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)])
  ); end function definition: MoveBishop
  
  ;; ========================== QUEEN MOVEMENT =========================
  (define (MoveQueen startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
    ;; Parameters same as other movement functions
    ;; Returns: Void, handles queen movement according to chess rules
    (define playerColor (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 0))
    
    (cond
      ; Rook-like movement (straight)
      [(or (and (= startCol endCol) 
                (IsVerticalPathClear startRow endRow startCol logicalArrangement playerColor))
           (and (= startRow endRow) 
                (IsHorizontalPathClear startRow startCol endCol logicalArrangement playerColor)))
       (cond
         [(and (= startCol endCol) 
               (IsVerticalPathClear startRow endRow startCol logicalArrangement playerColor))
          (if (or (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  ")
                  (not (equal? playerColor
                               (string-ref (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) 0))))
              (if (< startRow endRow)
                  (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
                  (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount))
              (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount))]
         
         [(and (= startRow endRow) 
               (IsHorizontalPathClear startRow startCol endCol logicalArrangement playerColor))
          (if (or (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  ")
                  (not (equal? playerColor
                               (string-ref (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) 0))))
              (if (< startCol endCol)
                  (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
                  (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount))
              (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount))]
         
         [else (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)])]
      
      ; Bishop-like movement (diagonal)
      [(and (= (abs (- startRow endRow)) (abs (- startCol endCol)))
            (IsDiagonalPathClear startRow endRow startCol endCol logicalArrangement playerColor))
       (if (or (string=? (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) "  ")
               (not (equal? playerColor
                            (string-ref (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) 0))))
           (if (< startPos endPos)
               (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
               (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount))
           (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount))]
      
      [else (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)])
  ); end function definition: MoveQueen
  
  ;; ========================== KING MOVEMENT =========================
  (define (MoveKing startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
    ;; Parameters same as other movement functions
    ;; Returns: Void, handles king movement according to chess rules
    (cond
      [(and (= startCol endCol) (= endRow (+ startRow 1)))
       (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= startCol endCol) (= endRow (- startRow 1)))
       (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= startRow endRow) (= endCol (+ startCol 1)))
       (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= startRow endRow) (= endCol (- startCol 1)))
       (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= endRow (+ startRow 1)) (= endCol (+ startCol 1)))
       (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= endRow (+ startRow 1)) (= endCol (- startCol 1)))
       (ExecuteForwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= endRow (- startRow 1)) (= endCol (+ startCol 1)))
       (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [(and (= endRow (- startRow 1)) (= endCol (- startCol 1)))
       (ExecuteBackwardMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
      [else (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)]
    )
  ); end function definition: MoveKing
  
  ;; ========================== CHECK/CHECKMATE DETECTION =========================
  (define (IsPositionUnderAttack row column attackingColor logicalArrangement)
    ;; row: Row to check
    ;; column: Column to check
    ;; attackingColor: Color of attacking pieces ('B' or 'W')
    ;; logicalArrangement: Current logical arrangement
    ;; Returns: Boolean indicating if position is under attack
    (define (CheckAttackFrom attackerRow attackerCol)
      (define attackerPos (+ (* (- attackerRow 1) 8) attackerCol))
      (define attackerContent (substring logicalArrangement (- (* attackerPos 2) 2) (* attackerPos 2)))
      
      (if (or (string=? attackerContent "  ")
              (not (equal? (string-ref attackerContent 0) attackingColor)))
          #f
          (CheckAttackByPieceType (string-ref attackerContent 1) attackerRow attackerCol row column logicalArrangement attackingColor)))
    
    (define (CheckAttackByPieceType pieceType attackerRow attackerCol targetRow targetCol logicalArrangement attackingColor)
      (cond
        [(equal? pieceType #\P) 
         (CheckPawnAttack attackerRow attackerCol targetRow targetCol attackingColor)]
        [(equal? pieceType #\H) 
         (CheckKnightAttack attackerRow attackerCol targetRow targetCol)]
        [(equal? pieceType #\R) 
         (CheckRookAttack attackerRow attackerCol targetRow targetCol logicalArrangement)]
        [(equal? pieceType #\B) 
         (CheckBishopAttack attackerRow attackerCol targetRow targetCol logicalArrangement)]
        [(equal? pieceType #\Q) 
         (CheckQueenAttack attackerRow attackerCol targetRow targetCol logicalArrangement)]
        [(equal? pieceType #\K) 
         (CheckKingAttack attackerRow attackerCol targetRow targetCol)]
        [else #f]))
    
    (define (ScanBoard currentRow currentCol)
      (cond
        [(> currentRow 8) #f]
        [(> currentCol 8) (ScanBoard (+ currentRow 1) 1)]
        [else 
         (if (CheckAttackFrom currentRow currentCol)
             #t
             (ScanBoard currentRow (+ currentCol 1)))]))
    
    (ScanBoard 1 1)
  ); end function definition: IsPositionUnderAttack

  (define (CheckPawnAttack pawnRow pawnCol targetRow targetCol pawnColor)
    (cond
      [(equal? pawnColor #\B)
       (and (= pawnRow (- targetRow 1))
            (or (= pawnCol (- targetCol 1))
                (= pawnCol (+ targetCol 1))))]
      [(equal? pawnColor #\W)
       (and (= pawnRow (+ targetRow 1))
            (or (= pawnCol (- targetCol 1))
                (= pawnCol (+ targetCol 1))))])
  ); end function definition: CheckPawnAttack

  (define (CheckKnightAttack knightRow knightCol targetRow targetCol)
    (or (and (= targetRow (+ knightRow 2)) (= targetCol (+ knightCol 1)))
        (and (= targetRow (+ knightRow 2)) (= targetCol (- knightCol 1)))
        (and (= targetRow (- knightRow 2)) (= targetCol (+ knightCol 1)))
        (and (= targetRow (- knightRow 2)) (= targetCol (- knightCol 1)))
        (and (= targetRow (+ knightRow 1)) (= targetCol (+ knightCol 2)))
        (and (= targetRow (+ knightRow 1)) (= targetCol (- knightCol 2)))
        (and (= targetRow (- knightRow 1)) (= targetCol (+ knightCol 2)))
        (and (= targetRow (- knightRow 1)) (= targetCol (- knightCol 2))))
  ); end function definition: CheckKnightAttack

  (define (CheckKingAttack kingRow kingCol targetRow targetCol)
    (and (<= (abs (- kingRow targetRow)) 1)
         (<= (abs (- kingCol targetCol)) 1)
         (not (and (= kingRow targetRow) (= kingCol targetCol))))
  ); end function definition: CheckKingAttack

  (define (CheckRookAttack rookRow rookCol targetRow targetCol logicalArrangement)
    (cond
      [(= rookRow targetRow)
       (IsHorizontalPathClear rookRow 
                              (min rookCol targetCol) 
                              (max rookCol targetCol) 
                              logicalArrangement 
                              #\_)]
      [(= rookCol targetCol)
       (IsVerticalPathClear (min rookRow targetRow) 
                            (max rookRow targetRow) 
                            rookCol 
                            logicalArrangement 
                            #\_)]
      [else #f])
  ); end function definition: CheckRookAttack

  (define (CheckBishopAttack bishopRow bishopCol targetRow targetCol logicalArrangement)
    (and (= (abs (- bishopRow targetRow)) 
          (abs (- bishopCol targetCol)))
         (IsDiagonalPathClear bishopRow 
                              targetRow 
                              bishopCol 
                              targetCol 
                              logicalArrangement 
                              #\_))
  ); end function definition: CheckBishopAttack
  
  (define (CheckQueenAttack queenRow queenCol targetRow targetCol logicalArrangement)
    (or (CheckRookAttack queenRow queenCol targetRow targetCol logicalArrangement)
        (CheckBishopAttack queenRow queenCol targetRow targetCol logicalArrangement))
  ); end function definition: CheckQueenAttack

  ;; ========================== KING LOCATION =========================
  (define (FindKing kingColor logicalArrangement)
    ;; kingColor: Color of king to find ('B' or 'W')
    ;; logicalArrangement: Current logical arrangement
    ;; Returns: Position of king or #f if not found
    (define (SearchKing position)
      (cond
        [(>= position 65) #f]
        [(and (equal? (string-ref (substring logicalArrangement (- (* position 2) 2) (* position 2)) 0) kingColor)
              (equal? (string-ref (substring logicalArrangement (- (* position 2) 2) (* position 2)) 1) #\K))
         position]
        [else (SearchKing (+ position 1))]))
    
    (SearchKing 1)
  ); end function definition: FindKing

  ;; ========================== CHECK DETECTION =========================
  (define (IsKingInCheck kingColor logicalArrangement)
    ;; kingColor: Color of king to check ('B' or 'W')
    ;; logicalArrangement: Current logical arrangement
    ;; Returns: Boolean indicating if king is in check
    (define kingPos (FindKing kingColor logicalArrangement))
    (define kingRow (+ (quotient (- kingPos 1) 8) 1))
    (define kingCol (+ (remainder (- kingPos 1) 8) 1))
    (define attackerColor (if (equal? kingColor #\B) #\W #\B))
    
    (IsPositionUnderAttack kingRow kingCol attackerColor logicalArrangement)
  ); end function definition: IsKingInCheck

  ;; ========================== CHECKMATE DETECTION =========================
  (define (IsCheckmate kingColor logicalArrangement)
    ;; kingColor: Color of king to check ('B' or 'W')
    ;; logicalArrangement: Current logical arrangement
    ;; Returns: Boolean indicating if king is in checkmate
    (if (not (IsKingInCheck kingColor logicalArrangement))
        #f
        (not (ExistsMoveToEscapeCheck kingColor logicalArrangement)))
  ); end function definition: IsCheckMate

  (define (ExistsMoveToEscapeCheck kingColor logicalArrangement)
    ;; kingColor: Color of king to check ('B' or 'W')
    ;; logicalArrangement: Current logical arrangement
    ;; Returns: Boolean indicating if escape move exists
    (define (TestPieceMove piecePos targetRow targetCol)
      (define pieceRow (+ (quotient (- piecePos 1) 8) 1))
      (define pieceCol (+ (remainder (- piecePos 1) 8) 1))
      (define targetPos (+ (* (- targetRow 1) 8) targetCol))
      (define pieceContent (substring logicalArrangement (- (* piecePos 2) 2) (* piecePos 2)))
      (define targetContent (substring logicalArrangement (- (* targetPos 2) 2) (* targetPos 2)))
      
      (if (and (not (string=? targetContent "  "))
               (equal? (string-ref pieceContent 0) (string-ref targetContent 0)))
          #f
          (if (IsValidMoveForPiece (string-ref pieceContent 1) 
                                 pieceRow pieceCol 
                                 targetRow targetCol 
                                 logicalArrangement)
              (not (WouldMoveLeaveKingInCheck piecePos targetPos 
                                           pieceRow targetRow 
                                           pieceCol targetCol 
                                           logicalArrangement kingColor))
              #f)))
    
    (define (TestAllMovesForPiece piecePos)
      (define pieceRow (+ (quotient (- piecePos 1) 8) 1))
      (define pieceCol (+ (remainder (- piecePos 1) 8) 1))
      (define pieceContent (substring logicalArrangement (- (* piecePos 2) 2) (* piecePos 2)))
      
      (define (TestTargets targetRow targetCol)
        (cond
          [(> targetRow 8) #f]
          [(> targetCol 8) (TestTargets (+ targetRow 1) 1)]
          [else
           (if (TestPieceMove piecePos targetRow targetCol)
               #t
               (TestTargets targetRow (+ targetCol 1)))]))
      
      (if (or (string=? pieceContent "  ") 
              (not (equal? (string-ref pieceContent 0) kingColor)))
          #f
          (TestTargets 1 1)))
    
    (define (ScanPieces position)
      (cond
        [(> position 64) #f]
        [(TestAllMovesForPiece position) #t]
        [else (ScanPieces (+ position 1))]))
    
    (ScanPieces 1)
  ); end function definition: ExistsMoveToEscapeCheck

  (define (IsValidMoveForPiece pieceType pieceRow pieceCol targetRow targetCol logicalArrangement)
    (case pieceType
      [(#\P) 
       (define piecePos (+ (* (- pieceRow 1) 8) pieceCol))
       (define pieceContent (substring logicalArrangement (- (* piecePos 2) 2) (* piecePos 2)))
       (define pieceColor (string-ref pieceContent 0))
       (define targetPos (+ (* (- targetRow 1) 8) targetCol))
       (define targetContent (substring logicalArrangement (- (* targetPos 2) 2) (* targetPos 2)))
       
       (cond
         [(equal? pieceColor #\B)
          (or 
           ; Normal forward move
           (and (= pieceCol targetCol) 
                (= targetRow (+ pieceRow 1))
                (string=? targetContent "  "))
           ; Double move from starting position
           (and (= pieceRow 2) 
                (= targetRow 4) 
                (= pieceCol targetCol)
                (string=? (substring logicalArrangement (- (* (+ (* (- 3 1) 8) pieceCol) 2) 2) 
                                     (* (+ (* (- 3 1) 8) pieceCol) 2)) "  ")
                (string=? targetContent "  "))
           ; Diagonal capture
           (and (= targetRow (+ pieceRow 1))
                (or (= targetCol (+ pieceCol 1)) 
                    (= targetCol (- pieceCol 1)))
                (not (string=? targetContent "  "))
                (equal? (string-ref targetContent 0) #\W)))]
         [(equal? pieceColor #\W)
          (or 
           ; Normal forward move
           (and (= pieceCol targetCol) 
                (= targetRow (- pieceRow 1))
                (string=? targetContent "  "))
           ; Double move from starting position
           (and (= pieceRow 7) 
                (= targetRow 5) 
                (= pieceCol targetCol)
                (string=? (substring logicalArrangement (- (* (+ (* (- 6 1) 8) pieceCol) 2) 2) 
                                     (* (+ (* (- 6 1) 8) pieceCol) 2)) "  ")
                (string=? targetContent "  "))
           ; Diagonal capture
           (and (= targetRow (- pieceRow 1))
                (or (= targetCol (+ pieceCol 1)) 
                    (= targetCol (- pieceCol 1)))
                (not (string=? targetContent "  "))
                (equal? (string-ref targetContent 0) #\B)))])]
      [(#\H) (CheckKnightAttack pieceRow pieceCol targetRow targetCol)]
      [(#\R) (CheckRookAttack pieceRow pieceCol targetRow targetCol logicalArrangement)]
      [(#\B) (CheckBishopAttack pieceRow pieceCol targetRow targetCol logicalArrangement)]
      [(#\Q) (CheckQueenAttack pieceRow pieceCol targetRow targetCol logicalArrangement)]
      [(#\K) (CheckKingAttack pieceRow pieceCol targetRow targetCol)]
      [else #f])
  ); end function definition: IsValidMoveForPiece
  
  (define (WouldMoveLeaveKingInCheck startPos endPos startRow endRow startCol endCol logicalArrangement playerColor)
    ;; Create hypothetical board after move
    (define hypotheticalBoard 
      (cond
        [(< startPos endPos)
         (string-append (substring logicalArrangement 0 (- (* startPos 2) 2))
                        "  "
                        (substring logicalArrangement (* startPos 2) (- (* endPos 2) 2))
                        (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2))
                        (substring logicalArrangement (* endPos 2) (string-length logicalArrangement)))]
        [else
         (string-append (substring logicalArrangement 0 (- (* endPos 2) 2))
                        (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2))
                        (substring logicalArrangement (* endPos 2) (- (* startPos 2) 2))
                        "  "
                        (substring logicalArrangement (* startPos 2) (string-length logicalArrangement)))]))
    
    ; Check if king is in check in hypothetical board
    (IsKingInCheck playerColor hypotheticalBoard)
  ); end function definition: WouldMoveLeaveKingInCheck

  ;; ========================== MOVE EXECUTION =========================
  (define (ExecuteMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)
    ;; startPos: Starting position index
    ;; endPos: Ending position index
    ;; startRow: Starting row
    ;; endRow: Ending row
    ;; startCol: Starting column
    ;; endCol: Ending column
    ;; visualArrangement: Current visual arrangement
    ;; logicalArrangement: Current logical arrangement
    ;; turnCount: Current turn count
    ;; Returns: Void, executes move if valid
    (define playerColor (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 0))
    (define opponentColor (if (equal? playerColor #\B) #\W #\B))
    
    ; Check if move would leave king in check
    (if (WouldMoveLeaveKingInCheck startPos endPos startRow endRow startCol endCol logicalArrangement playerColor)
        ; If move leaves king in check, it's invalid
        (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)
        
        ; If move is valid, proceed normally
        (cond
          [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 0) #\B)
           (cond
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\R)
              (MoveRook startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\H)
              (MoveKnight startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\B)
              (MoveBishop startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\Q)
              (MoveQueen startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\K)
              (MoveKing startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\P)
              (MovePawn startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)])]
          
          [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 0) #\W)
           (cond
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\R)
              (MoveRook startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\H)
              (MoveKnight startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\B)
              (MoveBishop startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\Q)
              (MoveQueen startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\K)
              (MoveKing startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)]
             [(equal? (string-ref (substring logicalArrangement (- (* startPos 2) 2) (* startPos 2)) 1) #\P)
              (MovePawn startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)])]
          [else (void)]))
  ); end function definition: ExecuteMove
  
  ;; ========================== INPUT HANDLING =========================
  (define (GetClickPosition)
    ;; Returns: Position of mouse click
    (define click (get-mouse-click chessWindow))
    (mouse-click-posn click)
  ); end function definition: GetClickPosition
  
  (define (ClickInArea? clickPos posX1 posX2 posY1 posY2)
    ;; clickPos: Position of click
    ;; posX1: Minimum X coordinate
    ;; posX2: Maximum X coordinate
    ;; posY1: Minimum Y coordinate
    ;; posY2: Maximum Y coordinate
    ;; Returns: Boolean indicating if click is within specified area
    (and
      (>= (posn-x clickPos) posX1)
      (<= (posn-x clickPos) posX2)
      (>= (posn-y clickPos) posY1)
      (<= (posn-y clickPos) posY2))
  ); end function definition: ClickInArea?
  
  (define (GetSquarePosition row column)
    ;; row: Row number (1-8)
    ;; column: Column number (1-8)
    ;; Returns: Position for square drawing
    (make-posn (+ 50 (* 75 (- column 1))) (+ 50 (* 75 (- row 1))))
  ); end function definition: GetSquarePosition
  
  ;; ========================== GAME LOOP =========================
  (define (ShowCheckStatus logicalArrangement turnCount)
    ;; logicalArrangement: Current logical arrangement
    ;; turnCount: Current turn count
    ;; Returns: Void, show on the screen the check status

    ; Clear previous messages
    ((clear-string chessWindow) (make-posn 815 499) "CHECK!")
    ((clear-string chessWindow) (make-posn 800 499) "CHECKMATE!")
    
    (cond 
      ; Black's turn
      [(= (remainder turnCount 2) 0)
       ((draw-pixmap chessWindow) "assets/MenuForBlackPlayer.png" (make-posn 700 0))
       (cond
         ; Checkmate for black
         [(IsCheckmate #\B logicalArrangement)
          ((draw-string chessWindow) (make-posn 800 499) "CHECKMATE!" "Red")
          ((draw-pixmap chessWindow) "assets/WhiteWins.jpeg" (make-posn 805 511))
         ]
         
         ; Check for black
         [(IsKingInCheck #\B logicalArrangement)
          ((draw-string chessWindow) (make-posn 815 499) "CHECK!" "Red")
         ]
         [else (void)]
       )
      ]
    
      ; White's turn
      [else
       (cond
         ; Checkmate for white
         [(IsCheckmate #\W logicalArrangement)
          ((draw-string chessWindow) (make-posn 800 499) "CHECKMATE!" "Red")
          ((draw-pixmap chessWindow) "assets/BlackWins.jpeg" (make-posn 805 511))
         ]
         
         ; Check for white
         [(IsKingInCheck #\W logicalArrangement)
          ((draw-string chessWindow) (make-posn 815 499) "CHECK!" "Red")
         ]
       
         ; Normal case (no check)
         [else (void)]
       )
      ]
    )
  ); end function definition: ShowCheckStatus
  
  (define (ProcessClicks clickPos visualArrangement logicalArrangement turnCount)
    ;; clickPos: Position of mouse click
    ;; visualArrangement: Current visual arrangement
    ;; logicalArrangement: Current logical arrangement
    ;; turnCount: Current turn count
    ;; Returns: Void, processes game clicks and updates state
    (define clickX (posn-x clickPos))
    (define clickY (posn-y clickPos))
    (define clickCol (+ 1 (quotient (- clickX 50) 75)))
    (define clickRow (+ 1 (quotient (- clickY 50) 75)))
    (define clickPosIndex (+ (* (- clickRow 1) 8) clickCol))

    ; End the game if the "Terminar" button is pressed
    (define (EndGame)
      (close-viewport chessWindow)
      (exit)
    )

    ; Shows a rectangle above the selected piece on the first click as a visual FeedBack
    (define (HighlightSelectedSquare)
      ((draw-rectangle chessWindow) (GetSquarePosition clickRow clickCol) 75 75 "Black"))

    ; Clear previous messages
    ((clear-string chessWindow) (make-posn 796 417) "Invalid move")
    
    ; Check for check or checkmate
    (cond 
      ; Black's turn
      [(= (remainder turnCount 2) 0)
       (cond
         ; Checkmate for black
         [(IsCheckmate #\B logicalArrangement)
          (if (ClickInArea? clickPos 758 943 600 670)
              (EndGame)
          ; else
              (begin
                (ShowCheckStatus logicalArrangement turnCount)
                (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount)
              )
          )]
         
         ; Check for black
         [(IsKingInCheck #\B logicalArrangement)
          (if (ClickInArea? clickPos 51 649 51 649)
              (cond
                [(and (equal? (string-ref (substring logicalArrangement (- (* clickPosIndex 2) 2) (* clickPosIndex 2)) 0) #\B))
                 (HighlightSelectedSquare)
                 (ProcessSecondClick (GetClickPosition) clickPosIndex clickRow clickCol visualArrangement logicalArrangement turnCount)]
                [else
                 (ShowCheckStatus logicalArrangement turnCount)
                 ((draw-string chessWindow) (make-posn 796 417) "Invalid move" "black")
                 (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount)])
              (if (ClickInArea? clickPos 758 943 600 670)
                  (EndGame)
              ; else
                  (begin
                    (ShowCheckStatus logicalArrangement turnCount)
                    ((draw-string chessWindow) (make-posn 796 417) "Invalid move" "black")
                    (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount)
                  )
              )
          )
         ]
       
       ; Normal case (no check)
         [else
          (if (ClickInArea? clickPos 51 649 51 649)
              (cond
                [(and (equal? (string-ref (substring logicalArrangement (- (* clickPosIndex 2) 2) (* clickPosIndex 2)) 0) #\B))
                 (HighlightSelectedSquare)
                 (ProcessSecondClick (GetClickPosition) clickPosIndex clickRow clickCol visualArrangement logicalArrangement turnCount)]
                [else
                 (ShowCheckStatus logicalArrangement turnCount)
                 ((draw-string chessWindow) (make-posn 796 417) "Invalid move" "black")
                 (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount)])
              (if (ClickInArea? clickPos 758 943 600 670)
                  (EndGame)
              ; else
                  (begin
                    (ShowCheckStatus logicalArrangement turnCount)
                    ((draw-string chessWindow) (make-posn 796 417) "Invalid move" "black")
                    (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount)
                  )
              )
          )
         ]
       )
      ]
    
      ; White's turn
      [else
       (cond
         ; Checkmate for white
         [(IsCheckmate #\W logicalArrangement)
          (if (ClickInArea? clickPos 758 943 600 670)
              (EndGame)
              ; else
              (begin
                (ShowCheckStatus logicalArrangement turnCount)
                (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount)
              )
          )]
         
         ; Check for white
         [(IsKingInCheck #\W logicalArrangement)
          (if (ClickInArea? clickPos 51 649 51 649)
              (cond
                [(and (equal? (string-ref (substring logicalArrangement (- (* clickPosIndex 2) 2) (* clickPosIndex 2)) 0) #\W))
                 (HighlightSelectedSquare)
                 (ProcessSecondClick (GetClickPosition) clickPosIndex clickRow clickCol visualArrangement logicalArrangement turnCount)]
                [else
                 (ShowCheckStatus logicalArrangement turnCount)
                 ((draw-string chessWindow) (make-posn 796 417) "Invalid move" "black")
                 (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount)])
              (if (ClickInArea? clickPos 758 943 600 670)
                  (EndGame)
                  (begin
                    (ShowCheckStatus logicalArrangement turnCount)
                    ((draw-string chessWindow) (make-posn 796 417) "Invalid move" "black")
                    (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount))))]
       
         ; Normal case (no check)
         [else
          (if (ClickInArea? clickPos 51 649 51 649)
            (cond
              [(and (equal? (string-ref (substring logicalArrangement (- (* clickPosIndex 2) 2) (* clickPosIndex 2)) 0) #\W))
               (HighlightSelectedSquare)
               (ProcessSecondClick (GetClickPosition) clickPosIndex clickRow clickCol visualArrangement logicalArrangement turnCount)]
              [else
               (ShowCheckStatus logicalArrangement turnCount)
               ((draw-string chessWindow) (make-posn 796 417) "Invalid move" "black")
               (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount)])
            (if (ClickInArea? clickPos 758 943 600 670)
                (EndGame)
                (begin
                  (ShowCheckStatus logicalArrangement turnCount)
                  ((draw-string chessWindow) (make-posn 796 417) "Invalid move" "black")
                  (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount)
                )
            )
          )
         ]
       )
      ]
    )
  ); end fuction definition: ProcessClicks
  
  (define (ProcessSecondClick secondClickPos startPos startRow startCol visualArrangement logicalArrangement turnCount)
    ;; secondClickPos: Position of second click
    ;; startPos: Index of starting position
    ;; startRow: Row of starting position
    ;; startCol: Column of starting position
    ;; visualArrangement: Current visual arrangement
    ;; logicalArrangement: Current logical arrangement
    ;; turnCount: Current turn count
    ;; Returns: Void, processes second click in move sequence
    (define clickX (posn-x secondClickPos))
    (define clickY (posn-y secondClickPos))
    (define endCol (+ 1 (quotient (- clickX 50) 75)))
    (define endRow (+ 1 (quotient (- clickY 50) 75)))
    (define endPos (+ (* (- endRow 1) 8) endCol))
    
    (if (ClickInArea? secondClickPos 51 649 51 649)
        (cond
          [(= startPos endPos)
           (DeselectSquare startRow startCol)
           (ShowCheckStatus logicalArrangement turnCount)
           (ProcessClicks (GetClickPosition) visualArrangement logicalArrangement turnCount)]
          [(and (= (remainder turnCount 2) 0)
                (equal? (string-ref (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) 0) #\B))
           (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)]
          [(and (= (remainder turnCount 2) 1)
                (equal? (string-ref (substring logicalArrangement (- (* endPos 2) 2) (* endPos 2)) 0) #\W))
           (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)]
          [else
           (ExecuteMove startPos endPos startRow endRow startCol endCol visualArrangement logicalArrangement turnCount)])
    ; else
        (HandleInvalidMove startRow startCol visualArrangement logicalArrangement turnCount)
    )
  ); end fuction definition: ProcessSecondClick
  
  ;; ========================== GAME INITIALIZATION =========================
  (InitializeBoardGraphics)
  (CreateChessBoard 50 50 1 1 1 64)
  (PlacePieces initialPieceArrangement 1 1 2 128)
  chessWindow
  (ShowCheckStatus initialLogicalArrangement 1)
  (ProcessClicks (GetClickPosition) initialPieceArrangement initialLogicalArrangement 1)
); end function definition: StartGame

;; ========================== START THE GAME =========================
(StartGame)