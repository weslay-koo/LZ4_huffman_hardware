/*****************************************************************/
/*****************************************************************/
/**程序:  compress.c                                            **/
/**功能:  压缩与解压缩单个文件                                  **/
/**详情:  利用霍夫曼算法生成输入文件的霍夫曼编码，并转换成二进制**/
/**       字节流输出从而达到压缩的效果；解压缩则是从压缩文件中读**/
/**       入霍夫曼树信息，从而还原为原编码，达到解压缩的目的。  **/
/**                     压缩文件结构                            **/
/**         偏移量             存储信息类型                     **/
/**         0~3                 文件头标志                      **/
/**         4                   源文件名长度:n_s                **/
/**         5~4+n_s             文件名                          **/
/**         5+n_s~8+n_s         源文件长度                      **/
/**         9+n_s~1028+n_s      huffman树非叶子节点孩子信息     **/
/**         1029+n_s~FILE_END   源文件的huffman二级制编码信息   **/
/**环境:  AM2_4000+ & Windows_Server_2008 & VC++_2008           **/
/**其他:  davelv @ 2008-12-18                                   **/
/*****************************************************************/
/*****************************************************************/
////////////////////////////////////////////////////////////////////
////                头文件、自定义类型、预定义宏常量            ////
////////////////////////////////////////////////////////////////////
#define _CRT_SECURE_NO_DEPRECATE//VC2005或更新的编译器不显示I/O安全警告
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
typedef unsigned int UINT;
typedef unsigned char UCHAR;
typedef unsigned short USHORT;
typedef struct node
{
	long    w;//权
	short   p, l, r;//父亲，左孩子，右孩子
}htnode, *htnp;//霍夫曼树的结点
typedef struct huffman_code
{
	UCHAR len;//长度
	UCHAR  *codestr;//字符串
}hufcode;//字符版本的霍夫曼编码
#define OK       1
#define ERROR   -1
#define UNUSE   -1
#define ARGS_ERR    -2//参数错误
#define FILE_ERR    -3//文件错误
#define HEAD_ERR    -4//头标错误
#define MALLOC_ERR  -5//内存分配错误
#define HUFTREE_ERR -6//霍夫曼树错误
#define HUFCODE_ERR -7//霍夫曼编码错误
#define CHAR_BITS   8//一个字符中的位数
#define INT_BITS    32//一个整型中的位数
#define CODE_SIZE   256//霍夫曼编码个数
#define CACHE_SIZE  256//I/O缓存大小
#define UINT_SIZE   sizeof(UINT)
#define UCHAR_SIZE  sizeof(UCHAR)
#define USHORT_SIZE sizeof(USHORT)
#define ZIP_HEAD    0xFFFFFFFF//压缩文件头标
#define MAX_NAME_LEN	512 

// semi-static huffman parameters
#define INIT_HEAD_SIZE	8192

