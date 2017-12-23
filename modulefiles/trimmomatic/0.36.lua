-- -*- lua -*-
whatis("A flexible read trimming tool for Illumina NGS data")

prepend_path("PATH", "/usr/local/Trimmomatic-0.36/")
prepend_path("CLASSPATH", "/usr/local/Trimmomatic-0.36/trimmomatic-0.36.jar")
prepend_path("ILLUMINACLIP_PATH", "/usr/local/Trimmomatic-0.36/adapters")


--[[
Build:
    # unzip, that's all
--]]

