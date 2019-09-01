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
static const char *ng0 = "F:/LZ4/mix_compress/mix_compress_v1/RTL_lz4/shifter_96bit_v3.v";
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {0U, 0U, 0U, 0U};
static unsigned int ng3[] = {1U, 0U};
static unsigned int ng4[] = {2U, 0U};
static unsigned int ng5[] = {3U, 0U};
static unsigned int ng6[] = {4U, 0U};
static unsigned int ng7[] = {5U, 0U};
static unsigned int ng8[] = {6U, 0U};
static unsigned int ng9[] = {7U, 0U};
static unsigned int ng10[] = {8U, 0U};
static unsigned int ng11[] = {0U, 0U, 0U, 0U, 0U, 0U};



static int sp_GLUE(char *t1, char *t2)
{
    char t8[24];
    char t14[8];
    char t25[16];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int t7;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t15;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;

LAB0:    t0 = 1;
    xsi_set_current_line(48, ng0);
    t3 = (t1 + 3800);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);

LAB2:    t6 = ((char*)((ng1)));
    t7 = xsi_vlog_unsigned_case_compare(t5, 4, t6, 4);
    if (t7 == 1)
        goto LAB3;

LAB4:    t3 = ((char*)((ng3)));
    t7 = xsi_vlog_unsigned_case_compare(t5, 4, t3, 4);
    if (t7 == 1)
        goto LAB5;

LAB6:    t3 = ((char*)((ng4)));
    t7 = xsi_vlog_unsigned_case_compare(t5, 4, t3, 4);
    if (t7 == 1)
        goto LAB7;

LAB8:    t3 = ((char*)((ng5)));
    t7 = xsi_vlog_unsigned_case_compare(t5, 4, t3, 4);
    if (t7 == 1)
        goto LAB9;

LAB10:    t3 = ((char*)((ng6)));
    t7 = xsi_vlog_unsigned_case_compare(t5, 4, t3, 4);
    if (t7 == 1)
        goto LAB11;

LAB12:    t3 = ((char*)((ng7)));
    t7 = xsi_vlog_unsigned_case_compare(t5, 4, t3, 4);
    if (t7 == 1)
        goto LAB13;

LAB14:    t3 = ((char*)((ng8)));
    t7 = xsi_vlog_unsigned_case_compare(t5, 4, t3, 4);
    if (t7 == 1)
        goto LAB15;

LAB16:    t3 = ((char*)((ng9)));
    t7 = xsi_vlog_unsigned_case_compare(t5, 4, t3, 4);
    if (t7 == 1)
        goto LAB17;

LAB18:    t3 = ((char*)((ng10)));
    t7 = xsi_vlog_unsigned_case_compare(t5, 4, t3, 4);
    if (t7 == 1)
        goto LAB19;

LAB20:
LAB22:
LAB21:    xsi_set_current_line(58, ng0);
    t3 = (t1 + 3480);
    t4 = (t3 + 56U);
    t6 = *((char **)t4);
    t9 = (t1 + 3320);
    xsi_vlogvar_assign_value(t9, t6, 0, 0, 96);

LAB23:    t0 = 0;

LAB1:    return t0;
LAB3:    xsi_set_current_line(49, ng0);
    t9 = ((char*)((ng2)));
    t10 = (t1 + 3640);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    xsi_vlogtype_concat(t8, 96, 96, 2U, t12, 32, t9, 64);
    t13 = (t1 + 3320);
    xsi_vlogvar_assign_value(t13, t8, 0, 0, 96);
    goto LAB23;

LAB5:    xsi_set_current_line(50, ng0);
    t4 = ((char*)((ng2)));
    t6 = (t1 + 3640);
    t9 = (t6 + 56U);
    t10 = *((char **)t9);
    t11 = (t1 + 3480);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memset(t14, 0, 8);
    t15 = (t14 + 4);
    t16 = (t13 + 16);
    t17 = (t13 + 20);
    t18 = *((unsigned int *)t16);
    t19 = (t18 >> 24);
    *((unsigned int *)t14) = t19;
    t20 = *((unsigned int *)t17);
    t21 = (t20 >> 24);
    *((unsigned int *)t15) = t21;
    t22 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t22 & 255U);
    t23 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t23 & 255U);
    xsi_vlogtype_concat(t8, 96, 96, 3U, t14, 8, t10, 32, t4, 56);
    t24 = (t1 + 3320);
    xsi_vlogvar_assign_value(t24, t8, 0, 0, 96);
    goto LAB23;

