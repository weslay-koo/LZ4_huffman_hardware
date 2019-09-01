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
static const char *ng0 = "F:/LZ4/mix_compress/mix_compress_v1/RTL_huffman/fifo_16x20bit.v";
static unsigned int ng1[] = {14U, 0U};
static unsigned int ng2[] = {1U, 0U};
static unsigned int ng3[] = {0U, 0U};
static unsigned int ng4[] = {16U, 0U};



static void Cont_38_0(char *t0)
{
    char t8[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;

LAB0:    t1 = (t0 + 3968U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(38, ng0);
    t2 = (t0 + 2888);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 3048);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memset(t8, 0, 8);
    xsi_vlog_unsigned_minus(t8, 5, t4, 5, t7, 5);
    t9 = (t0 + 5424);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memset(t13, 0, 8);
    t14 = 31U;
    t15 = t14;
    t16 = (t8 + 4);
    t17 = *((unsigned int *)t8);
    t14 = (t14 & t17);
    t18 = *((unsigned int *)t16);
    t15 = (t15 & t18);
    t19 = (t13 + 4);
    t20 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t20 | t14);
    t21 = *((unsigned int *)t19);
    *((unsigned int *)t19) = (t21 | t15);
    xsi_driver_vfirst_trans(t9, 0, 4);
    t22 = (t0 + 5280);
    *((int *)t22) = 1;

LAB1:    return;
}

static void Cont_39_1(char *t0)
{
    char t3[8];
    char t4[8];
    char t6[8];
    char *t1;
    char *t2;
    char *t5;
    char *t7;
    char *t8;
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
    char *t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    unsigned int t32;
    unsigned int t33;
    char *t34;
    unsigned int t35;
    unsigned int t36;
    char *t37;
    unsigned int t38;
    unsigned int t39;
    char *t40;

LAB0:    t1 = (t0 + 4216U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(39, ng0);
    t2 = (t0 + 2328U);
    t5 = *((char **)t2);
    t2 = ((char*)((ng1)));
    memset(t6, 0, 8);
    t7 = (t5 + 4);
    if (*((unsigned int *)t7) != 0)
        goto LAB5;

LAB4:    t8 = (t2 + 4);
    if (*((unsigned int *)t8) != 0)
        goto LAB5;

LAB8:    if (*((unsigned int *)t5) < *((unsigned int *)t2))
        goto LAB7;

LAB6:    *((unsigned int *)t6) = 1;

LAB7:    memset(t4, 0, 8);
    t10 = (t6 + 4);
    t11 = *((unsigned int *)t10);
    t12 = (~(t11));
    t13 = *((unsigned int *)t6);
    t14 = (t13 & t12);
    t15 = (t14 & 1U);
    if (t15 != 0)
        goto LAB9;

LAB10:    if (*((unsigned int *)t10) != 0)
        goto LAB11;

LAB12:    t17 = (t4 + 4);
    t18 = *((unsigned int *)t4);
    t19 = *((unsigned int *)t17);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB13;

LAB14:    t22 = *((unsigned int *)t4);
    t23 = (~(t22));
    t24 = *((unsigned int *)t17);
    t25 = (t23 || t24);
    if (t25 > 0)
        goto LAB15;

LAB16:    if (*((unsigned int *)t17) > 0)
        goto LAB17;

LAB18:    if (*((unsigned int *)t4) > 0)
        goto LAB19;

LAB20:    memcpy(t3, t26, 8);

LAB21:    t27 = (t0 + 5488);
    t28 = (t27 + 56U);
    t29 = *((char **)t28);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    memset(t31, 0, 8);
    t32 = 1U;
    t33 = t32;
    t34 = (t3 + 4);
    t35 = *((unsigned int *)t3);
    t32 = (t32 & t35);
    t36 = *((unsigned int *)t34);
    t33 = (t33 & t36);
    t37 = (t31 + 4);
    t38 = *((unsigned int *)t31);
    *((unsigned int *)t31) = (t38 | t32);
    t39 = *((unsigned int *)t37);
    *((unsigned int *)t37) = (t39 | t33);
    xsi_driver_vfirst_trans(t27, 0, 0);
    t40 = (t0 + 5296);
    *((int *)t40) = 1;

LAB1:    return;
LAB5:    t9 = (t6 + 4);
    *((unsigned int *)t6) = 1;
    *((unsigned int *)t9) = 1;
    goto LAB7;

LAB9:    *((unsigned int *)t4) = 1;
    goto LAB12;

LAB11:    t16 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t16) = 1;
    goto LAB12;

LAB13:    t21 = ((char*)((ng2)));
    goto LAB14;

LAB15:    t26 = ((char*)((ng3)));
    goto LAB16;

LAB17:    xsi_vlog_unsigned_bit_combine(t3, 1, t21, 1, t26, 1);
    goto LAB21;

LAB19:    memcpy(t3, t21, 8);
    goto LAB21;

}

