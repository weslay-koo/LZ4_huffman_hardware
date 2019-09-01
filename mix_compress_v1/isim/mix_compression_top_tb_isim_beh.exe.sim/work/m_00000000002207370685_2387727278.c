/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "F:/LZ4/mix_compress/mix_compress_v1/simulation/mix_compression_top_tb.v";
static const char *ng1 = "%c%c%c%c";
static int ng2[] = {31, 0};
static int ng3[] = {24, 0};
static int ng4[] = {23, 0};
static int ng5[] = {16, 0};
static int ng6[] = {15, 0};
static int ng7[] = {8, 0};
static int ng8[] = {7, 0};
static int ng9[] = {0, 0};
static unsigned int ng10[] = {1U, 0U};
static unsigned int ng11[] = {0U, 0U};
static unsigned int ng12[] = {4294967295U, 0U};
static const char *ng13 = "rb";
static int ng14[] = {1, 0};
static const char *ng15 = "The file length is 0x%x";
static const char *ng16 = "ab+";
static int ng17[] = {4096, 0};
static const char *ng18 = "rb+";
static const char *ng19 = "The fseek return value = %d";
static const char *ng20 = "NO=%d";
static unsigned int ng21[] = {131071U, 0U};
static unsigned int ng22[] = {255U, 0U};
static int ng23[] = {1885696561, 0, 1932488801, 0, 1886545267, 0, 795045741, 0, 1601401443, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng24[] = {1752524390, 0, 1752641139, 0, 1915838317, 0, 1885433957, 0, 1835101743, 0, 1752524390, 0, 1936026985, 0, 1869968431, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng25[] = {1885696563, 0, 1932488801, 0, 1886545267, 0, 795045741, 0, 1601401443, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng26[] = {1752524390, 0, 1752641139, 0, 1915969389, 0, 1885433957, 0, 1835101743, 0, 1752524390, 0, 1936026985, 0, 1869968431, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng27[] = {2U, 0U};
static int ng28[] = {1885696564, 0, 1932488801, 0, 1886545267, 0, 795045741, 0, 1601401443, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng29[] = {1752524390, 0, 1752641139, 0, 1916034925, 0, 1885433957, 0, 1835101743, 0, 1752524390, 0, 1936026985, 0, 1869968431, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng30[] = {3U, 0U};
static int ng31[] = {1885696565, 0, 1932488801, 0, 1886545267, 0, 795045741, 0, 1601401443, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng32[] = {1752524390, 0, 1752641139, 0, 1916100461, 0, 1885433957, 0, 1835101743, 0, 1752524390, 0, 1936026985, 0, 1869968431, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng33[] = {4U, 0U};
static int ng34[] = {1885696566, 0, 1932488801, 0, 1886545267, 0, 795045741, 0, 1601401443, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng35[] = {1752524390, 0, 1752641139, 0, 1916165997, 0, 1885433957, 0, 1835101743, 0, 1752524390, 0, 1936026985, 0, 1869968431, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng36[] = {5U, 0U};
static int ng37[] = {1885696562, 0, 1932488801, 0, 1886545267, 0, 795045741, 0, 1601401443, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng38[] = {1752524390, 0, 1752641139, 0, 1915903853, 0, 1885433957, 0, 1835101743, 0, 1752524390, 0, 1936026985, 0, 1869968431, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng39[] = {6U, 0U};
static int ng40[] = {794978658, 0, 1919251315, 0, 1668246896, 0, 1936876335, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng41[] = {1752524390, 0, 1752641139, 0, 1768054637, 0, 1634611042, 0, 1969645165, 0, 1701669224, 0, 1970548595, 0, 1937006447, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng42[] = {7U, 0U};
static int ng43[] = {795305327, 0, 1919251315, 0, 1668246896, 0, 1936876335, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng44[] = {1752524390, 0, 1752641139, 0, 1701797741, 0, 1634611047, 0, 1969645165, 0, 1701669224, 0, 1970548595, 0, 1937006447, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng45[] = {8U, 0U};
static int ng46[] = {1868720689, 0, 1702064943, 0, 1869443186, 0, 1919102819, 0, 1937006451, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng47[] = {1752524390, 0, 1752641139, 0, 1781620589, 0, 1848602466, 0, 1717988705, 0, 1835624565, 0, 1949266789, 0, 1952411509, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng48[] = {9U, 0U};
static int ng49[] = {1919903587, 0, 1936928624, 0, 1836085861, 0, 1664050031, 0, 1952412530, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng50[] = {1752524390, 0, 1752641139, 0, 1734565741, 0, 795898479, 0, 1718444398, 0, 1768453478, 0, 796091757, 0, 1601140084, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng51[] = {10U, 0U};
static int ng52[] = {1919903600, 0, 1936928624, 0, 1836085861, 0, 1664050031, 0, 1952412530, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng53[] = {1752524390, 0, 1752641139, 0, 1735417709, 0, 795898479, 0, 1718444398, 0, 1768453478, 0, 796091757, 0, 1601140084, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng54[] = {11U, 0U};
static int ng55[] = {1919903596, 0, 1936928624, 0, 1836085861, 0, 1664050031, 0, 1952412530, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng56[] = {1752524390, 0, 1752641139, 0, 1735155565, 0, 795898479, 0, 1718444398, 0, 1768453478, 0, 796091757, 0, 1601140084, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng57[] = {12U, 0U};
static int ng58[] = {1918987891, 0, 1936928628, 0, 1836085861, 0, 1664050031, 0, 1952412530, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng59[] = {1752524390, 0, 1752641139, 0, 1853054829, 0, 796160609, 0, 1718444398, 0, 1768453478, 0, 796091757, 0, 1601140084, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng60[] = {13U, 0U};
static int ng61[] = {1868720690, 0, 1702064943, 0, 1869443186, 0, 1919102819, 0, 1937006451, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng62[] = {1752524390, 0, 1752641139, 0, 1781686125, 0, 1848602466, 0, 1717988705, 0, 1835624565, 0, 1949266789, 0, 1952411509, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng63[] = {14U, 0U};
static int ng64[] = {1852143475, 0, 1702064943, 0, 1869443186, 0, 1919102819, 0, 1937006451, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng65[] = {1752524390, 0, 1752641139, 0, 2004049773, 0, 1848602213, 0, 1717988705, 0, 1835624565, 0, 1949266789, 0, 1952411509, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng66[] = {15U, 0U};
static int ng67[] = {795896163, 0, 1919251315, 0, 1668246896, 0, 1936876335, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng68[] = {1752524390, 0, 1752641139, 0, 1768120173, 0, 1634611056, 0, 1969645165, 0, 1701669224, 0, 1970548595, 0, 1937006447, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng69[] = {16U, 0U};
static int ng70[] = {1869572913, 0, 1936928610, 0, 1836085861, 0, 1664050031, 0, 1952412530, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng71[] = {1752524390, 0, 1752641139, 0, 1798397805, 0, 794980207, 0, 1718444398, 0, 1768453478, 0, 796091757, 0, 1601140084, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng72[] = {17U, 0U};
static int ng73[] = {1869572914, 0, 1936928610, 0, 1836085861, 0, 1664050031, 0, 1952412530, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng74[] = {1752524390, 0, 1752641139, 0, 1798463341, 0, 794980207, 0, 1718444398, 0, 1768453478, 0, 796091757, 0, 1601140084, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng75[] = {18U, 0U};
static int ng76[] = {779644019, 0, 1852138617, 0, 795567470, 0, 1919251315, 0, 1668246896, 0, 1936876335, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng77[] = {1752524390, 0, 1752641139, 0, 1685675885, 0, 1701736037, 0, 1634611051, 0, 1969645165, 0, 1701669224, 0, 1970548595, 0, 1937006447, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng78[] = {19U, 0U};
static int ng79[] = {796095853, 0, 1919251315, 0, 1668246896, 0, 1936876335, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng80[] = {1752524390, 0, 1752641139, 0, 1970102125, 0, 1634611059, 0, 1969645165, 0, 1701669224, 0, 1970548595, 0, 1937006447, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng81[] = {20U, 0U};
static int ng82[] = {1886680117, 0, 1702064943, 0, 1869443186, 0, 1919102819, 0, 1937006451, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng83[] = {1752524390, 0, 1752641139, 0, 1949654893, 0, 1848602740, 0, 1717988705, 0, 1835624565, 0, 1949266789, 0, 1952411509, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng84[] = {21U, 0U};
static int ng85[] = {1735601713, 0, 796418418, 0, 1919251315, 0, 1668246896, 0, 1936876335, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng86[] = {1752524390, 0, 1752641139, 0, 1735614317, 0, 796418418, 0, 1718444398, 0, 1768453478, 0, 796091757, 0, 1601140084, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng87[] = {22U, 0U};
static int ng88[] = {778859376, 0, 1835884914, 0, 795308641, 0, 1919251315, 0, 1668246896, 0, 1936876335, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng89[] = {1752524390, 0, 1752641139, 0, 1634885485, 0, 1918987629, 0, 1634611047, 0, 1969645165, 0, 1701669224, 0, 1970548595, 0, 1937006447, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng90[] = {23U, 0U};
static int ng91[] = {779384948, 0, 1667576377, 0, 794913897, 0, 1919251315, 0, 1668246896, 0, 1936876335, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng92[] = {1752524390, 0, 1752641139, 0, 842620781, 0, 1818846053, 0, 1634611041, 0, 1969645165, 0, 1701669224, 0, 1970548595, 0, 1937006447, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng93[] = {24U, 0U};
static int ng94[] = {1685270115, 0, 1718183276, 0, 1702064943, 0, 1869443186, 0, 1919102819, 0, 1937006451, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng95[] = {1752524390, 0, 1752641139, 0, 1685282669, 0, 1718183276, 0, 1835101743, 0, 1752524390, 0, 1936026985, 0, 1869968431, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng96[] = {25U, 0U};
static int ng97[] = {779384948, 0, 1702113584, 0, 1932487779, 0, 1886545267, 0, 795045741, 0, 1601401443, 0, 1952805748, 0, 11823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng98[] = {1752524390, 0, 1752641139, 0, 825253741, 0, 1818453364, 0, 1835101743, 0, 1752524390, 0, 1936026985, 0, 1869968431, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng99[] = {26U, 0U};
static int ng100[] = {779384948, 0, 1651388722, 0, 1886155361, 0, 1702064943, 0, 1869443186, 0, 1919102819, 0, 1937006451, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng101[] = {1752524390, 0, 1752641139, 0, 825384813, 0, 1918984814, 0, 1848602732, 0, 1717988705, 0, 1835624565, 0, 1949266789, 0, 1952411509, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng102[] = {27U, 0U};
static int ng103[] = {779384948, 0, 1970039147, 0, 1634957679, 0, 1702064943, 0, 1869443186, 0, 1919102819, 0, 1937006451, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng104[] = {1752524390, 0, 1752641139, 0, 1768644461, 0, 2037347692, 0, 1848598899, 0, 1717988705, 0, 1835624565, 0, 1949266789, 0, 1952411509, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng105[] = {28U, 0U};
static int ng106[] = {1752460652, 0, 795045934, 0, 1919251315, 0, 1668246896, 0, 1936876335, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng107[] = {1752524390, 0, 1752641139, 0, 1668308845, 0, 1835101743, 0, 1752524390, 0, 1936026985, 0, 1869968431, 0, 1702065247, 0, 3026804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng108[] = {2053468783, 0, 1702064943, 0, 1869443186, 0, 1919102819, 0, 1937006451, 0, 774861925, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng109[] = {1752524390, 0, 1752641139, 0, 1919901549, 0, 1848605285, 0, 1717988705, 0, 1835624565, 0, 1949266789, 0, 1952411509, 0, 796157299, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static const char *ng110 = "wb";
static const char *ng111 = "Jump in read o_buffer";
static int ng112[] = {4, 0};
static const char *ng113 = "file length is %d Bytes , process time is: %d us";
static const char *ng114 = "./test_out/semihuffman/time_usage.simlog";
static const char *ng115 = " (%s:%d us) ";



static int sp_read_4B_src(char *t1, char *t2)
{
    char t8[8];
    char t9[8];
    char t21[8];
    char t22[8];
    char t34[8];
    char t35[8];
    char t47[8];
    char t48[8];
    char t60[8];
    char t63[8];
    char t64[8];
    char t65[8];
    char t89[8];
    char t90[8];
    char t91[8];
    char t115[8];
    char t116[8];
    char t117[8];
    char t141[8];
    char t142[8];
    char t143[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    char *t36;
    char *t37;
    char *t38;
    char *t39;
    char *t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    char *t49;
    char *t50;
    char *t51;
    char *t52;
    char *t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    char *t61;
    char *t62;
    char *t66;
    char *t67;
    char *t68;
    char *t69;
    char *t70;
    char *t71;
    unsigned int t72;
    int t73;
    char *t74;
    unsigned int t75;
    int t76;
    int t77;
    char *t78;
    unsigned int t79;
    int t80;
    int t81;
    unsigned int t82;
    int t83;
    unsigned int t84;
    unsigned int t85;
    int t86;
    int t87;
    char *t88;
    char *t92;
    char *t93;
    char *t94;
    char *t95;
    char *t96;
    char *t97;
    unsigned int t98;
    int t99;
    char *t100;
    unsigned int t101;
    int t102;
    int t103;
    char *t104;
    unsigned int t105;
    int t106;
    int t107;
    unsigned int t108;
    int t109;
    unsigned int t110;
    unsigned int t111;
    int t112;
    int t113;
    char *t114;
    char *t118;
    char *t119;
    char *t120;
    char *t121;
    char *t122;
    char *t123;
    unsigned int t124;
    int t125;
    char *t126;
    unsigned int t127;
    int t128;
    int t129;
    char *t130;
    unsigned int t131;
    int t132;
    int t133;
    unsigned int t134;
    int t135;
    unsigned int t136;
    unsigned int t137;
    int t138;
    int t139;
    char *t140;
    char *t144;
    char *t145;
    char *t146;
    char *t147;
    char *t148;
    char *t149;
    unsigned int t150;
    int t151;
    char *t152;
    unsigned int t153;
    int t154;
    int t155;
    char *t156;
    unsigned int t157;
    int t158;
    int t159;
    unsigned int t160;
    int t161;
    unsigned int t162;
    unsigned int t163;
    int t164;
    int t165;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 1392);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(374, ng0);

LAB5:    xsi_set_current_line(376, ng0);
    t5 = (t1 + 10904);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t10 = (t1 + 8664);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    memset(t9, 0, 8);
    t13 = (t9 + 4);
    t14 = (t12 + 4);
    t15 = *((unsigned int *)t12);
    t16 = (t15 >> 24);
    *((unsigned int *)t9) = t16;
    t17 = *((unsigned int *)t14);
    t18 = (t17 >> 24);
    *((unsigned int *)t13) = t18;
    t19 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t19 & 255U);
    t20 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t20 & 255U);
    xsi_vlog_bit_copy(t8, 0, t9, 0, 8);
    t23 = (t1 + 8664);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    memset(t22, 0, 8);
    t26 = (t22 + 4);
    t27 = (t25 + 4);
    t28 = *((unsigned int *)t25);
    t29 = (t28 >> 16);
    *((unsigned int *)t22) = t29;
    t30 = *((unsigned int *)t27);
    t31 = (t30 >> 16);
    *((unsigned int *)t26) = t31;
    t32 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t32 & 255U);
    t33 = *((unsigned int *)t26);
    *((unsigned int *)t26) = (t33 & 255U);
    xsi_vlog_bit_copy(t21, 0, t22, 0, 8);
    t36 = (t1 + 8664);
    t37 = (t36 + 56U);
    t38 = *((char **)t37);
    memset(t35, 0, 8);
    t39 = (t35 + 4);
    t40 = (t38 + 4);
    t41 = *((unsigned int *)t38);
    t42 = (t41 >> 8);
    *((unsigned int *)t35) = t42;
    t43 = *((unsigned int *)t40);
    t44 = (t43 >> 8);
    *((unsigned int *)t39) = t44;
    t45 = *((unsigned int *)t35);
    *((unsigned int *)t35) = (t45 & 255U);
    t46 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t46 & 255U);
    xsi_vlog_bit_copy(t34, 0, t35, 0, 8);
    t49 = (t1 + 8664);
    t50 = (t49 + 56U);
    t51 = *((char **)t50);
    memset(t48, 0, 8);
    t52 = (t48 + 4);
    t53 = (t51 + 4);
    t54 = *((unsigned int *)t51);
    t55 = (t54 >> 0);
    *((unsigned int *)t48) = t55;
    t56 = *((unsigned int *)t53);
    t57 = (t56 >> 0);
    *((unsigned int *)t52) = t57;
    t58 = *((unsigned int *)t48);
    *((unsigned int *)t48) = (t58 & 255U);
    t59 = *((unsigned int *)t52);
    *((unsigned int *)t52) = (t59 & 255U);
    xsi_vlog_bit_copy(t47, 0, t48, 0, 8);
    *((int *)t60) = xsi_vlogfile_fscanf(*((unsigned int *)t7), ng1, 5, t1, (char)118, t8, 8, (char)118, t21, 8, (char)118, t34, 8, (char)118, t47, 8);
    t61 = (t60 + 4);
    *((int *)t61) = 0;
    t62 = (t1 + 8664);
    t66 = (t1 + 8664);
    t67 = (t66 + 72U);
    t68 = *((char **)t67);
    t69 = ((char*)((ng2)));
    t70 = ((char*)((ng3)));
    xsi_vlog_convert_partindices(t63, t64, t65, ((int*)(t68)), 2, t69, 32, 1, t70, 32, 1);
    t71 = (t63 + 4);
    t72 = *((unsigned int *)t71);
    t73 = (!(t72));
    t74 = (t64 + 4);
    t75 = *((unsigned int *)t74);
    t76 = (!(t75));
    t77 = (t73 && t76);
    t78 = (t65 + 4);
    t79 = *((unsigned int *)t78);
    t80 = (!(t79));
    t81 = (t77 && t80);
    if (t81 == 1)
        goto LAB6;

LAB7:    t88 = (t1 + 8664);
    t92 = (t1 + 8664);
    t93 = (t92 + 72U);
    t94 = *((char **)t93);
    t95 = ((char*)((ng4)));
    t96 = ((char*)((ng5)));
    xsi_vlog_convert_partindices(t89, t90, t91, ((int*)(t94)), 2, t95, 32, 1, t96, 32, 1);
    t97 = (t89 + 4);
    t98 = *((unsigned int *)t97);
    t99 = (!(t98));
    t100 = (t90 + 4);
    t101 = *((unsigned int *)t100);
    t102 = (!(t101));
    t103 = (t99 && t102);
    t104 = (t91 + 4);
    t105 = *((unsigned int *)t104);
    t106 = (!(t105));
    t107 = (t103 && t106);
    if (t107 == 1)
        goto LAB8;

LAB9:    t114 = (t1 + 8664);
    t118 = (t1 + 8664);
    t119 = (t118 + 72U);
    t120 = *((char **)t119);
    t121 = ((char*)((ng6)));
    t122 = ((char*)((ng7)));
    xsi_vlog_convert_partindices(t115, t116, t117, ((int*)(t120)), 2, t121, 32, 1, t122, 32, 1);
    t123 = (t115 + 4);
    t124 = *((unsigned int *)t123);
    t125 = (!(t124));
    t126 = (t116 + 4);
    t127 = *((unsigned int *)t126);
    t128 = (!(t127));
    t129 = (t125 && t128);
    t130 = (t117 + 4);
    t131 = *((unsigned int *)t130);
    t132 = (!(t131));
    t133 = (t129 && t132);
    if (t133 == 1)
        goto LAB10;

LAB11:    t140 = (t1 + 8664);
    t144 = (t1 + 8664);
    t145 = (t144 + 72U);
    t146 = *((char **)t145);
    t147 = ((char*)((ng8)));
    t148 = ((char*)((ng9)));
    xsi_vlog_convert_partindices(t141, t142, t143, ((int*)(t146)), 2, t147, 32, 1, t148, 32, 1);
    t149 = (t141 + 4);
    t150 = *((unsigned int *)t149);
    t151 = (!(t150));
    t152 = (t142 + 4);
    t153 = *((unsigned int *)t152);
    t154 = (!(t153));
    t155 = (t151 && t154);
    t156 = (t143 + 4);
    t157 = *((unsigned int *)t156);
    t158 = (!(t157));
    t159 = (t155 && t158);
    if (t159 == 1)
        goto LAB12;

LAB13:    xsi_set_current_line(378, ng0);
    t4 = ((char*)((ng10)));
    t5 = (t1 + 8824);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB6:    t82 = *((unsigned int *)t65);
    t83 = (t82 + 0);
    t84 = *((unsigned int *)t63);
    t85 = *((unsigned int *)t64);
    t86 = (t84 - t85);
    t87 = (t86 + 1);
    xsi_vlogvar_assign_value(t62, t8, t83, *((unsigned int *)t64), t87);
    goto LAB7;

LAB8:    t108 = *((unsigned int *)t91);
    t109 = (t108 + 0);
    t110 = *((unsigned int *)t89);
    t111 = *((unsigned int *)t90);
    t112 = (t110 - t111);
    t113 = (t112 + 1);
    xsi_vlogvar_assign_value(t88, t21, t109, *((unsigned int *)t90), t113);
    goto LAB9;

LAB10:    t134 = *((unsigned int *)t117);
    t135 = (t134 + 0);
    t136 = *((unsigned int *)t115);
    t137 = *((unsigned int *)t116);
    t138 = (t136 - t137);
    t139 = (t138 + 1);
    xsi_vlogvar_assign_value(t114, t34, t135, *((unsigned int *)t116), t139);
    goto LAB11;

LAB12:    t160 = *((unsigned int *)t143);
    t161 = (t160 + 0);
    t162 = *((unsigned int *)t141);
    t163 = *((unsigned int *)t142);
    t164 = (t162 - t163);
    t165 = (t164 + 1);
    xsi_vlogvar_assign_value(t140, t47, t161, *((unsigned int *)t142), t165);
    goto LAB13;

}

static int sp_compress_test_start(char *t1, char *t2)
{
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 1824);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(384, ng0);

LAB5:    xsi_set_current_line(385, ng0);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    xsi_process_wait(t6, 8000LL);
    *((char **)t3) = &&LAB6;
    t0 = 1;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB6:    xsi_set_current_line(385, ng0);
    t7 = ((char*)((ng11)));
    t8 = (t1 + 9144);
    xsi_vlogvar_assign_value(t8, t7, 0, 0, 1);
    xsi_set_current_line(386, ng0);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 8000LL);
    *((char **)t3) = &&LAB7;
    t0 = 1;
    goto LAB1;

LAB7:    xsi_set_current_line(386, ng0);
    t6 = ((char*)((ng10)));
    t7 = (t1 + 9144);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1);
    xsi_set_current_line(387, ng0);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 4000LL);
    *((char **)t3) = &&LAB8;
    t0 = 1;
    goto LAB1;

LAB8:    xsi_set_current_line(387, ng0);
    t6 = ((char*)((ng11)));
    t7 = (t1 + 9144);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1);
    goto LAB4;

}

static int sp_compress_test_done(char *t1, char *t2)
{
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 2256);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(393, ng0);

LAB5:    xsi_set_current_line(394, ng0);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    xsi_process_wait(t6, 24000LL);
    *((char **)t3) = &&LAB6;
    t0 = 1;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB6:    xsi_set_current_line(394, ng0);
    t7 = ((char*)((ng10)));
    t8 = (t1 + 8984);
    xsi_vlogvar_assign_value(t8, t7, 0, 0, 1);
    goto LAB4;

}

static int sp_file_length_init(char *t1, char *t2)
{
    char t10[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;
    char *t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    int t34;
    int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    char *t42;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 2688);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(400, ng0);

LAB5:    xsi_set_current_line(401, ng0);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    xsi_process_wait(t6, 4000LL);
    *((char **)t3) = &&LAB6;
    t0 = 1;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB6:    xsi_set_current_line(401, ng0);
    t7 = ((char*)((ng11)));
    t8 = (t1 + 9464);
    xsi_vlogvar_assign_value(t8, t7, 0, 0, 32);
    xsi_set_current_line(402, ng0);
    t4 = ((char*)((ng11)));
    t5 = (t1 + 9624);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(403, ng0);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 4000LL);
    *((char **)t3) = &&LAB7;
    t0 = 1;
    goto LAB1;

LAB7:    xsi_set_current_line(403, ng0);
    t6 = ((char*)((ng12)));
    t7 = (t1 + 10744);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t11 = *((unsigned int *)t6);
    t12 = *((unsigned int *)t9);
    t13 = (t11 & t12);
    *((unsigned int *)t10) = t13;
    t14 = (t6 + 4);
    t15 = (t9 + 4);
    t16 = (t10 + 4);
    t17 = *((unsigned int *)t14);
    t18 = *((unsigned int *)t15);
    t19 = (t17 | t18);
    *((unsigned int *)t16) = t19;
    t20 = *((unsigned int *)t16);
    t21 = (t20 != 0);
    if (t21 == 1)
        goto LAB8;

LAB9:
LAB10:    t42 = (t1 + 9464);
    xsi_vlogvar_assign_value(t42, t10, 0, 0, 32);
    xsi_set_current_line(404, ng0);
    t4 = ((char*)((ng10)));
    t5 = (t1 + 9624);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(405, ng0);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 4000LL);
    *((char **)t3) = &&LAB11;
    t0 = 1;
    goto LAB1;

LAB8:    t22 = *((unsigned int *)t10);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t10) = (t22 | t23);
    t24 = (t6 + 4);
    t25 = (t9 + 4);
    t26 = *((unsigned int *)t6);
    t27 = (~(t26));
    t28 = *((unsigned int *)t24);
    t29 = (~(t28));
    t30 = *((unsigned int *)t9);
    t31 = (~(t30));
    t32 = *((unsigned int *)t25);
    t33 = (~(t32));
    t34 = (t27 & t29);
    t35 = (t31 & t33);
    t36 = (~(t34));
    t37 = (~(t35));
    t38 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t38 & t36);
    t39 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t39 & t37);
    t40 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t40 & t36);
    t41 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t41 & t37);
    goto LAB10;

LAB11:    xsi_set_current_line(405, ng0);
    t6 = ((char*)((ng11)));
    t7 = (t1 + 9464);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 32);
    xsi_set_current_line(406, ng0);
    t4 = ((char*)((ng11)));
    t5 = (t1 + 9624);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    goto LAB4;

}

static int sp_max_stat_init(char *t1, char *t2)
{
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 3120);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(412, ng0);

LAB5:    xsi_set_current_line(413, ng0);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    xsi_process_wait(t6, 4000LL);
    *((char **)t3) = &&LAB6;
    t0 = 1;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB6:    xsi_set_current_line(413, ng0);
    t7 = ((char*)((ng11)));
    t8 = (t1 + 9784);
    xsi_vlogvar_assign_value(t8, t7, 0, 0, 17);
    xsi_set_current_line(414, ng0);
    t4 = ((char*)((ng11)));
    t5 = (t1 + 9944);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(415, ng0);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 4000LL);
    *((char **)t3) = &&LAB7;
    t0 = 1;
    goto LAB1;

LAB7:    xsi_set_current_line(415, ng0);
    t6 = (t1 + 12024);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t1 + 9784);
    xsi_vlogvar_assign_value(t9, t8, 0, 0, 17);
    xsi_set_current_line(416, ng0);
    t4 = ((char*)((ng10)));
    t5 = (t1 + 9944);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(417, ng0);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 4000LL);
    *((char **)t3) = &&LAB8;
    t0 = 1;
    goto LAB1;

LAB8:    xsi_set_current_line(417, ng0);
    t6 = ((char*)((ng11)));
    t7 = (t1 + 9784);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 17);
    xsi_set_current_line(418, ng0);
    t4 = ((char*)((ng11)));
    t5 = (t1 + 9944);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    goto LAB4;

}

static int sp_file_length_calc(char *t1, char *t2)
{
    char t9[8];
    char t10[8];
    char t27[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t28;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 3552);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(424, ng0);

LAB5:    xsi_set_current_line(425, ng0);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    xsi_process_wait(t6, 80000LL);
    *((char **)t3) = &&LAB6;
    t0 = 1;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB6:    xsi_set_current_line(426, ng0);
    t7 = ((char*)((ng9)));
    t8 = (t1 + 10264);
    xsi_vlogvar_assign_value(t8, t7, 0, 0, 32);
    xsi_set_current_line(427, ng0);
    t4 = (t1 + 11704);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((int *)t9) = xsi_vlogfile_file_open_of_valname_ctype(t6, 1024, ng13);
    t7 = (t9 + 4);
    *((int *)t7) = 0;
    t8 = (t1 + 10904);
    xsi_vlogvar_assign_value(t8, t9, 0, 0, 32);
    xsi_set_current_line(428, ng0);
    t4 = (t1 + 10904);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((int *)t9) = xsi_vlogfile_fgetc(*((unsigned int *)t6));
    t7 = (t9 + 4);
    *((int *)t7) = 0;
    t8 = (t1 + 11544);
    xsi_vlogvar_assign_value(t8, t9, 0, 0, 8);
    xsi_set_current_line(429, ng0);

LAB7:    t4 = (t1 + 10904);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((int *)t10) = xsi_vlogfile_feof(*((unsigned int *)t6));
    t7 = (t10 + 4);
    *((int *)t7) = 0;
    memset(t9, 0, 8);
    t8 = (t10 + 4);
    t11 = *((unsigned int *)t8);
    t12 = (~(t11));
    t13 = *((unsigned int *)t10);
    t14 = (t13 & t12);
    t15 = (t14 & 4294967295U);
    if (t15 != 0)
        goto LAB11;

LAB9:    if (*((unsigned int *)t8) == 0)
        goto LAB8;

LAB10:    t16 = (t9 + 4);
    *((unsigned int *)t9) = 1;
    *((unsigned int *)t16) = 1;

LAB11:    t17 = (t9 + 4);
    t18 = *((unsigned int *)t17);
    t19 = (~(t18));
    t20 = *((unsigned int *)t9);
    t21 = (t20 & t19);
    t22 = (t21 != 0);
    if (t22 > 0)
        goto LAB12;

LAB13:    xsi_set_current_line(436, ng0);
    t4 = (t1 + 10264);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t1 + 10744);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 32);
    xsi_set_current_line(437, ng0);
    t4 = (t1 + 10904);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    xsi_vlogfile_fclose(*((unsigned int *)t6));
    xsi_set_current_line(438, ng0);
    t4 = (t1 + 10744);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t1 + 3552);
    xsi_vlogfile_write(1, 0, 0, ng15, 2, t7, (char)119, t6, 32);
    xsi_set_current_line(439, ng0);
    t4 = ((char*)((ng9)));
    t5 = (t1 + 10264);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 32);
    goto LAB4;

LAB8:    *((unsigned int *)t9) = 1;
    goto LAB11;

LAB12:    xsi_set_current_line(430, ng0);

LAB14:    xsi_set_current_line(432, ng0);
    t23 = (t1 + 10264);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    t26 = ((char*)((ng14)));
    memset(t27, 0, 8);
    xsi_vlog_signed_add(t27, 32, t25, 32, t26, 32);
    t28 = (t1 + 10264);
    xsi_vlogvar_assign_value(t28, t27, 0, 0, 32);
    xsi_set_current_line(433, ng0);
    t4 = (t1 + 10904);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((int *)t9) = xsi_vlogfile_fgetc(*((unsigned int *)t6));
    t7 = (t9 + 4);
    *((int *)t7) = 0;
    t8 = (t1 + 11544);
    xsi_vlogvar_assign_value(t8, t9, 0, 0, 8);
    goto LAB7;

}

static int sp_write_16kbytes(char *t1, char *t2)
{
    char t8[8];
    char t24[8];
    char t34[8];
    char t44[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t25;
    char *t26;
    char *t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    char *t35;
    char *t36;
    char *t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    char *t45;
    char *t46;
    char *t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    char *t54;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 3984);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(445, ng0);

LAB5:    xsi_set_current_line(446, ng0);
    t5 = (t1 + 11864);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((int *)t8) = xsi_vlogfile_file_open_of_valname_ctype(t7, 1024, ng16);
    t9 = (t8 + 4);
    *((int *)t9) = 0;
    t10 = (t1 + 11064);
    xsi_vlogvar_assign_value(t10, t8, 0, 0, 32);
    xsi_set_current_line(447, ng0);
    xsi_set_current_line(447, ng0);
    t4 = ((char*)((ng9)));
    t5 = (t1 + 10424);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 32);

LAB6:    t4 = (t1 + 10424);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = ((char*)((ng17)));
    memset(t8, 0, 8);
    xsi_vlog_signed_less(t8, 32, t6, 32, t7, 32);
    t9 = (t8 + 4);
    t11 = *((unsigned int *)t9);
    t12 = (~(t11));
    t13 = *((unsigned int *)t8);
    t14 = (t13 & t12);
    t15 = (t14 != 0);
    if (t15 > 0)
        goto LAB7;

LAB8:    xsi_set_current_line(455, ng0);
    t4 = ((char*)((ng11)));
    t5 = (t1 + 9304);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(456, ng0);
    t4 = (t1 + 11064);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    xsi_vlogfile_fclose(*((unsigned int *)t6));

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB7:    xsi_set_current_line(448, ng0);

LAB9:    xsi_set_current_line(450, ng0);
    t10 = ((char*)((ng10)));
    t16 = (t1 + 9304);
    xsi_vlogvar_assign_value(t16, t10, 0, 0, 1);
    xsi_set_current_line(451, ng0);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 4000LL);
    *((char **)t3) = &&LAB10;
    t0 = 1;
    goto LAB1;

LAB10:    xsi_set_current_line(452, ng0);
    t4 = (t1 + 6984U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t11 = *((unsigned int *)t4);
    t12 = (~(t11));
    t13 = *((unsigned int *)t5);
    t14 = (t13 & t12);
    t15 = (t14 != 0);
    if (t15 > 0)
        goto LAB11;

LAB12:
LAB13:    xsi_set_current_line(447, ng0);
    t4 = (t1 + 10424);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = ((char*)((ng14)));
    memset(t8, 0, 8);
    xsi_vlog_signed_add(t8, 32, t6, 32, t7, 32);
    t9 = (t1 + 10424);
    xsi_vlogvar_assign_value(t9, t8, 0, 0, 32);
    goto LAB6;

LAB11:    xsi_set_current_line(453, ng0);
    t6 = (t1 + 11064);
    t7 = (t6 + 56U);
    t9 = *((char **)t7);
    t10 = (t1 + 6664U);
    t16 = *((char **)t10);
    memset(t8, 0, 8);
    t10 = (t8 + 4);
    t17 = (t16 + 4);
    t18 = *((unsigned int *)t16);
    t19 = (t18 >> 24);
    *((unsigned int *)t8) = t19;
    t20 = *((unsigned int *)t17);
    t21 = (t20 >> 24);
    *((unsigned int *)t10) = t21;
    t22 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t22 & 255U);
    t23 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t23 & 255U);
    t25 = (t1 + 6664U);
    t26 = *((char **)t25);
    memset(t24, 0, 8);
    t25 = (t24 + 4);
    t27 = (t26 + 4);
    t28 = *((unsigned int *)t26);
    t29 = (t28 >> 16);
    *((unsigned int *)t24) = t29;
    t30 = *((unsigned int *)t27);
    t31 = (t30 >> 16);
    *((unsigned int *)t25) = t31;
    t32 = *((unsigned int *)t24);
    *((unsigned int *)t24) = (t32 & 255U);
    t33 = *((unsigned int *)t25);
    *((unsigned int *)t25) = (t33 & 255U);
    t35 = (t1 + 6664U);
    t36 = *((char **)t35);
    memset(t34, 0, 8);
    t35 = (t34 + 4);
    t37 = (t36 + 4);
    t38 = *((unsigned int *)t36);
    t39 = (t38 >> 8);
    *((unsigned int *)t34) = t39;
    t40 = *((unsigned int *)t37);
    t41 = (t40 >> 8);
    *((unsigned int *)t35) = t41;
    t42 = *((unsigned int *)t34);
    *((unsigned int *)t34) = (t42 & 255U);
    t43 = *((unsigned int *)t35);
    *((unsigned int *)t35) = (t43 & 255U);
    t45 = (t1 + 6664U);
    t46 = *((char **)t45);
    memset(t44, 0, 8);
    t45 = (t44 + 4);
    t47 = (t46 + 4);
    t48 = *((unsigned int *)t46);
    t49 = (t48 >> 0);
    *((unsigned int *)t44) = t49;
    t50 = *((unsigned int *)t47);
    t51 = (t50 >> 0);
    *((unsigned int *)t45) = t51;
    t52 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t52 & 255U);
    t53 = *((unsigned int *)t45);
    *((unsigned int *)t45) = (t53 & 255U);
    t54 = (t1 + 3984);
    xsi_vlogfile_fwrite(*((unsigned int *)t9), 0, 0, 1, ng1, 5, t54, (char)118, t8, 8, (char)118, t24, 8, (char)118, t34, 8, (char)118, t44, 8);
    goto LAB13;

}

static int sp_write_last_block(char *t1, char *t2)
{
    char t7[8];
    char t24[8];
    char t34[8];
    char t44[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t8;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;
    char *t21;
    char *t22;
    unsigned int t23;
    char *t25;
    char *t26;
    char *t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    char *t35;
    char *t36;
    char *t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    char *t45;
    char *t46;
    char *t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    char *t54;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 4416);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(462, ng0);

LAB5:    xsi_set_current_line(463, ng0);
    t5 = ((char*)((ng9)));
    t6 = (t1 + 10264);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 32);
    xsi_set_current_line(464, ng0);
    t4 = (t1 + 11864);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((int *)t7) = xsi_vlogfile_file_open_of_valname_ctype(t6, 1024, ng16);
    t8 = (t7 + 4);
    *((int *)t8) = 0;
    t9 = (t1 + 11064);
    xsi_vlogvar_assign_value(t9, t7, 0, 0, 32);
    xsi_set_current_line(465, ng0);

LAB6:    t4 = (t1 + 6824U);
    t5 = *((char **)t4);
    memset(t7, 0, 8);
    t4 = (t5 + 4);
    t10 = *((unsigned int *)t4);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB10;

LAB8:    if (*((unsigned int *)t4) == 0)
        goto LAB7;

LAB9:    t6 = (t7 + 4);
    *((unsigned int *)t7) = 1;
    *((unsigned int *)t6) = 1;

LAB10:    t8 = (t7 + 4);
    t15 = *((unsigned int *)t8);
    t16 = (~(t15));
    t17 = *((unsigned int *)t7);
    t18 = (t17 & t16);
    t19 = (t18 != 0);
    if (t19 > 0)
        goto LAB11;

LAB12:    xsi_set_current_line(473, ng0);
    t4 = ((char*)((ng11)));
    t5 = (t1 + 9304);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(474, ng0);
    t4 = (t1 + 11064);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    xsi_vlogfile_fclose(*((unsigned int *)t6));

LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB7:    *((unsigned int *)t7) = 1;
    goto LAB10;

LAB11:    xsi_set_current_line(466, ng0);

LAB13:    xsi_set_current_line(468, ng0);
    t9 = ((char*)((ng10)));
    t20 = (t1 + 9304);
    xsi_vlogvar_assign_value(t20, t9, 0, 0, 1);
    xsi_set_current_line(469, ng0);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 4000LL);
    *((char **)t3) = &&LAB14;
    t0 = 1;
    goto LAB1;

LAB14:    xsi_set_current_line(470, ng0);
    t4 = (t1 + 6984U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t10 = *((unsigned int *)t4);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB15;

LAB16:
LAB17:    goto LAB6;

LAB15:    xsi_set_current_line(471, ng0);
    t6 = (t1 + 11064);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    t20 = (t1 + 6664U);
    t21 = *((char **)t20);
    memset(t7, 0, 8);
    t20 = (t7 + 4);
    t22 = (t21 + 4);
    t15 = *((unsigned int *)t21);
    t16 = (t15 >> 24);
    *((unsigned int *)t7) = t16;
    t17 = *((unsigned int *)t22);
    t18 = (t17 >> 24);
    *((unsigned int *)t20) = t18;
    t19 = *((unsigned int *)t7);
    *((unsigned int *)t7) = (t19 & 255U);
    t23 = *((unsigned int *)t20);
    *((unsigned int *)t20) = (t23 & 255U);
    t25 = (t1 + 6664U);
    t26 = *((char **)t25);
    memset(t24, 0, 8);
    t25 = (t24 + 4);
    t27 = (t26 + 4);
    t28 = *((unsigned int *)t26);
    t29 = (t28 >> 16);
    *((unsigned int *)t24) = t29;
    t30 = *((unsigned int *)t27);
    t31 = (t30 >> 16);
    *((unsigned int *)t25) = t31;
    t32 = *((unsigned int *)t24);
    *((unsigned int *)t24) = (t32 & 255U);
    t33 = *((unsigned int *)t25);
    *((unsigned int *)t25) = (t33 & 255U);
    t35 = (t1 + 6664U);
    t36 = *((char **)t35);
    memset(t34, 0, 8);
    t35 = (t34 + 4);
    t37 = (t36 + 4);
    t38 = *((unsigned int *)t36);
    t39 = (t38 >> 8);
    *((unsigned int *)t34) = t39;
    t40 = *((unsigned int *)t37);
    t41 = (t40 >> 8);
    *((unsigned int *)t35) = t41;
    t42 = *((unsigned int *)t34);
    *((unsigned int *)t34) = (t42 & 255U);
    t43 = *((unsigned int *)t35);
    *((unsigned int *)t35) = (t43 & 255U);
    t45 = (t1 + 6664U);
    t46 = *((char **)t45);
    memset(t44, 0, 8);
    t45 = (t44 + 4);
    t47 = (t46 + 4);
    t48 = *((unsigned int *)t46);
    t49 = (t48 >> 0);
    *((unsigned int *)t44) = t49;
    t50 = *((unsigned int *)t47);
    t51 = (t50 >> 0);
    *((unsigned int *)t45) = t51;
    t52 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t52 & 255U);
    t53 = *((unsigned int *)t45);
    *((unsigned int *)t45) = (t53 & 255U);
    t54 = (t1 + 4416);
    xsi_vlogfile_fwrite(*((unsigned int *)t9), 0, 0, 1, ng1, 5, t54, (char)118, t7, 8, (char)118, t24, 8, (char)118, t34, 8, (char)118, t44, 8);
    goto LAB17;

}

static int sp_write_length(char *t1, char *t2)
{
    char t10[8];
    char t19[8];
    char t27[8];
    char t37[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    char *t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    char *t28;
    char *t29;
    char *t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    char *t38;
    char *t39;
    char *t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    char *t47;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 4848);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(480, ng0);

LAB5:    xsi_set_current_line(481, ng0);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    xsi_process_wait(t6, 80000LL);
    *((char **)t3) = &&LAB6;
    t0 = 1;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB6:    xsi_set_current_line(482, ng0);
    t7 = (t1 + 11864);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((int *)t10) = xsi_vlogfile_file_open_of_valname_ctype(t9, 1024, ng18);
    t11 = (t10 + 4);
    *((int *)t11) = 0;
    t12 = (t1 + 11064);
    xsi_vlogvar_assign_value(t12, t10, 0, 0, 32);
    xsi_set_current_line(483, ng0);
    t4 = (t1 + 11064);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t1 + 608);
    t8 = *((char **)t7);
    t7 = ((char*)((ng9)));
    *((int *)t10) = xsi_vlogfile_fseek(*((unsigned int *)t6), *((unsigned int *)t8), *((unsigned int *)t7));
    t9 = (t10 + 4);
    *((int *)t9) = 0;
    t11 = (t1 + 4848);
    xsi_vlogfile_write(1, 0, 0, ng19, 2, t11, (char)119, t10, 32);
    xsi_set_current_line(484, ng0);
    t4 = (t1 + 11064);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t1 + 7624U);
    t8 = *((char **)t7);
    memset(t10, 0, 8);
    t7 = (t10 + 4);
    t9 = (t8 + 4);
    t13 = *((unsigned int *)t8);
    t14 = (t13 >> 0);
    *((unsigned int *)t10) = t14;
    t15 = *((unsigned int *)t9);
    t16 = (t15 >> 0);
    *((unsigned int *)t7) = t16;
    t17 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t17 & 255U);
    t18 = *((unsigned int *)t7);
    *((unsigned int *)t7) = (t18 & 255U);
    t11 = (t1 + 7624U);
    t12 = *((char **)t11);
    memset(t19, 0, 8);
    t11 = (t19 + 4);
    t20 = (t12 + 4);
    t21 = *((unsigned int *)t12);
    t22 = (t21 >> 8);
    *((unsigned int *)t19) = t22;
    t23 = *((unsigned int *)t20);
    t24 = (t23 >> 8);
    *((unsigned int *)t11) = t24;
    t25 = *((unsigned int *)t19);
    *((unsigned int *)t19) = (t25 & 255U);
    t26 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t26 & 255U);
    t28 = (t1 + 7624U);
    t29 = *((char **)t28);
    memset(t27, 0, 8);
    t28 = (t27 + 4);
    t30 = (t29 + 4);
    t31 = *((unsigned int *)t29);
    t32 = (t31 >> 16);
    *((unsigned int *)t27) = t32;
    t33 = *((unsigned int *)t30);
    t34 = (t33 >> 16);
    *((unsigned int *)t28) = t34;
    t35 = *((unsigned int *)t27);
    *((unsigned int *)t27) = (t35 & 255U);
    t36 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t36 & 255U);
    t38 = (t1 + 7624U);
    t39 = *((char **)t38);
    memset(t37, 0, 8);
    t38 = (t37 + 4);
    t40 = (t39 + 4);
    t41 = *((unsigned int *)t39);
    t42 = (t41 >> 24);
    *((unsigned int *)t37) = t42;
    t43 = *((unsigned int *)t40);
    t44 = (t43 >> 24);
    *((unsigned int *)t38) = t44;
    t45 = *((unsigned int *)t37);
    *((unsigned int *)t37) = (t45 & 255U);
    t46 = *((unsigned int *)t38);
    *((unsigned int *)t38) = (t46 & 255U);
    t47 = (t1 + 4848);
    xsi_vlogfile_fwrite(*((unsigned int *)t6), 0, 0, 1, ng1, 5, t47, (char)118, t10, 8, (char)118, t19, 8, (char)118, t27, 8, (char)118, t37, 8);
    xsi_set_current_line(485, ng0);
    t4 = (t1 + 11064);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    xsi_vlogfile_fclose(*((unsigned int *)t6));
    goto LAB4;

}

static int sp_feedback_test_file(char *t1, char *t2)
{
    char t15[8];
    char t25[8];
    char t35[8];
    char t45[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    char *t16;
    char *t17;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    char *t26;
    char *t27;
    char *t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    char *t36;
    char *t37;
    char *t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    char *t46;
    char *t47;
    char *t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    char *t55;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 5280);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(491, ng0);

LAB5:    xsi_set_current_line(492, ng0);
    t5 = (t1 + 7944U);
    t6 = *((char **)t5);
    t5 = (t6 + 4);
    t7 = *((unsigned int *)t5);
    t8 = (~(t7));
    t9 = *((unsigned int *)t6);
    t10 = (t9 & t8);
    t11 = (t10 != 0);
    if (t11 > 0)
        goto LAB6;

LAB7:
LAB8:
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB6:    xsi_set_current_line(493, ng0);
    t12 = (t1 + 11224);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t16 = (t1 + 7784U);
    t17 = *((char **)t16);
    memset(t15, 0, 8);
    t16 = (t15 + 4);
    t18 = (t17 + 4);
    t19 = *((unsigned int *)t17);
    t20 = (t19 >> 24);
    *((unsigned int *)t15) = t20;
    t21 = *((unsigned int *)t18);
    t22 = (t21 >> 24);
    *((unsigned int *)t16) = t22;
    t23 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t23 & 255U);
    t24 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t24 & 255U);
    t26 = (t1 + 7784U);
    t27 = *((char **)t26);
    memset(t25, 0, 8);
    t26 = (t25 + 4);
    t28 = (t27 + 4);
    t29 = *((unsigned int *)t27);
    t30 = (t29 >> 16);
    *((unsigned int *)t25) = t30;
    t31 = *((unsigned int *)t28);
    t32 = (t31 >> 16);
    *((unsigned int *)t26) = t32;
    t33 = *((unsigned int *)t25);
    *((unsigned int *)t25) = (t33 & 255U);
    t34 = *((unsigned int *)t26);
    *((unsigned int *)t26) = (t34 & 255U);
    t36 = (t1 + 7784U);
    t37 = *((char **)t36);
    memset(t35, 0, 8);
    t36 = (t35 + 4);
    t38 = (t37 + 4);
    t39 = *((unsigned int *)t37);
    t40 = (t39 >> 8);
    *((unsigned int *)t35) = t40;
    t41 = *((unsigned int *)t38);
    t42 = (t41 >> 8);
    *((unsigned int *)t36) = t42;
    t43 = *((unsigned int *)t35);
    *((unsigned int *)t35) = (t43 & 255U);
    t44 = *((unsigned int *)t36);
    *((unsigned int *)t36) = (t44 & 255U);
    t46 = (t1 + 7784U);
    t47 = *((char **)t46);
    memset(t45, 0, 8);
    t46 = (t45 + 4);
    t48 = (t47 + 4);
    t49 = *((unsigned int *)t47);
    t50 = (t49 >> 0);
    *((unsigned int *)t45) = t50;
    t51 = *((unsigned int *)t48);
    t52 = (t51 >> 0);
    *((unsigned int *)t46) = t52;
    t53 = *((unsigned int *)t45);
    *((unsigned int *)t45) = (t53 & 255U);
    t54 = *((unsigned int *)t46);
    *((unsigned int *)t46) = (t54 & 255U);
    t55 = (t1 + 5280);
    xsi_vlogfile_fwrite(*((unsigned int *)t14), 0, 0, 1, ng1, 5, t55, (char)118, t15, 8, (char)118, t25, 8, (char)118, t35, 8, (char)118, t45, 8);
    goto LAB8;

}

static int sp_select_file(char *t1, char *t2)
{
    char t5[8];
    char t9[8];
    int t0;
    char *t3;
    char *t4;
    char *t6;
    char *t7;
    char *t8;
    char *t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;
    char *t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    int t34;
    int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    char *t42;
    int t43;
    char *t44;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 5712);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(523, ng0);

LAB5:    xsi_set_current_line(524, ng0);
    t6 = (t1 + 12184);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    xsi_vlog_bit_copy(t5, 0, t8, 0, 32);
    *((int *)t9) = xsi_vlog_valueplusarg(ng20, -1, 2, t1, (char)118, t5, 32);
    t10 = (t9 + 4);
    *((int *)t10) = 0;
    t11 = (t1 + 12184);
    xsi_vlogvar_assign_value(t11, t5, 0, 0, 32);
    xsi_set_current_line(525, ng0);
    t4 = (t1 + 12184);
    t6 = (t4 + 56U);
    t7 = *((char **)t6);
    t8 = ((char*)((ng7)));
    memset(t5, 0, 8);
    xsi_vlog_unsigned_rshift(t5, 32, t7, 32, t8, 32);
    t10 = ((char*)((ng21)));
    t12 = *((unsigned int *)t5);
    t13 = *((unsigned int *)t10);
    t14 = (t12 & t13);
    *((unsigned int *)t9) = t14;
    t11 = (t5 + 4);
    t15 = (t10 + 4);
    t16 = (t9 + 4);
    t17 = *((unsigned int *)t11);
    t18 = *((unsigned int *)t15);
    t19 = (t17 | t18);
    *((unsigned int *)t16) = t19;
    t20 = *((unsigned int *)t16);
    t21 = (t20 != 0);
    if (t21 == 1)
        goto LAB6;

LAB7:
LAB8:    t42 = (t1 + 12024);
    xsi_vlogvar_assign_value(t42, t9, 0, 0, 17);
    xsi_set_current_line(526, ng0);
    t4 = (t1 + 12184);
    t6 = (t4 + 56U);
    t7 = *((char **)t6);
    t8 = ((char*)((ng22)));
    t12 = *((unsigned int *)t7);
    t13 = *((unsigned int *)t8);
    t14 = (t12 & t13);
    *((unsigned int *)t5) = t14;
    t10 = (t7 + 4);
    t11 = (t8 + 4);
    t15 = (t5 + 4);
    t17 = *((unsigned int *)t10);
    t18 = *((unsigned int *)t11);
    t19 = (t17 | t18);
    *((unsigned int *)t15) = t19;
    t20 = *((unsigned int *)t15);
    t21 = (t20 != 0);
    if (t21 == 1)
        goto LAB71;

LAB72:
LAB73:
LAB9:    t25 = ((char*)((ng11)));
    t43 = xsi_vlog_unsigned_case_compare(t5, 32, t25, 32);
    if (t43 == 1)
        goto LAB10;

LAB11:    t4 = ((char*)((ng10)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB12;

LAB13:    t4 = ((char*)((ng27)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB14;

LAB15:    t4 = ((char*)((ng30)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB16;

LAB17:    t4 = ((char*)((ng33)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB18;

LAB19:    t4 = ((char*)((ng36)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB20;

LAB21:    t4 = ((char*)((ng39)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB22;

LAB23:    t4 = ((char*)((ng42)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB24;

LAB25:    t4 = ((char*)((ng45)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB26;

LAB27:    t4 = ((char*)((ng48)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB28;

LAB29:    t4 = ((char*)((ng51)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB30;

LAB31:    t4 = ((char*)((ng54)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB32;

LAB33:    t4 = ((char*)((ng57)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB34;

LAB35:    t4 = ((char*)((ng60)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB36;

LAB37:    t4 = ((char*)((ng63)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB38;

LAB39:    t4 = ((char*)((ng66)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB40;

LAB41:    t4 = ((char*)((ng69)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB42;

LAB43:    t4 = ((char*)((ng72)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB44;

LAB45:    t4 = ((char*)((ng75)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB46;

LAB47:    t4 = ((char*)((ng78)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB48;

LAB49:    t4 = ((char*)((ng81)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB50;

LAB51:    t4 = ((char*)((ng84)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB52;

LAB53:    t4 = ((char*)((ng87)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB54;

LAB55:    t4 = ((char*)((ng90)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB56;

LAB57:    t4 = ((char*)((ng93)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB58;

LAB59:    t4 = ((char*)((ng96)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB60;

LAB61:    t4 = ((char*)((ng99)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB62;

LAB63:    t4 = ((char*)((ng102)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB64;

LAB65:    t4 = ((char*)((ng105)));
    t34 = xsi_vlog_unsigned_case_compare(t5, 32, t4, 32);
    if (t34 == 1)
        goto LAB66;

LAB67:
LAB69:
LAB68:    xsi_set_current_line(656, ng0);

LAB103:    xsi_set_current_line(657, ng0);
    t4 = ((char*)((ng108)));
    t6 = (t1 + 11704);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    xsi_set_current_line(658, ng0);
    t4 = ((char*)((ng109)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);

LAB70:
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB6:    t22 = *((unsigned int *)t9);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t9) = (t22 | t23);
    t24 = (t5 + 4);
    t25 = (t10 + 4);
    t26 = *((unsigned int *)t5);
    t27 = (~(t26));
    t28 = *((unsigned int *)t24);
    t29 = (~(t28));
    t30 = *((unsigned int *)t10);
    t31 = (~(t30));
    t32 = *((unsigned int *)t25);
    t33 = (~(t32));
    t34 = (t27 & t29);
    t35 = (t31 & t33);
    t36 = (~(t34));
    t37 = (~(t35));
    t38 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t38 & t36);
    t39 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t39 & t37);
    t40 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t40 & t36);
    t41 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t41 & t37);
    goto LAB8;

LAB10:    xsi_set_current_line(540, ng0);

LAB74:    xsi_set_current_line(541, ng0);
    t42 = ((char*)((ng23)));
    t44 = (t1 + 11704);
    xsi_vlogvar_assign_value(t44, t42, 0, 0, 1024);
    xsi_set_current_line(542, ng0);
    t4 = ((char*)((ng24)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB12:    xsi_set_current_line(544, ng0);

LAB75:    xsi_set_current_line(545, ng0);
    t6 = ((char*)((ng25)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(546, ng0);
    t4 = ((char*)((ng26)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB14:    xsi_set_current_line(548, ng0);

LAB76:    xsi_set_current_line(549, ng0);
    t6 = ((char*)((ng28)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(550, ng0);
    t4 = ((char*)((ng29)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB16:    xsi_set_current_line(552, ng0);

LAB77:    xsi_set_current_line(553, ng0);
    t6 = ((char*)((ng31)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(554, ng0);
    t4 = ((char*)((ng32)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB18:    xsi_set_current_line(556, ng0);

LAB78:    xsi_set_current_line(557, ng0);
    t6 = ((char*)((ng34)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(558, ng0);
    t4 = ((char*)((ng35)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB20:    xsi_set_current_line(560, ng0);

LAB79:    xsi_set_current_line(561, ng0);
    t6 = ((char*)((ng37)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(562, ng0);
    t4 = ((char*)((ng38)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB22:    xsi_set_current_line(564, ng0);

LAB80:    xsi_set_current_line(565, ng0);
    t6 = ((char*)((ng40)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(566, ng0);
    t4 = ((char*)((ng41)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB24:    xsi_set_current_line(568, ng0);

LAB81:    xsi_set_current_line(569, ng0);
    t6 = ((char*)((ng43)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(570, ng0);
    t4 = ((char*)((ng44)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB26:    xsi_set_current_line(572, ng0);

LAB82:    xsi_set_current_line(573, ng0);
    t6 = ((char*)((ng46)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(574, ng0);
    t4 = ((char*)((ng47)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB28:    xsi_set_current_line(576, ng0);

LAB83:    xsi_set_current_line(577, ng0);
    t6 = ((char*)((ng49)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(578, ng0);
    t4 = ((char*)((ng50)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB30:    xsi_set_current_line(580, ng0);

LAB84:    xsi_set_current_line(581, ng0);
    t6 = ((char*)((ng52)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(582, ng0);
    t4 = ((char*)((ng53)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB32:    xsi_set_current_line(584, ng0);

LAB85:    xsi_set_current_line(585, ng0);
    t6 = ((char*)((ng55)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(586, ng0);
    t4 = ((char*)((ng56)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB34:    xsi_set_current_line(588, ng0);

LAB86:    xsi_set_current_line(589, ng0);
    t6 = ((char*)((ng58)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(590, ng0);
    t4 = ((char*)((ng59)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB36:    xsi_set_current_line(592, ng0);

LAB87:    xsi_set_current_line(593, ng0);
    t6 = ((char*)((ng61)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(594, ng0);
    t4 = ((char*)((ng62)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB38:    xsi_set_current_line(596, ng0);

LAB88:    xsi_set_current_line(597, ng0);
    t6 = ((char*)((ng64)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(598, ng0);
    t4 = ((char*)((ng65)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB40:    xsi_set_current_line(600, ng0);

LAB89:    xsi_set_current_line(601, ng0);
    t6 = ((char*)((ng67)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(602, ng0);
    t4 = ((char*)((ng68)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB42:    xsi_set_current_line(604, ng0);

LAB90:    xsi_set_current_line(605, ng0);
    t6 = ((char*)((ng70)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(606, ng0);
    t4 = ((char*)((ng71)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB44:    xsi_set_current_line(608, ng0);

LAB91:    xsi_set_current_line(609, ng0);
    t6 = ((char*)((ng73)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(610, ng0);
    t4 = ((char*)((ng74)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB46:    xsi_set_current_line(612, ng0);

LAB92:    xsi_set_current_line(613, ng0);
    t6 = ((char*)((ng76)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(614, ng0);
    t4 = ((char*)((ng77)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB48:    xsi_set_current_line(616, ng0);

LAB93:    xsi_set_current_line(617, ng0);
    t6 = ((char*)((ng79)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(618, ng0);
    t4 = ((char*)((ng80)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB50:    xsi_set_current_line(620, ng0);

LAB94:    xsi_set_current_line(621, ng0);
    t6 = ((char*)((ng82)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(622, ng0);
    t4 = ((char*)((ng83)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB52:    xsi_set_current_line(624, ng0);

LAB95:    xsi_set_current_line(625, ng0);
    t6 = ((char*)((ng85)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(626, ng0);
    t4 = ((char*)((ng86)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB54:    xsi_set_current_line(628, ng0);

LAB96:    xsi_set_current_line(629, ng0);
    t6 = ((char*)((ng88)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(630, ng0);
    t4 = ((char*)((ng89)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB56:    xsi_set_current_line(632, ng0);

LAB97:    xsi_set_current_line(633, ng0);
    t6 = ((char*)((ng91)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(634, ng0);
    t4 = ((char*)((ng92)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB58:    xsi_set_current_line(636, ng0);

LAB98:    xsi_set_current_line(637, ng0);
    t6 = ((char*)((ng94)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(638, ng0);
    t4 = ((char*)((ng95)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB60:    xsi_set_current_line(640, ng0);

LAB99:    xsi_set_current_line(641, ng0);
    t6 = ((char*)((ng97)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(642, ng0);
    t4 = ((char*)((ng98)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB62:    xsi_set_current_line(644, ng0);

LAB100:    xsi_set_current_line(645, ng0);
    t6 = ((char*)((ng100)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(646, ng0);
    t4 = ((char*)((ng101)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB64:    xsi_set_current_line(648, ng0);

LAB101:    xsi_set_current_line(649, ng0);
    t6 = ((char*)((ng103)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(650, ng0);
    t4 = ((char*)((ng104)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB66:    xsi_set_current_line(652, ng0);

LAB102:    xsi_set_current_line(653, ng0);
    t6 = ((char*)((ng106)));
    t7 = (t1 + 11704);
    xsi_vlogvar_assign_value(t7, t6, 0, 0, 1024);
    xsi_set_current_line(654, ng0);
    t4 = ((char*)((ng107)));
    t6 = (t1 + 11864);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 1024);
    goto LAB70;

LAB71:    t22 = *((unsigned int *)t5);
    t23 = *((unsigned int *)t15);
    *((unsigned int *)t5) = (t22 | t23);
    t16 = (t7 + 4);
    t24 = (t8 + 4);
    t26 = *((unsigned int *)t7);
    t27 = (~(t26));
    t28 = *((unsigned int *)t16);
    t29 = (~(t28));
    t30 = *((unsigned int *)t8);
    t31 = (~(t30));
    t32 = *((unsigned int *)t24);
    t33 = (~(t32));
    t34 = (t27 & t29);
    t35 = (t31 & t33);
    t36 = (~(t34));
    t37 = (~(t35));
    t38 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t38 & t36);
    t39 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t39 & t37);
    t40 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t40 & t36);
    t41 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t41 & t37);
    goto LAB73;

}

static void Initial_258_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;

LAB0:    t1 = (t0 + 13104U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(258, ng0);

LAB4:    xsi_set_current_line(260, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 8344);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(261, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 8504);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(262, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 8664);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(263, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 8824);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(264, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 8984);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(265, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 9144);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(266, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 9304);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(267, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 9464);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(268, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 9624);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(269, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 9784);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 17);
    xsi_set_current_line(270, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 9944);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(271, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 10104);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(272, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 11544);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(285, ng0);
    t2 = (t0 + 12912);
    xsi_process_wait(t2, 8000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(285, ng0);
    t3 = ((char*)((ng9)));
    t4 = (t0 + 8504);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    xsi_set_current_line(286, ng0);
    t2 = (t0 + 12912);
    xsi_process_wait(t2, 8000LL);
    *((char **)t1) = &&LAB6;
    goto LAB1;

LAB6:    xsi_set_current_line(286, ng0);
    t3 = ((char*)((ng14)));
    t4 = (t0 + 8504);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    goto LAB1;

}

static void Always_290_1(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    char *t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    unsigned int t27;
    unsigned int t28;
    char *t29;
    unsigned int t30;
    unsigned int t31;
    char *t32;
    char *t33;
    char *t34;

LAB0:    t1 = (t0 + 13352U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(290, ng0);
    t2 = (t0 + 8344);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    memset(t3, 0, 8);
    t6 = (t5 + 4);
    t7 = *((unsigned int *)t6);
    t8 = (~(t7));
    t9 = *((unsigned int *)t5);
    t10 = (t9 & t8);
    t11 = (t10 & 1U);
    if (t11 != 0)
        goto LAB7;

LAB5:    if (*((unsigned int *)t6) == 0)
        goto LAB4;

LAB6:    t12 = (t3 + 4);
    *((unsigned int *)t3) = 1;
    *((unsigned int *)t12) = 1;

LAB7:    t13 = (t3 + 4);
    t14 = (t5 + 4);
    t15 = *((unsigned int *)t5);
    t16 = (~(t15));
    *((unsigned int *)t3) = t16;
    *((unsigned int *)t13) = 0;
    if (*((unsigned int *)t14) != 0)
        goto LAB9;

LAB8:    t21 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t21 & 1U);
    t22 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t22 & 1U);
    t23 = (t0 + 17844);
    memset(t23, 0, 8);
    t24 = 1U;
    t25 = t24;
    t26 = (t3 + 4);
    t27 = *((unsigned int *)t3);
    t24 = (t24 & t27);
    t28 = *((unsigned int *)t26);
    t25 = (t25 & t28);
    t29 = (t23 + 4);
    t30 = *((unsigned int *)t23);
    *((unsigned int *)t23) = (t30 | t24);
    t31 = *((unsigned int *)t29);
    *((unsigned int *)t29) = (t31 | t25);
    t32 = (t0 + 13160);
    xsi_process_wait(t32, 2000LL);
    *((char **)t1) = &&LAB10;

LAB1:    return;
LAB4:    *((unsigned int *)t3) = 1;
    goto LAB7;

LAB9:    t17 = *((unsigned int *)t3);
    t18 = *((unsigned int *)t14);
    *((unsigned int *)t3) = (t17 | t18);
    t19 = *((unsigned int *)t13);
    t20 = *((unsigned int *)t14);
    *((unsigned int *)t13) = (t19 | t20);
    goto LAB8;

LAB10:    t33 = (t0 + 17844);
    t34 = (t0 + 8344);
    xsi_vlogvar_assign_value(t34, t33, 0, 0, 1);
    goto LAB2;

}

static void Initial_293_2(char *t0)
{
    char t18[8];
    char t29[16];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    int t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    double t30;
    double t31;

LAB0:    t1 = (t0 + 13600U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(294, ng0);

LAB4:    xsi_set_current_line(295, ng0);
    t2 = (t0 + 13408);
    xsi_process_wait(t2, 500000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(298, ng0);
    t2 = (t0 + 13408);
    t3 = (t0 + 5712);
    t4 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t4);

LAB8:    t5 = (t0 + 13504);
    t6 = *((char **)t5);
    t7 = (t6 + 80U);
    t8 = *((char **)t7);
    t9 = (t8 + 272U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    t12 = *((char **)t11);
    t13 = ((int  (*)(char *, char *))t12)(t0, t6);

LAB10:    if (t13 != 0)
        goto LAB11;

LAB6:    t6 = (t0 + 5712);
    xsi_vlog_subprogram_popinvocation(t6);

LAB7:    t14 = (t0 + 13504);
    t15 = *((char **)t14);
    t14 = (t0 + 5712);
    t16 = (t0 + 13408);
    t17 = 0;
    xsi_delete_subprogram_invocation(t14, t15, t0, t16, t17);
    xsi_set_current_line(301, ng0);
    t2 = (t0 + 13408);
    t3 = (t0 + 3552);
    t4 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t4);

LAB14:    t5 = (t0 + 13504);
    t6 = *((char **)t5);
    t7 = (t6 + 80U);
    t8 = *((char **)t7);
    t9 = (t8 + 272U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    t12 = *((char **)t11);
    t13 = ((int  (*)(char *, char *))t12)(t0, t6);

LAB16:    if (t13 != 0)
        goto LAB17;

LAB12:    t6 = (t0 + 3552);
    xsi_vlog_subprogram_popinvocation(t6);

LAB13:    t14 = (t0 + 13504);
    t15 = *((char **)t14);
    t14 = (t0 + 3552);
    t16 = (t0 + 13408);
    t17 = 0;
    xsi_delete_subprogram_invocation(t14, t15, t0, t16, t17);
    xsi_set_current_line(302, ng0);
    t2 = (t0 + 13408);
    t3 = (t0 + 1824);
    t4 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t4);

LAB20:    t5 = (t0 + 13504);
    t6 = *((char **)t5);
    t7 = (t6 + 80U);
    t8 = *((char **)t7);
    t9 = (t8 + 272U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    t12 = *((char **)t11);
    t13 = ((int  (*)(char *, char *))t12)(t0, t6);

LAB22:    if (t13 != 0)
        goto LAB23;

LAB18:    t6 = (t0 + 1824);
    xsi_vlog_subprogram_popinvocation(t6);

LAB19:    t14 = (t0 + 13504);
    t15 = *((char **)t14);
    t14 = (t0 + 1824);
    t16 = (t0 + 13408);
    t17 = 0;
    xsi_delete_subprogram_invocation(t14, t15, t0, t16, t17);
    xsi_set_current_line(304, ng0);
    t2 = (t0 + 11704);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    *((int *)t18) = xsi_vlogfile_file_open_of_valname_ctype(t4, 1024, ng13);
    t5 = (t18 + 4);
    *((int *)t5) = 0;
    t6 = (t0 + 10904);
    xsi_vlogvar_assign_value(t6, t18, 0, 0, 32);
    xsi_set_current_line(305, ng0);
    t2 = (t0 + 11864);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    *((int *)t18) = xsi_vlogfile_file_open_of_valname_ctype(t4, 1024, ng110);
    t5 = (t18 + 4);
    *((int *)t5) = 0;
    t6 = (t0 + 11064);
    xsi_vlogvar_assign_value(t6, t18, 0, 0, 32);
    xsi_set_current_line(308, ng0);
    t2 = (t0 + 11064);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    xsi_vlogfile_fclose(*((unsigned int *)t4));
    xsi_set_current_line(310, ng0);
    t2 = (t0 + 13408);
    t3 = (t0 + 2688);
    t4 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t4);

LAB26:    t5 = (t0 + 13504);
    t6 = *((char **)t5);
    t7 = (t6 + 80U);
    t8 = *((char **)t7);
    t9 = (t8 + 272U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    t12 = *((char **)t11);
    t13 = ((int  (*)(char *, char *))t12)(t0, t6);

LAB28:    if (t13 != 0)
        goto LAB29;

LAB24:    t6 = (t0 + 2688);
    xsi_vlog_subprogram_popinvocation(t6);

LAB25:    t14 = (t0 + 13504);
    t15 = *((char **)t14);
    t14 = (t0 + 2688);
    t16 = (t0 + 13408);
    t17 = 0;
    xsi_delete_subprogram_invocation(t14, t15, t0, t16, t17);
    xsi_set_current_line(311, ng0);
    t2 = (t0 + 13408);
    t3 = (t0 + 3120);
    t4 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t4);

LAB32:    t5 = (t0 + 13504);
    t6 = *((char **)t5);
    t7 = (t6 + 80U);
    t8 = *((char **)t7);
    t9 = (t8 + 272U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    t12 = *((char **)t11);
    t13 = ((int  (*)(char *, char *))t12)(t0, t6);

LAB34:    if (t13 != 0)
        goto LAB35;

LAB30:    t6 = (t0 + 3120);
    xsi_vlog_subprogram_popinvocation(t6);

LAB31:    t14 = (t0 + 13504);
    t15 = *((char **)t14);
    t14 = (t0 + 3120);
    t16 = (t0 + 13408);
    t17 = 0;
    xsi_delete_subprogram_invocation(t14, t15, t0, t16, t17);
    xsi_set_current_line(313, ng0);
    t2 = ((char*)((ng9)));
    t3 = (t0 + 10264);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(314, ng0);

LAB36:    t2 = (t0 + 10264);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 10744);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memset(t18, 0, 8);
    xsi_vlog_signed_less(t18, 32, t4, 32, t7, 32);
    t8 = (t18 + 4);
    t19 = *((unsigned int *)t8);
    t20 = (~(t19));
    t21 = *((unsigned int *)t18);
    t22 = (t21 & t20);
    t23 = (t22 != 0);
    if (t23 > 0)
        goto LAB37;

LAB38:    xsi_set_current_line(335, ng0);
    t2 = ((char*)((ng11)));
    t3 = (t0 + 8664);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(336, ng0);
    t2 = ((char*)((ng11)));
    t3 = (t0 + 8824);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(338, ng0);

LAB72:    t2 = (t0 + 7464U);
    t3 = *((char **)t2);
    memset(t18, 0, 8);
    t2 = (t3 + 4);
    t19 = *((unsigned int *)t2);
    t20 = (~(t19));
    t21 = *((unsigned int *)t3);
    t22 = (t21 & t20);
    t23 = (t22 & 1U);
    if (t23 != 0)
        goto LAB76;

LAB74:    if (*((unsigned int *)t2) == 0)
        goto LAB73;

LAB75:    t4 = (t18 + 4);
    *((unsigned int *)t18) = 1;
    *((unsigned int *)t4) = 1;

LAB76:    t5 = (t18 + 4);
    t24 = *((unsigned int *)t5);
    t25 = (~(t24));
    t26 = *((unsigned int *)t18);
    t27 = (t26 & t25);
    t28 = (t27 != 0);
    if (t28 > 0)
        goto LAB77;

LAB78:    xsi_set_current_line(349, ng0);
    t2 = (t0 + 13408);
    t3 = (t0 + 4416);
    t4 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t4);

LAB93:    t5 = (t0 + 13504);
    t6 = *((char **)t5);
    t7 = (t6 + 80U);
    t8 = *((char **)t7);
    t9 = (t8 + 272U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    t12 = *((char **)t11);
    t13 = ((int  (*)(char *, char *))t12)(t0, t6);

LAB95:    if (t13 != 0)
        goto LAB96;

LAB91:    t6 = (t0 + 4416);
    xsi_vlog_subprogram_popinvocation(t6);

LAB92:    t14 = (t0 + 13504);
    t15 = *((char **)t14);
    t14 = (t0 + 4416);
    t16 = (t0 + 13408);
    t17 = 0;
    xsi_delete_subprogram_invocation(t14, t15, t0, t16, t17);
    xsi_set_current_line(350, ng0);
    t2 = (t0 + 13408);
    t3 = (t0 + 4848);
    t4 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t4);

LAB99:    t5 = (t0 + 13504);
    t6 = *((char **)t5);
    t7 = (t6 + 80U);
    t8 = *((char **)t7);
    t9 = (t8 + 272U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    t12 = *((char **)t11);
    t13 = ((int  (*)(char *, char *))t12)(t0, t6);

LAB101:    if (t13 != 0)
        goto LAB102;

LAB97:    t6 = (t0 + 4848);
    xsi_vlog_subprogram_popinvocation(t6);

LAB98:    t14 = (t0 + 13504);
    t15 = *((char **)t14);
    t14 = (t0 + 4848);
    t16 = (t0 + 13408);
    t17 = 0;
    xsi_delete_subprogram_invocation(t14, t15, t0, t16, t17);
    xsi_set_current_line(351, ng0);
    t2 = (t0 + 10744);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = xsi_vlog_time(t29, 1000.0000000000000, 1000.0000000000000);
    t30 = xsi_vlog_convert_to_real(t29, 64, 2);
    t31 = (t30 / 1000.0000000000000);
    *((double *)t18) = t31;
    xsi_vlogfile_write(1, 0, 0, ng113, 3, t0, (char)119, t4, 32, (char)114, t18, 64);
    xsi_set_current_line(358, ng0);
    t2 = (t0 + 13408);
    xsi_process_wait(t2, 80000LL);
    *((char **)t1) = &&LAB103;
    goto LAB1;

LAB9:;
LAB11:    t5 = (t0 + 13600U);
    *((char **)t5) = &&LAB8;
    goto LAB1;

LAB15:;
LAB17:    t5 = (t0 + 13600U);
    *((char **)t5) = &&LAB14;
    goto LAB1;

LAB21:;
LAB23:    t5 = (t0 + 13600U);
    *((char **)t5) = &&LAB20;
    goto LAB1;

LAB27:;
LAB29:    t5 = (t0 + 13600U);
    *((char **)t5) = &&LAB26;
    goto LAB1;

LAB33:;
LAB35:    t5 = (t0 + 13600U);
    *((char **)t5) = &&LAB32;
    goto LAB1;

LAB37:    xsi_set_current_line(315, ng0);

LAB39:    xsi_set_current_line(316, ng0);
    t9 = (t0 + 7304U);
    t10 = *((char **)t9);
    t9 = (t10 + 4);
    t24 = *((unsigned int *)t9);
    t25 = (~(t24));
    t26 = *((unsigned int *)t10);
    t27 = (t26 & t25);
    t28 = (t27 != 0);
    if (t28 > 0)
        goto LAB40;

LAB41:
LAB42:    xsi_set_current_line(322, ng0);

LAB50:    t2 = (t0 + 6344U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t19 = *((unsigned int *)t2);
    t20 = (~(t19));
    t21 = *((unsigned int *)t3);
    t22 = (t21 & t20);
    t23 = (t22 != 0);
    if (t23 > 0)
        goto LAB51;

LAB52:    xsi_set_current_line(332, ng0);
    t2 = (t0 + 13408);
    t3 = (t0 + 1392);
    t4 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t4);

LAB67:    t5 = (t0 + 13504);
    t6 = *((char **)t5);
    t7 = (t6 + 80U);
    t8 = *((char **)t7);
    t9 = (t8 + 272U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    t12 = *((char **)t11);
    t13 = ((int  (*)(char *, char *))t12)(t0, t6);

LAB69:    if (t13 != 0)
        goto LAB70;

LAB65:    t6 = (t0 + 1392);
    xsi_vlog_subprogram_popinvocation(t6);

LAB66:    t14 = (t0 + 13504);
    t15 = *((char **)t14);
    t14 = (t0 + 1392);
    t16 = (t0 + 13408);
    t17 = 0;
    xsi_delete_subprogram_invocation(t14, t15, t0, t16, t17);
    xsi_set_current_line(333, ng0);
    t2 = (t0 + 13408);
    xsi_process_wait(t2, 4000LL);
    *((char **)t1) = &&LAB71;
    goto LAB1;

LAB40:    xsi_set_current_line(317, ng0);

LAB43:    xsi_set_current_line(318, ng0);
    t11 = ((char*)((ng11)));
    t12 = (t0 + 8824);
    xsi_vlogvar_assign_value(t12, t11, 0, 0, 1);
    xsi_set_current_line(319, ng0);
    xsi_vlogfile_write(1, 0, 0, ng111, 1, t0);
    xsi_set_current_line(320, ng0);
    t2 = (t0 + 13408);
    t3 = (t0 + 3984);
    t4 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t4);

LAB46:    t5 = (t0 + 13504);
    t6 = *((char **)t5);
    t7 = (t6 + 80U);
    t8 = *((char **)t7);
    t9 = (t8 + 272U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    t12 = *((char **)t11);
    t13 = ((int  (*)(char *, char *))t12)(t0, t6);

LAB48:    if (t13 != 0)
        goto LAB49;

LAB44:    t6 = (t0 + 3984);
    xsi_vlog_subprogram_popinvocation(t6);

LAB45:    t14 = (t0 + 13504);
    t15 = *((char **)t14);
    t14 = (t0 + 3984);
    t16 = (t0 + 13408);
    t17 = 0;
    xsi_delete_subprogram_invocation(t14, t15, t0, t16, t17);
    goto LAB42;

LAB47:;
LAB49:    t5 = (t0 + 13600U);
    *((char **)t5) = &&LAB46;
    goto LAB1;

LAB51:    xsi_set_current_line(323, ng0);

LAB53:    xsi_set_current_line(324, ng0);
    t4 = ((char*)((ng11)));
    t5 = (t0 + 8824);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(325, ng0);
    t2 = (t0 + 7304U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t19 = *((unsigned int *)t2);
    t20 = (~(t19));
    t21 = *((unsigned int *)t3);
    t22 = (t21 & t20);
    t23 = (t22 != 0);
    if (t23 > 0)
        goto LAB54;

LAB55:
LAB56:    xsi_set_current_line(330, ng0);
    t2 = (t0 + 13408);
    xsi_process_wait(t2, 4000LL);
    *((char **)t1) = &&LAB64;
    goto LAB1;

LAB54:    xsi_set_current_line(326, ng0);

LAB57:    xsi_set_current_line(327, ng0);
    xsi_vlogfile_write(1, 0, 0, ng111, 1, t0);
    xsi_set_current_line(328, ng0);
    t2 = (t0 + 13408);
    t3 = (t0 + 3984);
    t4 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t4);

LAB60:    t5 = (t0 + 13504);
    t6 = *((char **)t5);
    t7 = (t6 + 80U);
    t8 = *((char **)t7);
    t9 = (t8 + 272U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    t12 = *((char **)t11);
    t13 = ((int  (*)(char *, char *))t12)(t0, t6);

LAB62:    if (t13 != 0)
        goto LAB63;

LAB58:    t6 = (t0 + 3984);
    xsi_vlog_subprogram_popinvocation(t6);

LAB59:    t14 = (t0 + 13504);
    t15 = *((char **)t14);
    t14 = (t0 + 3984);
    t16 = (t0 + 13408);
    t17 = 0;
    xsi_delete_subprogram_invocation(t14, t15, t0, t16, t17);
    goto LAB56;

LAB61:;
LAB63:    t5 = (t0 + 13600U);
    *((char **)t5) = &&LAB60;
    goto LAB1;

LAB64:    goto LAB50;

LAB68:;
LAB70:    t5 = (t0 + 13600U);
    *((char **)t5) = &&LAB67;
    goto LAB1;

LAB71:    xsi_set_current_line(333, ng0);
    t3 = (t0 + 10264);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    t6 = ((char*)((ng112)));
    memset(t18, 0, 8);
    xsi_vlog_signed_add(t18, 32, t5, 32, t6, 32);
    t7 = (t0 + 10264);
    xsi_vlogvar_assign_value(t7, t18, 0, 0, 32);
    goto LAB36;

LAB73:    *((unsigned int *)t18) = 1;
    goto LAB76;

LAB77:    xsi_set_current_line(339, ng0);

LAB79:    xsi_set_current_line(340, ng0);
    t6 = (t0 + 13408);
    xsi_process_wait(t6, 4000LL);
    *((char **)t1) = &&LAB80;
    goto LAB1;

LAB80:    xsi_set_current_line(342, ng0);
    t2 = (t0 + 7304U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t19 = *((unsigned int *)t2);
    t20 = (~(t19));
    t21 = *((unsigned int *)t3);
    t22 = (t21 & t20);
    t23 = (t22 != 0);
    if (t23 > 0)
        goto LAB81;

LAB82:
LAB83:    goto LAB72;

LAB81:    xsi_set_current_line(343, ng0);

LAB84:    xsi_set_current_line(344, ng0);
    xsi_vlogfile_write(1, 0, 0, ng111, 1, t0);
    xsi_set_current_line(345, ng0);
    t2 = (t0 + 13408);
    t3 = (t0 + 3984);
    t4 = xsi_create_subprogram_invocation(t2, 0, t0, t3, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t3, t4);

LAB87:    t5 = (t0 + 13504);
    t6 = *((char **)t5);
    t7 = (t6 + 80U);
    t8 = *((char **)t7);
    t9 = (t8 + 272U);
    t10 = *((char **)t9);
    t11 = (t10 + 0U);
    t12 = *((char **)t11);
    t13 = ((int  (*)(char *, char *))t12)(t0, t6);

LAB89:    if (t13 != 0)
        goto LAB90;

LAB85:    t6 = (t0 + 3984);
    xsi_vlog_subprogram_popinvocation(t6);

LAB86:    t14 = (t0 + 13504);
    t15 = *((char **)t14);
    t14 = (t0 + 3984);
    t16 = (t0 + 13408);
    t17 = 0;
    xsi_delete_subprogram_invocation(t14, t15, t0, t16, t17);
    goto LAB83;

LAB88:;
LAB90:    t5 = (t0 + 13600U);
    *((char **)t5) = &&LAB87;
    goto LAB1;

LAB94:;
LAB96:    t5 = (t0 + 13600U);
    *((char **)t5) = &&LAB93;
    goto LAB1;

LAB100:;
LAB102:    t5 = (t0 + 13600U);
    *((char **)t5) = &&LAB99;
    goto LAB1;

LAB103:    xsi_set_current_line(359, ng0);
    *((int *)t18) = xsi_vlogfile_file_open_of_cname_ctype(ng114, ng16);
    t2 = (t18 + 4);
    *((int *)t2) = 0;
    t3 = (t0 + 11384);
    xsi_vlogvar_assign_value(t3, t18, 0, 0, 32);
    xsi_set_current_line(360, ng0);
    t2 = (t0 + 11384);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 11704);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = xsi_vlog_time(t29, 1000.0000000000000, 1000.0000000000000);
    t30 = xsi_vlog_convert_to_real(t29, 64, 2);
    t31 = (t30 / 1000.0000000000000);
    *((double *)t18) = t31;
    xsi_vlogfile_fwrite(*((unsigned int *)t4), 0, 0, 1, ng115, 3, t0, (char)118, t7, 1024, (char)114, t18, 64);
    xsi_set_current_line(361, ng0);
    t2 = (t0 + 11384);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    xsi_vlogfile_fclose(*((unsigned int *)t4));
    xsi_set_current_line(364, ng0);
    t2 = (t0 + 13408);
    xsi_process_wait(t2, 40000LL);
    *((char **)t1) = &&LAB104;
    goto LAB1;

LAB104:    xsi_set_current_line(365, ng0);
    xsi_vlog_stop(1);
    goto LAB1;

}


extern void work_m_00000000002207370685_2387727278_init()
{
	static char *pe[] = {(void *)Initial_258_0,(void *)Always_290_1,(void *)Initial_293_2};
	static char *se[] = {(void *)sp_read_4B_src,(void *)sp_compress_test_start,(void *)sp_compress_test_done,(void *)sp_file_length_init,(void *)sp_max_stat_init,(void *)sp_file_length_calc,(void *)sp_write_16kbytes,(void *)sp_write_last_block,(void *)sp_write_length,(void *)sp_feedback_test_file,(void *)sp_select_file};
	xsi_register_didat("work_m_00000000002207370685_2387727278", "isim/mix_compression_top_tb_isim_beh.exe.sim/work/m_00000000002207370685_2387727278.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
