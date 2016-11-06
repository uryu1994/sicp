(use gl)
(use gl.glut)

(load "./graphic-helper")
(load "./2_44")
(load "./2_46")
(load "./2_47")
(load "./2_48")
(load "./2_49")
(load "./2_50")
(load "./2_51")
(load "./2_52")

(define frame (make-frame (make-vect 0 0) (make-vect 1 0) (make-vect 0 1)))

(define (init)
  (gl-clear-color 1.0 1.0 1.0 1.0))

(define (display)
  (gl-clear GL_COLOR_BUFFER_BIT)
  (gl-color 0.0 0.0 0.0)
  (gl-begin GL_LINES)

  ;;((rotate270 wave) frame)
  ;;  (wave frame)
  ;;  (draw-frame-outline frame)
  ;;  ((below wave wave) frame)
  ;; ((below2 wave wave) frame)
  (wave2 frame)
  (gl-end)
  (gl-flush)
  )

(define (draw-line v1 v2)
  (define (t z)
    (- (* 2 z) 1))
  (gl-vertex (t (xcor-vect v1)) (t (ycor-vect v1)))
  (gl-vertex (t (xcor-vect v2)) (t (ycor-vect v2)))
  )

(define (main args)
  (glut-init args)
  (glut-init-display-mode GLUT_RGBA)
  (glut-create-window "Painter Line Test")
  (glut-display-func display)
  (init)
  (glut-main-loop)
  )
