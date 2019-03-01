(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
	  :parameters (?r - robot ?locStart - location ?locEnd - location)
	  :precondition (and (free ?r) (at ?r ?locStart) (no-robot ?locEnd) (connected ?locStart ?locEnd))
	  :effect (and (no-robot ?locStart) (not (no-robot ?locEnd)) (at ?r ?locEnd) (not (at ?r ?locStart)))
   )

   (:action robotMoveWithPallette
      :parameters (?r - robot ?p - pallette ?locStart - location ?locEnd - location)
      :precondition (and (at ?r ?locStart) (at ?p ?locStart) (connected ?locStart ?locEnd) (free ?r) (no-robot ?locEnd) (no-pallette ?locEnd)) 
      :effect (and (at ?r ?locEnd) (at ?p ?locEnd) (not (at ?r ?locStart)) (not (at ?p ?locStart)) (no-pallette ?locStart) (not (no-pallette ?locEnd)) (no-robot ?locStart) (not (no-robot ?locEnd)))
   )
    
   
   (:action moveItemFromPallettetoShipment
      :parameters (?loc - location ?s - shipment ?i - saleitem ?p - pallette ?o - order)
      :precondition (and (at ?p ?loc) (contains ?p ?i)   (ships ?s ?o) (orders ?o ?i) (started ?s) (not (unstarted ?s)) (packing-location ?loc) (packing-at ?s ?loc))
      :effect (and (not (contains ?p ?i)) (includes ?s ?i))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?loc - location)
      :precondition  (and (packing-at ?s ?loc) (ships ?s ?o) (started ?s))
      :effect (and (complete ?s) (available ?loc) (not (packing-at ?s ?loc)))
   )

)
