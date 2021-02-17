#lang pie

;; Exercises on Pi types and using the List elimiator from Chapters 4 and 5
;; of The Little Typer
;;
;; Some exercises are adapted from assignments at Indiana University


;; Exercise 4.1
;;
;; Extend the definitions of kar and kdr (frame 4.42) so they work with arbirary
;; Pairs (instead of just for Pair Nat Nat).

;; First, let's redefine elim-Pair:

(claim elim-Pair
  (Pi ((A U) (B U) (X U))
    (-> (Pair A B) (-> A B X) X)))
(define elim-Pair
  (lambda (A B X)
    (lambda (pair f)
      (f (car pair) (cdr pair)))))

(claim kar
  (Pi ((A U) (B U))
    (-> (Pair A B) A)))
(define kar
  (lambda (A B)
    (lambda (x)
      (elim-Pair A B A x
        (lambda (ca cd) ca)))))

(check-same Atom (kar Atom Atom (cons 'three 'four)) 'three)

(claim kdr
  (Pi ((A U) (B U))
    (-> (Pair A B) B)))
(define kdr
  (lambda (A B)
    (lambda (x)
      (elim-Pair A B B x
        (lambda (ca cd) cd)))))

(check-same Atom (kdr Atom Atom (cons 'three 'four)) 'four)

;; Exercise 4.2
;;
;; Define a function called compose that takes (in addition to the type
;; arguments A, B, C) an argument of type (-> A B) and an argument of
;; type (-> B C) that and evaluates to a value of type (-> A C), the function
;; composition of the arguments.

(claim compose
  (Pi ((A U) (B U) (C U))
    (-> (-> A B) (-> B C) (-> A C))))
(define compose
  (lambda (A B C)
    (lambda (f g)
      (lambda (x)
        (g (f x))))))

;; Exercise 5.1
;;
;; Define a function called sum-List that takes one List Nat argument and
;; evaluates to a Nat, the sum of the Nats in the list.

;; First, let's redefine +:
(claim + (-> Nat Nat Nat))
(define +
  (lambda (i j)
    (iter-Nat i
      j
      (lambda (x) (add1 x)))))

(claim sum-List (-> (List Nat) Nat))
(define sum-List
  (lambda (lst)
    (rec-List lst
      0
      (lambda (e _es rest-of-sum)
        (+ e rest-of-sum)))))

(check-same Nat (sum-List (:: 1 (:: 2 (:: 3 (:: 4 nil))))) 10)

;; Exercise 5.2
;;
;; Define a function called maybe-last which takes (in addition to the type
;; argument for the list element) one (List E) argument and one E argument and
;; evaluates to an E with value of either the last element in the list, or the
;; value of the second argument if the list is empty.


(claim hd (Pi ((E U)) (-> (List E) E E)))
(define hd
  (lambda (E es default)
    (rec-List es
      default
      (lambda (e _es _next) e))))

(claim one-element? (Pi ((E U)) (-> (List E) Atom)))
(define one-element?
  (lambda (E es)
    (rec-List es
      'false
      (lambda (e es next)
        (rec-List es
          'true
          (lambda (e es next) 'false))))))

(check-same Atom (one-element? Nat nil) 'false)
(check-same Atom (one-element? Nat (:: 1 nil)) 'true)
(check-same Atom (one-element? Nat (:: 1 (:: 2 nil))) 'false)
(check-same Atom (one-element? Nat (:: 1 (:: 2 (:: 3 nil)))) 'false)

(claim maybe-last
  (Pi ((E U))
    (-> (List E) E E)))
(define maybe-last
  (lambda (E)
    (lambda (es default)
      (rec-List es
        default
        (lambda (ei eis maybe-last-es)
          (rec-List eis
            ei
            (lambda (_ _ _) maybe-last-es)))))))

(check-same Nat (maybe-last Nat nil 0) 0)
(check-same Nat (maybe-last Nat (:: 42 nil) 0) 42)
(check-same Nat (maybe-last Nat (:: 41 (:: 42 nil)) 0) 42)

;; Exercise 5.3
;;
;; Define a function called filter-list which takes (in addition to the type
;; argument for the list element) one (-> E Nat) argument representing a
;; predicate and one (List E) argument.
;;
;; The function evaluates to a (List E) consisting of elements from the list
;; argument where the predicate is true.
;;
;; Consider the predicate to be false for an element if it evaluates to zero,
;; and true otherwise.

(claim filter-list
  (Pi ((E U))
    (-> (-> E Nat) (List E) (List E))))
(define filter-list
  (lambda (E)
    (lambda (predicate lst)
      (rec-List lst
        (the (List E) nil)
        (lambda (e es rest)
          (which-Nat (predicate e)
            rest
            (lambda (_) (:: e rest))))))))

;; Test case from crib


(claim id
       (Π ([E U])
          (-> E
              E)))

(define id
  (λ (E)
    (λ (x) x)))

(claim different-from-zero
       (-> Nat
           Nat))

(define different-from-zero (id Nat))

(check-same (List Nat) (filter-list Nat different-from-zero (:: 0 (:: 1 (:: 0 nil)))) (:: 1 nil))
(check-same (List Nat) (filter-list Nat different-from-zero (:: 0 (:: 0 (:: 0 nil)))) nil)
(check-same (List Nat) (filter-list Nat different-from-zero nil) nil)

;; Exercise 5.4
;;
;; Define a function called sort-List-Nat which takes one (List Nat) argument
;; and evaluates to a (List Nat) consisting of the elements from the list
;; argument sorted in ascending order.