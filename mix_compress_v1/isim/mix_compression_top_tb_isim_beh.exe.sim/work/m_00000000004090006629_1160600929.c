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
static const char *ng0 = "F:/LZ4/mix_compress/mix_compress_v1/RTL_lz4/hash_match.v";
static unsigned int ng1[] = {1U, 0U};
static unsigned int ng2[] = {0U, 0U};
static unsigned int ng3[] = {2U, 0U};
static unsigned int ng4[] = {3U, 0U};



static void Always_55_0(char *t0)
{
    char t7[8];
    char t22[8];
    char t36[8];
    char t43[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t8;
    unsigned int t9;
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
    unsigned int t20;
    char *t21;
    char *t23;
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
    char *t34;
    char *t35;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    char *t42;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    char *t47;
    char *t48;
    char *t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    char *t57;
    char *t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    int t67;
    int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    char *t75;
    unsigned int t76;
    unsigned int t77;
    unsigned int t78;
    unsigned int t79;
    unsigned int t80;
    char *t81;
    char *t82;

LAB0:    t1 = (t0 + 6208U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(55, ng0);
    t2 = (t0 + 6528);
    *((int *)t2) = 1;
    t3 = (t0 + 6240);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(56, ng0);

LAB5:    xsi_set_current_line(57, ng0);
    t4 = (t0 + 2648U);
    t5 = *((char **)t4);
    t4 = (t0 + 1368U);
    t6 = *((char **)t4);
    memset(t7, 0, 8);
    t4 = (t5 + 4);
    t8 = (t6 + 4);
    t9 = *((unsigned int *)t5);
    t10 = *((unsigned int *)t6);
    t11 = (t9 ^ t10);
    t12 = *((unsigned int *)t4);
    t13 = *((unsigned int *)t8);
    t14 = (t12 ^ t13);
    t15 = (t11 | t14);
    t16 = *((unsigned int *)t4);
    t17 = *((unsigned int *)t8);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB9;

LAB6:    if (t18 != 0)
        goto LAB8;

LAB7:    *((unsigned int *)t7) = 1;

LAB9:    memset(t22, 0, 8);
    t23 = (t7 + 4);
    t24 = *((unsigned int *)t23);
    t25 = (~(t24));
    t26 = *((unsigned int *)t7);
    t27 = (t26 & t25);
    t28 = (t27 & 1U);
    if (t28 != 0)
        goto LAB10;

LAB11:    if (*((unsigned int *)t23) != 0)
        goto LAB12;

LAB13:    t30 = (t22 + 4);
    t31 = *((unsigned int *)t22);
    t32 = *((unsigned int *)t30);
    t33 = (t31 || t32);
    if (t33 > 0)
        goto LAB14;

LAB15:    memcpy(t43, t22, 8);

LAB16:    t75 = (t43 + 4);
    t76 = *((unsigned int *)t75);
    t77 = (~(t76));
    t78 = *((unsigned int *)t43);
    t79 = (t78 & t77);
    t80 = (t79 != 0);
    if (t80 > 0)
        goto LAB24;

LAB25:    xsi_set_current_line(64, ng0);
    t2 = (t0 + 3128U);
    t3 = *((char **)t2);
    t2 = (t0 + 1688U);
    t4 = *((char **)t2);
    memset(t7, 0, 8);
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t9 = *((unsigned int *)t3);
    t10 = *((unsigned int *)t4);
    t11 = (t9 ^ t10);
    t12 = *((unsigned int *)t2);
    t13 = *((unsigned int *)t5);
    t14 = (t12 ^ t13);
    t15 = (t11 | t14);
    t16 = *((unsigned int *)t2);
    t17 = *((unsigned int *)t5);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB31;

LAB28:    if (t18 != 0)
        goto LAB30;

LAB29:    *((unsigned int *)t7) = 1;

LAB31:    memset(t22, 0, 8);
    t8 = (t7 + 4);
    t24 = *((unsigned int *)t8);
    t25 = (~(t24));
    t26 = *((unsigned int *)t7);
    t27 = (t26 & t25);
    t28 = (t27 & 1U);
    if (t28 != 0)
        goto LAB32;

LAB33:    if (*((unsigned int *)t8) != 0)
        goto LAB34;

LAB35:    t23 = (t22 + 4);
    t31 = *((unsigned int *)t22);
    t32 = *((unsigned int *)t23);
    t33 = (t31 || t32);
    if (t33 > 0)
        goto LAB36;

LAB37:    memcpy(t43, t22, 8);

LAB38:    t57 = (t43 + 4);
    t76 = *((unsigned int *)t57);
    t77 = (~(t76));
    t78 = *((unsigned int *)t43);
    t79 = (t78 & t77);
    t80 = (t79 != 0);
    if (t80 > 0)
        goto LAB46;

LAB47:    xsi_set_current_line(71, ng0);
    t2 = (t0 + 3608U);
    t3 = *((char **)t2);
    t2 = (t0 + 2008U);
    t4 = *((char **)t2);
    memset(t7, 0, 8);
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t9 = *((unsigned int *)t3);
    t10 = *((unsigned int *)t4);
    t11 = (t9 ^ t10);
    t12 = *((unsigned int *)t2);
    t13 = *((unsigned int *)t5);
    t14 = (t12 ^ t13);
    t15 = (t11 | t14);
    t16 = *((unsigned int *)t2);
    t17 = *((unsigned int *)t5);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB53;

LAB50:    if (t18 != 0)
        goto LAB52;

LAB51:    *((unsigned int *)t7) = 1;

LAB53:    memset(t22, 0, 8);
    t8 = (t7 + 4);
    t24 = *((unsigned int *)t8);
    t25 = (~(t24));
    t26 = *((unsigned int *)t7);
    t27 = (t26 & t25);
    t28 = (t27 & 1U);
    if (t28 != 0)
        goto LAB54;

LAB55:    if (*((unsigned int *)t8) != 0)
        goto LAB56;

LAB57:    t23 = (t22 + 4);
    t31 = *((unsigned int *)t22);
    t32 = *((unsigned int *)t23);
    t33 = (t31 || t32);
    if (t33 > 0)
        goto LAB58;

LAB59:    memcpy(t43, t22, 8);

LAB60:    t57 = (t43 + 4);
    t76 = *((unsigned int *)t57);
    t77 = (~(t76));
    t78 = *((unsigned int *)t43);
    t79 = (t78 & t77);
    t80 = (t79 != 0);
    if (t80 > 0)
        goto LAB68;

LAB69:    xsi_set_current_line(78, ng0);
    t2 = (t0 + 4088U);
    t3 = *((char **)t2);
    t2 = (t0 + 2328U);
    t4 = *((char **)t2);
    memset(t7, 0, 8);
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t9 = *((unsigned int *)t3);
    t10 = *((unsigned int *)t4);
    t11 = (t9 ^ t10);
    t12 = *((unsigned int *)t2);
    t13 = *((unsigned int *)t5);
    t14 = (t12 ^ t13);
    t15 = (t11 | t14);
    t16 = *((unsigned int *)t2);
    t17 = *((unsigned int *)t5);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB75;

LAB72:    if (t18 != 0)
        goto LAB74;

LAB73:    *((unsigned int *)t7) = 1;

LAB75:    memset(t22, 0, 8);
    t8 = (t7 + 4);
    t24 = *((unsigned int *)t8);
    t25 = (~(t24));
    t26 = *((unsigned int *)t7);
    t27 = (t26 & t25);
    t28 = (t27 & 1U);
    if (t28 != 0)
        goto LAB76;

LAB77:    if (*((unsigned int *)t8) != 0)
        goto LAB78;

LAB79:    t23 = (t22 + 4);
    t31 = *((unsigned int *)t22);
    t32 = *((unsigned int *)t23);
    t33 = (t31 || t32);
    if (t33 > 0)
        goto LAB80;

LAB81:    memcpy(t43, t22, 8);

LAB82:    t57 = (t43 + 4);
    t76 = *((unsigned int *)t57);
    t77 = (~(t76));
    t78 = *((unsigned int *)t43);
    t79 = (t78 & t77);
    t80 = (t79 != 0);
    if (t80 > 0)
        goto LAB90;

LAB91:    xsi_set_current_line(86, ng0);

LAB94:    xsi_set_current_line(87, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5128);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(88, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4968);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 3);
    xsi_set_current_line(89, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4808);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(90, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5288);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);

LAB92:
LAB70:
LAB48:
LAB26:    goto LAB2;

LAB8:    t21 = (t7 + 4);
    *((unsigned int *)t7) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB9;

LAB10:    *((unsigned int *)t22) = 1;
    goto LAB13;

LAB12:    t29 = (t22 + 4);
    *((unsigned int *)t22) = 1;
    *((unsigned int *)t29) = 1;
    goto LAB13;

LAB14:    t34 = (t0 + 2968U);
    t35 = *((char **)t34);
    memset(t36, 0, 8);
    t34 = (t35 + 4);
    t37 = *((unsigned int *)t34);
    t38 = (~(t37));
    t39 = *((unsigned int *)t35);
    t40 = (t39 & t38);
    t41 = (t40 & 1U);
    if (t41 != 0)
        goto LAB17;

LAB18:    if (*((unsigned int *)t34) != 0)
        goto LAB19;

LAB20:    t44 = *((unsigned int *)t22);
    t45 = *((unsigned int *)t36);
    t46 = (t44 & t45);
    *((unsigned int *)t43) = t46;
    t47 = (t22 + 4);
    t48 = (t36 + 4);
    t49 = (t43 + 4);
    t50 = *((unsigned int *)t47);
    t51 = *((unsigned int *)t48);
    t52 = (t50 | t51);
    *((unsigned int *)t49) = t52;
    t53 = *((unsigned int *)t49);
    t54 = (t53 != 0);
    if (t54 == 1)
        goto LAB21;

LAB22:
LAB23:    goto LAB16;

LAB17:    *((unsigned int *)t36) = 1;
    goto LAB20;

LAB19:    t42 = (t36 + 4);
    *((unsigned int *)t36) = 1;
    *((unsigned int *)t42) = 1;
    goto LAB20;

LAB21:    t55 = *((unsigned int *)t43);
    t56 = *((unsigned int *)t49);
    *((unsigned int *)t43) = (t55 | t56);
    t57 = (t22 + 4);
    t58 = (t36 + 4);
    t59 = *((unsigned int *)t22);
    t60 = (~(t59));
    t61 = *((unsigned int *)t57);
    t62 = (~(t61));
    t63 = *((unsigned int *)t36);
    t64 = (~(t63));
    t65 = *((unsigned int *)t58);
    t66 = (~(t65));
    t67 = (t60 & t62);
    t68 = (t64 & t66);
    t69 = (~(t67));
    t70 = (~(t68));
    t71 = *((unsigned int *)t49);
    *((unsigned int *)t49) = (t71 & t69);
    t72 = *((unsigned int *)t49);
    *((unsigned int *)t49) = (t72 & t70);
    t73 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t73 & t69);
    t74 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t74 & t70);
    goto LAB23;