LAB7:    xsi_set_current_line(51, ng0);
    t4 = ((char*)((ng2)));
    t6 = (t1 + 3640);
    t9 = (t6 + 56U);
    t10 = *((char **)t9);
    t11 = (t1 + 3480);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memset(t14, 0, 8);
    t15 = (t14 + 4);
    t16 = (t13 + 16);
    t17 = (t13 + 20);
    t18 = *((unsigned int *)t16);
    t19 = (t18 >> 16);
    *((unsigned int *)t14) = t19;
    t20 = *((unsigned int *)t17);
    t21 = (t20 >> 16);
    *((unsigned int *)t15) = t21;
    t22 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t22 & 65535U);
    t23 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t23 & 65535U);
    xsi_vlogtype_concat(t8, 96, 96, 3U, t14, 16, t10, 32, t4, 48);
    t24 = (t1 + 3320);
    xsi_vlogvar_assign_value(t24, t8, 0, 0, 96);
    goto LAB23;

LAB9:    xsi_set_current_line(52, ng0);
    t4 = ((char*)((ng2)));
    t6 = (t1 + 3640);
    t9 = (t6 + 56U);
    t10 = *((char **)t9);
    t11 = (t1 + 3480);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memset(t14, 0, 8);
    t15 = (t14 + 4);
    t16 = (t13 + 16);
    t17 = (t13 + 20);
    t18 = *((unsigned int *)t16);
    t19 = (t18 >> 8);
    *((unsigned int *)t14) = t19;
    t20 = *((unsigned int *)t17);
    t21 = (t20 >> 8);
    *((unsigned int *)t15) = t21;
    t22 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t22 & 16777215U);
    t23 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t23 & 16777215U);
    xsi_vlogtype_concat(t8, 96, 96, 3U, t14, 24, t10, 32, t4, 40);
    t24 = (t1 + 3320);
    xsi_vlogvar_assign_value(t24, t8, 0, 0, 96);
    goto LAB23;

LAB11:    xsi_set_current_line(53, ng0);
    t4 = ((char*)((ng1)));
    t6 = (t1 + 3640);
    t9 = (t6 + 56U);
    t10 = *((char **)t9);
    t11 = (t1 + 3480);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memset(t14, 0, 8);
    t15 = (t14 + 4);
    t16 = (t13 + 16);
    t17 = (t13 + 20);
    t18 = *((unsigned int *)t16);
    t19 = (t18 >> 0);
    *((unsigned int *)t14) = t19;
    t20 = *((unsigned int *)t17);
    t21 = (t20 >> 0);
    *((unsigned int *)t15) = t21;
    t22 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t22 & 4294967295U);
    t23 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t23 & 4294967295U);
    xsi_vlogtype_concat(t8, 96, 96, 3U, t14, 32, t10, 32, t4, 32);
    t24 = (t1 + 3320);
    xsi_vlogvar_assign_value(t24, t8, 0, 0, 96);
    goto LAB23;

LAB13:    xsi_set_current_line(54, ng0);
    t4 = ((char*)((ng1)));
    t6 = (t1 + 3640);
    t9 = (t6 + 56U);
    t10 = *((char **)t9);
    t11 = (t1 + 3480);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    xsi_vlog_get_part_select_value(t25, 40, t13, 95, 56);
    xsi_vlogtype_concat(t8, 96, 96, 3U, t25, 40, t10, 32, t4, 24);
    t15 = (t1 + 3320);
    xsi_vlogvar_assign_value(t15, t8, 0, 0, 96);
    goto LAB23;

LAB15:    xsi_set_current_line(55, ng0);
    t4 = ((char*)((ng1)));
    t6 = (t1 + 3640);
    t9 = (t6 + 56U);
    t10 = *((char **)t9);
    t11 = (t1 + 3480);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    xsi_vlog_get_part_select_value(t25, 48, t13, 95, 48);
    xsi_vlogtype_concat(t8, 96, 96, 3U, t25, 48, t10, 32, t4, 16);
    t15 = (t1 + 3320);
    xsi_vlogvar_assign_value(t15, t8, 0, 0, 96);
    goto LAB23;

LAB17:    xsi_set_current_line(56, ng0);
    t4 = ((char*)((ng1)));
    t6 = (t1 + 3640);
    t9 = (t6 + 56U);
    t10 = *((char **)t9);
    t11 = (t1 + 3480);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    xsi_vlog_get_part_select_value(t25, 56, t13, 95, 40);
    xsi_vlogtype_concat(t8, 96, 96, 3U, t25, 56, t10, 32, t4, 8);
    t15 = (t1 + 3320);
    xsi_vlogvar_assign_value(t15, t8, 0, 0, 96);
    goto LAB23;

LAB19:    xsi_set_current_line(57, ng0);
    t4 = (t1 + 3640);
    t6 = (t4 + 56U);
    t9 = *((char **)t6);
    t10 = (t1 + 3480);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    xsi_vlog_get_part_select_value(t25, 64, t12, 95, 32);
    xsi_vlogtype_concat(t8, 96, 96, 2U, t25, 64, t9, 32);
    t13 = (t1 + 3320);
    xsi_vlogvar_assign_value(t13, t8, 0, 0, 96);
    goto LAB23;

}

