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
static const char *ng0 = "F:/LZ4/mix_compress/mix_compress_v1/RTL_huffman/compare_unit.v";



static void Always_28_0(char *t0)
{
    char t4[8];
    char t14[8];
    char t24[8];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t15;
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
    char *t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    char *t34;
    char *t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    char *t48;
    char *t49;

LAB0:    t1 = (t0 + 2528U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(28, ng0);
    t2 = (t0 + 2848);
    *((int *)t2) = 1;
    t3 = (t0 + 2560);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(29, ng0);

LAB5:    xsi_set_current_line(30, ng0);
    t5 = (t0 + 1048U);
    t6 = *((char **)t5);
    memset(t4, 0, 8);
    t5 = (t4 + 4);
    t7 = (t6 + 4);
    t8 = *((unsigned int *)t6);
    t9 = (t8 >> 0);
    *((unsigned int *)t4) = t9;
    t10 = *((unsigned int *)t7);
    t11 = (t10 >> 0);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t12 & 134217727U);
    t13 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t13 & 134217727U);
    t15 = (t0 + 1208U);
    t16 = *((char **)t15);
    memset(t14, 0, 8);
    t15 = (t14 + 4);
    t17 = (t16 + 4);
    t18 = *((unsigned int *)t16);
    t19 = (t18 >> 0);
    *((unsigned int *)t14) = t19;
    t20 = *((unsigned int *)t17);
    t21 = (t20 >> 0);
    *((unsigned int *)t15) = t21;
    t22 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t22 & 134217727U);
    t23 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t23 & 134217727U);
    memset(t24, 0, 8);
    t25 = (t4 + 4);
    if (*((unsigned int *)t25) != 0)
        goto LAB7;

LAB6:    t26 = (t14 + 4);
    if (*((unsigned int *)t26) != 0)
        goto LAB7;

LAB10:    if (*((unsigned int *)t4) > *((unsigned int *)t14))
        goto LAB8;

LAB9:    t28 = (t24 + 4);
    t29 = *((unsigned int *)t28);
    t30 = (~(t29));
    t31 = *((unsigned int *)t24);
    t32 = (t31 & t30);
    t33 = (t32 != 0);
    if (t33 > 0)
        goto LAB11;

LAB12:    xsi_set_current_line(32, ng0);
    t2 = (t0 + 1048U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4);
    t5 = (t3 + 4);
    t8 = *((unsigned int *)t3);
    t9 = (t8 >> 0);
    *((unsigned int *)t4) = t9;
    t10 = *((unsigned int *)t5);
    t11 = (t10 >> 0);
    *((unsigned int *)t2) = t11;
    t12 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t12 & 134217727U);
    t13 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t13 & 134217727U);
    t6 = (t0 + 1208U);
    t7 = *((char **)t6);
    memset(t14, 0, 8);
    t6 = (t14 + 4);
    t15 = (t7 + 4);
    t18 = *((unsigned int *)t7);
    t19 = (t18 >> 0);
    *((unsigned int *)t14) = t19;
    t20 = *((unsigned int *)t15);
    t21 = (t20 >> 0);
    *((unsigned int *)t6) = t21;
    t22 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t22 & 134217727U);
    t23 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t23 & 134217727U);
    memset(t24, 0, 8);
    t16 = (t4 + 4);
    if (*((unsigned int *)t16) != 0)
        goto LAB15;

LAB14:    t17 = (t14 + 4);
    if (*((unsigned int *)t17) != 0)
        goto LAB15;

LAB18:    if (*((unsigned int *)t4) < *((unsigned int *)t14))
        goto LAB16;

LAB17:    t26 = (t24 + 4);
    t29 = *((unsigned int *)t26);
    t30 = (~(t29));
    t31 = *((unsigned int *)t24);
    t32 = (t31 & t30);
    t33 = (t32 != 0);
    if (t33 > 0)
        goto LAB19;

LAB20:    xsi_set_current_line(35, ng0);