static void Cont_40_2(char *t0)
{
    char t3[8];
    char t4[8];
    char t6[8];
    char *t1;
    char *t2;
    char *t5;
    char *t7;
    char *t8;
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
    char *t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    unsigned int t32;
    unsigned int t33;
    char *t34;
    unsigned int t35;
    unsigned int t36;
    char *t37;
    unsigned int t38;
    unsigned int t39;
    char *t40;

LAB0:    t1 = (t0 + 4464U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(40, ng0);
    t2 = (t0 + 2328U);
    t5 = *((char **)t2);
    t2 = ((char*)((ng3)));
    memset(t6, 0, 8);
    t7 = (t5 + 4);
    if (*((unsigned int *)t7) != 0)
        goto LAB5;

LAB4:    t8 = (t2 + 4);
    if (*((unsigned int *)t8) != 0)
        goto LAB5;

LAB8:    if (*((unsigned int *)t5) > *((unsigned int *)t2))
        goto LAB7;

LAB6:    *((unsigned int *)t6) = 1;

LAB7:    memset(t4, 0, 8);
    t10 = (t6 + 4);
    t11 = *((unsigned int *)t10);
    t12 = (~(t11));
    t13 = *((unsigned int *)t6);
    t14 = (t13 & t12);
    t15 = (t14 & 1U);
    if (t15 != 0)
        goto LAB9;

LAB10:    if (*((unsigned int *)t10) != 0)
        goto LAB11;

LAB12:    t17 = (t4 + 4);
    t18 = *((unsigned int *)t4);
    t19 = *((unsigned int *)t17);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB13;

LAB14:    t22 = *((unsigned int *)t4);
    t23 = (~(t22));
    t24 = *((unsigned int *)t17);
    t25 = (t23 || t24);
    if (t25 > 0)
        goto LAB15;

LAB16:    if (*((unsigned int *)t17) > 0)
        goto LAB17;

LAB18:    if (*((unsigned int *)t4) > 0)
        goto LAB19;

LAB20:    memcpy(t3, t26, 8);

LAB21:    t27 = (t0 + 5552);
    t28 = (t27 + 56U);
    t29 = *((char **)t28);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    memset(t31, 0, 8);
    t32 = 1U;
    t33 = t32;
    t34 = (t3 + 4);
    t35 = *((unsigned int *)t3);
    t32 = (t32 & t35);
    t36 = *((unsigned int *)t34);
    t33 = (t33 & t36);
    t37 = (t31 + 4);
    t38 = *((unsigned int *)t31);
    *((unsigned int *)t31) = (t38 | t32);
    t39 = *((unsigned int *)t37);
    *((unsigned int *)t37) = (t39 | t33);
    xsi_driver_vfirst_trans(t27, 0, 0);
    t40 = (t0 + 5312);
    *((int *)t40) = 1;

LAB1:    return;
LAB5:    t9 = (t6 + 4);
    *((unsigned int *)t6) = 1;
    *((unsigned int *)t9) = 1;
    goto LAB7;

LAB9:    *((unsigned int *)t4) = 1;
    goto LAB12;

LAB11:    t16 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t16) = 1;
    goto LAB12;

LAB13:    t21 = ((char*)((ng2)));
    goto LAB14;

LAB15:    t26 = ((char*)((ng3)));
    goto LAB16;

LAB17:    xsi_vlog_unsigned_bit_combine(t3, 1, t21, 1, t26, 1);
    goto LAB21;

LAB19:    memcpy(t3, t21, 8);
    goto LAB21;

}

