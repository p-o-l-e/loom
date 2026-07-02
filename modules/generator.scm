(define generator-id 0)
(define generator-width 249) 
(define generator-height 99)

(define (generator-descriptor)
    (let*  ((static-id   (control-counter 0))
            (control-id  (control-counter 0))
            (input-id    (control-counter 0))
            (output-id   (control-counter 0))
            (TBoxCoarse  (encode-uid CMT_GENERATOR generator-id F_CT_STATIC (static-id)))
            (TBoxFine    (encode-uid CMT_GENERATOR generator-id F_CT_STATIC (static-id)))
            (TBoxAmp     (encode-uid CMT_GENERATOR generator-id F_CT_STATIC (static-id)))
            )

    (format #t "Module-ID : ~s ~%" generator-id) ;; In main.c we create 3 generators but this line printed once
    (format #t "TBoxAmp   : ~X~%" TBoxAmp) ;; In main.c we create 3 generators but this line printed once
    (list
        (sector
            ID:             generator-id
            Width:          generator-width
            Height:         generator-height
            Type:           ST_NODE
            SubType:        SS_A
            Label:          "GENERATOR"
            Flags:          MOVEABLE
        )

        (sector
            ID:             (encode-uid CMT_GENERATOR generator-id F_CT_STATIC (static-id))
            NodeID:         generator-id
            Left:           (grid-x 3)
            Top:            (grid-y 0)
            Width:          (grid-x 9)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "GENERATOR"
            Flags:          TRANSPARENT
        )

        ;---COARSE--------------------------------------------------------------------------------------------------------------

        (sector
            ID:             (encode-uid CMT_GENERATOR generator-id F_CT_STATIC (static-id))
            NodeID:         generator-id
            Left:           (grid-x 0)
            Top:            (grid-y 1)
            Width:          (* 6 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "COARSE"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             TBoxCoarse
            NodeID:         generator-id
            Left:           (grid-x 10)
            Top:            (grid-y 1)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          0;TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_GENERATOR generator-id F_CT_CONTROL (control-id))
            NodeID:         generator-id
            Left:           (grid-x 3)
            Top:            (grid-y 1)
            Width:          (* 10 Unit)
            Height:         Unit
            Type:           ST_SLIDER
            CoreType:       F_CT_CONTROL
            SubType:        SS_B
            DefaultValue:   1.0
            RangeMin:       1.0
            RangeMax:       100.0
            StepCoarse:     1.0
            StepFine:       0.1
            Label:          "COARSE"
            Flags:          MOVEABLE
            CallbackTarget: TBoxCoarse
            CallbackEvent:  F_CE_VALUE
        )

        ;---FINE----------------------------------------------------------------------------------------------------------------

        (sector
            ID:             (encode-uid CMT_GENERATOR generator-id F_CT_STATIC (static-id))
            NodeID:         generator-id
            Left:           (grid-x 0)
            Top:            (grid-y 2)
            Width:          (* 6 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "  FINE"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             TBoxFine
            NodeID:         generator-id
            Left:           (grid-x 10)
            Top:            (grid-y 2)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          0;TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_GENERATOR generator-id F_CT_CONTROL (control-id))
            NodeID:         generator-id
            Left:           (grid-x 3)
            Top:            (grid-y 2)
            Width:          (* 10 Unit)
            Height:         Unit
            Type:           ST_SLIDER
            CoreType:       F_CT_CONTROL
            SubType:        SS_B
            DefaultValue:   1.0
            RangeMin:       0.01
            RangeMax:       10.0
            StepCoarse:     0.1
            StepFine:       0.01
            Label:          "FINE"
            Flags:          MOVEABLE
            CallbackTarget: TBoxFine
            CallbackEvent:  F_CE_VALUE
        )

        ;---AMPLITUDE-----------------------------------------------------------------------------------------------------------
        
        (sector
            ID:             (encode-uid CMT_GENERATOR generator-id F_CT_STATIC (static-id))
            NodeID:         generator-id
            Left:           (grid-x 0)
            Top:            (grid-y 3)
            Width:          (* 6 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "   AMP"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             TBoxAmp
            NodeID:         generator-id
            Left:           (grid-x 10)
            Top:            (grid-y 3)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_GENERATOR generator-id F_CT_CONTROL (control-id))
            NodeID:         generator-id
            Left:           (grid-x 3)
            Top:            (grid-y 3)
            Width:          (* 10 Unit)
            Height:         Unit
            Type:           ST_SLIDER
            CoreType:       F_CT_CONTROL
            SubType:        SS_B
            DefaultValue:   0.00
            RangeMin:       0.00
            RangeMax:       1.00
            StepCoarse:     0.01
            StepFine:       0.001
            Label:          "AMP"
            Flags:          MOVEABLE
            CallbackTarget: TBoxAmp
            CallbackEvent:  F_CE_VALUE
        )

        ;---OUTPUTS-------------------------------------------------------------------------------------------------------------
        (sector
            ID:             (encode-uid CMT_GENERATOR generator-id F_CT_OUTPUT (output-id))
            NodeID:         generator-id
            Left:           (grid-x 12)
            Top:            (grid-y 4)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_OUTPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        (sector
            ID:             (encode-uid CMT_GENERATOR generator-id F_CT_STATIC (static-id))
            NodeID:         generator-id
            Left:           (grid-x 10)
            Top:            (grid-y 4)
            Width:          (* 2 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "OUT"
            Flags:          TRANSPARENT
        )

    ))
)