LAB22:    xsi_set_current_line(36, ng0);
    t2 = (t0 + 1048U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4);
    t5 = (t3 + 4);
    t8 = *((unsigned int *)t3);
    t9 = (t8 >> 27);
    *((unsigned int *)t4) = t9;
    t10 = *((unsigned int *)t5);
    t11 = (t10 >> 27);
    *((unsigned int *)t2) = t11;
    t6 = (t3 + 8);
    t7 = (t3 + 12);
    t12 = *((unsigned int *)t6);
    t13 = (t12 << 5);
    t18 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t18 | t13);
    t19 = *((unsigned int *)t7);
    t20 = (t19 << 5);
    t21 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t21 | t20);
    t22 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t22 & 511U);
    t23 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t23 & 511U);
    t15 = (t0 + 1208U);
    t16 = *((char **)t15);
    memset(t14, 0, 8);
    t15 = (t14 + 4);
    t17 = (t16 + 4);
    t29 = *((unsigned int *)t16);
    t30 = (t29 >> 27);
    *((unsigned int *)t14) = t30;
    t31 = *((unsigned int *)t17);
    t32 = (t31 >> 27);
    *((unsigned int *)t15) = t32;
    t25 = (t16 + 8);
    t26 = (t16 + 12);
    t33 = *((unsigned int *)t25);
    t36 = (t33 << 5);
    t37 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t37 | t36);
    t38 = *((unsigned int *)t26);
    t39 = (t38 << 5);
    t40 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t40 | t39);
    t41 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t41 & 511U);
    t42 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t42 & 511U);
    memset(t24, 0, 8);
    t27 = (t4 + 4);
    if (*((unsigned int *)t27) != 0)
        goto LAB24;

LAB23:    t28 = (t14 + 4);
    if (*((unsigned int *)t28) != 0)
        goto LAB24;

LAB27:    if (*((unsigned int *)t4) > *((unsigned int *)t14))
        goto LAB25;

LAB26:    t35 = (t24 + 4);
    t43 = *((unsigned int *)t35);
    t44 = (~(t43));
    t45 = *((unsigned int *)t24);
    t46 = (t45 & t44);
    t47 = (t46 != 0);
    if (t47 > 0)
        goto LAB28;

LAB29:    xsi_set_current_line(39, ng0);
    t2 = (t0 + 1048U);
    t3 = *((char **)t2);
    t2 = (t0 + 1608);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 36);

LAB30:
LAB21:
LAB13:    goto LAB2;

LAB7:    t27 = (t24 + 4);
    *((unsigned int *)t24) = 1;
    *((unsigned int *)t27) = 1;
    goto LAB9;

LAB8:    *((unsigned int *)t24) = 1;
    goto LAB9;

LAB11:    xsi_set_current_line(31, ng0);
    t34 = (t0 + 1208U);
    t35 = *((char **)t34);
    t34 = (t0 + 1608);
    xsi_vlogvar_assign_value(t34, t35, 0, 0, 36);
    goto LAB13;

LAB15:    t25 = (t24 + 4);
    *((unsigned int *)t24) = 1;
    *((unsigned int *)t25) = 1;
    goto LAB17;

LAB16:    *((unsigned int *)t24) = 1;
    goto LAB17;

LAB19:    xsi_set_current_line(33, ng0);
    t27 = (t0 + 1048U);
    t28 = *((char **)t27);
    t27 = (t0 + 1608);
    xsi_vlogvar_assign_value(t27, t28, 0, 0, 36);
    goto LAB21;

LAB24:    t34 = (t24 + 4);
    *((unsigned int *)t24) = 1;
    *((unsigned int *)t34) = 1;
    goto LAB26;

LAB25:    *((unsigned int *)t24) = 1;
    goto LAB26;

LAB28:    xsi_set_current_line(37, ng0);
    t48 = (t0 + 1208U);
    t49 = *((char **)t48);
    t48 = (t0 + 1608);
    xsi_vlogvar_assign_value(t48, t49, 0, 0, 36);
    goto LAB30;

}


extern void work_m_00000000001723441669_0895723785_init()
{
	static char *pe[] = {(void *)Always_28_0};
	xsi_register_didat("work_m_00000000001723441669_0895723785", "isim/mix_compression_top_tb_isim_beh.exe.sim/work/m_00000000001723441669_0895723785.didat");
	xsi_register_executes(pe);
}
