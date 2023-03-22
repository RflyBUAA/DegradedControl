//论文2: 故障未知 参数更新时间20221007 IMU_INTEG_RATE = 400Hz
/**
 * MY_ATT_P
 *
 * Param Controller 
 *
 * @value 3 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_ATT_P, 3);  //减小空气阻尼力矩系数后 改为3, 之前是5

/**
 * MY_ATT_P_YAW
 *
 * Param Controller 
 *
 * @value 0 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_ATT_P_YAW, 0.0);

/**
 * MY_K_CP
 *
 * Param Controller 
 *
 * @value 0.6 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_K_CP, 0.6);//0.6效果最合适此时2 3(顺时针数)两个旋翼转速最为接近, 更小甚至为0的情况下会不会更好? 之前问题的关键很有可能是IMU_INTEG_RATE参数默认为200Hz的缘故

/**
 * MY_POS_P
 *
 * Param Controller 
 *
 * @value 0.3 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_POS_P, 0.3);

/**
 * MY_POS_ALT
 *
 * Param Controller 
 *
 * @value 0.6 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_POS_ALT, 0.6);

/**
 * MY_RATE_P
 *
 * Param Controller 
 *
 * @value 14 (default)
 * @min 0
 * @max 30
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_RATE_P, 14);

/**
 * MY_RATE_P_YAW
 *
 * Param Controller 
 *
 * @value 0.3 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_RATE_P_YAW, 0.3);

/**
 * MY_SAT_AD
 *
 * Param Controller 
 *
 * @value 0.15 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_SAT_AD, 0.15);

/**
 * MY_TAU_P_A
 *
 * Param Controller 
 *
 * @value 0.0 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_TAU_P_A, 0.0);

/**
 * MY_TAU_P_A_YAW
 *
 * Param Controller 
 *
 * @value 0.0 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_TAU_P_A_YAW, 0.0);

/**
 * MY_TAU_P_P
 *
 * Param Controller 
 *
 * @value 1.3 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_TAU_P_P, 1.3); 

/**
 * MY_TAU_P_P_YAW
 *
 * Param Controller 
 *
 * @value 0.1 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_TAU_P_P_YAW, 0.1); 

/**
 * MY_VEL_P
 *
 * Param Controller 
 *
 * @value 0.1 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_VEL_P, 0.1);

/**
 * MY_VEL_ALT
 *
 * Param Controller 
 *
 * @value 1 (default)
 * @min 0
 * @max 10
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_VEL_ALT, 1);

/**
 * MY_ROTOR1
 *
 * Param Controller 
 *
 * @value 1 (default)
 * @min 0
 * @max 1
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_ROTOR1, 1);

/**
 * MY_ROTOR2
 *
 * Param Controller 
 *
 * @value 1 (default)
 * @min 0
 * @max 1
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_ROTOR2, 1);

/**
 * MY_ROTOR3
 *
 * Param Controller 
 *
 * @value 1 (default)
 * @min 0
 * @max 1
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_ROTOR3, 1);

/**
 * MY_ROTOR4
 *
 * Param Controller 
 *
 * @value 1 (default)
 * @min 0
 * @max 1
 *
 * @group MY
 */
PARAM_DEFINE_FLOAT(MY_ROTOR4, 1);
