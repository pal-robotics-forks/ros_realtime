# Sorry, anyone who depends on rosrt gets xenomai flags forced upon them if detected
if (Xenomai_FOUND)
  add_xenomai_flags()
endif()
