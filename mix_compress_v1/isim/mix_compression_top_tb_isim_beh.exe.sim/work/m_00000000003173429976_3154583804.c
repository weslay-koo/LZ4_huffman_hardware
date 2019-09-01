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
static const char *ng0 = "F:/LZ4/mix_compress/mix_compress_v1/RTL_huffman/node_unit.v";
static unsigned int ng1[] = {0U, 0U, 0U, 0U};
static unsigned int ng2[] = {4294967295U, 0U, 15U, 0U};



static void Cont_40_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;

LAB0:    t1 = (t0 + 3464U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(40, ng0);
    t2 = (t0 + 1984U);
    t3 = *((char **)t2);
    t2 = (t0 + 4128);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memset(t7, 0, 8);
    t8 = 1U;
    t9 = t8;
    t10 = (t3 + 4);
    t11 = *((unsigned int *)t3);
    t8 = (t8 & t11);
    t12 = *((unsigned int *)t10);
    t9 = (t9 & t12);
    t13 = (t7 + 4);
    t14 = *((unsigned int *)t7);
    *((unsigned int *)t7) = (t14 | t8);
    t15 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t15 | t9);
    xsi_driver_vfirst_trans(t2, 0, 0);
    t16 = (t0 + 4032);
    *((int *)t16) = 1;

LAB1:    return;
}

static void Always_42_1(char *t0)
{
    char t4[8];
    char t21[8];
    char t33[8];
    char t41[8];
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
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    char *t32;
    char *t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    char *t40;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    char *t45;
    char *t46;
    char *t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    char *t55;
    char *t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    int t65;
    int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    char *t73;
    unsigned int t74;
    unsigned int t75;
    unsigned int t76;
    unsigned int t77;
    unsigned int t78;
    char *t79;
    char *t80;

LAB0:    t1 = (t0 + 3712U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(42, ng0);
    t2 = (t0 + 4048);
    *((int *)t2) = 1;
    t3 = (t0 + 3744);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(43, ng0);

LAB5:    xsi_set_current_line(44, ng0);
    t5 = (t0 + 1344U);
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

LAB11:    xsi_set_current_line(50, ng0);

LAB14:    xsi_set_current_line(51, ng0);
    t2 = (t0 + 1984U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t7 = *((unsigned int *)t2);
    t8 = (~(t7));
    t9 = *((unsigned int *)t3);
    t10 = (t9 & t8);
    t11 = (t10 != 0);
    if (t11 > 0)
        goto LAB15;

LAB16:    xsi_set_current_line(56, ng0);
    t2 = (t0 + 1664U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t3 + 4);
    t7 = *((unsigned int *)t2);
    t8 = (~(t7));
    t9 = *((unsigned int *)t3);
    t10 = (t9 & t8);
    t11 = (t10 & 1U);
    if (t11 != 0)
        goto LAB19;

LAB20:    if (*((unsigned int *)t2) != 0)
        goto LAB21;

LAB22:    t6 = (t4 + 4);
    t14 = *((unsigned int *)t4);
    t15 = *((unsigned int *)t6);
    t16 = (t14 || t15);
    if (t16 > 0)
        goto LAB23;

LAB24:    memcpy(t41, t4, 8);

LAB25:    t73 = (t41 + 4);
    t74 = *((unsigned int *)t73);
    t75 = (~(t74));
    t76 = *((unsigned int *)t41);
    t77 = (t76 & t75);
    t78 = (t77 != 0);
    if (t78 > 0)
        goto LAB37;

LAB38:    xsi_set_current_line(62, ng0);

LAB41:    xsi_set_current_line(63, ng0);
    t2 = (t0 + 2544);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 36, 0LL);

LAB39:
LAB17:
LAB12:    goto LAB2;

LAB6:    *((unsigned int *)t4) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(45, ng0);

LAB13:    xsi_set_current_line(46, ng0);
    t19 = ((char*)((ng1)));
    t20 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, 0, 36, 0LL);
    goto LAB12;

LAB15:    xsi_set_current_line(52, ng0);

LAB18:    xsi_set_current_line(53, ng0);
    t5 = (t0 + 1824U);
    t6 = *((char **)t5);
    t5 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t5, t6, 0, 0, 36, 0LL);
    goto LAB17;