static void Always_42_3(char *t0)
{
    char t4[8];
    char t21[8];
    char t51[8];
    char t96[8];
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
    char *t23;
    char *t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    int t33;
    int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    char *t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    char *t47;
    char *t48;
    char *t49;
    char *t50;
    char *t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    unsigned int t75;
    unsigned int t76;
    unsigned int t77;
    int t78;
    int t79;
    unsigned int t80;
    unsigned int t81;
    unsigned int t82;
    unsigned int t83;
    unsigned int t84;
    unsigned int t85;
    char *t86;
    unsigned int t87;
    unsigned int t88;
    unsigned int t89;
    unsigned int t90;
    unsigned int t91;
    char *t92;
    char *t93;
    char *t94;
    char *t95;
    char *t97;

LAB0:    t1 = (t0 + 4712U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(42, ng0);
    t2 = (t0 + 5328);
    *((int *)t2) = 1;
    t3 = (t0 + 4744);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(43, ng0);

LAB5:    xsi_set_current_line(44, ng0);
    t5 = (t0 + 1208U);
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
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t0 + 2328U);
    t5 = *((char **)t2);
    t2 = ((char*)((ng4)));
    memset(t4, 0, 8);
    t6 = (t5 + 4);
    if (*((unsigned int *)t6) != 0)
        goto LAB16;

LAB15:    t12 = (t2 + 4);
    if (*((unsigned int *)t12) != 0)
        goto LAB16;

LAB19:    if (*((unsigned int *)t5) < *((unsigned int *)t2))
        goto LAB17;

LAB18:    t7 = *((unsigned int *)t3);
    t8 = *((unsigned int *)t4);
    t9 = (t7 & t8);
    *((unsigned int *)t21) = t9;
    t19 = (t3 + 4);
    t20 = (t4 + 4);
    t22 = (t21 + 4);
    t10 = *((unsigned int *)t19);
    t11 = *((unsigned int *)t20);
    t14 = (t10 | t11);
    *((unsigned int *)t22) = t14;
    t15 = *((unsigned int *)t22);
    t16 = (t15 != 0);
    if (t16 == 1)
        goto LAB20;

LAB21:
LAB22:    t41 = (t21 + 4);
    t42 = *((unsigned int *)t41);
    t43 = (~(t42));
    t44 = *((unsigned int *)t21);
    t45 = (t44 & t43);
    t46 = (t45 != 0);
    if (t46 > 0)
        goto LAB23;

LAB24:    xsi_set_current_line(53, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t0 + 2328U);
    t5 = *((char **)t2);
    t2 = ((char*)((ng4)));
    memset(t4, 0, 8);
    t6 = (t5 + 4);
    t12 = (t2 + 4);
    t7 = *((unsigned int *)t5);
    t8 = *((unsigned int *)t2);
    t9 = (t7 ^ t8);
    t10 = *((unsigned int *)t6);
    t11 = *((unsigned int *)t12);
    t14 = (t10 ^ t11);
    t15 = (t9 | t14);
    t16 = *((unsigned int *)t6);
    t17 = *((unsigned int *)t12);
    t18 = (t16 | t17);
    t25 = (~(t18));
    t26 = (t15 & t25);
    if (t26 != 0)
        goto LAB29;

LAB26:    if (t18 != 0)
        goto LAB28;

LAB27:    *((unsigned int *)t4) = 1;

LAB29:    t27 = *((unsigned int *)t3);
    t28 = *((unsigned int *)t4);
    t29 = (t27 & t28);
    *((unsigned int *)t21) = t29;
    t19 = (t3 + 4);
    t20 = (t4 + 4);
    t22 = (t21 + 4);
    t30 = *((unsigned int *)t19);
    t31 = *((unsigned int *)t20);
    t32 = (t30 | t31);
    *((unsigned int *)t22) = t32;
    t35 = *((unsigned int *)t22);
    t36 = (t35 != 0);
    if (t36 == 1)
        goto LAB30;

LAB31:
LAB32:    t41 = (t0 + 1688U);
    t47 = *((char **)t41);
    t60 = *((unsigned int *)t21);
    t61 = *((unsigned int *)t47);
    t62 = (t60 & t61);
    *((unsigned int *)t51) = t62;
    t41 = (t21 + 4);
    t48 = (t47 + 4);
    t49 = (t51 + 4);
    t63 = *((unsigned int *)t41);
    t64 = *((unsigned int *)t48);
    t65 = (t63 | t64);
    *((unsigned int *)t49) = t65;
    t66 = *((unsigned int *)t49);
    t67 = (t66 != 0);
    if (t67 == 1)
        goto LAB33;

LAB34:
LAB35:    t86 = (t51 + 4);
    t87 = *((unsigned int *)t86);
    t88 = (~(t87));
    t89 = *((unsigned int *)t51);
    t90 = (t89 & t88);
    t91 = (t90 != 0);
    if (t91 > 0)
        goto LAB36;

LAB37:    xsi_set_current_line(56, ng0);
    t2 = (t0 + 2888);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 5, 0LL);

