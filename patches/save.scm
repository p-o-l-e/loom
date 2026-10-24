#|
 | patches/save.scm — saved patch layout.
 |
 | Written by the menu SAVE button (patch.h:patch_save_current).
 | Mirrors patches/init.scm: creates the core rack, instantiates and
 | places modules, wires them to core nodes, and starts the
 | processing thread.
 |#

(define FPS 60)

;;--------------------------------------------------------------------------
;; Core rack — the DSP-side processing graph.
;;--------------------------------------------------------------------------

(define rack (create-rack 16))

;;--------------------------------------------------------------------------
;; Modules — one place-node call per module.
;; With core-type + uid: load GUI + create core node + place + bind.
;; Without: load GUI + place only (menu, CRT, unbound generators).
;;--------------------------------------------------------------------------

(place-node rack "menu"      0   0)
(place-node rack "vco"       0   25   CMT_VCO       #xc)
(place-node rack "generator" 0   225  CMT_GENERATOR #xa)
(place-node rack "generator" 0   325  CMT_GENERATOR #xb)
(place-node rack "generator" 0   425  CMT_GENERATOR #xe)
(place-node rack "crt"       250 25)
(place-node rack "split"     250 325  CMT_SPLIT     #xd)

;;--------------------------------------------------------------------------
;; CRT display refresh rate.
;;--------------------------------------------------------------------------

(set-crt-fps FPS)

;;--------------------------------------------------------------------------
;; Start the core processing thread (runs in the background).
;;--------------------------------------------------------------------------

(start-core rack FPS)
