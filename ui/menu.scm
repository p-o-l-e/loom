(define menu-id 0)
(define menu-width 249) 
(define menu-height 24)

(define (menu-descriptor)
    (let*  ((static-id   (control-counter 0))
            (control-id  (control-counter 0))
            (input-id    (control-counter 0))
            (output-id   (control-counter 0))
            (TBoxNew     (encode-uid CMT_MAINMENU menu-id F_CT_STATIC (static-id)))
            (TBoxAbout   (encode-uid CMT_MAINMENU menu-id F_CT_STATIC (static-id)))
            )

    (list
        (sector
            ID:             menu-id
            Width:          menu-width
            Height:         menu-height
            Type:           ST_NODE
            SubType:        SS_A
            Label:          "MAINMENU"
            Flags:          0
        )

        (sector
            ID:             (encode-uid CMT_MAINMENU menu-id F_CT_STATIC (static-id))
            NodeID:         menu-id
            Left:           (grid-x 0)
            Top:            (grid-y 0)
            Width:          (grid-x 4)
            Height:         Unit
            Type:           ST_MOMENTARY
            Label:          "NEW"
            Flags:          0
            CallbackTarget: TBoxNew
            CallbackEvent:  F_CE_REPAINT
        )

        (sector
            ID:             TBoxNew
            NodeID:         menu-id
            Left:           (grid-x 1)
            Top:            (grid-y 0)
            Width:          (grid-x 5)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "NEW"
            Flags:          TRANSPARENT
        )

        (sector
            ID:             (encode-uid CMT_MAINMENU menu-id F_CT_STATIC (static-id))
            NodeID:         menu-id
            Left:           (grid-x 5)
            Top:            (grid-y 0)
            Width:          (grid-x 4)
            Height:         Unit
            Type:           ST_MOMENTARY
            Label:          "NEW"
            Flags:          0
            CallbackTarget: TBoxAbout
            CallbackEvent:  F_CE_REPAINT
        )

        (sector
            ID:             TBoxAbout
            NodeID:         menu-id
            Left:           (grid-x 6)
            Top:            (grid-y 0)
            Width:          (grid-x 5)
            Height:         Unit
            Type:           ST_TEXTBOX
            Label:          "ABOUT"
            Flags:          TRANSPARENT
        )
        ;---COARSE--------------------------------------------------------------------------------------------------------------


        ;---FINE----------------------------------------------------------------------------------------------------------------




    ))
)
