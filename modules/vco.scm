(define vco-id 0)
(define vco-width 249) 
(define vco-height 199)

(define (vco-descriptor)
    (let*  ((static-id   (control-counter 0))
            (control-id  (control-counter 0))
            (input-id    (control-counter 0))
            (output-id   (control-counter 0))
            (TBoxCoarse  (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id)))
            (TBoxFine    (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id)))
            (TBoxPWM     (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id)))
            (TBoxFM      (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id)))
            (TBoxAM      (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id)))
            (TBoxAmp     (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id)))
            )

    (list
        (sector
            ID:             vco-id
            Width:          vco-width
            Height:         vco-height
            Type:           ST_NODE
            SubType:        SS_A
            Label:          "VCO"
            Flags:          MOVEABLE
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
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
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
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
            NodeID:         vco-id
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 1)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          0;TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_CONTROL (control-id))
            NodeID:         vco-id
            Left:           (grid-x 3)
            Top:            (grid-y 1)
            Width:          (* 6 GridStepX)
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
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
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
            NodeID:         vco-id
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 2)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          0;TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_CONTROL (control-id))
            NodeID:         vco-id
            Left:           (grid-x 3)
            Top:            (grid-y 2)
            Width:          (* 6 GridStepX)
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

        ;---PWM-----------------------------------------------------------------------------------------------------------------
        
        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
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
            NodeID:         vco-id
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 3)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          0;TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_CONTROL (control-id))
            NodeID:         vco-id
            Left:           (grid-x 3)
            Top:            (grid-y 3)
            Width:          (* 6 GridStepX)
            Height:         Unit
            Type:           ST_ENCODER
            CoreType:       F_CT_CONTROL
            SubType:        SS_A
            DefaultValue:   0.00
            RangeMin:       -1.00
            RangeMax:       1.00
            StepCoarse:     0.1
            StepFine:       0.01
            Label:          "PWM"
            Flags:          MOVEABLE
            CallbackTarget: TBoxPWM
            CallbackEvent:  F_CE_VALUE
        )

        ;---FM------------------------------------------------------------------------------------------------------------------
        
        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
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
            NodeID:         vco-id
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 4)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_CONTROL (control-id))
            NodeID:         vco-id
            Left:           (grid-x 3)
            Top:            (grid-y 4)
            Width:          (* 6 GridStepX)
            Height:         Unit
            Type:           ST_SLIDER
            CoreType:       F_CT_CONTROL
            SubType:        SS_B
            DefaultValue:   0.00
            RangeMin:       0.00
            RangeMax:       1.00
            StepCoarse:     0.01
            StepFine:       0.001
            Label:          "FM"
            Flags:          MOVEABLE
            CallbackTarget: TBoxFM
            CallbackEvent:  F_CE_VALUE
        )

        ;---AM------------------------------------------------------------------------------------------------------------------
        
        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
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
            NodeID:         vco-id
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 5)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_CONTROL (control-id))
            NodeID:         vco-id
            Left:           (grid-x 3)
            Top:            (grid-y 5)
            Width:          (* 6 GridStepX)
            Height:         Unit
            Type:           ST_SLIDER
            CoreType:       F_CT_CONTROL
            SubType:        SS_B
            DefaultValue:   0.00
            RangeMin:       0.00
            RangeMax:       1.00
            StepCoarse:     0.01
            StepFine:       0.001
            Label:          "AM"
            Flags:          MOVEABLE
            CallbackTarget: TBoxAM
            CallbackEvent:  F_CE_VALUE
        )

        ;---AMPLITUDE-----------------------------------------------------------------------------------------------------------
        
        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
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
            NodeID:         vco-id
            Left:           (- (grid-x 10) Unit)
            Top:            (grid-y 6)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "0.00"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_CONTROL (control-id))
            NodeID:         vco-id
            Left:           (grid-x 3)
            Top:            (grid-y 6)
            Width:          (* 6 GridStepX)
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
        )

        ;---SWITCHES------------------------------------------------------------------------------------------------------------
        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_CONTROL (control-id))
            NodeID:         vco-id
            Left:           (grid-x 3)
            Top:            (grid-y 7)
            Width:          Unit
            Height:         Unit
            Type:           ST_CHECKBOX
            CoreType:       F_CT_CONTROL
            RadioID:        (encode-uid CMT_VCO vco-id F_CT_CONTROL 0)
            Label:          "SWITCH"
            Flags:          RADIO
            CallbackTarget: 0
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_CONTROL (control-id))
            NodeID:         vco-id
            Left:           (grid-x 3)
            Top:            (grid-y 8)
            Width:          Unit
            Height:         Unit
            Type:           ST_CHECKBOX
            CoreType:       F_CT_CONTROL
            SubType:        SS_B
            RadioID:        (encode-uid CMT_VCO vco-id F_CT_CONTROL 0)
            Label:          "SWITCH"
            Flags:          RADIO
            CallbackTarget: 0
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_CONTROL (control-id))
            NodeID:         vco-id
            Left:           (grid-x 3)
            Top:            (grid-y 9)
            Width:          Unit
            Height:         Unit
            Type:           ST_CHECKBOX
            CoreType:       F_CT_CONTROL
            SubType:        SS_B
            RadioID:        (encode-uid CMT_VCO vco-id F_CT_CONTROL 0)
            Label:          "SWITCH"
            Flags:          RADIO
            CallbackTarget: 0
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
            Left:           (grid-x 4)
            Top:            (grid-y 7)
            Width:          (* 4 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "SINE"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
            Left:           (grid-x 4)
            Top:            (grid-y 8)
            Width:          (* 3 Unit)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "SAW"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
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
            ID:             (encode-uid CMT_VCO vco-id F_CT_INPUT (input-id))
            NodeID:         vco-id
            Left:           (grid-x 0)
            Top:            (grid-y 3)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_INPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_INPUT (input-id))
            NodeID:         vco-id
            Left:           (grid-x 0)
            Top:            (grid-y 4)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_INPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_INPUT (input-id))
            NodeID:         vco-id
            Left:           (grid-x 0)
            Top:            (grid-y 5)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_INPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        ;---OUTPUTS-------------------------------------------------------------------------------------------------------------
        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_OUTPUT (output-id))
            NodeID:         vco-id
            Left:           (grid-x 12)
            Top:            (grid-y 8)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_OUTPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
            Left:           (grid-x 11)
            Top:            (grid-y 8)
            Width:          Unit
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "X"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_OUTPUT (output-id))
            NodeID:         vco-id
            Left:           (grid-x 12)
            Top:            (grid-y 9)
            Width:          Unit
            Height:         Unit
            Type:           ST_SOCKET
            CoreType:       F_CT_OUTPUT
            Flags:          (logior INTERCON MOVEABLE)
        )

        (sector
            ID:             (encode-uid CMT_VCO vco-id F_CT_STATIC (static-id))
            NodeID:         vco-id
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
