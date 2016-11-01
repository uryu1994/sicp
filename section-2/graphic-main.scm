(use gl)
(use gl.glut)

(load "./graphic-helper")
(load "./2_44")
(load "./2_46")
(load "./2_47")
(load "./2_48")
(load "./2_49")
(load "./2_50")

(define frame (make-frame (make-vect -1.0 -1.0) (make-vect 2.0 0.0) (make-vect 0.0 2.0)))

(define (init)
  (gl-clear-color 1.0 1.0 1.0 1.0))

(define (disp)
  (gl-clear GL_COLOR_BUFFER_BIT)
  (gl-color 1.0 0.0 0.0)
  (gl-begin GL_LINES)
  ((flip-vert wave) frame)
  (gl-end)
  (gl-flush)
  )

(define (main args)
  (glut-init-window-position 100 100)
  (glut-init-window-size 500 500)
  (glut-init args)
  (glut-init-display-mode GLUT_RGBA)
  (glut-create-window "Painter Line Test")
  (glut-display-func disp)
  (init)
  (glut-main-loop)
  0)

(define (draw-line v1 v2)
  (gl-vertex (xcor-vect v1) (ycor-vect v1))
  (gl-vertex (xcor-vect v2) (ycor-vect v2)))
