(define generator-id 0)
(define generator-width 249) 
(define generator-height 99)

(define generator-descriptor
    (let*  ((textbox-id  (control-counter 0))
            (checkbox-id (control-counter 0))
            (socket-id   (control-counter 0))
            (encoder-id  (control-counter 0))
            (slider-id   (control-counter 0))
            (TBoxCoarse  (encode-uid MT_GENERATOR generator-id ST_TEXTBOX (textbox-id)))
            (TBoxFine    (encode-uid MT_GENERATOR generator-id ST_TEXTBOX (textbox-id)))
            (TBoxAmp     (encode-uid MT_GENERATOR generator-id ST_TEXTBOX (textbox-id)))
            )

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
            ID:             (encode-uid MT_GENERATOR generator-id ST_TEXTBOX (textbox-id))
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
            ID:             (encode-uid MT_GENERATOR generator-id ST_TEXTBOX (textbox-id))
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
            ID:             (encode-uid MT_GENERATOR generator-id ST_SLIDER (slider-id))
            NodeID:         generator-id
            Left:           (grid-x 3)
            Top:            (grid-y 1)
            Width:          (* 10 Unit)
            Height:         Unit
            Type:           ST_SLIDER
            SubType:        SS_B
            DefaultValue:   1.0
            RangeMin:       1.0
            RangeMax:       100.0
            StepCoarse:     1.0
            StepFine:       0.1
            Label:          "COARSE"
            Flags:          MOVEABLE
            Output:         TBoxCoarse
        )

        ;---FINE----------------------------------------------------------------------------------------------------------------

        (sector
            ID:             (encode-uid MT_GENERATOR generator-id ST_TEXTBOX (textbox-id))
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
            ID:             (encode-uid MT_GENERATOR generator-id ST_SLIDER (slider-id))
            NodeID:         generator-id
            Left:           (grid-x 3)
            Top:            (grid-y 2)
            Width:          (* 10 Unit)
            Height:         Unit
            Type:           ST_SLIDER
            SubType:        SS_B
            DefaultValue:   1.0
            RangeMin:       0.01
            RangeMax:       10.0
            StepCoarse:     0.1
            StepFine:       0.01
            Label:          "FINE"
            Flags:          MOVEABLE
            Output:         TBoxFine
        )

        ;---AMPLITUDE-----------------------------------------------------------------------------------------------------------
        
        (sector
            ID:             (encode-uid MT_GENERATOR generator-id ST_TEXTBOX (textbox-id))
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
            ID:             (encode-uid MT_GENERATOR generator-id ST_SLIDER (slider-id))
            NodeID:         generator-id
            Left:           (grid-x 3)
            Top:            (grid-y 3)
            Width:          (* 10 Unit)
            Height:         Unit
            Type:           ST_SLIDER
            SubType:        SS_B
            DefaultValue:   0.00
            RangeMin:       0.00
            RangeMax:       1.00
            StepCoarse:     0.01
            StepFine:       0.001
            Label:          "AMP"
            Flags:          MOVEABLE
            Output:         TBoxAmp
        )

        ;---OUTPUTS-------------------------------------------------------------------------------------------------------------
        (sector
            ID:             (encode-uid MT_GENERATOR generator-id ST_SOCKET (socket-id))
            NodeID:         generator-id
            Left:           (grid-x 12)
            Top:            (grid-y 4)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            Flags:          (logior INTERCON OUTPUT MOVEABLE)
        )

        (sector
            ID:             (encode-uid MT_GENERATOR generator-id ST_TEXTBOX (textbox-id))
            NodeID:         generator-id
            Left:           (grid-x 10)
            Top:            (grid-y 4)
            Width:          (* 3 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "OUT"
            Flags:          TRANSPARENT
        )

    ))
)