////////////////////////////////////////////////////////////////////
////                        函数声明                            ////
////////////////////////////////////////////////////////////////////
//压缩相关函数
UCHAR   chars_to_bits(const UCHAR chars[CHAR_BITS]);//将一个字符数组转换成二进制数字@ write_compress_file()
int     search_set(htnp ht, int n);//查找当前最小权值的霍夫曼树节点并置为占用@create_huffmantree()
int     create_huffmantree(long w[], int n, htnode ht[]);//生成霍夫曼树@compress()
int     encode_huffmantree(htnp htp, int n, hufcode hc[]);//生成霍夫曼编码@compress()
long    calc_data_frequency(FILE *in, long frequency[], long semi_head_len);//计算每个不同字节的频率以及所有的字节数@compress()
int     compress(char *source_filename, char *obj_filename, long semi_head_len);//处理压缩文件的流程@process_args()
int     c_initial_files(char *source_filename, FILE **inp, char *obj_filename, FILE **outp);//为处理压缩流程初始化文件@compress()
int     write_compress_file(FILE *in, FILE *out, htnp ht, hufcode hc[], char* source_filename, long source_filesize);//写压缩文件@compress()
//解压缩相关函数
void    get_mini_huffmantree(FILE* in, short mini_ht[][2]);//从待解压缩文件中得到一个小型的huffman树@decompress()
int     decompress(char *source_filename, char *obj_filename);//处理解压缩文件的流程@process_args()
int     d_initial_files(char *source_filename, FILE **inp, char *obj_filename, FILE **outp);//为处理解压缩流程初始化文件@decompress()
int     write_decompress_file(FILE *in, FILE* out, short mini_ht[][2], long bits_pos, long obj_filesize);//写解压缩文件@decompress()
//辅助函数
void    print_help();//在屏幕上显示帮助@process_args(),main()
void    process_error(int error_code);//处理函数中返回的错误代码@process_args(),main()
void    process_args(char *first, char*second, char*third);//处理命令行参数@main()
char    *create_default_obj_filename(char *source_filename, char* obj_filename);//生成一个默认的文件名@c_initial_files()
////////////////////////////////////////////////////////////////////
////                    压缩相关函数                            ////
////////////////////////////////////////////////////////////////////
/****************************************************************/
/*函数:   c_initial_files()                                     */
/*功能:   初始化并打开压缩功能所需所有文件                      */
/*参数:   char    *source_filename    源文件名字符串            */
/*        FILE    **inp               指向输入文件指针的指针    */
/*        char    *obj_filename       目标文件名字字符串        */
/*        FILE    **outp              指向输出文件指针的指针    */
/*返回:   int     OK                  函数成功运行              */
/*                其他                出错                      */
/****************************************************************/
int c_initial_files(char *source_filename, FILE **inp, char *obj_filename, FILE **outp)
{
	char  temp_filename[MAX_NAME_LEN];
	if (source_filename == NULL)
	{
		return FILE_ERR;//空名字返回错误
	}
	//当目标文件名没分配时
	if (obj_filename == NULL)
	{
		obj_filename = temp_filename;
		create_default_obj_filename(source_filename, obj_filename);//生成默认名字
	}
	if (strcmp(source_filename, obj_filename) == 0)
	{
		return FILE_ERR;//重名返回错误
	}
	printf("待压缩文件:%s,压缩文件:%s\n", source_filename, obj_filename);

	if ((*outp = fopen(obj_filename, "wb")) == NULL)
	{
		return FILE_ERR;//不能读，返回错误
	}
	if ((*inp = fopen(source_filename, "rb")) == NULL)
	{
		return FILE_ERR;//不能写，返回错误
	}

	return OK;
}
/****************************************************************/
/*函数:   calc_data_frequency()                                 */
/*功能:   计算输入文件中不同字节的出现的次数以及所有的字节数    */
/*参数:   FILE    *in         输入文件指针                      */
/*        long    frequency[] 保存不同字节出现次数的数组        */
/*返回:   long    filesize    输入文件总长度                     */
/****************************************************************/
long calc_data_frequency(FILE *in, long frequency[], long semi_head_len)
{
	int     i, read_len;
	int		init_cnt=0;// semi-static huffman initial head length counter
	UCHAR   buf[CACHE_SIZE];//I/O缓存数组
	long    filesize;//总长
	// initial Freq Counter
	for (i = 0; i<CODE_SIZE; i++)
	{
		frequency[i] = 0;//初始化频率为0
	}
	// move to file head
	fseek(in, 0L, SEEK_SET);
	// Dynamic Huffman or Semi-static Huffman 
	if (semi_head_len == 0)
	{
		read_len = CACHE_SIZE;    //设置读入长度
		while (read_len == CACHE_SIZE)
		{
			read_len = fread(buf, 1, CACHE_SIZE, in);
			for (i = 0; i<read_len; i++)
			{
				frequency[*(buf + i)]++;//计算每个字符出现次数
			}
		}
		for (i = 0, filesize = 0; i<CODE_SIZE; i++)
		{
			filesize += frequency[i];//计算全部字节数
		}
		return filesize;
	}
	else
	{
		read_len = CACHE_SIZE;    //设置读入长度
		while (read_len == CACHE_SIZE)
		{
			if (init_cnt < semi_head_len)  // (init_cnt < INIT_HEAD_SIZE)
			{
				read_len = fread(buf, 1, CACHE_SIZE, in);
				for (i = 0; i < read_len; i++)
				{
					frequency[*(buf + i)]++;//计算前semi_head_len个字符出现次数
					++init_cnt;
				}
			}
			else
			{
				//printf("Over 8K\n");
				break;
			}
				
		}
		return semi_head_len; // INIT_HEAD_SIZE;
	}
}
/****************************************************************/
/*函数:   search_set()                                          */
/*功能:   查找当前最小权值的霍夫曼树节点并置为占用              */
/*参数:   htnp    ht          huffman树的指针                   */
/*        int     n           查找范围                          */
/*返回:   int     x           最小权值节点的下标                */
/****************************************************************/
int search_set(htnp ht, int n)
{
	int i, x;
	for (x = 0; x<n; x++)
	{
		if (ht[x].p == UNUSE)  break;//找到第一个叶子节点，跳出
	}
	for (i = x; i<n; i++)
	{
		if (ht[i].p == UNUSE&&ht[i].w<ht[x].w)
		{
			x = i;//找权值最小的叶子节点
		}
	}
	ht[x].p = -2;//将叶子节点占用
	return x;
}
/****************************************************************/
/*函数:   create_huffmantree()                                  */
/*功能:   通过给定的数据权值生成霍夫曼树                        */
/*参数:   long    w[]             数据的权值                    */
/*        int     n               数据的个数                    */
/*        htnp    ht              huffman树的指针               */
/*返回:   int     OK              函数成功运行                  */
/*                其他            出错                          */
/****************************************************************/
int create_huffmantree(long w[], int n, htnode ht[])
{
	int m, i, s1, s2;
	if (n<1)    return HUFTREE_ERR;
	m = 2 * n - 1;//霍夫曼树节点总数=叶子数*2-1
	if (ht == NULL)   return HUFTREE_ERR;
	for (i = 0; i<n; i++)
	{
		ht[i].w = w[i], ht[i].p = ht[i].l = ht[i].r = UNUSE;//初始化叶子节点
	}
	for (; i<m; i++)
	{
		ht[i].w = ht[i].p = ht[i].l = ht[i].r = UNUSE;//初始化非叶子节点
	}
	for (i = n; i<m; i++)//建立huffman树
	{
		s1 = search_set(ht, i);
		s2 = search_set(ht, i);//找到权值最小的两个节点
		ht[s1].p = ht[s2].p = i;//设置父节点
		ht[i].l = s1, ht[i].r = s2;//设置孩子
		ht[i].w = ht[s1].w + ht[s2].w;//设置权
	}
	return OK;
}
/****************************************************************/
/*函数:   encode_huffmantree()                                  */
/*功能:   通过给定的霍夫曼树生成霍夫曼编码                      */
/*参数:   htnp        htp             huffman树的指针           */
/*        int         n               数据的个数                */
/*        huffcode    hc[]            霍夫曼编码存储数组        */
/*返回:   int         OK              函数成功运行              */
/*                    其他            出错                      */
/****************************************************************/
int encode_huffmantree(htnp htp, int n, hufcode hc[])
{
	int i, j, p, codelen;//codelen:临时字符数组长度
	UCHAR *code = (UCHAR*)malloc(n*UCHAR_SIZE);//临时字符数组

	if (code == NULL) return MALLOC_ERR;
	for (i = 0; i<n; i++)//遍历所有叶子节点
	{
		//从当前节点到根节点逆向求huffman编码
		for (p = i, codelen = 0; p != 2 * n - 2; p = htp[p].p, codelen++)
		{
			code[codelen] = (htp[htp[p].p].l == p ? 0 : 1);//左孩子:0;右孩子:1
		}
		if ((hc[i].codestr = (UCHAR *)malloc((codelen)*UCHAR_SIZE)) == NULL)
		{
			return MALLOC_ERR;//分配叶子节点huffman编码的空间
		}
		hc[i].len = codelen;//码长
		for (j = 0; j<codelen; j++)
		{
			hc[i].codestr[j] = code[codelen - j - 1];//转换为正向huffman编码
		}
	}
	free(code);//清理临时字符数组
	return OK;
}
/****************************************************************/
/*函数:   chars_to_bits()                                       */
/*功能:   将一组(8)个字符转换为二进制数                         */
/*参数:   const UCHAR chars[]     待转换的字符数组              */
/*返回:   UCHAR       bits        转换后的二进制数              */
/****************************************************************/
UCHAR chars_to_bits(const UCHAR chars[CHAR_BITS])
{
	int i;
	UCHAR bits = 0;

	bits |= chars[0];
	for (i = 1; i<CHAR_BITS; ++i)//将8个字符转换成8个二进制位
	{
		bits <<= 1;
		bits |= chars[i];
	}
	return bits;
}
/****************************************************************/
/*函数:   write_compress_file()                                 */
/*功能:   转换源文件为二进制huffman编码并其他信息输出到目标文件 */
/*参数:   FILE    *in                 输入文件的指针            */
/*        FILE    *out                输出文件的指针            */
/*        htnp    ht                  霍夫曼树的指针            */
/*        hufcode hc[]                霍夫曼编码数组            */
/*        char    *source_filename    源文件名字符串            */
/*        long    source_filesize     源文件长度                */
/*返回:   int     OK                  函数成功运行              */
/*                其他                出错                      */
/****************************************************************/
int write_compress_file(FILE *in, FILE *out, htnp ht, hufcode hc[], char* source_filename, long source_filesize)
{
	UINT    i, read_counter, write_counter, zip_head = ZIP_HEAD;//读缓存计数器,写缓存计数器,压缩文件头标
	UCHAR   write_char_counter, code_char_counter, copy_char_counter,//写字符计数器,huffman码字符计数器,复制字符计数器
		read_buf[CACHE_SIZE], write_buf[CACHE_SIZE], write_chars[CHAR_BITS], filename_size = strlen(source_filename);//读缓存,写缓存,转换字符数组,文件名长度
	hufcode *cur_hufcode;//当前数据的huffman编码指针
	//定位读写文件到文件开始处
	fseek(in, 0L, SEEK_SET);
	fseek(out, 0L, SEEK_SET);
	//写文件头
	fwrite(&zip_head, UINT_SIZE, 1, out);//写入文件头标志
	//写源文件名
	fwrite(&filename_size, UCHAR_SIZE, 1, out);//写入源文件名长度
	fwrite(source_filename, sizeof(char), filename_size, out);//写入源文件名
	//写入源文件长度
	fwrite(&source_filesize, sizeof(long), 1, out);
	//写huffman树的左右孩子(前CODE_SIZE个节点无孩子，不写)
	for (i = CODE_SIZE; i<CODE_SIZE * 2 - 1; i++)
	{
		fwrite(&(ht[i].l), sizeof(ht[i].l), 1, out);//写入左孩子
		fwrite(&(ht[i].r), sizeof(ht[i].r), 1, out);//写入右孩子
	}
	//写编码后信息
	write_counter = write_char_counter = 0;//写缓冲计数器以及写字符计数器清0
	read_counter = CACHE_SIZE;//置读缓存字符数
	//当读入的缓存字符数不等于缓存时，文件读完，退出循环
	while (read_counter == CACHE_SIZE)
	{
		read_counter = fread(read_buf, 1, CACHE_SIZE, in);//读入数据到读缓存
		//为每个缓存的数据找huffman编码
		for (i = 0; i<read_counter; i++)
		{
			cur_hufcode = &hc[read_buf[i]];//当前数据的huffman编码位置
			code_char_counter = 0;//当前数据huffman编码字符的计数器清0
			//当huffman编码字符的计数器等于码长时，转换完毕退出
			while (code_char_counter != cur_hufcode->len)
			{   //获取本次复制字符的长度为 可用写字符长度与可用huffman编码长度中的较小者
				copy_char_counter = (CHAR_BITS - write_char_counter > cur_hufcode->len - code_char_counter ?
					cur_hufcode->len - code_char_counter : CHAR_BITS - write_char_counter);
				//复制一段字符
				memcpy(write_chars + write_char_counter, cur_hufcode->codestr + code_char_counter, copy_char_counter);
				write_char_counter += copy_char_counter;//写字符计数器增加
				code_char_counter += copy_char_counter;//编码字符计数器增加
				//当写字符计算器满=8时
				if (write_char_counter == CHAR_BITS)
				{
					write_char_counter = 0;//写字符计数器清0
					//当写缓存满时
					write_buf[write_counter++] = chars_to_bits(write_chars);//转化写字符为二进制数并存入写缓存
					if (write_counter == CACHE_SIZE)
					{
						fwrite(write_buf, 1, CACHE_SIZE, out);//输出到文件
						write_counter = 0;//写缓存清0
					}
				}
			}
		}

	}
	fwrite(write_buf, 1, write_counter, out);//写缓存中剩余数据输出到文件
	//当写字符数组中还有字符未转换
	if (write_char_counter != 0)
	{
		write_char_counter = chars_to_bits(write_chars);//转化为二级制数据
		fwrite(&write_char_counter, 1, 1, out);//输出到文件
	}
	return OK;
}
/****************************************************************/
/*函数:   compress()                                            */
/*功能:   处理压缩文件的流程                                    */
/*参数:   char    *source_filename    源文件名字符串            */
/*        char    *obj_filename       目标文件名字字符串        */
/*返回:   int     OK                  函数成功运行              */
/*                其他                出错                      */
/****************************************************************/
int compress(char *source_filename, char *obj_filename, long semi_head_len)
{
	FILE *in, *out;
	int error_code, i;
	float compress_rate;
	hufcode hc[CODE_SIZE];
	htnode  ht[CODE_SIZE * 2 - 1];
	long frequency[CODE_SIZE], source_filesize, obj_filesize = 0;
	long semi_head_size;
	//处理待压缩与压缩文件文件
	error_code = c_initial_files(source_filename, &in, obj_filename, &out);
	if (error_code != OK)
	{
		return error_code;
	}
	puts("文件打开成功,开始读取文件信息...");
	//处理各个字符的频率
	if (semi_head_len == 0)
	{
		source_filesize = calc_data_frequency(in, frequency,0);
		puts("文件读入完成，开始分析文件信息...");
		printf("文件大小 %ld 字节\n", source_filesize);
	}
	else
	{
		puts("文件读入完成，初始化半静态头...");
		fseek(in, 0L, SEEK_END);
		source_filesize = ftell(in);
		fseek(in, 0L, SEEK_SET);
		if (source_filesize <= semi_head_len)
		{
			semi_head_size = calc_data_frequency(in, frequency, 0);
		}
		else
		{
			semi_head_size = calc_data_frequency(in, frequency, semi_head_len);
		}
		printf("统计大小 %ld 字节,文件大小 %ld 字节\n", semi_head_size, source_filesize);
	}
	//生成huffmantree
	error_code = create_huffmantree(frequency, CODE_SIZE, ht);
	if (error_code != OK)
	{
		return error_code;
	}
	puts("霍夫曼树建立成功，开始霍夫曼编码...");
	//生成huffmancode
	error_code = encode_huffmantree(ht, CODE_SIZE, hc);
	if (error_code != OK)
	{
		return error_code;
	}
	//处理压缩文件长度
	if (semi_head_len == 0)
	{
		for (i = 0; i<CODE_SIZE; i++)
			obj_filesize += frequency[i] * hc[i].len;//计算位的个数
		obj_filesize = obj_filesize % 8 == 0 ? obj_filesize / 8 : obj_filesize / 8 + 1;//转换为字节个数;
		for (i = 0; i<CODE_SIZE - 1; i++)
			obj_filesize += 2 * sizeof(short);//huffmantree长度
		obj_filesize += strlen(source_filename) + 1;//源文件名长度
		obj_filesize += sizeof(long);//源文件长度
		obj_filesize += UINT_SIZE;//文件头长度
		compress_rate = (float)obj_filesize / source_filesize;
		puts("编码成功，开始生成压缩文件...");
		printf("压缩文件预期长度:%ld字节,压缩比例:%%%.2lf\n", obj_filesize, compress_rate * 100);
		//生成压缩文件
		error_code = write_compress_file(in, out, ht, hc, source_filename, source_filesize);
		if (error_code != OK)
		{
			return error_code;
		}
	}
	else
	{
		error_code = write_compress_file(in, out, ht, hc, source_filename, source_filesize);
		if (error_code != OK)
		{
			return error_code;
		}
		fseek(out, 0L, SEEK_END);
		obj_filesize = ftell(out);
		compress_rate = (float)obj_filesize / source_filesize;
		puts("编码成功，开始生成压缩文件...");
		printf("压缩文件长度:%ld字节,压缩比例:%%%.2lf\n", obj_filesize, compress_rate * 100);
	}
	puts("压缩完成!");
	//清理资源
	fclose(in);
	fclose(out);//关闭文件  
	for (i = 0; i<CODE_SIZE; i++)
	{
		free(hc[i].codestr);
	}
	return OK;
}
////////////////////////////////////////////////////////////////////
////                    解压缩相关函数函                        ////
////////////////////////////////////////////////////////////////////
/****************************************************************/
/*函数:   d_initial_files()                                     */
/*功能:   初始化并打开压缩功能所需所有文件                      */
/*参数:   char    *source_filename    源(待解压缩)文件名字符串  */
/*        FILE    **inp               指向输入文件指针的指针    */
/*        char    *obj_filename       目标(解压缩)文件名字字符串*/
/*        FILE    **outp              指向输出文件指针的指针    */
/*返回:   int     OK                  函数成功运行              */
/*                其他                出错                      */
/****************************************************************/
int d_initial_files(char *source_filename, FILE **inp, char *obj_filename, FILE **outp)
{
	UINT    zip_head;
	UCHAR   filename_size;
	char  temp_filename[MAX_NAME_LEN];
	printf("待解压缩文件:%s,", source_filename);
	if ((*inp = fopen(source_filename, "rb")) == NULL)
	{
		return FILE_ERR;//不能读文件
	}
	//处理文件头
	fread(&zip_head, UINT_SIZE, 1, *inp);
	if (zip_head != ZIP_HEAD)
	{
		return HEAD_ERR;//非法的文件头
	}
	//处理解压缩文件名
	if (obj_filename == NULL)//如果目标文件名未分配
	{
		obj_filename = temp_filename;
		fread(&filename_size, UCHAR_SIZE, 1, *inp);//得到目标文件名长度
		fread(obj_filename, sizeof(char), filename_size, *inp);//得到目标文件名
		obj_filename[filename_size] = '\0';//添加结尾字符
	}
	else
	{
		fread(&filename_size, UCHAR_SIZE, 1, *inp);
		fseek(*inp, filename_size, SEEK_CUR);//若分配了，直接跳过文件名信息
	}
	printf("解压缩文件:%s\n", obj_filename);
	if ((*outp = fopen(obj_filename, "wb")) == NULL)
	{
		return FILE_ERR;//不能写文件
	}
	return OK;
}
/****************************************************************/
/*函数:   get_mini_huffmantree()                                */
/*功能:   从输入文件得到一个小型的huffman树                     */
/*参数:   FILE    *in             输入文件指针                  */
/*        short   mini_ht[][2]    存储小型huffman树的数组       */
/*返回:   无                                                    */
/****************************************************************/
void get_mini_huffmantree(FILE* in, short mini_ht[][2])
{
	int i;
	for (i = 0; i<CODE_SIZE; i++)
	{
		mini_ht[i][0] = mini_ht[i][1] = UNUSE;//叶子节点无孩子
	}
	fread(mini_ht[i], sizeof(short), 2 * (CODE_SIZE - 1), in);//得到非叶子节点的孩子信息
}
/****************************************************************/
/*函数:   write_decompress_file()                               */
/*功能:   转换压缩文件二进制huffman编码为源编码并输出到目标文件 */
/*参数:   FILE    *in                 输入文件的指针            */
/*        FILE    *out                输出文件的指针            */
/*        short   mini_ht[][2]        存储小心霍夫曼树数组      */
/*        long    bits_pos            输入文件压缩码处的偏移量  */
/*        long    source_filesize     源文件长度                */
/*返回:   int     OK                  函数成功运行              */
/*                其他                出错                      */
/****************************************************************/
int write_decompress_file(FILE *in, FILE* out, short mini_ht[][2], long bits_pos, long obj_filesize)
{
	long    cur_size;
	UCHAR   read_buf[CACHE_SIZE], write_buf[CACHE_SIZE], convert_bit;
	UINT    read_counter, write_counter, cur_pos;

	fseek(in, bits_pos, SEEK_SET);//定位到写文件压缩码开始处
	fseek(out, 0L, SEEK_SET);//定位到写文件头部
	//解码开始
	read_counter = CACHE_SIZE - 1;//置写缓存计数器
	cur_size = write_counter = 0;//当前写入文件长度与写缓存计数器为0
	cur_pos = CODE_SIZE * 2 - 2;//当前huffman节点为根节点
	//如果写入文件长度达到目标文件长度，文件写入完毕，退出
	while (cur_size != obj_filesize)
	{   //若读缓存计数器满
		if (++read_counter == CACHE_SIZE)
		{
			fread(read_buf, 1, CACHE_SIZE, in);//读入到读缓存
			read_counter = 0;//读缓存计数器清0
		}
		//一次循环处理8位，即1字节
		for (convert_bit = 128; convert_bit != 0; convert_bit >>= 1)
		{
			cur_pos = ((read_buf[read_counter] & convert_bit) == 0 ? mini_ht[cur_pos][0] : mini_ht[cur_pos][1]);//按位查找huffmantree节点，0左，1右
			if (cur_pos<CODE_SIZE)//如果当前节点位置小与编码数，则是叶子节点
			{
				write_buf[write_counter] = (UCHAR)cur_pos;//缓存一个byte
				if (++write_counter == CACHE_SIZE)//如果当前输出缓存满
				{
					fwrite(write_buf, 1, CACHE_SIZE, out);//输出到文件
					write_counter = 0;//输入缓存计数器清0
				}
				cur_pos = CODE_SIZE * 2 - 2;//当前节点重置为最后根节点
				if (++cur_size == obj_filesize)
				{
					break;//如果当前写入文件长度到达预定值，跳出
				}
			}
		}
	}
	fwrite(write_buf, 1, write_counter, out);//将写缓存中未输出的数据输出
	return OK;
}
/****************************************************************/
/*函数:   decompress()                                          */
/*功能:   处理解压缩文件的流程                                  */
/*参数:   char    *source_filename    源文件名字符串            */
/*        char    *obj_filename       目标文件名字字符串        */
/*返回:   int     OK                  函数成功运行              */
/*                其他                出错                      */
/****************************************************************/
int decompress(char *source_filename, char *obj_filename)
{
	int     error_code;
	FILE    *in, *out;
	short   mini_ht[CODE_SIZE * 2 - 1][2];
	long    obj_filesize;
	//处理待解压缩文件
	error_code = d_initial_files(source_filename, &in, obj_filename, &out);
	if (error_code != OK)
	{
		return error_code;
	}
	puts("文件打开成功,开始读取文件信息...");
	//读取解压缩文件长度
	fread(&obj_filesize, sizeof(long), 1, in);
	printf("解压文件预期长度:%ld\n", obj_filesize);
	puts("开始重建霍夫曼树...");
	//生成mini的huffmantree
	get_mini_huffmantree(in, mini_ht);
	puts("霍夫曼树建立成功，开始解压缩...");
	//解码压缩文件并生成解压缩文件
	error_code = write_decompress_file(in, out, mini_ht, ftell(in), obj_filesize);
	if (error_code != OK)
	{
		return error_code;
	}
	puts("解压缩完成!");
	//清理资源
	fclose(in);
	fclose(out);
	return OK;
}
////////////////////////////////////////////////////////////////////
////                    辅助相关函数                            ////
////////////////////////////////////////////////////////////////////
/****************************************************************/
/*函数:   create_default_obj_filename()                         */
/*功能:   根据源文件名生成一个默认的目标文件名                  */
/*参数:   char    *source_filename    源文件名字符串            */
/*        char    *obj_filename       目标文件名字字符串        */
/*返回:   char    *obj_filename       目标文件名字字符串        */
/****************************************************************/
char *create_default_obj_filename(char *source_filename, char* obj_filename)
{
	char *temp;
	//若当前文件名中不含有'.'(没有后缀名
	if ((temp = strrchr(source_filename, '.')) == NULL)
	{
		strcpy(obj_filename, source_filename);//复制到目标文件名
		strcat(obj_filename, ".cmp");//将".cmp"后缀名添加到目标文件名后
	}
	else
	{   //如果有后缀名
		strncpy(obj_filename, source_filename, temp - source_filename);//将源文件后缀名前的字符复制到目标文件名
		obj_filename[temp - source_filename] = '\0';//加上字符串结尾字符
		strcat(obj_filename, ".cmp");//将".cmp"后缀名添加到目标文件名后
	}
	return obj_filename;
}
/****************************************************************/
/*函数:   print_help()                                          */
/*功能:   在屏幕上显示帮助信息                                  */
/*参数:   无                                                    */
/*返回:   无                                                    */
/****************************************************************/
void print_help()
{
	puts("\n压缩或者解压缩单个文件\n");
	puts("compress [/h]");
	puts("compress [/c]|[/d] source_file [object_file]\n");
	puts("  -h\t\t显示当前的这些东西...");
	puts("  -s\t\t半静态压缩文件");
	puts("  -c\t\t压缩文件");
	puts("  -d\t\t解压缩文件");
	puts("  source_file\t源文件(包括路径)");
	puts("  object_file\t目标文件(包括路径)");
}
/****************************************************************/
/*函数:   process_error()                                       */
/*功能:   处理从函数中返回的错误代码并在屏幕上显示对应信息      */
/*参数:   int     error_code          从函数中返回的错误代码    */
/*返回:   无                                                    */
/****************************************************************/
void process_error(int error_code)
{
	//#define ARGS_ERR      -2
	//#define FILE_ERR      -3
	//#define HEAD_ERR      -4
	//#define MALLOC_ERR    -5
	//#define HUFTREE_ERR   -6
	//#define HUFCODE_ERR   -7
	switch (error_code)
	{
	case ARGS_ERR:      puts("ERR:错误的参数!"); break;
	case FILE_ERR:      puts("ERR:打开文件出错!"); break;
	case HEAD_ERR:      puts("ERR:非法的压缩文件头!"); break;
	case MALLOC_ERR:    puts("ERR:内存分配出错!"); break;
	case HUFTREE_ERR:   puts("ERR:霍夫曼生成树出错!"); break;
	case HUFCODE_ERR:   puts("ERR:霍夫曼编码出错!"); break;
	default:            break;
	}
}
/****************************************************************/
/*函数:   process_args()                                        */
/*功能:   处理传给程序的命令行参数                              */
/*参数:   char    *first      第一个参数的字符串                */
/*        char    *second     第二个参数的字符串                */
/*        char    *third      第三个参数的字符串                */
/*        char    *forth      第四个参数 1K 2K 4K 8K 16K 32K 64K*/
/*返回:   无                                                    */
/****************************************************************/
void process_args(char *first, char*second, char*third, char*forth)
{
	if (strcmp(first, "-h") == 0 || strcmp(first, "?") == 0)//第一参数first为-h，显示帮助
	{
		print_help();
	}
	else if (strcmp(first, "-s") == 0)//第一参数first为-s，半静态huffman压缩
	{	//第二参数second为半静态统计长度，第三参数third为源文件名，第四个参数forth为目标文件名
		if (strcmp(second, "1K") == 0)
		{
			process_error(compress(third, forth, (long)1024));
			puts("Notice: Semi-Huffman Codec Static length has been set to 1K!\n");
		}
		else if (strcmp(second, "2K") == 0)
		{
			process_error(compress(third, forth, (long)1024 * 2));
			puts("Notice: Semi-Huffman Codec Static length has been set to 2K!\n");
		}
		else if (strcmp(second, "4K") == 0)
		{
			process_error(compress(third, forth, (long)1024 * 4));
			puts("Notice: Semi-Huffman Codec Static length has been set to 4K!\n");
		}
		else if (strcmp(second, "8K") == 0)
		{
			process_error(compress(third, forth, (long)1024 * 8));
			puts("Notice: Semi-Huffman Codec Static length has been set to 8K!\n");
		}
		else if (strcmp(second, "16K") == 0)
		{
			process_error(compress(third, forth, (long)1024 * 16));
			puts("Notice: Semi-Huffman Codec Static length has been set to 16K!\n");
		}
		else if (strcmp(second, "32K") == 0)
		{
			process_error(compress(third, forth, (long)1024 * 32));
			puts("Notice: Semi-Huffman Codec Static length has been set to 32K!\n");
		}
		else if (strcmp(second, "64K") == 0)
		{
			process_error(compress(third, forth, (long)1024 * 64));
			puts("Notice: Semi-Huffman Codec Static length has been set to 64K!\n");
		}
		else
		{
			process_error(compress(third, forth, (long)0));
			puts("Warning: Semi-Huffman Codec Static length set UNSUCCESSFULLY!\n");
		}
	}
	else if (strcmp(first, "-c") == 0)//第一参数first为-c，压缩
	{
		process_error(compress(second, third, (long)0));//第二参数second为源文件名，第三参数third为目标文件名
	}
	else if (strcmp(first, "-d") == 0)//第一参数first为-d，解压缩
	{
		process_error(decompress(second, third));//第二参数second为源文件名
	}
	else//其他，显示错误信息
	{
		process_error(ARGS_ERR);
	}
}
/****************************************************************/
/*函数:   main()                                                */
/*功能:   程序入口，处理参数的个数                              */
/*参数:   int     argc        传给程序参数的个数(包括程序名)    */
/*        char    *argv[]     传给程序参数的字符串数组          */
/*返回:   int     OK          函数成功运行                      */
/*                其他        出错                              */
/****************************************************************/
int main(int argc, char *argv[])
{
	switch (argc)
	{
	case    1:  print_help(); break;//没有参数的时候显示帮助
	case    2:  process_args(argv[1], NULL, NULL,NULL); break;//仅带有-h参数的时候显示帮助
	case    3:  process_args(argv[1], argv[2], NULL,NULL); break;
	case    4:  process_args(argv[1], argv[2], argv[3], NULL); break;
	case    5:  process_args(argv[1], argv[2], argv[3], argv[4]); break;//仅对-s半静态参数有效
	default:   process_error(ARGS_ERR);//其他参数，显示错误信息
	}
	return OK;
}
//end