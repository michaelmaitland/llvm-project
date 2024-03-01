//===-- RISCVInstrGISel.td - RISC-V GISel target pseudos ----*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
/// \file
// RISC-V GlobalISel target pseudo instruction definitions. This is kept
// separately from the other tablegen files for organizational purposes, but
// share the same infrastructure.
//
//===----------------------------------------------------------------------===//

class RISCVGenericInstruction : GenericInstruction {
  let Namespace = "RISCV";
}

// Pseudo equivalent to a RISCVISD::FCLASS.
def G_FCLASS : RISCVGenericInstruction {
  let OutOperandList = (outs type0:$dst);
  let InOperandList = (ins type1:$src);
  let hasSideEffects = false;
}
def : GINodeEquiv<G_FCLASS, riscv_fclass>;

// Pseudo equivalent to a RISCVISD::VFMV_S_F_VL
def G_VFMV_S_F_VL : RISCVGenericInstruction {
  let OutOperandList = (outs type0:$dst);
  let InOperandList = (ins type0:$vec, type1:$scalar, type2:$vl);
  let hasSideEffects = false;
}
def : GINodeEquiv<G_VFMV_S_F_VL, riscv_vfmv_s_f_vl>;

// Pseudo equivalent to a RISCVISD::VFMV_V_F_VL
def G_VFMV_V_F_VL : RISCVGenericInstruction {
  let OutOperandList = (outs type0:$dst);
  let InOperandList = (ins type0:$vec, type1:$scalar, type2:$vl);
  let hasSideEffects = false;
}
def : GINodeEquiv<G_VFMV_V_F_VL, riscv_vfmv_v_f_vl>;


// Pseudo equivalent to a RISCVISD::VMV_S_X_VL
def G_VMV_S_X_VL : RISCVGenericInstruction {
  let OutOperandList = (outs type0:$dst);
  let InOperandList = (ins type0:$vec, type1:$scalar, type2:$vl);
  let hasSideEffects = false;
}
def : GINodeEquiv<G_VMV_S_X_VL, riscv_vmv_s_x_vl>;

// Pseudo equivalent to a RISCVISD::VMV_V_X_VL
def G_VMV_V_X_VL : RISCVGenericInstruction {
  let OutOperandList = (outs type0:$dst);
  let InOperandList = (ins type0:$vec, type1:$scalar, type2:$vl);
  let hasSideEffects = false;
}
def : GINodeEquiv<G_VMV_V_X_VL, riscv_vmv_v_x_vl>;

// Pseudo equivalent to a RISCVISD::VSLIDEUP_VL
def G_VSLIDEUP_VL : RISCVGenericInstruction {
  let OutOperandList = (outs type0:$dst);
  let InOperandList = (ins type0:$merge, type0:$vec, type1:$idx, type2:$mask,
                       type3:$vl, type4:$policy);
  let hasSideEffects = false;
}
def : GINodeEquiv<G_VSLIDEUP_VL, riscv_slideup_vl>;

// Pseudo equivalent to a RISCVISD::VMSET_VL
def G_VMSET_VL : RISCVGenericInstruction {
  let OutOperandList = (outs type0:$dst);
  let InOperandList = (ins type1:$vl);
  let hasSideEffects = false;
}
def : GINodeEquiv<G_VMSET_VL, riscv_vmset_vl>;
