# extract-debug-infos

This repository contains some little shell scripts allowing to process some _ELF_ containing debug infos in order to extract these infos and save them in some dedicated files. These files are then linked to the original _ELF_ object allowing **gdb** to find debug infos. This link is stored in _ELF_ as a _BuildId_ (**NT_GNU_BUILD_ID** entry in notes from section _.note.gnu.build-id_), through the *--add-gnu-debuglink* option of **objcopy** command. The _buildId_ is computed thanks to a **sha256** sum of the _ELF_ file.

## Commands

Three commands are availables:
* **_extract-debug-infos.sh_**: the actual real command doing the job
* **_extract-debug-infos-from-dir.sh_**: a wrapper over extract-debug-infos.sh allowing to process all files in a specific dir
* **_extract-debug-infos-from-tree.sh_**: a wrapper over extract-debug-infos-from-dir.sh allowing to process recursivelly all files under a specific directory.

When a file <an_elf> is processed, debug infos are extracted from it (the file is stripped from them) and they are dumped in a file named .debug/<an_elf>.debug.
The readelf allows to see the build id. Next listing shows a readelf for clang-change-namespace command and clang-change-namespace.debug:

```shellsession
cohen@mobdevrcs:/usr/local/src/data2/misc/LLVM/llvm-7/build-Debug/_CPack_Packages/Linux/TXZ/LLVM-7.0.0svn-Linux/bin$ LANG=C readelf -a ./clang-change-namespace
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Shared object file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0xdf90
  Start of program headers:          64 (bytes into file)
  Start of section headers:          438648 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         9
  Size of section headers:           64 (bytes)
  Number of section headers:         30
  Section header string table index: 29

Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  [ 1] .interp           PROGBITS         0000000000000238  00000238
       000000000000001c  0000000000000000   A       0     0     1
  [ 2] .note.ABI-tag     NOTE             0000000000000254  00000254
       0000000000000020  0000000000000000   A       0     0     4
  [ 3] .note.gnu.build-i NOTE             0000000000000274  00000274
       0000000000000024  0000000000000000   A       0     0     4
  [ 4] .gnu.hash         GNU_HASH         0000000000000298  00000298
       0000000000000520  0000000000000000   A       5     0     8
  [ 5] .dynsym           DYNSYM           00000000000007b8  000007b8
       00000000000020a0  0000000000000018   A       6     1     8
  [ 6] .dynstr           STRTAB           0000000000002858  00002858
       0000000000004eee  0000000000000000   A       0     0     1
  [ 7] .gnu.version      VERSYM           0000000000007746  00007746
       00000000000002b8  0000000000000002   A       5     0     2
  [ 8] .gnu.version_r    VERNEED          0000000000007a00  00007a00
       0000000000000070  0000000000000000   A       6     2     8
  [ 9] .rela.dyn         RELA             0000000000007a70  00007a70
       0000000000004c80  0000000000000018   A       5     0     8
  [10] .rela.plt         RELA             000000000000c6f0  0000c6f0
       0000000000000ea0  0000000000000018  AI       5    24     8
  [11] .init             PROGBITS         000000000000d590  0000d590
       0000000000000017  0000000000000000  AX       0     0     4
  [12] .plt              PROGBITS         000000000000d5b0  0000d5b0
       00000000000009d0  0000000000000010  AX       0     0     16
  [13] .plt.got          PROGBITS         000000000000df80  0000df80
       0000000000000008  0000000000000008  AX       0     0     8
  [14] .text             PROGBITS         000000000000df90  0000df90
       000000000002aba2  0000000000000000  AX       0     0     16
  [15] .fini             PROGBITS         0000000000038b34  00038b34
       0000000000000009  0000000000000000  AX       0     0     4
  [16] .rodata           PROGBITS         0000000000038b40  00038b40
       000000000000da20  0000000000000000   A       0     0     32
  [17] .eh_frame_hdr     PROGBITS         0000000000046560  00046560
       0000000000006914  0000000000000000   A       0     0     4
  [18] .eh_frame         PROGBITS         000000000004ce78  0004ce78
       000000000001a7c8  0000000000000000   A       0     0     8
  [19] .init_array       INIT_ARRAY       0000000000267d70  00067d70
       0000000000000010  0000000000000008  WA       0     0     8
  [20] .fini_array       FINI_ARRAY       0000000000267d80  00067d80
       0000000000000008  0000000000000008  WA       0     0     8
  [21] .jcr              PROGBITS         0000000000267d88  00067d88
       0000000000000008  0000000000000000  WA       0     0     8
  [22] .data.rel.ro      PROGBITS         0000000000267d90  00067d90
       0000000000002a28  0000000000000000  WA       0     0     8
  [23] .dynamic          DYNAMIC          000000000026a7b8  0006a7b8
       0000000000000290  0000000000000010  WA       6     0     8
  [24] .got              PROGBITS         000000000026aa48  0006aa48
       00000000000005b8  0000000000000008  WA       0     0     8
  [25] .data             PROGBITS         000000000026b000  0006b000
       0000000000000018  0000000000000000  WA       0     0     8
  [26] .bss              NOBITS           000000000026b020  0006b018
       00000000000006d8  0000000000000000  WA       0     0     32
  [27] .comment          PROGBITS         0000000000000000  0006b018
       000000000000002c  0000000000000001  MS       0     0     1
  [28] .gnu_debuglink    PROGBITS         0000000000000000  0006b044
       0000000000000024  0000000000000000           0     0     4
  [29] .shstrtab         STRTAB           0000000000000000  0006b068
       000000000000010f  0000000000000000           0     0     1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  l (large), p (processor specific)

There are no section groups in this file.
...

Displaying notes found in: .note.gnu.build-id
  Owner                 Data size	Description
  GNU                  0x00000014	NT_GNU_BUILD_ID (unique build ID bitstring)
    Build ID: 81c3eaf7aae62ce40e3dd7e1ae298a20d45ce8f7

...
cohen@mobdevrcs:/usr/local/src/data2/misc/LLVM/llvm-7/build-Debug/_CPack_Packages/Linux/TXZ/LLVM-7.0.0svn-Linux/bin$ 
```

