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
static const char *ng0 = "F:/LZ4/mix_compress/mix_compress_v1/RTL_huffman/code_lookup_v2.v";
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {1U, 0U};
static unsigned int ng3[] = {2U, 0U};



static void Always_68_0(char *t0)
{
    char t4[8];
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

LAB0:    t1 = (t0 + 5176U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(68, ng0);
    t2 = (t0 + 6240);
    *((int *)t2) = 1;
    t3 = (t0 + 5208);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(69, ng0);

LAB5:    xsi_set_current_line(70, ng0);
    t5 = (t0 + 1616U);
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

LAB11:    xsi_set_current_line(75, ng0);

LAB14:    xsi_set_current_line(76, ng0);
    t2 = (t0 + 3936);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 3776);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 4, 0LL);

LAB12:    goto LAB2;

LAB6:    *((unsigned int *)t4) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(71, ng0);

LAB13:    xsi_set_current_line(72, ng0);
    t19 = ((char*)((ng1)));
    t20 = (t0 + 3776);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, 0, 4, 0LL);
    goto LAB12;

}

static void Always_81_1(char *t0)
{
    char t4[8];
    char t21[8];
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
    char *t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    char *t29;
    char *t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    int t39;
    int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    char *t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    char *t53;
    char *t54;

LAB0:    t1 = (t0 + 5424U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(81, ng0);
    t2 = (t0 + 6256);
    *((int *)t2) = 1;
    t3 = (t0 + 5456);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(82, ng0);

LAB5:    xsi_set_current_line(83, ng0);
    t5 = (t0 + 1616U);
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

LAB11:    xsi_set_current_line(88, ng0);

LAB14:    xsi_set_current_line(89, ng0);
    t2 = (t0 + 4256);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 2096U);
    t12 = *((char **)t6);
    memset(t4, 0, 8);
    t6 = (t4 + 4);
    t13 = (t12 + 4);
    t7 = *((unsigned int *)t12);
    t8 = (t7 >> 15);
    t9 = (t8 & 1);
    *((unsigned int *)t4) = t9;
    t10 = *((unsigned int *)t13);
    t11 = (t10 >> 15);
    t14 = (t11 & 1);
    *((unsigned int *)t6) = t14;
    t15 = *((unsigned int *)t5);
    t16 = *((unsigned int *)t4);
    t17 = (t15 & t16);
    *((unsigned int *)t21) = t17;
    t19 = (t5 + 4);
    t20 = (t4 + 4);
    t22 = (t21 + 4);
    t18 = *((unsigned int *)t19);
    t23 = *((unsigned int *)t20);
    t24 = (t18 | t23);
    *((unsigned int *)t22) = t24;
    t25 = *((unsigned int *)t22);
    t26 = (t25 != 0);
    if (t26 == 1)
        goto LAB15;

LAB16:
LAB17:    t47 = (t21 + 4);
    t48 = *((unsigned int *)t47);
    t49 = (~(t48));
    t50 = *((unsigned int *)t21);
    t51 = (t50 & t49);
    t52 = (t51 != 0);
    if (t52 > 0)
        goto LAB18;

LAB19:    xsi_set_current_line(92, ng0);
    t2 = (t0 + 3616);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 3616);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 1, 0LL);

LAB20:
LAB12:    goto LAB2;

LAB6:    *((unsigned int *)t4) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(84, ng0);

LAB13:    xsi_set_current_line(85, ng0);
    t19 = ((char*)((ng1)));
    t20 = (t0 + 3616);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, 0, 1, 0LL);
    goto LAB12;

