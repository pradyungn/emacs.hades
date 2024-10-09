;;; -- Helper Functions and Macros --
(defun timestamp()
  (interactive)
  (insert (format-time-string "%B %e, %Y -- %H:%M:%S")))

;; stolen from doom emacs (hlissner ily)
(defun athena/window-swap (direction)
  "Move current window to the next window in DIRECTION.
If there are no windows there and there is only one window, split in that
direction and place this window there. If there are no windows and this isn't
the only window, use evil-window-move-* (e.g. `evil-window-move-far-left')."
  (when (window-dedicated-p)
    (user-error "Cannot swap a dedicated window"))
  (let* ((this-window (selected-window))
	       (this-buffer (current-buffer))
	       (that-window (windmove-find-other-window direction nil this-window))
	       (that-buffer (window-buffer that-window)))
    (when (or (minibufferp that-buffer)
	            (window-dedicated-p this-window))
      (setq that-buffer nil that-window nil))
    (if (not (or that-window (one-window-p t)))
	      (funcall (pcase direction
		               ('left  #'evil-window-move-far-left)
		               ('right #'evil-window-move-far-right)
		               ('up    #'evil-window-move-very-top)
		               ('down  #'evil-window-move-very-bottom)))
      (unless that-window
	      (setq that-window
	            (split-window this-window nil
			                      (pcase direction
			                        ('up 'above)
			                        ('down 'below)
			                        (_ direction))))
	      (with-selected-window that-window
	        (switch-to-buffer (doom-fallback-buffer)))
	      (setq that-buffer (window-buffer that-window)))
      (window-swap-states this-window that-window)
      (select-window that-window))))

(defun athena/window-move-left ()
  "Swap windows to the left."
  (interactive) (athena/window-swap 'left))
(defun athena/window-move-right ()
  "Swap windows to the right"
  (interactive) (athena/window-swap 'right))
(defun athena/window-move-up ()
  "Swap windows upward."
  (interactive) (athena/window-swap 'up))
(defun athena/window-move-down ()
  "Swap windows downward."
  (interactive) (athena/window-swap 'down))