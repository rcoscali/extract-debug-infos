# extract-debug-infos

This repository contains some little shell scripts allowing to process some ELF containiong debug infos in order to extract these infos and save them in some dedicated files. These files are then linked to the original object allowing gdb to find debug infos. This link is stored in ELF as a BuildId (NT_GNU_BUILD_ID), through the --add-gnu-debuglink option of objcopy command.