static void Cont_63_0(char *t0)
{
    char t3[16];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;

LAB0:    t1 = (t0 + 4720U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(63, ng0);
    t2 = (t0 + 3160);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_vlog_get_part_select_value(t3, 56, t5, 95, 40);
    t6 = (t0 + 5648);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    xsi_vlog_bit_copy(t10, 0, t3, 0, 56);
    xsi_driver_vfirst_trans(t6, 0, 55);
    t11 = (t0 + 5536);
    *((int *)t11) = 1;

LAB1:    return;
}

static void Cont_65_1(char *t0)
{
    char t3[8];
    char t4[8];
    char t8[8];
    char *t1;
    char *t2;
    char *t5;
    char *t6;
    char *t7;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    char *t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    unsigned int t34;
    unsigned int t35;
    char *t36;
    unsigned int t37;
    unsigned int t38;
    char *t39;
    unsigned int t40;
    unsigned int t41;
    char *t42;

LAB0:    t1 = (t0 + 4968U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(65, ng0);
    t2 = (t0 + 3000);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    t7 = ((char*)((ng9)));
    memset(t8, 0, 8);
    t9 = (t6 + 4);
    if (*((unsigned int *)t9) != 0)
        goto LAB5;

LAB4:    t10 = (t7 + 4);
    if (*((unsigned int *)t10) != 0)
        goto LAB5;

LAB8:    if (*((unsigned int *)t6) < *((unsigned int *)t7))
        goto LAB6;

LAB7:    memset(t4, 0, 8);
    t12 = (t8 + 4);
    t13 = *((unsigned int *)t12);
    t14 = (~(t13));
    t15 = *((unsigned int *)t8);
    t16 = (t15 & t14);
    t17 = (t16 & 1U);
    if (t17 != 0)
        goto LAB9;

LAB10:    if (*((unsigned int *)t12) != 0)
        goto LAB11;

LAB12:    t19 = (t4 + 4);
    t20 = *((unsigned int *)t4);
    t21 = *((unsigned int *)t19);
    t22 = (t20 || t21);
    if (t22 > 0)
        goto LAB13;

LAB14:    t24 = *((unsigned int *)t4);
    t25 = (~(t24));
    t26 = *((unsigned int *)t19);
    t27 = (t25 || t26);
    if (t27 > 0)
        goto LAB15;

LAB16:    if (*((unsigned int *)t19) > 0)
        goto LAB17;

LAB18:    if (*((unsigned int *)t4) > 0)
        goto LAB19;

LAB20:    memcpy(t3, t28, 8);

LAB21:    t29 = (t0 + 5712);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    memset(t33, 0, 8);
    t34 = 1U;
    t35 = t34;
    t36 = (t3 + 4);
    t37 = *((unsigned int *)t3);
    t34 = (t34 & t37);
    t38 = *((unsigned int *)t36);
    t35 = (t35 & t38);
    t39 = (t33 + 4);
    t40 = *((unsigned int *)t33);
    *((unsigned int *)t33) = (t40 | t34);
    t41 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t41 | t35);
    xsi_driver_vfirst_trans(t29, 0, 0);
    t42 = (t0 + 5552);
    *((int *)t42) = 1;

LAB1:    return;
LAB5:    t11 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t11) = 1;
    goto LAB7;

LAB6:    *((unsigned int *)t8) = 1;
    goto LAB7;

LAB9:    *((unsigned int *)t4) = 1;
    goto LAB12;

LAB11:    t18 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t18) = 1;
    goto LAB12;

LAB13:    t23 = ((char*)((ng3)));
    goto LAB14;

LAB15:    t28 = ((char*)((ng1)));
    goto LAB16;

LAB17:    xsi_vlog_unsigned_bit_combine(t3, 1, t23, 1, t28, 1);
    goto LAB21;

LAB19:    memcpy(t3, t23, 8);
    goto LAB21;

}

