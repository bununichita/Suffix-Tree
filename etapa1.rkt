#lang racket
(require "suffix-tree.rkt")

(provide (all-defined-out))

; TODO 2
; Implementați o funcție care primește două cuvinte (liste
; de caractere) w1 și w2 și calculează cel mai lung prefix
; comun al acestora, împreună cu restul celor două cuvinte
; după eliminarea prefixului comun.
; ex:
; (longest-common-prefix '(#\w #\h #\y) '(#\w #\h #\e #\n))
; => '((#\w #\h) (#\y) (#\e #\n))
; Folosiți recursivitate pe coadă.
(define (longest-common-prefix w1 w2)
  (define (lcp-aux pref rem1 rem2)
    (cond ((null? rem1) (list pref rem1 rem2))
          ((null? rem2) (list pref rem1 rem2))
          ((not (equal? (car rem1) (car rem2))) (list pref rem1 rem2))
          (else (lcp-aux (append pref (list (car rem1))) (cdr rem1) (cdr rem2)))))
  (lcp-aux '() w1 w2))


; TODO 3
; Implementați recursiv o funcție care primește o listă nevidă 
; de cuvinte care încep cu același caracter și calculează cel 
; mai lung prefix comun al acestora.
; Opriți căutarea (parcurgerea) în momentul în care aveți garanția 
; că prefixul comun curent este prefixul comun final.


;(define (longest-common-prefix-of-list words)
;  (define (lcpol-aux pref words)
;    (define (just-longest-common-prefix pref rem1 rem2)
;      (cond ((null? rem1) pref)
;            ((null? rem2) pref)
;            ((not (equal? (car rem1) (car rem2))) pref)
;            (else (just-longest-common-prefix (append pref (list (car rem1))) (cdr rem1) (cdr rem2)))))

;    (lcpol-aux ()))
;  )


(define (longest-common-prefix-of-list words)
  (define (lcpol-aux word words)
    (cond ((null? word) '())
          ((null? words) word)
          (else (lcpol-aux (car (longest-common-prefix word (car words))) (cdr words)))))
  (lcpol-aux (car words) (cdr words)))


;; Următoarele două funcții sunt utile căutării unui șablon
;; (pattern) într-un text cu ajutorul arborelui de sufixe.
;; Ideea de căutare este următoarea:
;; - dacă șablonul există în text, atunci există un sufix care
;;   începe cu acest șablon, deci există o cale care începe din
;;   rădăcina arborelui care se potrivește cu șablonul
;; - vom căuta ramura a cărei etichetă începe cu prima literă
;;   din șablon
;; - dacă nu găsim această ramură, șablonul nu apare în text
;; - dacă șablonul este conținut integral în eticheta ramurii,
;;   atunci el apare în text
;; - dacă șablonul se potrivește cu eticheta dar nu este conținut
;;   în ea (de exemplu șablonul "nana$" se potrivește cu eticheta
;;   "na"), atunci continuăm căutarea în subarborele ramurii
;; - dacă șablonul nu se potrivește cu eticheta (de exemplu
;;   șablonul "numai" nu se potrivește cu eticheta "na"), atunci
;;   el nu apare în text (altfel, eticheta ar fi fost "n", nu
;;   "na", pentru că eticheta este cel mai lung prefix comun al
;;   sufixelor din subarborele său)


; TODO 4
; Implementați funcția match-pattern-with-label care primește un
; arbore de sufixe și un șablon nevid și realizează un singur pas 
; din procesul prezentat mai sus - identifică ramura arborelui a
; cărei etichetă începe cu prima literă din șablon, apoi
; determină cât de bine se potrivește șablonul cu eticheta,
; întorcând ca rezultat:
; - true, dacă șablonul este conținut integral în etichetă
; - lista (etichetă, nou pattern, subarbore), dacă șablonul se
;   potrivește cu eticheta dar nu este conținut în ea
;   (ex: ("na", "na$", subarborele de sub eticheta "na")
;   pentru șablonul inițial "nana$" și eticheta "na")
; - lista (false, cel mai lung prefix comun între etichetă și
;   șablon), dacă șablonul nu s-a potrivit cu eticheta sau nu
;   s-a găsit din start o etichetă care începe cu litera dorită
;   (ex1: (false, "n") pentru șablonul "numai" și eticheta "na")
;   (ex2: (false, "") pentru etichetă negăsită)
; Obs: deși exemplele folosesc stringuri pentru claritate, vă
; reamintim că în realitate lucrăm cu liste de caractere.

(define (match-aux branch pattern)
  (if (false? branch)
      '(() '() '())
      (longest-common-prefix (get-branch-label branch) pattern)))
(define (get-label branch)
  (if (false? branch)
      '()
      (get-branch-label branch)))

(define (false-no-common) '(#f ()))

(define (match-pattern-with-label st pattern)
  (let* ([branch (get-ch-branch st (car pattern))]
         [label (get-label branch)]
         [common-prefix (car (match-aux branch pattern))]
         [rem-label (cadr (match-aux branch pattern))]
         [rem-pattern (car (cddr (match-aux branch pattern)))]
         )
    (cond ((and (null? rem-pattern) (null? rem-label) (null? common-prefix)) (list #f '()))
          ((null? rem-pattern) #t)
          ((equal? rem-label (string->list "$")) (list label rem-pattern (get-branch-subtree branch)))
          ((null? rem-label) (list label rem-pattern (get-branch-subtree branch)))
          (else (list #f common-prefix)))))


; TODO 5
; Implementați funcția st-has-pattern? care primește un
; arbore de sufixe și un șablon și întoarce true dacă șablonul
; apare în arbore, respectiv false în caz contrar.



(define (shp-aux st pattern)
  (let* ([ret (match-pattern-with-label st pattern)]
         [new-pattern (cadr ret)]
         [new-st (cddr ret)])
    (if (null? (car new-st)) #f (st-has-pattern? (car new-st) new-pattern))))

(define (st-has-pattern? st pattern)
  (if (equal? #t (match-pattern-with-label st pattern))
      #t
      (if (equal? #f (car (match-pattern-with-label st pattern)))
          #f
          (shp-aux st pattern))))