LAB24:    xsi_set_current_line(58, ng0);

LAB27:    xsi_set_current_line(59, ng0);
    t81 = ((char*)((ng1)));
    t82 = (t0 + 4808);
    xsi_vlogvar_assign_value(t82, t81, 0, 0, 1);
    xsi_set_current_line(60, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4968);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 3);
    xsi_set_current_line(61, ng0);
    t2 = (t0 + 2808U);
    t3 = *((char **)t2);
    t2 = (t0 + 5128);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(62, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t0 + 2808U);
    t4 = *((char **)t2);
    memset(t7, 0, 8);
    xsi_vlog_unsigned_minus(t7, 32, t3, 32, t4, 32);
    t2 = (t0 + 5288);
    xsi_vlogvar_assign_value(t2, t7, 0, 0, 32);
    goto LAB26;

LAB30:    t6 = (t7 + 4);
    *((unsigned int *)t7) = 1;
    *((unsigned int *)t6) = 1;
    goto LAB31;

LAB32:    *((unsigned int *)t22) = 1;
    goto LAB35;

LAB34:    t21 = (t22 + 4);
    *((unsigned int *)t22) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB35;

LAB36:    t29 = (t0 + 3448U);
    t30 = *((char **)t29);
    memset(t36, 0, 8);
    t29 = (t30 + 4);
    t37 = *((unsigned int *)t29);
    t38 = (~(t37));
    t39 = *((unsigned int *)t30);
    t40 = (t39 & t38);
    t41 = (t40 & 1U);
    if (t41 != 0)
        goto LAB39;