static void Always_71_2(char *t0)
{
    char t4[8];
    char t23[24];
    char t24[24];
    char t25[8];
    char t26[16];
    char t52[24];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    char *t20;
    int t21;
    int t22;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;
    char *t36;
    char *t37;
    char *t38;
    char *t39;
    char *t40;
    char *t41;
    char *t42;
    char *t43;
    char *t44;
    char *t45;
    char *t46;
    char *t47;
    int t48;
    char *t49;
    char *t50;
    char *t51;
    char *t53;

LAB0:    t1 = (t0 + 5216U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(71, ng0);
    t2 = (t0 + 5568);
    *((int *)t2) = 1;
    t3 = (t0 + 5248);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(72, ng0);

LAB5:    xsi_set_current_line(73, ng0);
    t5 = (t0 + 1640U);
    t6 = *((char **)t5);
    memset(t4, 0, 8);
    t5 = (t6 + 4);
    t7 = *((unsigned int *)t5);
    t8 = (~(t7));
    t9 = *((unsigned int *)t6);
    t10 = (t9 & t8);
    t11 = (t10 & 1U);
    if (t11 != 0)
        goto LAB9;

LAB7:    if (*((unsigned int *)t5) == 0)
        goto LAB6;

LAB8:    t12 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t12) = 1;

LAB9:    t13 = (t4 + 4);
    t14 = *((unsigned int *)t13);
    t15 = (~(t14));
    t16 = *((unsigned int *)t4);
    t17 = (t16 & t15);
    t18 = (t17 != 0);
    if (t18 > 0)
        goto LAB10;

LAB11:    xsi_set_current_line(79, ng0);

LAB14:    xsi_set_current_line(80, ng0);
    t2 = (t0 + 2120U);
    t3 = *((char **)t2);
    t2 = (t0 + 2280U);
    t5 = *((char **)t2);
    xsi_vlogtype_concat(t4, 2, 2, 2U, t5, 1, t3, 1);

LAB15:    t2 = ((char*)((ng1)));
    t21 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t21 == 1)
        goto LAB16;

LAB17:    t2 = ((char*)((ng3)));
    t21 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t21 == 1)
        goto LAB18;

LAB19:    t2 = ((char*)((ng4)));
    t21 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t21 == 1)
        goto LAB20;

LAB21:    t2 = ((char*)((ng5)));
    t21 = xsi_vlog_unsigned_case_compare(t4, 2, t2, 2);
    if (t21 == 1)
        goto LAB22;

LAB23:
LAB25:
LAB24:    xsi_set_current_line(141, ng0);

LAB86:    xsi_set_current_line(142, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t12 = *((char **)t3);
    t13 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t13, t12, 0, 0, 4, 0LL);
    xsi_set_current_line(143, ng0);
    t2 = (t0 + 3160);
    t3 = (t2 + 56U);
    t12 = *((char **)t3);
    t13 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t13, t12, 0, 0, 96, 0LL);

LAB26:
LAB12:    goto LAB2;

LAB6:    *((unsigned int *)t4) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(74, ng0);

LAB13:    xsi_set_current_line(75, ng0);
    t19 = ((char*)((ng11)));
    t20 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, 0, 96, 0LL);
    xsi_set_current_line(76, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    goto LAB12;

LAB16:    xsi_set_current_line(81, ng0);

LAB27:    xsi_set_current_line(82, ng0);
    t6 = (t0 + 3160);
    t12 = (t6 + 56U);
    t13 = *((char **)t12);
    t19 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t19, t13, 0, 0, 96, 0LL);
    xsi_set_current_line(83, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 4, 0LL);
    goto LAB26;

LAB18:    xsi_set_current_line(85, ng0);

LAB28:    xsi_set_current_line(86, ng0);
    t3 = (t0 + 1960U);
    t5 = *((char **)t3);

LAB29:    t3 = ((char*)((ng3)));
    t22 = xsi_vlog_unsigned_case_compare(t5, 3, t3, 3);
    if (t22 == 1)
        goto LAB30;

LAB31:    t2 = ((char*)((ng4)));
    t21 = xsi_vlog_unsigned_case_compare(t5, 3, t2, 3);
    if (t21 == 1)
        goto LAB32;

LAB33:    t2 = ((char*)((ng5)));
    t21 = xsi_vlog_unsigned_case_compare(t5, 3, t2, 3);
    if (t21 == 1)
        goto LAB34;

LAB35:    t2 = ((char*)((ng6)));
    t21 = xsi_vlog_unsigned_case_compare(t5, 3, t2, 3);
    if (t21 == 1)
        goto LAB36;

LAB37:
LAB39:
LAB38:    xsi_set_current_line(103, ng0);

LAB45:    xsi_set_current_line(104, ng0);
    t2 = (t0 + 3160);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t12, t6, 0, 0, 96, 0LL);
    xsi_set_current_line(105, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t12, t6, 0, 0, 4, 0LL);

LAB40:    goto LAB26;

LAB20:    xsi_set_current_line(109, ng0);

