#library("shiny");library("devtools");
#install_github("syounkin/ITHIM")
#install_github("syounkin/ITHIM", ref = "devel")
#library("ITHIM")
#runGitHub( "ITHIM-UI", "syounkin")
runGitHub( "ITHIM-UI", "syounkin", ref = "devel")



library("shiny");library("devtools");
install("~/ITHIM/");library("ITHIM");
runApp("~/ITHIM-UI/")