LAB38:
LAB25:    xsi_set_current_line(58, ng0);
    t2 = (t0 + 1688U);
    t3 = *((char **)t2);
    t2 = (t0 + 2008U);
    t5 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t5 + 4);
    t7 = *((unsigned int *)t2);
    t8 = (~(t7));
    t9 = *((unsigned int *)t5);
    t10 = (t9 & t8);
    t11 = (t10 & 1U);
    if (t11 != 0)
        goto LAB42;

LAB40:    if (*((unsigned int *)t2) == 0)
        goto LAB39;

LAB41:    t6 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t6) = 1;

LAB42:    t12 = (t4 + 4);
    t13 = (t5 + 4);
    t14 = *((unsigned int *)t5);
    t15 = (~(t14));
    *((unsigned int *)t4) = t15;
    *((unsigned int *)t12) = 0;
    if (*((unsigned int *)t13) != 0)
        goto LAB44;

LAB43:    t26 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t26 & 1U);
    t27 = *((unsigned int *)t12);
    *((unsigned int *)t12) = (t27 & 1U);
    t28 = *((unsigned int *)t3);
    t29 = *((unsigned int *)t4);
    t30 = (t28 & t29);
    *((unsigned int *)t21) = t30;
    t19 = (t3 + 4);
    t20 = (t4 + 4);
    t22 = (t21 + 4);
    t31 = *((unsigned int *)t19);
    t32 = *((unsigned int *)t20);
    t35 = (t31 | t32);
    *((unsigned int *)t22) = t35;
    t36 = *((unsigned int *)t22);
    t37 = (t36 != 0);
    if (t37 == 1)
        goto LAB45;

LAB46:
LAB47:    t41 = (t21 + 4);
    t61 = *((unsigned int *)t41);
    t62 = (~(t61));
    t63 = *((unsigned int *)t21);
    t64 = (t63 & t62);
    t65 = (t64 != 0);
    if (t65 > 0)
        goto LAB48;