LAB40:    if (*((unsigned int *)t29) != 0)
        goto LAB41;

LAB42:    t44 = *((unsigned int *)t22);
    t45 = *((unsigned int *)t36);
    t46 = (t44 & t45);
    *((unsigned int *)t43) = t46;
    t35 = (t22 + 4);
    t42 = (t36 + 4);
    t47 = (t43 + 4);
    t50 = *((unsigned int *)t35);
    t51 = *((unsigned int *)t42);
    t52 = (t50 | t51);
    *((unsigned int *)t47) = t52;
    t53 = *((unsigned int *)t47);
    t54 = (t53 != 0);
    if (t54 == 1)
        goto LAB43;

LAB44:
LAB45:    goto LAB38;

LAB39:    *((unsigned int *)t36) = 1;
    goto LAB42;

LAB41:    t34 = (t36 + 4);
    *((unsigned int *)t36) = 1;
    *((unsigned int *)t34) = 1;
    goto LAB42;

LAB43:    t55 = *((unsigned int *)t43);
    t56 = *((unsigned int *)t47);
    *((unsigned int *)t43) = (t55 | t56);
    t48 = (t22 + 4);
    t49 = (t36 + 4);
    t59 = *((unsigned int *)t22);
    t60 = (~(t59));
    t61 = *((unsigned int *)t48);
    t62 = (~(t61));
    t63 = *((unsigned int *)t36);
    t64 = (~(t63));
    t65 = *((unsigned int *)t49);
    t66 = (~(t65));
    t67 = (t60 & t62);
    t68 = (t64 & t66);
    t69 = (~(t67));
    t70 = (~(t68));
    t71 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t71 & t69);
    t72 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t72 & t70);
    t73 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t73 & t69);
    t74 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t74 & t70);
    goto LAB45;

