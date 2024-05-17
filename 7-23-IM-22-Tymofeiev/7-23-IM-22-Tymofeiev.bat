@echo off

ml /c /coff "7-23-IM-22-Tymofeiev.asm"
ml /c /coff "7-23-IM-22-Tymofeiev-PUB-EXTERN.asm"

link32 /subsystem:windows "7-23-IM-22-Tymofeiev.obj" "7-23-IM-22-Tymofeiev-PUB-EXTERN.obj"

7-23-IM-22-Tymofeiev.exe