LAB49:    xsi_set_current_line(60, ng0);
    t2 = (t0 + 1688U);
    t3 = *((char **)t2);
    t2 = (t0 + 2328U);
    t5 = *((char **)t2);
    t2 = ((char*)((ng3)));
    memset(t4, 0, 8);
    t6 = (t5 + 4);
    t12 = (t2 + 4);
    t7 = *((unsigned int *)t5);
    t8 = *((unsigned int *)t2);
    t9 = (t7 ^ t8);
    t10 = *((unsigned int *)t6);
    t11 = *((unsigned int *)t12);
    t14 = (t10 ^ t11);
    t15 = (t9 | t14);
    t16 = *((unsigned int *)t6);
    t17 = *((unsigned int *)t12);
    t18 = (t16 | t17);
    t25 = (~(t18));
    t26 = (t15 & t25);
    if (t26 != 0)
        goto LAB54;

LAB51:    if (t18 != 0)
        goto LAB53;

LAB52:    *((unsigned int *)t4) = 1;

LAB54:    t27 = *((unsigned int *)t3);
    t28 = *((unsigned int *)t4);
    t29 = (t27 & t28);
    *((unsigned int *)t21) = t29;
    t19 = (t3 + 4);
    t20 = (t4 + 4);
    t22 = (t21 + 4);
    t30 = *((unsigned int *)t19);
    t31 = *((unsigned int *)t20);
    t32 = (t30 | t31);
    *((unsigned int *)t22) = t32;
    t35 = *((unsigned int *)t22);
    t36 = (t35 != 0);
    if (t36 == 1)
        goto LAB55;

LAB56:
LAB57:    t41 = (t0 + 1528U);
    t47 = *((char **)t41);
    t60 = *((unsigned int *)t21);
    t61 = *((unsigned int *)t47);
    t62 = (t60 & t61);
    *((unsigned int *)t51) = t62;
    t41 = (t21 + 4);
    t48 = (t47 + 4);
    t49 = (t51 + 4);
    t63 = *((unsigned int *)t41);
    t64 = *((unsigned int *)t48);
    t65 = (t63 | t64);
    *((unsigned int *)t49) = t65;
    t66 = *((unsigned int *)t49);
    t67 = (t66 != 0);
    if (t67 == 1)
        goto LAB58;

LAB59:
LAB60:    t86 = (t51 + 4);
    t87 = *((unsigned int *)t86);
    t88 = (~(t87));
    t89 = *((unsigned int *)t51);
    t90 = (t89 & t88);
    t91 = (t90 != 0);
    if (t91 > 0)
        goto LAB61;

LAB62:    xsi_set_current_line(63, ng0);
    t2 = (t0 + 3048);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 5, 0LL);

LAB63:
LAB50:
LAB12:    goto LAB2;

LAB6:    *((unsigned int *)t4) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(45, ng0);

LAB13:    xsi_set_current_line(46, ng0);
    t19 = ((char*)((ng3)));
    t20 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, 0, 5, 0LL);
    xsi_set_current_line(47, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 5, 0LL);
    goto LAB12;

LAB16:    t13 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t13) = 1;
    goto LAB18;

LAB17:    *((unsigned int *)t4) = 1;
    goto LAB18;

LAB20:    t17 = *((unsigned int *)t21);
    t18 = *((unsigned int *)t22);
    *((unsigned int *)t21) = (t17 | t18);
    t23 = (t3 + 4);
    t24 = (t4 + 4);
    t25 = *((unsigned int *)t3);
    t26 = (~(t25));
    t27 = *((unsigned int *)t23);
    t28 = (~(t27));
    t29 = *((unsigned int *)t4);
    t30 = (~(t29));
    t31 = *((unsigned int *)t24);
    t32 = (~(t31));
    t33 = (t26 & t28);
    t34 = (t30 & t32);
    t35 = (~(t33));
    t36 = (~(t34));
    t37 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t37 & t35);
    t38 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t38 & t36);
    t39 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t39 & t35);
    t40 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t40 & t36);
    goto LAB22;