LAB46:    xsi_set_current_line(110, ng0);
    t3 = (t0 + 3000);
    t6 = (t3 + 56U);
    t12 = *((char **)t6);
    t13 = ((char*)((ng6)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_add(t25, 4, t12, 4, t13, 4);
    t19 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t19, t25, 0, 0, 4, 0LL);
    xsi_set_current_line(111, ng0);
    t2 = (t0 + 3160);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = (t0 + 1800U);
    t13 = *((char **)t12);
    t12 = (t0 + 3000);
    t19 = (t12 + 56U);
    t20 = *((char **)t19);
    t27 = (t0 + 5024);
    t28 = (t0 + 848);
    t29 = xsi_create_subprogram_invocation(t27, 0, t0, t28, 0, 0);
    t30 = (t0 + 3480);
    xsi_vlogvar_assign_value(t30, t6, 0, 0, 96);
    t31 = (t0 + 3640);
    xsi_vlogvar_assign_value(t31, t13, 0, 0, 32);
    t32 = (t0 + 3800);
    xsi_vlogvar_assign_value(t32, t20, 0, 0, 4);

LAB47:    t33 = (t0 + 5120);
    t34 = *((char **)t33);
    t35 = (t34 + 80U);
    t36 = *((char **)t35);
    t37 = (t36 + 272U);
    t38 = *((char **)t37);
    t39 = (t38 + 0U);
    t40 = *((char **)t39);
    t21 = ((int  (*)(char *, char *))t40)(t0, t34);
    if (t21 != 0)
        goto LAB49;

LAB48:    t34 = (t0 + 5120);
    t41 = *((char **)t34);
    t34 = (t0 + 3320);
    t42 = (t34 + 56U);
    t43 = *((char **)t42);
    memcpy(t23, t43, 24);
    t44 = (t0 + 848);
    t45 = (t0 + 5024);
    t46 = 0;
    xsi_delete_subprogram_invocation(t44, t41, t0, t45, t46);
    t47 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t47, t23, 0, 0, 96, 0LL);
    goto LAB26;

LAB22:    xsi_set_current_line(113, ng0);

LAB50:    xsi_set_current_line(114, ng0);
    t3 = (t0 + 1960U);
    t6 = *((char **)t3);

LAB51:    t3 = ((char*)((ng1)));
    t22 = xsi_vlog_unsigned_case_compare(t6, 3, t3, 3);
    if (t22 == 1)
        goto LAB52;

LAB53:    t2 = ((char*)((ng3)));
    t21 = xsi_vlog_unsigned_case_compare(t6, 3, t2, 3);
    if (t21 == 1)
        goto LAB54;

LAB55:    t2 = ((char*)((ng4)));
    t21 = xsi_vlog_unsigned_case_compare(t6, 3, t2, 3);
    if (t21 == 1)
        goto LAB56;

LAB57:    t2 = ((char*)((ng5)));
    t21 = xsi_vlog_unsigned_case_compare(t6, 3, t2, 3);
    if (t21 == 1)
        goto LAB58;

LAB59:    t2 = ((char*)((ng6)));
    t21 = xsi_vlog_unsigned_case_compare(t6, 3, t2, 3);
    if (t21 == 1)
        goto LAB60;

LAB61:
LAB63:
LAB62:    xsi_set_current_line(135, ng0);

LAB85:    xsi_set_current_line(136, ng0);
    t2 = (t0 + 3160);
    t3 = (t2 + 56U);
    t12 = *((char **)t3);
    t13 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t13, t12, 0, 0, 96, 0LL);
    xsi_set_current_line(137, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t12 = *((char **)t3);
    t13 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t13, t12, 0, 0, 4, 0LL);

LAB64:    goto LAB26;

LAB30:    xsi_set_current_line(87, ng0);

