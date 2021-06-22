/*
 * isInside.c
 *
 * Code generation for function 'isInside'
 *
 */

/* Include files */
#include <string.h>
#include "rt_nonfinite.h"
#include "isInside.h"
#include "isInside_data.h"

/* Variable Definitions */
static emlrtBCInfo emlrtBCI = { 1,     /* iFirst */
  52,                                  /* iLast */
  8,                                   /* lineNo */
  19,                                  /* colNo */
  "H",                                 /* aName */
  "isInside",                          /* fName */
  "G:\\Meu Drive\\ISD\\orientacoes\\Domingos\\multivariateLimbControl\\isInside.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo emlrtRTEI = { 7,   /* lineNo */
  17,                                  /* colNo */
  "isInside",                          /* fName */
  "G:\\Meu Drive\\ISD\\orientacoes\\Domingos\\multivariateLimbControl\\isInside.m"/* pName */
};

/* Function Definitions */
void isInside(const emlrtStack *sp, const real_T H[134524], const real_T
              H_Sizes[199], const real_T x0[12], boolean_T *isin, real_T
              *inwhich)
{
  boolean_T notIn;
  int32_T i;
  boolean_T exitg1;
  int32_T j;
  boolean_T exitg2;
  int32_T k;
  real_T b[13];
  real_T y;

  /*  Compilacao: codegen isInside -args {Hpoly,PnH_Sizes,zeros(size(E,2),1)} */
  notIn = true;
  *isin = false;
  *inwhich = -1.0;
  i = 0;
  exitg1 = false;
  while ((!exitg1) && (i < 199)) {
    emlrtForLoopVectorCheckR2012b(1.0, 1.0, H_Sizes[i], mxDOUBLE_CLASS, (int32_T)
      H_Sizes[i], &emlrtRTEI, sp);
    j = 0;
    exitg2 = false;
    while ((!exitg2) && (j <= (int32_T)H_Sizes[i] - 1)) {
      k = 1 + j;
      if ((k < 1) || (k > 52)) {
        emlrtDynamicBoundsCheckR2012b(k, 1, 52, &emlrtBCI, sp);
      }

      memcpy(&b[0], &x0[0], 12U * sizeof(real_T));
      b[12] = -1.0;
      y = 0.0;
      for (k = 0; k < 13; k++) {
        y += H[(j + 52 * k) + 676 * i] * b[k];
      }

      if (y > 1.0E-8) {
        notIn = false;
        exitg2 = true;
      } else {
        j++;
        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b(sp);
        }
      }
    }

    if (notIn) {
      *inwhich = 1.0 + (real_T)i;
      *isin = true;
      exitg1 = true;
    } else {
      notIn = true;
      i++;
      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(sp);
      }
    }
  }
}

/* End of code generation (isInside.c) */