LAB23:    xsi_set_current_line(52, ng0);
    t47 = (t0 + 2888);
    t48 = (t47 + 56U);
    t49 = *((char **)t48);
    t50 = ((char*)((ng2)));
    memset(t51, 0, 8);
    xsi_vlog_unsigned_add(t51, 5, t49, 5, t50, 5);
    t52 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t52, t51, 0, 0, 5, 0LL);
    goto LAB25;

LAB28:    t13 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t13) = 1;
    goto LAB29;

LAB30:    t37 = *((unsigned int *)t21);
    t38 = *((unsigned int *)t22);
    *((unsigned int *)t21) = (t37 | t38);
    t23 = (t3 + 4);
    t24 = (t4 + 4);
    t39 = *((unsigned int *)t3);
    t40 = (~(t39));
    t42 = *((unsigned int *)t23);
    t43 = (~(t42));
    t44 = *((unsigned int *)t4);
    t45 = (~(t44));
    t46 = *((unsigned int *)t24);
    t53 = (~(t46));
    t33 = (t40 & t43);
    t34 = (t45 & t53);
    t54 = (~(t33));
    t55 = (~(t34));
    t56 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t56 & t54);
    t57 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t57 & t55);
    t58 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t58 & t54);
    t59 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t59 & t55);
    goto LAB32;

LAB33:    t68 = *((unsigned int *)t51);
    t69 = *((unsigned int *)t49);
    *((unsigned int *)t51) = (t68 | t69);
    t50 = (t21 + 4);
    t52 = (t47 + 4);
    t70 = *((unsigned int *)t21);
    t71 = (~(t70));
    t72 = *((unsigned int *)t50);
    t73 = (~(t72));
    t74 = *((unsigned int *)t47);
    t75 = (~(t74));
    t76 = *((unsigned int *)t52);
    t77 = (~(t76));
    t78 = (t71 & t73);
    t79 = (t75 & t77);
    t80 = (~(t78));
    t81 = (~(t79));
    t82 = *((unsigned int *)t49);
    *((unsigned int *)t49) = (t82 & t80);
    t83 = *((unsigned int *)t49);
    *((unsigned int *)t49) = (t83 & t81);
    t84 = *((unsigned int *)t51);
    *((unsigned int *)t51) = (t84 & t80);
    t85 = *((unsigned int *)t51);
    *((unsigned int *)t51) = (t85 & t81);
    goto LAB35;

LAB36:    xsi_set_current_line(54, ng0);
    t92 = (t0 + 2888);
    t93 = (t92 + 56U);
    t94 = *((char **)t93);
    t95 = ((char*)((ng2)));
    memset(t96, 0, 8);
    xsi_vlog_unsigned_add(t96, 5, t94, 5, t95, 5);
    t97 = (t0 + 2888);
    xsi_vlogvar_wait_assign_value(t97, t96, 0, 0, 5, 0LL);
    goto LAB38;

LAB39:    *((unsigned int *)t4) = 1;
    goto LAB42;

LAB44:    t16 = *((unsigned int *)t4);
    t17 = *((unsigned int *)t13);
    *((unsigned int *)t4) = (t16 | t17);
    t18 = *((unsigned int *)t12);
    t25 = *((unsigned int *)t13);
    *((unsigned int *)t12) = (t18 | t25);
    goto LAB43;

LAB45:    t38 = *((unsigned int *)t21);
    t39 = *((unsigned int *)t22);
    *((unsigned int *)t21) = (t38 | t39);
    t23 = (t3 + 4);
    t24 = (t4 + 4);
    t40 = *((unsigned int *)t3);
    t42 = (~(t40));
    t43 = *((unsigned int *)t23);
    t44 = (~(t43));
    t45 = *((unsigned int *)t4);
    t46 = (~(t45));
    t53 = *((unsigned int *)t24);
    t54 = (~(t53));
    t33 = (t42 & t44);
    t34 = (t46 & t54);
    t55 = (~(t33));
    t56 = (~(t34));
    t57 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t57 & t55);
    t58 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t58 & t56);
    t59 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t59 & t55);
    t60 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t60 & t56);
    goto LAB47;

