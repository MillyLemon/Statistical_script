# -*- coding: utf-8 -*-
import sx.pisa3 as pisa
import sys
import getopt
import os

errormessage="\nError:\n\tpython htm2pdf.py -i input.htm -o output.pdf\n"
try:
    #opt,args=getopt.getopt(sys.argv[1:],"hvi:o:",["help","version","in=","out="])
    opt,args=getopt.getopt(sys.argv[1:],"hvi:o:")
except getopt.GetoptError:
    print(errormessage)
    sys.exit()
opts, args = getopt.getopt(sys.argv[1:],"hvi:o:")
inputfile=""
outputfile=""
num=0
for par,val in opts:
    if par == "-h":
        print("DESCRIPTION:  This script.py is used to convert htm format to pdf format")
        print("VERSION:      1.0")
        print("USAGE:        python htm2pdf.py -i input.htm -o output.pdf")
        print("CONTRACT:     xuhanshi@genomics.cn")
        sys.exit()
    elif par == "-v":
        print("VERSION:1.0")
        sys.exit()
    elif par == "-i":
        num=num+1
        inputfile=val
    elif par == "-o":
        num=num+1
        outputfile=val
if num != 2:
    print(errormessage)
    sys.exit()
if not os.path.exists(inputfile):
    print("Error:\tThe %s is not exist" %(inputfile))
    sys.exit()
if os.path.exists(outputfile):
    print("Warning: The %s has been overwritten" %(outputfile))
data= open(inputfile).read()
result = file(outputfile, 'wb')
pdf = pisa.CreatePDF(data, result)
result.close()
#pisa.startViewer('test.pdf') 