LAB41:    xsi_set_current_line(88, ng0);
    t6 = ((char*)((ng1)));
    t12 = (t0 + 3160);
    t13 = (t12 + 56U);
    t19 = *((char **)t13);
    xsi_vlog_get_part_select_value(t24, 88, t19, 87, 0);
    xsi_vlogtype_concat(t23, 96, 96, 2U, t24, 88, t6, 8);
    t20 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t20, t23, 0, 0, 96, 0LL);
    xsi_set_current_line(89, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = ((char*)((ng3)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_minus(t25, 4, t6, 4, t12, 4);
    t13 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t13, t25, 0, 0, 4, 0LL);
    goto LAB40;

LAB32:    xsi_set_current_line(91, ng0);

LAB42:    xsi_set_current_line(92, ng0);
    t3 = ((char*)((ng1)));
    t6 = (t0 + 3160);
    t12 = (t6 + 56U);
    t13 = *((char **)t12);
    xsi_vlog_get_part_select_value(t24, 80, t13, 79, 0);
    xsi_vlogtype_concat(t23, 96, 96, 2U, t24, 80, t3, 16);
    t19 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t19, t23, 0, 0, 96, 0LL);
    xsi_set_current_line(93, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = ((char*)((ng4)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_minus(t25, 4, t6, 4, t12, 4);
    t13 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t13, t25, 0, 0, 4, 0LL);
    goto LAB40;

LAB34:    xsi_set_current_line(95, ng0);

LAB43:    xsi_set_current_line(96, ng0);
    t3 = ((char*)((ng1)));
    t6 = (t0 + 3160);
    t12 = (t6 + 56U);
    t13 = *((char **)t12);
    xsi_vlog_get_part_select_value(t24, 72, t13, 71, 0);
    xsi_vlogtype_concat(t23, 96, 96, 2U, t24, 72, t3, 24);
    t19 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t19, t23, 0, 0, 96, 0LL);
    xsi_set_current_line(97, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = ((char*)((ng5)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_minus(t25, 4, t6, 4, t12, 4);
    t13 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t13, t25, 0, 0, 4, 0LL);
    goto LAB40;

LAB36:    xsi_set_current_line(99, ng0);

LAB44:    xsi_set_current_line(100, ng0);
    t3 = ((char*)((ng1)));
    t6 = (t0 + 3160);
    t12 = (t6 + 56U);
    t13 = *((char **)t12);
    xsi_vlog_get_part_select_value(t26, 64, t13, 63, 0);
    xsi_vlogtype_concat(t23, 96, 96, 2U, t26, 64, t3, 32);
    t19 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t19, t23, 0, 0, 96, 0LL);
    xsi_set_current_line(101, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = ((char*)((ng6)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_minus(t25, 4, t6, 4, t12, 4);
    t13 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t13, t25, 0, 0, 4, 0LL);
    goto LAB40;

LAB49:    t33 = (t0 + 5216U);
    *((char **)t33) = &&LAB47;
    goto LAB1;

LAB52:    xsi_set_current_line(115, ng0);

LAB65:    xsi_set_current_line(116, ng0);
    t12 = (t0 + 3160);
    t13 = (t12 + 56U);
    t19 = *((char **)t13);
    t20 = (t0 + 1800U);
    t27 = *((char **)t20);
    t20 = (t0 + 3000);
    t28 = (t20 + 56U);
    t29 = *((char **)t28);
    t30 = (t0 + 5024);
    t31 = (t0 + 848);
    t32 = xsi_create_subprogram_invocation(t30, 0, t0, t31, 0, 0);
    t33 = (t0 + 3480);
    xsi_vlogvar_assign_value(t33, t19, 0, 0, 96);
    t34 = (t0 + 3640);
    xsi_vlogvar_assign_value(t34, t27, 0, 0, 32);
    t35 = (t0 + 3800);
    xsi_vlogvar_assign_value(t35, t29, 0, 0, 4);

LAB66:    t36 = (t0 + 5120);
    t37 = *((char **)t36);
    t38 = (t37 + 80U);
    t39 = *((char **)t38);
    t40 = (t39 + 272U);
    t41 = *((char **)t40);
    t42 = (t41 + 0U);
    t43 = *((char **)t42);
    t48 = ((int  (*)(char *, char *))t43)(t0, t37);
    if (t48 != 0)
        goto LAB68;

LAB67:    t37 = (t0 + 5120);
    t44 = *((char **)t37);
    t37 = (t0 + 3320);
    t45 = (t37 + 56U);
    t46 = *((char **)t45);
    memcpy(t23, t46, 24);
    t47 = (t0 + 848);
    t49 = (t0 + 5024);
    t50 = 0;
    xsi_delete_subprogram_invocation(t47, t44, t0, t49, t50);
    t51 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t51, t23, 0, 0, 96, 0LL);
    xsi_set_current_line(117, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t12 = *((char **)t3);
    t13 = ((char*)((ng6)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_add(t25, 4, t12, 4, t13, 4);
    t19 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t19, t25, 0, 0, 4, 0LL);
    goto LAB64;

LAB54:    xsi_set_current_line(119, ng0);

LAB69:    xsi_set_current_line(120, ng0);
    t3 = ((char*)((ng1)));
    t12 = (t0 + 3160);
    t13 = (t12 + 56U);
    t19 = *((char **)t13);
    xsi_vlog_get_part_select_value(t24, 88, t19, 87, 0);
    xsi_vlogtype_concat(t23, 96, 96, 2U, t24, 88, t3, 8);
    t20 = (t0 + 1800U);
    t27 = *((char **)t20);
    t20 = (t0 + 3000);
    t28 = (t20 + 56U);
    t29 = *((char **)t28);
    t30 = ((char*)((ng3)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_minus(t25, 4, t29, 4, t30, 4);
    t31 = (t0 + 5024);
    t32 = (t0 + 848);
    t33 = xsi_create_subprogram_invocation(t31, 0, t0, t32, 0, 0);
    t34 = (t0 + 3480);
    xsi_vlogvar_assign_value(t34, t23, 0, 0, 96);
    t35 = (t0 + 3640);
    xsi_vlogvar_assign_value(t35, t27, 0, 0, 32);
    t36 = (t0 + 3800);
    xsi_vlogvar_assign_value(t36, t25, 0, 0, 4);

LAB70:    t37 = (t0 + 5120);
    t38 = *((char **)t37);
    t39 = (t38 + 80U);
    t40 = *((char **)t39);
    t41 = (t40 + 272U);
    t42 = *((char **)t41);
    t43 = (t42 + 0U);
    t44 = *((char **)t43);
    t22 = ((int  (*)(char *, char *))t44)(t0, t38);
    if (t22 != 0)
        goto LAB72;

LAB71:    t38 = (t0 + 5120);
    t45 = *((char **)t38);
    t38 = (t0 + 3320);
    t46 = (t38 + 56U);
    t47 = *((char **)t46);
    memcpy(t52, t47, 24);
    t49 = (t0 + 848);
    t50 = (t0 + 5024);
    t51 = 0;
    xsi_delete_subprogram_invocation(t49, t45, t0, t50, t51);
    t53 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t53, t52, 0, 0, 96, 0LL);
    xsi_set_current_line(121, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t12 = *((char **)t3);
    t13 = ((char*)((ng5)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_add(t25, 4, t12, 4, t13, 4);
    t19 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t19, t25, 0, 0, 4, 0LL);
    goto LAB64;

LAB56:    xsi_set_current_line(123, ng0);

LAB73:    xsi_set_current_line(124, ng0);
    t3 = ((char*)((ng1)));
    t12 = (t0 + 3160);
    t13 = (t12 + 56U);
    t19 = *((char **)t13);
    xsi_vlog_get_part_select_value(t24, 80, t19, 79, 0);
    xsi_vlogtype_concat(t23, 96, 96, 2U, t24, 80, t3, 16);
    t20 = (t0 + 1800U);
    t27 = *((char **)t20);
    t20 = (t0 + 3000);
    t28 = (t20 + 56U);
    t29 = *((char **)t28);
    t30 = ((char*)((ng4)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_minus(t25, 4, t29, 4, t30, 4);
    t31 = (t0 + 5024);
    t32 = (t0 + 848);
    t33 = xsi_create_subprogram_invocation(t31, 0, t0, t32, 0, 0);
    t34 = (t0 + 3480);
    xsi_vlogvar_assign_value(t34, t23, 0, 0, 96);
    t35 = (t0 + 3640);
    xsi_vlogvar_assign_value(t35, t27, 0, 0, 32);
    t36 = (t0 + 3800);
    xsi_vlogvar_assign_value(t36, t25, 0, 0, 4);

LAB74:    t37 = (t0 + 5120);
    t38 = *((char **)t37);
    t39 = (t38 + 80U);
    t40 = *((char **)t39);
    t41 = (t40 + 272U);
    t42 = *((char **)t41);
    t43 = (t42 + 0U);
    t44 = *((char **)t43);
    t22 = ((int  (*)(char *, char *))t44)(t0, t38);
    if (t22 != 0)
        goto LAB76;

LAB75:    t38 = (t0 + 5120);
    t45 = *((char **)t38);
    t38 = (t0 + 3320);
    t46 = (t38 + 56U);
    t47 = *((char **)t46);
    memcpy(t52, t47, 24);
    t49 = (t0 + 848);
    t50 = (t0 + 5024);
    t51 = 0;
    xsi_delete_subprogram_invocation(t49, t45, t0, t50, t51);
    t53 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t53, t52, 0, 0, 96, 0LL);
    xsi_set_current_line(125, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t12 = *((char **)t3);
    t13 = ((char*)((ng4)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_add(t25, 4, t12, 4, t13, 4);
    t19 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t19, t25, 0, 0, 4, 0LL);
    goto LAB64;

LAB58:    xsi_set_current_line(127, ng0);

LAB77:    xsi_set_current_line(128, ng0);
    t3 = ((char*)((ng1)));
    t12 = (t0 + 3160);
    t13 = (t12 + 56U);
    t19 = *((char **)t13);
    xsi_vlog_get_part_select_value(t24, 72, t19, 71, 0);
    xsi_vlogtype_concat(t23, 96, 96, 2U, t24, 72, t3, 24);
    t20 = (t0 + 1800U);
    t27 = *((char **)t20);
    t20 = (t0 + 3000);
    t28 = (t20 + 56U);
    t29 = *((char **)t28);
    t30 = ((char*)((ng5)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_minus(t25, 4, t29, 4, t30, 4);
    t31 = (t0 + 5024);
    t32 = (t0 + 848);
    t33 = xsi_create_subprogram_invocation(t31, 0, t0, t32, 0, 0);
    t34 = (t0 + 3480);
    xsi_vlogvar_assign_value(t34, t23, 0, 0, 96);
    t35 = (t0 + 3640);
    xsi_vlogvar_assign_value(t35, t27, 0, 0, 32);
    t36 = (t0 + 3800);
    xsi_vlogvar_assign_value(t36, t25, 0, 0, 4);

LAB78:    t37 = (t0 + 5120);
    t38 = *((char **)t37);
    t39 = (t38 + 80U);
    t40 = *((char **)t39);
    t41 = (t40 + 272U);
    t42 = *((char **)t41);
    t43 = (t42 + 0U);
    t44 = *((char **)t43);
    t22 = ((int  (*)(char *, char *))t44)(t0, t38);
    if (t22 != 0)
        goto LAB80;

LAB79:    t38 = (t0 + 5120);
    t45 = *((char **)t38);
    t38 = (t0 + 3320);
    t46 = (t38 + 56U);
    t47 = *((char **)t46);
    memcpy(t52, t47, 24);
    t49 = (t0 + 848);
    t50 = (t0 + 5024);
    t51 = 0;
    xsi_delete_subprogram_invocation(t49, t45, t0, t50, t51);
    t53 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t53, t52, 0, 0, 96, 0LL);
    xsi_set_current_line(129, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t12 = *((char **)t3);
    t13 = ((char*)((ng3)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_add(t25, 4, t12, 4, t13, 4);
    t19 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t19, t25, 0, 0, 4, 0LL);
    goto LAB64;

LAB60:    xsi_set_current_line(131, ng0);

LAB81:    xsi_set_current_line(132, ng0);
    t3 = ((char*)((ng1)));
    t12 = (t0 + 3160);
    t13 = (t12 + 56U);
    t19 = *((char **)t13);
    xsi_vlog_get_part_select_value(t26, 64, t19, 63, 0);
    xsi_vlogtype_concat(t23, 96, 96, 2U, t26, 64, t3, 32);
    t20 = (t0 + 1800U);
    t27 = *((char **)t20);
    t20 = (t0 + 3000);
    t28 = (t20 + 56U);
    t29 = *((char **)t28);
    t30 = ((char*)((ng6)));
    memset(t25, 0, 8);
    xsi_vlog_unsigned_minus(t25, 4, t29, 4, t30, 4);
    t31 = (t0 + 5024);
    t32 = (t0 + 848);
    t33 = xsi_create_subprogram_invocation(t31, 0, t0, t32, 0, 0);
    t34 = (t0 + 3480);
    xsi_vlogvar_assign_value(t34, t23, 0, 0, 96);
    t35 = (t0 + 3640);
    xsi_vlogvar_assign_value(t35, t27, 0, 0, 32);
    t36 = (t0 + 3800);
    xsi_vlogvar_assign_value(t36, t25, 0, 0, 4);

LAB82:    t37 = (t0 + 5120);
    t38 = *((char **)t37);
    t39 = (t38 + 80U);
    t40 = *((char **)t39);
    t41 = (t40 + 272U);
    t42 = *((char **)t41);
    t43 = (t42 + 0U);
    t44 = *((char **)t43);
    t22 = ((int  (*)(char *, char *))t44)(t0, t38);
    if (t22 != 0)
        goto LAB84;

LAB83:    t38 = (t0 + 5120);
    t45 = *((char **)t38);
    t38 = (t0 + 3320);
    t46 = (t38 + 56U);
    t47 = *((char **)t46);
    memcpy(t24, t47, 24);
    t49 = (t0 + 848);
    t50 = (t0 + 5024);
    t51 = 0;
    xsi_delete_subprogram_invocation(t49, t45, t0, t50, t51);
    t53 = (t0 + 3160);
    xsi_vlogvar_wait_assign_value(t53, t24, 0, 0, 96, 0LL);
    xsi_set_current_line(133, ng0);
    t2 = (t0 + 3000);
    t3 = (t2 + 56U);
    t12 = *((char **)t3);
    t13 = (t0 + 3000);
    xsi_vlogvar_wait_assign_value(t13, t12, 0, 0, 4, 0LL);
    goto LAB64;

LAB68:    t36 = (t0 + 5216U);
    *((char **)t36) = &&LAB66;
    goto LAB1;

LAB72:    t37 = (t0 + 5216U);
    *((char **)t37) = &&LAB70;
    goto LAB1;

LAB76:    t37 = (t0 + 5216U);
    *((char **)t37) = &&LAB74;
    goto LAB1;

LAB80:    t37 = (t0 + 5216U);
    *((char **)t37) = &&LAB78;
    goto LAB1;

LAB84:    t37 = (t0 + 5216U);
    *((char **)t37) = &&LAB82;
    goto LAB1;

}


extern void work_m_00000000001256605473_2367429755_init()
{
	static char *pe[] = {(void *)Cont_63_0,(void *)Cont_65_1,(void *)Always_71_2};
	static char *se[] = {(void *)sp_GLUE};
	xsi_register_didat("work_m_00000000001256605473_2367429755", "isim/mix_compression_top_tb_isim_beh.exe.sim/work/m_00000000001256605473_2367429755.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
