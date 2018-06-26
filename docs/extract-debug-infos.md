# extract-debug-infos.sh

This shell script command allows to process an _ELF_ file through:

```shellsession
cohen@mobdevrcs:~/bin$ extract-debug-infos.sh **<an_elf_object_file>** 
stripping llvm-readobj, putting debug info into **<an_elf_object_file>**.debug ... done!
cohen@mobdevrcs:~/bin$ 
```

If no argument is provided, an error is raised and exit code -1 is returned.

The script handles exception conditions as:
* the file is not a supported _ELF_ (exit code -2)
* the file do not contain debug infos (exit code -3)
* the file is already stripped and debug infos file doesn't exists  (exit code -4)
* the file is already stripped and the debug infos file found is not related to the _ELF_ object  (exit code -5)
* the file is already stripped and the debug infos file already exists  (exit code 1)
  ```shellsession
  cohen@mobdevrcs:/usr/local/src/data2/misc/LLVM/llvm-7/build-Debug/bin$ extract-debug-infos.sh tool-template
  WARNING! Skipping tool-template: already processed ...
  cohen@mobdevrcs:/usr/local/src/data2/misc/LLVM/llvm-7/build-Debug/bin$ 
  ```

At now scripts doesn't manage cross compilation. It could be implemented later.