LAB15:    t27 = *((unsigned int *)t21);
    t28 = *((unsigned int *)t22);
    *((unsigned int *)t21) = (t27 | t28);
    t29 = (t5 + 4);
    t30 = (t4 + 4);
    t31 = *((unsigned int *)t5);
    t32 = (~(t31));
    t33 = *((unsigned int *)t29);
    t34 = (~(t33));
    t35 = *((unsigned int *)t4);
    t36 = (~(t35));
    t37 = *((unsigned int *)t30);
    t38 = (~(t37));
    t39 = (t32 & t34);
    t40 = (t36 & t38);
    t41 = (~(t39));
    t42 = (~(t40));
    t43 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t43 & t41);
    t44 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t44 & t42);
    t45 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t45 & t41);
    t46 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t46 & t42);
    goto LAB17;

LAB18:    xsi_set_current_line(90, ng0);
    t53 = ((char*)((ng2)));
    t54 = (t0 + 3616);
    xsi_vlogvar_wait_assign_value(t54, t53, 0, 0, 1, 0LL);
    goto LAB20;

}

static void Always_100_2(char *t0)
{
    char t18[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    int t8;
    char *t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    char *t17;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;

LAB0:    t1 = (t0 + 5672U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(100, ng0);
    t2 = (t0 + 6272);
    *((int *)t2) = 1;
    t3 = (t0 + 5704);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(101, ng0);

LAB5:    xsi_set_current_line(102, ng0);
    t4 = (t0 + 3776);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);

LAB6:    t7 = ((char*)((ng1)));
    t8 = xsi_vlog_unsigned_case_compare(t6, 4, t7, 4);
    if (t8 == 1)
        goto LAB7;

LAB8:    t2 = ((char*)((ng2)));
    t8 = xsi_vlog_unsigned_case_compare(t6, 4, t2, 4);
    if (t8 == 1)
        goto LAB9;

LAB10:    t2 = ((char*)((ng3)));
    t8 = xsi_vlog_unsigned_case_compare(t6, 4, t2, 4);
    if (t8 == 1)
        goto LAB11;

LAB12:
LAB14:
LAB13:    xsi_set_current_line(121, ng0);

LAB32:    xsi_set_current_line(122, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3936);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 4);

LAB15:    goto LAB2;

LAB7:    xsi_set_current_line(103, ng0);

LAB16:    xsi_set_current_line(104, ng0);
    t9 = (t0 + 1936U);
    t10 = *((char **)t9);
    t9 = (t10 + 4);
    t11 = *((unsigned int *)t9);
    t12 = (~(t11));
    t13 = *((unsigned int *)t10);
    t14 = (t13 & t12);
    t15 = (t14 != 0);
    if (t15 > 0)
        goto LAB17;

LAB18:    xsi_set_current_line(107, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3936);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 4);

LAB19:    goto LAB15;

LAB9:    xsi_set_current_line(109, ng0);

LAB20:    xsi_set_current_line(110, ng0);
    t3 = (t0 + 1936U);
    t4 = *((char **)t3);
    memset(t18, 0, 8);
    t3 = (t4 + 4);
    t11 = *((unsigned int *)t3);
    t12 = (~(t11));
    t13 = *((unsigned int *)t4);
    t14 = (t13 & t12);
    t15 = (t14 & 1U);
    if (t15 != 0)
        goto LAB24;

LAB22:    if (*((unsigned int *)t3) == 0)
        goto LAB21;

LAB23:    t5 = (t18 + 4);
    *((unsigned int *)t18) = 1;
    *((unsigned int *)t5) = 1;

LAB24:    t7 = (t18 + 4);
    t19 = *((unsigned int *)t7);
    t20 = (~(t19));
    t21 = *((unsigned int *)t18);
    t22 = (t21 & t20);
    t23 = (t22 != 0);
    if (t23 > 0)
        goto LAB25;

LAB26:    xsi_set_current_line(113, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3936);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 4);

LAB27:    goto LAB15;

LAB11:    xsi_set_current_line(115, ng0);

LAB28:    xsi_set_current_line(116, ng0);
    t3 = (t0 + 1936U);
    t4 = *((char **)t3);
    t3 = (t4 + 4);
    t11 = *((unsigned int *)t3);
    t12 = (~(t11));
    t13 = *((unsigned int *)t4);
    t14 = (t13 & t12);
    t15 = (t14 != 0);
    if (t15 > 0)
        goto LAB29;

