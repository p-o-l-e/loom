(define LeftMargin  8)
(define TopMargin   8)
(define GridStepX   16)
(define GridStepY   18)

(define (grid-x value) (+ LeftMargin (* value GridStepX)))
(define (grid-y value) (+ TopMargin  (* value GridStepY)))