LAB46:    xsi_set_current_line(65, ng0);

LAB49:    xsi_set_current_line(66, ng0);
    t58 = ((char*)((ng1)));
    t75 = (t0 + 4808);
    xsi_vlogvar_assign_value(t75, t58, 0, 0, 1);
    xsi_set_current_line(67, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4968);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 3);
    xsi_set_current_line(68, ng0);
    t2 = (t0 + 3288U);
    t3 = *((char **)t2);
    t2 = (t0 + 5128);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(69, ng0);
    t2 = (t0 + 1848U);
    t3 = *((char **)t2);
    t2 = (t0 + 3288U);
    t4 = *((char **)t2);
    memset(t7, 0, 8);
    xsi_vlog_unsigned_minus(t7, 32, t3, 32, t4, 32);
    t2 = (t0 + 5288);
    xsi_vlogvar_assign_value(t2, t7, 0, 0, 32);
    goto LAB48;

LAB52:    t6 = (t7 + 4);
    *((unsigned int *)t7) = 1;
    *((unsigned int *)t6) = 1;
    goto LAB53;

LAB54:    *((unsigned int *)t22) = 1;
    goto LAB57;

LAB56:    t21 = (t22 + 4);
    *((unsigned int *)t22) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB57;

LAB58:    t29 = (t0 + 3928U);
    t30 = *((char **)t29);
    memset(t36, 0, 8);
    t29 = (t30 + 4);
    t37 = *((unsigned int *)t29);
    t38 = (~(t37));
    t39 = *((unsigned int *)t30);
    t40 = (t39 & t38);
    t41 = (t40 & 1U);
    if (t41 != 0)
        goto LAB61;

LAB62:    if (*((unsigned int *)t29) != 0)
        goto LAB63;

LAB64:    t44 = *((unsigned int *)t22);
    t45 = *((unsigned int *)t36);
    t46 = (t44 & t45);
    *((unsigned int *)t43) = t46;
    t35 = (t22 + 4);
    t42 = (t36 + 4);
    t47 = (t43 + 4);
    t50 = *((unsigned int *)t35);
    t51 = *((unsigned int *)t42);
    t52 = (t50 | t51);
    *((unsigned int *)t47) = t52;
    t53 = *((unsigned int *)t47);
    t54 = (t53 != 0);
    if (t54 == 1)
        goto LAB65;

LAB66:
LAB67:    goto LAB60;

LAB61:    *((unsigned int *)t36) = 1;
    goto LAB64;

LAB63:    t34 = (t36 + 4);
    *((unsigned int *)t36) = 1;
    *((unsigned int *)t34) = 1;
    goto LAB64;

LAB65:    t55 = *((unsigned int *)t43);
    t56 = *((unsigned int *)t47);
    *((unsigned int *)t43) = (t55 | t56);
    t48 = (t22 + 4);
    t49 = (t36 + 4);
    t59 = *((unsigned int *)t22);
    t60 = (~(t59));
    t61 = *((unsigned int *)t48);
    t62 = (~(t61));
    t63 = *((unsigned int *)t36);
    t64 = (~(t63));
    t65 = *((unsigned int *)t49);
    t66 = (~(t65));
    t67 = (t60 & t62);
    t68 = (t64 & t66);
    t69 = (~(t67));
    t70 = (~(t68));
    t71 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t71 & t69);
    t72 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t72 & t70);
    t73 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t73 & t69);
    t74 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t74 & t70);
    goto LAB67;

LAB68:    xsi_set_current_line(72, ng0);