LAB30:    xsi_set_current_line(119, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3936);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 4);

LAB31:    goto LAB15;

LAB17:    xsi_set_current_line(105, ng0);
    t16 = ((char*)((ng2)));
    t17 = (t0 + 3936);
    xsi_vlogvar_assign_value(t17, t16, 0, 0, 4);
    goto LAB19;

LAB21:    *((unsigned int *)t18) = 1;
    goto LAB24;

LAB25:    xsi_set_current_line(111, ng0);
    t9 = ((char*)((ng3)));
    t10 = (t0 + 3936);
    xsi_vlogvar_assign_value(t10, t9, 0, 0, 4);
    goto LAB27;

LAB29:    xsi_set_current_line(117, ng0);
    t5 = ((char*)((ng2)));
    t7 = (t0 + 3936);
    xsi_vlogvar_assign_value(t7, t5, 0, 0, 4);
    goto LAB31;

}

static void Always_128_3(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    int t8;
    char *t9;
    char *t10;

LAB0:    t1 = (t0 + 5920U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(128, ng0);
    t2 = (t0 + 6288);
    *((int *)t2) = 1;
    t3 = (t0 + 5952);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(129, ng0);

LAB5:    xsi_set_current_line(130, ng0);
    t4 = (t0 + 3776);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);

LAB6:    t7 = ((char*)((ng1)));
    t8 = xsi_vlog_unsigned_case_compare(t6, 4, t7, 4);
    if (t8 == 1)
        goto LAB7;

LAB8:    t2 = ((char*)((ng2)));
    t8 = xsi_vlog_unsigned_case_compare(t6, 4, t2, 4);
    if (t8 == 1)
        goto LAB9;

LAB10:    t2 = ((char*)((ng3)));
    t8 = xsi_vlog_unsigned_case_compare(t6, 4, t2, 4);
    if (t8 == 1)
        goto LAB11;

LAB12:
LAB14:
LAB13:    xsi_set_current_line(146, ng0);

LAB19:    xsi_set_current_line(147, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3456);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(148, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4256);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(149, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4096);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 20);

LAB15:    goto LAB2;

LAB7:    xsi_set_current_line(131, ng0);

LAB16:    xsi_set_current_line(132, ng0);
    t9 = (t0 + 1776U);
    t10 = *((char **)t9);
    t9 = (t0 + 3456);
    xsi_vlogvar_assign_value(t9, t10, 0, 0, 8);
    xsi_set_current_line(133, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4256);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(134, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4096);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 20);
    goto LAB15;

LAB9:    xsi_set_current_line(136, ng0);

LAB17:    xsi_set_current_line(137, ng0);
    t3 = (t0 + 1776U);
    t4 = *((char **)t3);
    t3 = (t0 + 3456);
    xsi_vlogvar_assign_value(t3, t4, 0, 0, 8);
    xsi_set_current_line(138, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4256);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(139, ng0);
    t2 = (t0 + 2096U);
    t3 = *((char **)t2);
    t2 = (t0 + 4096);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 20);
    goto LAB15;

LAB11:    xsi_set_current_line(141, ng0);

LAB18:    xsi_set_current_line(142, ng0);
    t3 = (t0 + 1776U);
    t4 = *((char **)t3);
    t3 = (t0 + 3456);
    xsi_vlogvar_assign_value(t3, t4, 0, 0, 8);
    xsi_set_current_line(143, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4256);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(144, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4096);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 20);
    goto LAB15;

}


extern void work_m_00000000003550557377_1885498045_init()
{
	static char *pe[] = {(void *)Always_68_0,(void *)Always_81_1,(void *)Always_100_2,(void *)Always_128_3};
	xsi_register_didat("work_m_00000000003550557377_1885498045", "isim/mix_compression_top_tb_isim_beh.exe.sim/work/m_00000000003550557377_1885498045.didat");
	xsi_register_executes(pe);
}
