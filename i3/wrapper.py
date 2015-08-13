import subprocess
 
def get_rhythmbox_status():
  """ Get the current song playing and elapsed time from rhythmbox if it is running. """
  cmd = "rhythmbox-client --no-start --print-playing-format '%aa - %tt (%te)'"
  try:
    rb_output = subprocess.check_output(cmd, shell=True)
    rb_output = rb_output.strip()
  except subprocess.CalledProcessError, cpe:
    rb_output = "Rhythmbox Client: Error"
 
  if "(Unknown)" in rb_output:
    rb_output = "Rhythmbox: Not Playing"
 
  return rb_output
