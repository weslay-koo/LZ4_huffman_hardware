# /usr/bin/python
import filecmp
import os,os.path

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
				
file_list = GetFileList('./','.lz4')
print file_list
flog = open('compared.log','w')
stat = open('compress.stat','w')				
for file_name in file_list:
	decomp_name = file_name + '.decomp'
	lz4_name	= file_name + '_hw.lz4'
	src_size	= os.path.getsize(file_name)
	dest_size	= os.path.getsize(lz4_name)
	if filecmp.cmp(file_name,decomp_name) :
		print >> flog, "File %s\t and %s\t is the same" % (file_name,decomp_name)
		print >> stat, "%s\t=\t%d\t%s\t=\t%d\tRC = %0.4f" % (file_name,src_size,lz4_name,dest_size,float(dest_size)/float(src_size))
	else:
		print >> flog, "File %s and %s is NOT the same" % (file_name,decomp_name)
else:
	print "File compare done"

flog.close()
stat.close()