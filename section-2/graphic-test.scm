(use gl)
(use gl.glut)


(define (main args)
  (glut-init args)
  (glut-init-display-mode GLUT_RGBA)
  (glut-create-window "fill window sample")
  (glut-display-func display)
  (init)
  (glut-main-loop)
  )

(define (display)
  (gl-clear GL_COLOR_BUFFER_BIT)
  (gl-flush)
  )

(define (init)
  (gl-clear-color 0.0 0.0 1.0 1.0)
  )

 
