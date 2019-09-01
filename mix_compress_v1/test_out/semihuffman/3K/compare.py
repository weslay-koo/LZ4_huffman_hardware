# /usr/bin/python
import filecmp
import os,os.path
import sys

#file_list = [	'bib','book1','book2','geo','news','obj1','obj2',
				# 'paper1','paper2','paper3','paper4','paper5','paper6',
				# 'pic','progc','progl','progp','trans']

def IsSubString(SubStrList,Str):
	flag=True
	for substr in SubStrList: 
		if not(substr in Str): 
			flag=False
	return flag
				
def GetFileList(FindPath,FlagStr=[]):			
	FileList  = []
	FileNames = os.listdir(FindPath) 
	if (len(FileNames)>0):
		for fn in FileNames: 
			if (len(FlagStr)>0): 
				if (IsSubString(FlagStr,fn)): 
					fullfilename = fn.split('_')	## os.path.join(FindPath,fn) 
					FileList.append(fullfilename[0]) 
	else: 
		fullfilename = fn.split('_')	## os.path.join(FindPath,fn) 
		FileList.append(fullfilename[0]) 
	if (len(FileList)>0): 
		FileList.sort() 
	return FileList				

print (sys.argv)
file_list = GetFileList(sys.argv[2],'.pattern')
print (file_list)
flog = open('compared.log','w')
#stat = open('compress.stat','w')	
dir_path 		= 	sys.argv[1] + '/'	
pattern_path 	= 	sys.argv[2] + '/'	
for file_name in file_list:
	pattern_name= pattern_path + file_name + '_mhw.pattern'
	decomp_name = dir_path + file_name + '_mhw.decomp'
	# python3.x # src_size	= os.path.getsize(lz4_name)
	# python3.x # dest_size	= os.path.getsize(shuff_name)
	if filecmp.cmp(decomp_name,decomp_name) :
		flog.write("File %s\t and %s\t is the same\n" % (pattern_name,decomp_name)) 	# python3.x # 
		# python3.x # stat.write("%s\t=\t%d\t%s\t=\t%d\tRC=%0.4f\n" % (lz4_name,src_size,shuff_name,dest_size,float(dest_size)/float(src_size)))  
		# python2.x # print >> flog, "File %s\t and %s\t is the same" % (lz4_name,decomp_name)
		# python2.x # print >> stat, "%s\t=\t%d\t%s\t=\t%d\tRC=%0.4f" % (lz4_name,src_size,shuff_name,dest_size,float(dest_size)/float(src_size))
	else:
		flog.write("File %s and %s is NOT the same\n" % (lz4_name,decomp_name)) 	# python3.x # 
		# python2.x # print >> flog, "File %s and %s is NOT the same" % (lz4_name,decomp_name)
else:
	print ("File compare done")

flog.close()
#stat.close()