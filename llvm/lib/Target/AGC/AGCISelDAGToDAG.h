//===-- AGCISelDAGToDAG.cpp - A DAG to DAG instruction selector for AGC ---===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares an instruction selector for the AGC target.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AGC_AGCISELDAGTODAG_H
#define LLVM_LIB_TARGET_AGC_AGCISELDAGTODAG_H

#include "AGCTargetMachine.h"
#include "MCTargetDesc/AGCMCTargetDesc.h"
#include "llvm/CodeGen/SelectionDAGISel.h"

namespace llvm {
class AGCDAGToDAGISel final : public SelectionDAGISel {
public:
  explicit AGCDAGToDAGISel(AGCTargetMachine &TM) : SelectionDAGISel(TM) {}

  StringRef getPassName() const override {
    return "AGC DAG->DAG Pattern Instruction Selection";
  }

  void Select(SDNode *Node) override;

  void SelectConstant(SDNode *Node);
  void SelectBR(SDNode *Node);
  void SelectBR_CC_ZERO(SDNode *Node);

#include "AGCGenDAGISel.inc"
};
} // namespace llvm

#endif // LLVM_LIB_TARGET_AGC_AGCISELDAGTODAG_H
