#!/bin/sh

astyle \
  --style=attach \
  --indent=spaces=2 \
  --indent-namespaces \
  --indent-switches \
  --add-brackets \
  --pad-first-paren-out \
	src/Konv.vala \
  src/gui/components/*.vala \
  src/gui/windows/*.vala