```shellsession
cohen@mobdevrcs:/usr/local/src/data2/misc/LLVM/llvm-7/build-Debug/_CPack_Packages/Linux/TXZ/LLVM-7.0.0svn-Linux-Debug/LLVM-7.0.0svn-Linux/bin/.debug$ LANG=C readelf -a ./clang-change-namespace.debug 
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Shared object file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0xdf90
  Start of program headers:          64 (bytes into file)
  Start of section headers:          1665336 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         9
  Size of section headers:           64 (bytes)
  Number of section headers:         36
  Section header string table index: 35

Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  [ 1] .interp           NOBITS           0000000000000238  00000238
       000000000000001c  0000000000000000   A       0     0     1
  [ 2] .note.ABI-tag     NOTE             0000000000000254  00000254
       0000000000000020  0000000000000000   A       0     0     4
  [ 3] .note.gnu.build-i NOTE             0000000000000274  00000274
       0000000000000024  0000000000000000   A       0     0     4
  [ 4] .gnu.hash         NOBITS           0000000000000298  00000298
       0000000000000520  0000000000000000   A       5     0     8
  [ 5] .dynsym           NOBITS           00000000000007b8  00000298
       00000000000020a0  0000000000000018   A       6     1     8
  [ 6] .dynstr           NOBITS           0000000000002858  00000298
       0000000000004eee  0000000000000000   A       0     0     1
  [ 7] .gnu.version      NOBITS           0000000000007746  00000298
       00000000000002b8  0000000000000002   A       5     0     2
  [ 8] .gnu.version_r    NOBITS           0000000000007a00  00000298
       0000000000000070  0000000000000000   A       6     2     8
  [ 9] .rela.dyn         NOBITS           0000000000007a70  00000298
       0000000000004c80  0000000000000018   A       5     0     8
  [10] .rela.plt         NOBITS           000000000000c6f0  00000298
       0000000000000ea0  0000000000000018   A       5    24     8
  [11] .init             NOBITS           000000000000d590  00000298
       0000000000000017  0000000000000000  AX       0     0     4
  [12] .plt              NOBITS           000000000000d5b0  00000298
       00000000000009d0  0000000000000010  AX       0     0     16
  [13] .plt.got          NOBITS           000000000000df80  00000298
       0000000000000008  0000000000000008  AX       0     0     8
  [14] .text             NOBITS           000000000000df90  00000298
       000000000002aba2  0000000000000000  AX       0     0     16
  [15] .fini             NOBITS           0000000000038b34  00000298
       0000000000000009  0000000000000000  AX       0     0     4
  [16] .rodata           NOBITS           0000000000038b40  00000298
       000000000000da20  0000000000000000   A       0     0     32
  [17] .eh_frame_hdr     NOBITS           0000000000046560  00000298
       0000000000006914  0000000000000000   A       0     0     4
  [18] .eh_frame         NOBITS           000000000004ce78  00000298
       000000000001a7c8  0000000000000000   A       0     0     8
  [19] .init_array       NOBITS           0000000000267d70  00067d70
       0000000000000010  0000000000000008  WA       0     0     8
  [20] .fini_array       NOBITS           0000000000267d80  00067d70
       0000000000000008  0000000000000008  WA       0     0     8
  [21] .jcr              NOBITS           0000000000267d88  00067d70
       0000000000000008  0000000000000000  WA       0     0     8
  [22] .data.rel.ro      NOBITS           0000000000267d90  00067d70
       0000000000002a28  0000000000000000  WA       0     0     8
  [23] .dynamic          NOBITS           000000000026a7b8  00067d70
       0000000000000290  0000000000000010  WA       6     0     8
  [24] .got              NOBITS           000000000026aa48  00067d70
       00000000000005b8  0000000000000008  WA       0     0     8
  [25] .data             NOBITS           000000000026b000  00067d70
       0000000000000018  0000000000000000  WA       0     0     8
  [26] .bss              NOBITS           000000000026b020  00067d70
       00000000000006d8  0000000000000000  WA       0     0     32
  [27] .comment          PROGBITS         0000000000000000  00000298
       000000000000002c  0000000000000001  MS       0     0     1
  [28] .debug_aranges    PROGBITS         0000000000000000  000002c4
       0000000000000510  0000000000000000           0     0     1
  [29] .debug_info       PROGBITS         0000000000000000  000007d4
       00000000000a1020  0000000000000000           0     0     1
  [30] .debug_abbrev     PROGBITS         0000000000000000  000a17f4
       000000000000a7cb  0000000000000000           0     0     1
  [31] .debug_line       PROGBITS         0000000000000000  000abfbf
       000000000000ec37  0000000000000000           0     0     1
  [32] .debug_str        PROGBITS         0000000000000000  000babf6
       0000000000055497  0000000000000001  MS       0     0     1
  [33] .symtab           SYMTAB           0000000000000000  00110090
       000000000001bcd8  0000000000000018          34   993     8
  [34] .strtab           STRTAB           0000000000000000  0012bd68
       000000000006aa7b  0000000000000000           0     0     1
  [35] .shstrtab         STRTAB           0000000000000000  001967e3
       0000000000000150  0000000000000000           0     0     1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  l (large), p (processor specific)

There are no section groups in this file.

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  PHDR           0x0000000000000040 0x0000000000000040 0x0000000000000040
...

Displaying notes found in: .note.gnu.build-id
  Owner                 Data size	Description
  GNU                  0x00000014	NT_GNU_BUILD_ID (unique build ID bitstring)
    Build ID: 81c3eaf7aae62ce40e3dd7e1ae298a20d45ce8f7

...
cohen@mobdevrcs:/usr/local/src/data2/misc/LLVM/llvm-7/build-Debug/_CPack_Packages/Linux/TXZ/LLVM-7.0.0svn-Linux-Debug/LLVM-7.0.0svn-Linux/bin/.debug$     
```

 -- Rémi Cohen-Scali <cohen@mobdevrcs.jayacode.fr>, Mon, 25 Jun 2018 17:44:15 +0200
