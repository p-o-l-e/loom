(define NodeID      1)

(define vco-descriptor
    (let*  ((NodeWidth  249) 
            (NodeHeight 199)
            (Unit 12)
            (textbox-id  (control-counter 0))
            (checkbox-id (control-counter 0))
            (socket-id   (control-counter 0))
            (encoder-id  (control-counter 0))
            (slider-id   (control-counter 0))
            (TBoxCoarse  (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id)))
            (TBoxFine    (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id)))
            (TBoxPWM     (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id)))
            (TBoxFM      (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id)))
            (TBoxAM      (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id)))
            (TBoxAmp     (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id)))
            )

    (list
        (sector
            ID:             NodeID
            Width:          NodeWidth
            Height:         NodeHeight
            Type:           ST_NODE
            SubType:        SS_A
            Label:          "VCO"
            Flags:          MOVEABLE
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
            Left:           (grid-x 3)
            Top:            (grid-y 0)
            Width:          (grid-x 9)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "OSCILLATOR"
            Flags:          TRANSPARENT
        )

        ;---COARSE--------------------------------------------------------------------------------------------------------------

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
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
            NodeID:         NodeID
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 1)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          0;TRANSPARENT
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SLIDER (slider-id))
            NodeID:         NodeID
            Left:           (grid-x 3)
            Top:            (grid-y 1)
            Width:          (* 6 GridStepX)
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
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
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
            NodeID:         NodeID
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 2)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          0;TRANSPARENT
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SLIDER (slider-id))
            NodeID:         NodeID
            Left:           (grid-x 3)
            Top:            (grid-y 2)
            Width:          (* 6 GridStepX)
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

        ;---PWM-----------------------------------------------------------------------------------------------------------------
        
        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 3)
            Width:          (* 6 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "   PWM"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             TBoxPWM
            NodeID:         NodeID
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 3)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          0;TRANSPARENT
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_ENCODER (encoder-id))
            NodeID:         NodeID
            Left:           (grid-x 3)
            Top:            (grid-y 3)
            Width:          (* 6 GridStepX)
            Height:         Unit
            Type:           ST_ENCODER
            SubType:        SS_A
            DefaultValue:   0.00
            RangeMin:       -1.00
            RangeMax:       1.00
            StepCoarse:     0.1
            StepFine:       0.01
            Label:          "PWM"
            Flags:          MOVEABLE
            Output:         TBoxPWM
        )

        ;---FM------------------------------------------------------------------------------------------------------------------
        
        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 4)
            Width:          (* 6 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "    FM"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             TBoxFM
            NodeID:         NodeID
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 4)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SLIDER (slider-id))
            NodeID:         NodeID
            Left:           (grid-x 3)
            Top:            (grid-y 4)
            Width:          (* 6 GridStepX)
            Height:         Unit
            Type:           ST_SLIDER
            SubType:        SS_B
            DefaultValue:   0.00
            RangeMin:       0.00
            RangeMax:       1.00
            StepCoarse:     0.01
            StepFine:       0.001
            Label:          "FM"
            Flags:          MOVEABLE
            Output:         TBoxFM
        )

        ;---AM------------------------------------------------------------------------------------------------------------------
        
        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 5)
            Width:          (* 6 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "    AM"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             TBoxAM
            NodeID:         NodeID
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 5)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SLIDER (slider-id))
            NodeID:         NodeID
            Left:           (grid-x 3)
            Top:            (grid-y 5)
            Width:          (* 6 GridStepX)
            Height:         Unit
            Type:           ST_SLIDER
            SubType:        SS_B
            DefaultValue:   0.00
            RangeMin:       0.00
            RangeMax:       1.00
            StepCoarse:     0.01
            StepFine:       0.001
            Label:          "AM"
            Flags:          MOVEABLE
            Output:         TBoxAM
        )

        ;---AMPLITUDE-----------------------------------------------------------------------------------------------------------
        
        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 6)
            Width:          (* 6 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "   AMP"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             TBoxAmp
            NodeID:         NodeID
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 6)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SLIDER (slider-id))
            NodeID:         NodeID
            Left:           (grid-x 3)
            Top:            (grid-y 6)
            Width:          (* 6 GridStepX)
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

        ;---SWITCHES------------------------------------------------------------------------------------------------------------
        (sector
            ID:             (encode-uid MT_VCO NodeID ST_CHECKBOX (checkbox-id))
            NodeID:         NodeID
            Left:           (grid-x 3)
            Top:            (grid-y 7)
            Width:          Unit
            Height:         Unit
            Type:           ST_CHECKBOX
            RadioID:        (encode-uid MT_VCO NodeID ST_CHECKBOX 0)
            Label:          "SWITCH"
            Flags:          RADIO
            Output:         0
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_CHECKBOX (checkbox-id))
            NodeID:         NodeID
            Left:           (grid-x 3)
            Top:            (grid-y 8)
            Width:          Unit
            Height:         Unit
            Type:           ST_CHECKBOX
            SubType:        SS_B
            RadioID:        (encode-uid MT_VCO NodeID ST_CHECKBOX 0)
            Label:          "SWITCH"
            Flags:          RADIO
            Output:         0
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_CHECKBOX (checkbox-id))
            NodeID:         NodeID
            Left:           (grid-x 3)
            Top:            (grid-y 9)
            Width:          Unit
            Height:         Unit
            Type:           ST_CHECKBOX
            SubType:        SS_B
            RadioID:        (encode-uid MT_VCO NodeID ST_CHECKBOX 0)
            Label:          "SWITCH"
            Flags:          RADIO
            Output:         0
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
            Left:           (grid-x 4)
            Top:            (grid-y 7)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "SINE"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
            Left:           (grid-x 4)
            Top:            (grid-y 8)
            Width:          (* 3 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "SAW"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
            Left:           (grid-x 4)
            Top:            (grid-y 9)
            Width:          (* 6 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "SQUARE"
            Flags:          TRANSPARENT
        )

        ;---INPUTS--------------------------------------------------------------------------------------------------------------
        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SOCKET (socket-id))
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 3)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            Flags:          (logior INTERCON INPUT MOVEABLE)
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SOCKET (socket-id))
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 4)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            Flags:          (logior INTERCON INPUT MOVEABLE)
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SOCKET (socket-id))
            NodeID:         NodeID
            Left:           (grid-x 0)
            Top:            (grid-y 5)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            Flags:          (logior INTERCON INPUT MOVEABLE)
        )

        ;---OUTPUTS-------------------------------------------------------------------------------------------------------------
        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SOCKET (socket-id))
            NodeID:         NodeID
            Left:           (grid-x 12)
            Top:            (grid-y 8)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            Flags:          (logior INTERCON OUTPUT MOVEABLE)
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
            Left:           (grid-x 11)
            Top:            (grid-y 8)
            Width:          Unit
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "X"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_SOCKET (socket-id))
            NodeID:         NodeID
            Left:           (grid-x 12)
            Top:            (grid-y 9)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            Flags:          (logior INTERCON OUTPUT MOVEABLE)
        )

        (sector
            ID:             (encode-uid MT_VCO NodeID ST_TEXTBOX (textbox-id))
            NodeID:         NodeID
            Left:           (grid-x 11)
            Top:            (grid-y 9)
            Width:          Unit
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "Y"
            Flags:          TRANSPARENT
        )
    ))
)