LAB19:    *((unsigned int *)t4) = 1;
    goto LAB22;

LAB21:    t5 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t5) = 1;
    goto LAB22;

LAB23:    t12 = (t0 + 1504U);
    t13 = *((char **)t12);
    t12 = (t0 + 472);
    t19 = *((char **)t12);
    memset(t21, 0, 8);
    t12 = (t13 + 4);
    t20 = (t19 + 4);
    t17 = *((unsigned int *)t13);
    t18 = *((unsigned int *)t19);
    t22 = (t17 ^ t18);
    t23 = *((unsigned int *)t12);
    t24 = *((unsigned int *)t20);
    t25 = (t23 ^ t24);
    t26 = (t22 | t25);
    t27 = *((unsigned int *)t12);
    t28 = *((unsigned int *)t20);
    t29 = (t27 | t28);
    t30 = (~(t29));
    t31 = (t26 & t30);
    if (t31 != 0)
        goto LAB29;

LAB26:    if (t29 != 0)
        goto LAB28;

LAB27:    *((unsigned int *)t21) = 1;

LAB29:    memset(t33, 0, 8);
    t34 = (t21 + 4);
    t35 = *((unsigned int *)t34);
    t36 = (~(t35));
    t37 = *((unsigned int *)t21);
    t38 = (t37 & t36);
    t39 = (t38 & 1U);
    if (t39 != 0)
        goto LAB30;

LAB31:    if (*((unsigned int *)t34) != 0)
        goto LAB32;

LAB33:    t42 = *((unsigned int *)t4);
    t43 = *((unsigned int *)t33);
    t44 = (t42 & t43);
    *((unsigned int *)t41) = t44;
    t45 = (t4 + 4);
    t46 = (t33 + 4);
    t47 = (t41 + 4);
    t48 = *((unsigned int *)t45);
    t49 = *((unsigned int *)t46);
    t50 = (t48 | t49);
    *((unsigned int *)t47) = t50;
    t51 = *((unsigned int *)t47);
    t52 = (t51 != 0);
    if (t52 == 1)
        goto LAB34;

LAB35:
LAB36:    goto LAB25;

LAB28:    t32 = (t21 + 4);
    *((unsigned int *)t21) = 1;
    *((unsigned int *)t32) = 1;
    goto LAB29;

LAB30:    *((unsigned int *)t33) = 1;
    goto LAB33;

LAB32:    t40 = (t33 + 4);
    *((unsigned int *)t33) = 1;
    *((unsigned int *)t40) = 1;
    goto LAB33;

LAB34:    t53 = *((unsigned int *)t41);
    t54 = *((unsigned int *)t47);
    *((unsigned int *)t41) = (t53 | t54);
    t55 = (t4 + 4);
    t56 = (t33 + 4);
    t57 = *((unsigned int *)t4);
    t58 = (~(t57));
    t59 = *((unsigned int *)t55);
    t60 = (~(t59));
    t61 = *((unsigned int *)t33);
    t62 = (~(t61));
    t63 = *((unsigned int *)t56);
    t64 = (~(t63));
    t65 = (t58 & t60);
    t66 = (t62 & t64);
    t67 = (~(t65));
    t68 = (~(t66));
    t69 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t69 & t67);
    t70 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t70 & t68);
    t71 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t71 & t67);
    t72 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t72 & t68);
    goto LAB36;

LAB37:    xsi_set_current_line(57, ng0);

LAB40:    xsi_set_current_line(58, ng0);
    t79 = ((char*)((ng2)));
    t80 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t80, t79, 0, 0, 36, 0LL);
    goto LAB39;

}


extern void work_m_00000000003173429976_3154583804_init()
{
	static char *pe[] = {(void *)Cont_40_0,(void *)Always_42_1};
	xsi_register_didat("work_m_00000000003173429976_3154583804", "isim/mix_compression_top_tb_isim_beh.exe.sim/work/m_00000000003173429976_3154583804.didat");
	xsi_register_executes(pe);
}