LAB48:    xsi_set_current_line(59, ng0);
    t47 = (t0 + 3048);
    t48 = (t47 + 56U);
    t49 = *((char **)t48);
    t50 = ((char*)((ng2)));
    memset(t51, 0, 8);
    xsi_vlog_unsigned_add(t51, 5, t49, 5, t50, 5);
    t52 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t52, t51, 0, 0, 5, 0LL);
    goto LAB50;

LAB53:    t13 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t13) = 1;
    goto LAB54;

LAB55:    t37 = *((unsigned int *)t21);
    t38 = *((unsigned int *)t22);
    *((unsigned int *)t21) = (t37 | t38);
    t23 = (t3 + 4);
    t24 = (t4 + 4);
    t39 = *((unsigned int *)t3);
    t40 = (~(t39));
    t42 = *((unsigned int *)t23);
    t43 = (~(t42));
    t44 = *((unsigned int *)t4);
    t45 = (~(t44));
    t46 = *((unsigned int *)t24);
    t53 = (~(t46));
    t33 = (t40 & t43);
    t34 = (t45 & t53);
    t54 = (~(t33));
    t55 = (~(t34));
    t56 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t56 & t54);
    t57 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t57 & t55);
    t58 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t58 & t54);
    t59 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t59 & t55);
    goto LAB57;

LAB58:    t68 = *((unsigned int *)t51);
    t69 = *((unsigned int *)t49);
    *((unsigned int *)t51) = (t68 | t69);
    t50 = (t21 + 4);
    t52 = (t47 + 4);
    t70 = *((unsigned int *)t21);
    t71 = (~(t70));
    t72 = *((unsigned int *)t50);
    t73 = (~(t72));
    t74 = *((unsigned int *)t47);
    t75 = (~(t74));
    t76 = *((unsigned int *)t52);
    t77 = (~(t76));
    t78 = (t71 & t73);
    t79 = (t75 & t77);
    t80 = (~(t78));
    t81 = (~(t79));
    t82 = *((unsigned int *)t49);
    *((unsigned int *)t49) = (t82 & t80);
    t83 = *((unsigned int *)t49);
    *((unsigned int *)t49) = (t83 & t81);
    t84 = *((unsigned int *)t51);
    *((unsigned int *)t51) = (t84 & t80);
    t85 = *((unsigned int *)t51);
    *((unsigned int *)t51) = (t85 & t81);
    goto LAB60;

LAB61:    xsi_set_current_line(61, ng0);
    t92 = (t0 + 3048);
    t93 = (t92 + 56U);
    t94 = *((char **)t93);
    t95 = ((char*)((ng2)));
    memset(t96, 0, 8);
    xsi_vlog_unsigned_add(t96, 5, t94, 5, t95, 5);
    t97 = (t0 + 3048);
    xsi_vlogvar_wait_assign_value(t97, t96, 0, 0, 5, 0LL);
    goto LAB63;

}

static void Always_67_4(char *t0)
{
    char t4[8];
    char t24[8];
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
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    char *t36;
    char *t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    int t46;
    int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    char *t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    char *t60;
    char *t61;

LAB0:    t1 = (t0 + 4960U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(67, ng0);
    t2 = (t0 + 5344);
    *((int *)t2) = 1;
    t3 = (t0 + 4992);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(68, ng0);

LAB5:    xsi_set_current_line(69, ng0);
    t5 = (t0 + 1208U);
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

LAB11:    xsi_set_current_line(74, ng0);

LAB14:    xsi_set_current_line(75, ng0);
    t2 = (t0 + 1688U);
    t3 = *((char **)t2);
    t2 = (t0 + 2008U);
    t5 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t5 + 4);
    t7 = *((unsigned int *)t2);
    t8 = (~(t7));
    t9 = *((unsigned int *)t5);
    t10 = (t9 & t8);
    t11 = (t10 & 1U);
    if (t11 != 0)
        goto LAB18;

LAB16:    if (*((unsigned int *)t2) == 0)
        goto LAB15;

LAB17:    t6 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t6) = 1;

