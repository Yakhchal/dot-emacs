;;; maintain-connection.el --- Basic script to continually attempt to keep a shaky wireless internet connection steady on Windows. Made this at the library because my hotspot connection would continually drop, and I have to navigate through Windows's (often slow) wifi menu, and would like an Emacs-based solution, since it's where I do most of my studies.

(defvar maintain-connection--relevant-wifi-name nil
  "Name of the Wi-Fi connection that will be continually connected to.")

(defvar maintain-connection--timer-object nil)

(defun maintain-connection--identify-network-name ()
  "Returns the network name from the SSID field fetched from 'netsh'.
Returns 'nil' if there's no active Wi-Fi connection."
  (let (
	(netsh-output (shell-command-to-string "netsh wlan show interfaces"))
	)
    (with-temp-buffer
      (save-excursion
	(insert netsh-output))
      (when (search-forward "SSID" nil t)
	(search-forward ": ")
	(buffer-substring (point) (prog2
				      (end-of-line)
				    (point))))
      )
    )
  )

(defun maintain-connection--connect ()
  (let (
	(connect-cmd (concat "netsh wlan connect name=\"" maintain-connection--relevant-wifi-name "\""))
	)
    (unless (string-equal (maintain-connection--identify-network-name) maintain-connection--relevant-wifi-name)
    (start-process-shell-command "MAINTAIN-CONNECTION-SH-CMD" nil connect-cmd))))

(defun maintain-connection ()
  (interactive)
  (let (
	(net-name (maintain-connection--identify-network-name))
	)
  (if net-name
      (progn
	(setq maintain-connection--relevant-wifi-name net-name)
	(setq maintain-connection--timer-object (run-with-timer 2 3 #'maintain-connection--connect)))
    (message "You're not connected to a Wi-Fi network!"))))

(defun cancel-connection-maintenance ()
  (interactive)
  (cancel-timer maintain-connection--timer-object)
  (message "Connection is no longer being maintained!"))

(provide 'maintain-connection)