LAB71:    xsi_set_current_line(73, ng0);
    t58 = ((char*)((ng1)));
    t75 = (t0 + 4808);
    xsi_vlogvar_assign_value(t75, t58, 0, 0, 1);
    xsi_set_current_line(74, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4968);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 3);
    xsi_set_current_line(75, ng0);
    t2 = (t0 + 3768U);
    t3 = *((char **)t2);
    t2 = (t0 + 5128);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(76, ng0);
    t2 = (t0 + 2168U);
    t3 = *((char **)t2);
    t2 = (t0 + 3768U);
    t4 = *((char **)t2);
    memset(t7, 0, 8);
    xsi_vlog_unsigned_minus(t7, 32, t3, 32, t4, 32);
    t2 = (t0 + 5288);
    xsi_vlogvar_assign_value(t2, t7, 0, 0, 32);
    goto LAB70;

LAB74:    t6 = (t7 + 4);
    *((unsigned int *)t7) = 1;
    *((unsigned int *)t6) = 1;
    goto LAB75;

LAB76:    *((unsigned int *)t22) = 1;
    goto LAB79;

LAB78:    t21 = (t22 + 4);
    *((unsigned int *)t22) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB79;

LAB80:    t29 = (t0 + 4408U);
    t30 = *((char **)t29);
    memset(t36, 0, 8);
    t29 = (t30 + 4);
    t37 = *((unsigned int *)t29);
    t38 = (~(t37));
    t39 = *((unsigned int *)t30);
    t40 = (t39 & t38);
    t41 = (t40 & 1U);
    if (t41 != 0)
        goto LAB83;

LAB84:    if (*((unsigned int *)t29) != 0)
        goto LAB85;

LAB86:    t44 = *((unsigned int *)t22);
    t45 = *((unsigned int *)t36);
    t46 = (t44 & t45);
    *((unsigned int *)t43) = t46;
    t35 = (t22 + 4);
    t42 = (t36 + 4);
    t47 = (t43 + 4);
    t50 = *((unsigned int *)t35);
    t51 = *((unsigned int *)t42);
    t52 = (t50 | t51);
    *((unsigned int *)t47) = t52;
    t53 = *((unsigned int *)t47);
    t54 = (t53 != 0);
    if (t54 == 1)
        goto LAB87;

LAB88:
LAB89:    goto LAB82;

LAB83:    *((unsigned int *)t36) = 1;
    goto LAB86;

LAB85:    t34 = (t36 + 4);
    *((unsigned int *)t36) = 1;
    *((unsigned int *)t34) = 1;
    goto LAB86;

LAB87:    t55 = *((unsigned int *)t43);
    t56 = *((unsigned int *)t47);
    *((unsigned int *)t43) = (t55 | t56);
    t48 = (t22 + 4);
    t49 = (t36 + 4);
    t59 = *((unsigned int *)t22);
    t60 = (~(t59));
    t61 = *((unsigned int *)t48);
    t62 = (~(t61));
    t63 = *((unsigned int *)t36);
    t64 = (~(t63));
    t65 = *((unsigned int *)t49);
    t66 = (~(t65));
    t67 = (t60 & t62);
    t68 = (t64 & t66);
    t69 = (~(t67));
    t70 = (~(t68));
    t71 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t71 & t69);
    t72 = *((unsigned int *)t47);
    *((unsigned int *)t47) = (t72 & t70);
    t73 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t73 & t69);
    t74 = *((unsigned int *)t43);
    *((unsigned int *)t43) = (t74 & t70);
    goto LAB89;

LAB90:    xsi_set_current_line(79, ng0);

LAB93:    xsi_set_current_line(80, ng0);
    t58 = ((char*)((ng1)));
    t75 = (t0 + 4808);
    xsi_vlogvar_assign_value(t75, t58, 0, 0, 1);
    xsi_set_current_line(81, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 4968);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 3);
    xsi_set_current_line(82, ng0);
    t2 = (t0 + 4248U);
    t3 = *((char **)t2);
    t2 = (t0 + 5128);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(83, ng0);
    t2 = (t0 + 2488U);
    t3 = *((char **)t2);
    t2 = (t0 + 4248U);
    t4 = *((char **)t2);
    memset(t7, 0, 8);
    xsi_vlog_unsigned_minus(t7, 32, t3, 32, t4, 32);
    t2 = (t0 + 5288);
    xsi_vlogvar_assign_value(t2, t7, 0, 0, 32);
    goto LAB92;

}


extern void work_m_00000000004090006629_1160600929_init()
{
	static char *pe[] = {(void *)Always_55_0};
	xsi_register_didat("work_m_00000000004090006629_1160600929", "isim/mix_compression_top_tb_isim_beh.exe.sim/work/m_00000000004090006629_1160600929.didat");
	xsi_register_executes(pe);
}