LAB18:    t12 = (t4 + 4);
    t13 = (t5 + 4);
    t14 = *((unsigned int *)t5);
    t15 = (~(t14));
    *((unsigned int *)t4) = t15;
    *((unsigned int *)t12) = 0;
    if (*((unsigned int *)t13) != 0)
        goto LAB20;

LAB19:    t22 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t22 & 1U);
    t23 = *((unsigned int *)t12);
    *((unsigned int *)t12) = (t23 & 1U);
    t25 = *((unsigned int *)t3);
    t26 = *((unsigned int *)t4);
    t27 = (t25 & t26);
    *((unsigned int *)t24) = t27;
    t19 = (t3 + 4);
    t20 = (t4 + 4);
    t28 = (t24 + 4);
    t29 = *((unsigned int *)t19);
    t30 = *((unsigned int *)t20);
    t31 = (t29 | t30);
    *((unsigned int *)t28) = t31;
    t32 = *((unsigned int *)t28);
    t33 = (t32 != 0);
    if (t33 == 1)
        goto LAB21;

LAB22:
LAB23:    t54 = (t24 + 4);
    t55 = *((unsigned int *)t54);
    t56 = (~(t55));
    t57 = *((unsigned int *)t24);
    t58 = (t57 & t56);
    t59 = (t58 != 0);
    if (t59 > 0)
        goto LAB24;

LAB25:    xsi_set_current_line(78, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);

LAB26:
LAB12:    goto LAB2;

LAB6:    *((unsigned int *)t4) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(70, ng0);

LAB13:    xsi_set_current_line(71, ng0);
    t19 = ((char*)((ng3)));
    t20 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, 0, 1, 0LL);
    goto LAB12;

LAB15:    *((unsigned int *)t4) = 1;
    goto LAB18;

LAB20:    t16 = *((unsigned int *)t4);
    t17 = *((unsigned int *)t13);
    *((unsigned int *)t4) = (t16 | t17);
    t18 = *((unsigned int *)t12);
    t21 = *((unsigned int *)t13);
    *((unsigned int *)t12) = (t18 | t21);
    goto LAB19;

LAB21:    t34 = *((unsigned int *)t24);
    t35 = *((unsigned int *)t28);
    *((unsigned int *)t24) = (t34 | t35);
    t36 = (t3 + 4);
    t37 = (t4 + 4);
    t38 = *((unsigned int *)t3);
    t39 = (~(t38));
    t40 = *((unsigned int *)t36);
    t41 = (~(t40));
    t42 = *((unsigned int *)t4);
    t43 = (~(t42));
    t44 = *((unsigned int *)t37);
    t45 = (~(t44));
    t46 = (t39 & t41);
    t47 = (t43 & t45);
    t48 = (~(t46));
    t49 = (~(t47));
    t50 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t50 & t48);
    t51 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t51 & t49);
    t52 = *((unsigned int *)t24);
    *((unsigned int *)t24) = (t52 & t48);
    t53 = *((unsigned int *)t24);
    *((unsigned int *)t24) = (t53 & t49);
    goto LAB23;

LAB24:    xsi_set_current_line(76, ng0);
    t60 = ((char*)((ng2)));
    t61 = (t0 + 2728);
    xsi_vlogvar_wait_assign_value(t61, t60, 0, 0, 1, 0LL);
    goto LAB26;

}


extern void work_m_00000000002506010692_2412551072_init()
{
	static char *pe[] = {(void *)Cont_38_0,(void *)Cont_39_1,(void *)Cont_40_2,(void *)Always_42_3,(void *)Always_67_4};
	xsi_register_didat("work_m_00000000002506010692_2412551072", "isim/mix_compression_top_tb_isim_beh.exe.sim/work/m_00000000002506010692_2412551072.didat");
	xsi_register_executes(pe);
}
