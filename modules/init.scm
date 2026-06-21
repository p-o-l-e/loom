#|
 | Returns 32-bit identifier [ AA BB CC DD  ]
 | AA : Module type
 | BB : Module id/position
 | CC : Parameter type
 | DD : Parameter id/position
 |#

(define (encode-uid mt mp pt pp)
  (logior (ash mt 24)
          (ash mp 16)
          (ash pt 8)
          pp))

(define (decode-uid data)
  (list (logand #xff (ash data -24))  ; mt
        (logand #xff (ash data -16))  ; mp
        (logand #xff (ash data -8))   ; pt
        (logand #xff data)))          ; pp


(define (partition-keywords args)
    (let loop ((lst args) (acc '()))
        (if (null? lst)
            (reverse acc)
            (loop (cddr lst)
                (cons (cons (car lst) (cadr lst)) acc)))))


(define (merge-defaults defaults pairs)
    (map (lambda (d)
        (let ((found (assq (car d) pairs)))
            (if found (cdr found) (cdr d))))
            defaults))


(define-macro (sector . args)
    (let* ((pairs (partition-keywords args))
        (defaults '((ID:            . -1)
                    (NodeID:        . 0)
                    (Left:          . 0)
                    (Top:           . 0)
                    (Width:         . 10)
                    (Height:        . 10)
                    (Type:          . 0)
                    (SubType:       . 0)
                    (DefaultValue:  . 0.0)
                    (RangeMin:      . 0.0)
                    (RangeMax:      . 100.0)
                    (StepCoarse:    . 1.0)
                    (StepFine:      . 0.1)
                    (RadioID:       . 0)
                    (Label:         . "")
                    (Flags:         . 0)
                    (Output:        . 0)
                )
            )
         )
    `(create-sector-descriptor ,@(merge-defaults defaults pairs))))

