/*
 * isInside.h
 *
 * Code generation for function 'isInside'
 *
 */

#ifndef ISINSIDE_H
#define ISINSIDE_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "isInside_types.h"

/* Function Declarations */
extern void isInside(const emlrtStack *sp, const real_T H[134524], const real_T
                     H_Sizes[199], const real_T x0[12], boolean_T *isin, real_T *
                     inwhich);

#endif

/* End of code generation (isInside.h) */
