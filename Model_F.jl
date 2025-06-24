#    ,ggg, ,ggg,_,ggg,                                                ,gggggggggggggg
#   dP""Y8dP""Y88P""Y8b                       8I           ,dPYb,    dP""""""88""""""
#   Yb, `88'  `88'  `88                       8I           IP'`Yb    Yb,_    88      
#    `"  88    88    88                       8I           I8  8I     `""    88      
#        88    88    88                       8I           I8  8'         ggg88gggg  
#        88    88    88    ,ggggg,      ,gggg,8I   ,ggg,   I8 dP             88   8  
#        88    88    88   dP"  "Y8ggg  dP"  "Y8I  i8" "8i  I8dP              88      
#        88    88    88  i8'    ,8I   i8'    ,8I  I8, ,8I  I8P         gg,   88      
#        88    88    Y8,,d8,   ,d8'  ,d8,   ,d8b, `YbadP' ,d8b,_        "Yb,,8P      
#        88    88    `Y8P"Y8888P"    P"Y8888P"`Y8888P"Y8888P'"Y88         "Y8P'                                              


cd(@__DIR__)

using Distributions
using Printf
using Random
using JLD2
using CodecZlib

include("Initialize.jl")
include("simulation.jl")

