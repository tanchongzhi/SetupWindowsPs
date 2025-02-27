$ErrorActionPreference = "Stop"

DISM /Online /Enable-Feature /FeatureName:Microsoft-Hyper-V /All /NoRestart
